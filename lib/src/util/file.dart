import 'dart:io';

class FileUtil {
  static void writeYaml(String dir, String filename, String yaml) {
    var directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File(filename).writeAsString(yaml);
  }

  static void writeFsx(String dir, String fileName, String fsx) {
    var directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File(fileName).writeAsString(fsx);
  }
}

void writeYaml(String dir, String fileName, String yaml, {String? extension = '.yaml'}) {
  FileUtil.writeYaml('res/app_config/$dir', "res/app_config/$dir/$fileName$extension", yaml);
}

void writeTemplate(String dir, String fileName, String fsx) {
  FileUtil.writeFsx('res/app_config/$dir/templates', "res/app_config/$dir/templates/$fileName.fsx", fsx);
}

void writeModelYaml(String dir, String fileName, String yaml) {
  FileUtil.writeYaml('res/connector/models/$dir', "res/connector/models/$dir/$fileName.yaml", yaml);
}

void writeConfigYaml(String dir, String yaml) {
  FileUtil.writeYaml('res/connector/config/$dir', "res/connector/config/$dir/config.yaml", yaml);
}
