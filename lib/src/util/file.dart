import 'dart:io';

class FileUtil {
  static void writeFile(String dir, String filename, String yaml) {
    var directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File('$dir/$filename').writeAsString(yaml);
  }
}

void writeYaml(
  String dir,
  String fileName,
  String yaml, {
  String? extension = '.yaml',
}) {
  FileUtil.writeFile('res/app_config/$dir', "$fileName$extension", yaml);
}

void writeTemplate(String dir, String fileName, String fsx) {
  FileUtil.writeFile('res/app_config/$dir/templates', "$fileName.fsx", fsx);
}

void writeModelYaml(String dir, String fileName, String yaml) {
  FileUtil.writeFile('res/connector/models/$dir', "$fileName.yaml", yaml);
}

void writeConfigYaml(String dir, String yaml) {
  FileUtil.writeFile('res/connector/config/$dir', "config.yaml", yaml);
}

void writeModelDart(String dir, String fileName, String dart) {
  FileUtil.writeFile('$dir/lib/generated/models', '$fileName.dart', dart);
}

void writeDatasourceDart(String dir, String fileName, String dart) {
  FileUtil.writeFile('$dir/lib/generated/datasources', '$fileName.dart', dart);
}

void writeSampleDart(String dir, String fileName, String dart) {
  FileUtil.writeFile('$dir/lib/generated/samples', '$fileName.dart', dart);
}

void writeSamplePartialDart(String dir, String fileName, String dart) {
  FileUtil.writeFile('res/generated/samples/$dir', '$fileName.dart', dart);
}

void writeGeneratedDart(String dir, String fileName, String dart) {
  FileUtil.writeFile('$dir/lib/generated', '$fileName.dart', dart);
}

void writeAppDart(String dir, String fileName, String dart) {
  FileUtil.writeFile('$dir/lib', '$fileName.dart', dart);
}

void writeServerDart(String dir, String fileName, String dart) {
  FileUtil.writeFile('$dir/bin', "$fileName.dart", dart);
}

void writePubspec(String dir, String pubspec) {
  FileUtil.writeFile(dir, 'pubspec.yaml', pubspec);
}

Future<String> readModelDart(String dir, String fileName) async {
  return await File('$dir/lib/generated/models/$fileName.dart').readAsString();
}

Future<String> readDatasourceDart(String dir, String fileName) async {
  return await File(
    '$dir/lib/generated/datasources/$fileName.dart',
  ).readAsString();
}

Future<String> readSampleDart(String dir, String fileName) async {
  return await File('$dir/lib/generated/samples/$fileName.dart').readAsString();
}

Future<String> readPubspec(String dir) async {
  return await File('$dir/pubspec.yaml').readAsString();
}

Future<String> readSamplePartialDart(String dir, String fileName) async {
  final file = File('res/generated/samples/$dir/$fileName.dart');
  if (await file.exists()) {
    return await file.readAsString();
  }
  return '';
}
