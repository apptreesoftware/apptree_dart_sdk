import 'dart:io';

class FileUtil {
  static void writeFile(String dir, String filename, String yaml) {
    var directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File(filename).writeAsString(yaml);
  }
}

void writeYaml(String dir, String fileName, String yaml, {String? extension = '.yaml'}) {
  FileUtil.writeFile('res/app_config/$dir', "res/app_config/$dir/$fileName$extension", yaml);
}

void writeTemplate(String dir, String fileName, String fsx) {
  FileUtil.writeFile('res/app_config/$dir/templates', "res/app_config/$dir/templates/$fileName.fsx", fsx);
}

void writeModelYaml(String dir, String fileName, String yaml) {
  FileUtil.writeFile('res/connector/models/$dir', "res/connector/models/$dir/$fileName.yaml", yaml);
}

void writeConfigYaml(String dir, String yaml) {
  FileUtil.writeFile('res/connector/config/$dir', "res/connector/config/$dir/config.yaml", yaml);
}

void writeModelDart(String fileName, String dart) {
  FileUtil.writeFile('res/generated/models', "res/generated/models/$fileName.dart", dart);
}



