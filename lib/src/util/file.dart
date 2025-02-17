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
  Directory destination = Directory('res/$dir/templates');
  if (!destination.existsSync()) {
    destination.createSync(recursive: true);
  }
  return copyDirectory(source, destination);
}
