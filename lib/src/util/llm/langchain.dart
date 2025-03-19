import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:apptree_dart_sdk/apptree.dart';

Future<String> generateSampleDataLLM(
  String codeRequest,
  String fileName,
  List<String> relatedRecordNames,
  String projectDir,
  String openaiApiKey,
  bool overwrite,
) async {
  // 1. Attempt to read in existing samples
  final existingSamples = await readSamplePartialDart(projectDir, fileName);
  if (existingSamples.isNotEmpty && overwrite) {
    return existingSamples;
  }

  // 2. Generate new samples
  final vectorStore = MemoryVectorStore(
    embeddings: OpenAIEmbeddings(apiKey: openaiApiKey),
  );
  List<Document> documents = [];
  for (final recordName in relatedRecordNames) {
    final model = await readModelDart(projectDir, recordName);
    documents.add(Document(pageContent: model));
  }
  await vectorStore.addDocuments(documents: documents);

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
        Any string fields should be wrapped in double quotes.
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
  final res = await chain.invoke(codeRequest);

  // 7. Write the samples to the file
  writeSamplePartialDart(projectDir, fileName, res['code']);
  return res['code'];
}
