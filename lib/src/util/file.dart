import 'dart:io';

class FileUtil {
  static void writeYaml(String dir, String fileName, String yaml) {
    var directory = Directory('res/$dir');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File("res/$dir/$fileName.yaml").writeAsString(yaml);
  }
}

void writeYaml(String dir, String fileName, String yaml) {
  FileUtil.writeYaml(dir, fileName, yaml);
}
