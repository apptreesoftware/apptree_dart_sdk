import 'package:example_connector/app.dart';
import 'package:example_connector/generated/generated.dart';
import 'package:logging/logging.dart';
import 'package:server/server.dart';

void main() {
  var app = App();
  app.init();
  registerSamples(app);

  var server = Server<App>(app);

  server.addCollectionRoute<MyCardsRequest, MyCardsCollection, Card>(
    '/my-cards',
    MyCardsRequest.fromJson,
  );
  server.start();
}

var serverLogger = Logger('Server')..level = Level.INFO;
// Handler init() {
//   var appServer = Server<App>(App());
//   var router = Router().plus;
//   var app = App();

//   router.get('/', () => 'Hello, World!');

//   // Generic handler for POST requests

//   router.post('/my-cards', (Request request) async {
//     return handleCollectionPostRequest<
//       MyCardsRequest,
//       MyCardsCollection,
//       List<Card>
//     >(
//       app: app,
//       request: request,
//       fromJson: MyCardsRequest.fromJson,
//       collectionMethod: (dataSource, input) => dataSource.getCollection(input),
//     );
//   });

  // router.get('/my-cards', (Request request) async {
  //   var traceId = _generateTraceId();
  //   var params = request.url.queryParameters;
  //   var jsonBody = {
  //     'owner': params['owner'] ?? '',
  //     'filter': params['filter'] ?? '',
  //   };
  //   var input = MyCardsRequest.fromJson(jsonBody);
  //   _logRequest(traceId, request, input);
  //   var dataSource = app.get<MyCardsCollection>();
  //   var cards = await dataSource.getCollection(input);
  //   _logResponse(traceId, request, cards);
  //   return cards;
  // });

  // return router.call;
// }
