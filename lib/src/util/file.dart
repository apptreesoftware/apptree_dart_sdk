import 'dart:io';

class FileUtil {
  static void writeYaml(String dir, String filename, String yaml) {
    var directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File(filename).writeAsString(yaml);
  }
}

void writeYaml(String dir, String fileName, String yaml, {String? extension = '.yaml'}) {
  FileUtil.writeYaml('res/app_config/$dir', "res/app_config/$dir/$fileName$extension", yaml);
}

void writeModelYaml(String dir, String fileName, String yaml) {
  FileUtil.writeYaml('res/connector/models/$dir', "res/connector/models/$dir/$fileName.yaml", yaml);
}

void writeConfigYaml(String dir, String yaml) {
  FileUtil.writeYaml('res/connector/config/$dir', "res/connector/config/$dir/config.yaml", yaml);
}

List<String> copyDirectory(Directory source, Directory destination) {
  if (!destination.existsSync()) {
    destination.createSync(recursive: true);
  }

  for (FileSystemEntity entity in source.listSync(recursive: false)) {
    String newPath = '${destination.path}/${entity.uri.pathSegments.last}';

    if (entity is File) {
      entity.copySync(newPath);
    } else if (entity is Directory) {
      copyDirectory(entity, Directory(newPath));
    }
  }

  // Returns a list of the filenames prefixed with templates/
  return destination.listSync().map((e) => 'templates/${e.uri.pathSegments.last}').toList();
}

List<String> copyTemplates(String dir) {
  Directory source = Directory('res/includes/templates');
  Directory destination = Directory('res/app_config/$dir/templates');
  if (!destination.existsSync()) {
    destination.createSync(recursive: true);
  }
  return copyDirectory(source, destination);
}
