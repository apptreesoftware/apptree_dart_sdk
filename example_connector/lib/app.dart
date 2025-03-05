import 'package:server/server.dart';
import 'generated.dart';
class App extends AppBase {
  App();

  init() {
    registerSamples(this);
    register<MyCardsCollection>(SampleMyCardsCollection());
  }
}
