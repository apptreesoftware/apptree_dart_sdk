import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';
import 'package:apptree_dart_sdk/apptree.dart';
import 'dart:mirrors';

class SampleGenerator {
  final Record record;
  final Request request;
  final String dataSourceName;
  final String projectDir;
  final String openaiApiKey;
  final bool overwrite;

  SampleGenerator({
    required this.record,
    required this.request,
    required this.dataSourceName,
    required this.projectDir,
    required this.openaiApiKey,
    this.overwrite = false,
  }) {
    generateSamples();
  }

  String getRecordName() {
    return MirrorSystem.getName(reflect(record).type.simpleName);
  }

  String getRequestName() {
    return MirrorSystem.getName(reflect(request).type.simpleName);
  }

  String getRecordFileName() {
    return '${separateCapitalsWithUnderscore(getRecordName())}.dart';
  }

  String getRequestFileName() {
    return '${separateCapitalsWithUnderscore(getRequestName())}.dart';
  }

  String getDataSourceFileName() {
    return '${separateCapitalsWithUnderscore(dataSourceName)}.dart';
  }

  String getFileName() {
    return '${separateCapitalsWithUnderscore(dataSourceName)}_sample';
  }

  String generateImports() {
    return 'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n'
        'import \'package:$projectDir/generated/models/${getRequestFileName()}\';\n'
        'import \'package:$projectDir/generated/datasources/${getDataSourceFileName()}\';\n';
  }

  Future<String> generateSampleData() async {
    // 1 Attempt to read in existing samples
    final existingSamples = await readSamplePartialDart(projectDir, getFileName());
    if (existingSamples.isNotEmpty && overwrite) {
      return existingSamples;
    }

    // 2. Generate new samples
    final vectorStore = MemoryVectorStore(
      embeddings: OpenAIEmbeddings(apiKey: openaiApiKey),
    );
    final modelDart = await readModelDart(projectDir, getRecordName());
    await vectorStore.addDocuments(
      documents: [Document(pageContent: modelDart)],
    );

    // 3. Define the retrieval chain
    final retriever = vectorStore.asRetriever();
    final setupAndRetrieval = Runnable.fromMap<String>({
      'context': retriever.pipe(
        Runnable.mapInput((docs) => docs.map((d) => d.pageContent).join('\n')),
      ),
      'code_request': Runnable.passthrough(),
    });

    const String systemPrompt = '''
        You are a Dart developer.
        You are given a code request and a context.
        You need to generate a Dart code snippet that implements the code request.
        The code should be formatted using Dart's formatting rules.
        The code should be a string representation of the objects in Dart declared with the name 'samples' as a list of the objects.
        Do not include any imports.
        This will be declared as a static variable in the class.
        Output in JSON format with the following keys:
        - prefix: A brief explanation of the code
        - code: The Dart code snippet
        {context}
      ''';

    // 4. Construct a RAG prompt template
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      SystemChatMessagePromptTemplate.fromTemplate(systemPrompt),
      HumanChatMessagePromptTemplate.fromTemplate('{code_request}'),
    ]);

    // 5. Define the final chain
    final model = ChatOpenAI(
      apiKey: openaiApiKey,
      defaultOptions: ChatOpenAIOptions(
        model: 'gpt-4o-mini',
        temperature: 0,
        responseFormat: ChatOpenAIResponseFormat.jsonObject,
      ),
    );
    final outputParser = JsonOutputParser<ChatResult>();
    final chain = setupAndRetrieval
        .pipe(promptTemplate)
        .pipe(model)
        .pipe(outputParser);

    // 6. Run the pipeline
    final res = await chain.invoke(
      'Please produce 10 samples of the ${getRecordName()} objects.',
    );

    // 7. Write the samples to the file
    writeSamplePartialDart(projectDir, getFileName(), res['code']);
    return res['code'];
  }

  // TODO: Needs to be updated to return the correct object
  String generateGetRecord() {
    return '@override\n  Future<${getRecordName()}> getRecord(String id) async { return await samples[0]; }\n';
  }

  // TODO: Implement Filters
  Future<String> generateSampleClass() async {
    String res = 'class Sample$dataSourceName extends $dataSourceName {\n';
    res += '  ${await generateSampleData()}\n';
    '  @override\n';
    res +=
        '  Future<List<${getRecordName()}>> getCollection(${getRequestName()} request) async {\n';
    res += '  return samples;\n';
    res += '  }\n';
    res += generateGetRecord();
    res += '}\n';
    return res;
  }

  Future<void> generateSamples() async {
    String res = '';
    res += generateImports();
    res += await generateSampleClass();

    writeSampleDart(projectDir, getFileName(), res);
  }
}
