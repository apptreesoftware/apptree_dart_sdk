import 'package:server/server.dart';
import 'generated.dart';
void main() {
  var app = App();
  app.init();

  var server = Server<App>(app);
  server.addCollectionRoute<MyCardsRequest, MyCardsCollection, Card>(
   '/my-cards', 
   MyCardsRequest.fromJson, 
 );

  server.start();
}
