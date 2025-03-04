import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';

class SampleGenerator {
  final String className;
  final String openaiApiKey;
  final String requestName;
  final String dataSourceName;

  SampleGenerator({
    required this.className,
    required this.openaiApiKey,
    required this.requestName,
    required this.dataSourceName,
  });

  String generateImports() {
    return 'import \'package:example_connector/generated/models/${className}.dart\';\n'
        'import \'package:example_connector/generated/models/${requestName}.dart\';\n'
        'import \'package:example_connector/generated/datasources/${dataSourceName}.dart\';\n';
  }

  Future<String> generateSampleData() async {
    final vectorStore = MemoryVectorStore(
      embeddings: OpenAIEmbeddings(apiKey: openaiApiKey),
    );
    await vectorStore.addDocuments(
      documents: [Document(pageContent: readModelDart('Card'))],
    );

    // 2. Define the retrieval chain
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
        Output in JSON format with the following keys:
        - prefix: A brief explanation of the code
        - code: The Dart code snippet
        {context}
      ''';

    // 3. Construct a RAG prompt template
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      SystemChatMessagePromptTemplate.fromTemplate(systemPrompt),
      HumanChatMessagePromptTemplate.fromTemplate('{code_request}'),
    ]);

    // 4. Define the final chain
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

    // 5. Run the pipeline
    final res = await chain.invoke(
      'Please produce 10 samples of the ${className} objects.',
    );

    return res['code'];
  }

  // TODO: Implement Filters
  Future<String> generateSampleClass() async {
    String res =
        'class Sample${className}Collection extends ${dataSourceName} {\n'
        '  @override\n';
    res += '  Future<List<${className}>> getCollection(${requestName} request) async {\n';
    res += '  ${await generateSampleData()}\n';
    res += '  return samples;\n';
    res += '  }\n';
    res += '}\n';
    return res;
  }

  Future<void> generateSamples() async {
    String res = '';
    res += generateImports();
    res += await generateSampleClass();
    writeSampleDart(className, res);
  }
}