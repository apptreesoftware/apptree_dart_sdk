import 'dart:io';

class FileUtil {
  static void writeYaml(String path, String yaml) {
    var directory = Directory('res');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File(path).writeAsString(yaml);
  }
}

void writeYaml(String fileName, String yaml) {
  String path = "res/$fileName.yaml";
  FileUtil.writeYaml(path, yaml);
}
