import 'dart:io';
import 'package:path/path.dart' as path;

void copyDirectory(String source, String destination) {
  final srcDir = Directory(source);
  final destDir = Directory(destination);

  if (!srcDir.existsSync()) {
    throw FileSystemException('Source directory does not exist', source);
  }

  if (!destDir.existsSync()) {
    destDir.createSync(recursive: true);
  }

  for (final entity in srcDir.listSync(recursive: true)) {
    // Compute the relative path by stripping the source directory path.
    var relativePath = entity.path.substring(srcDir.path.length);
    // Remove leading separator if present.
    if (relativePath.startsWith(Platform.pathSeparator)) {
      relativePath = relativePath.substring(1);
    }
    final newPath = destDir.path + Platform.pathSeparator + relativePath;

    if (entity is Directory) {
      Directory(newPath).createSync(recursive: true);
    } else if (entity is File) {
      // Ensure the destination directory exists.
      Directory(path.dirname(newPath)).createSync(recursive: true);
      entity.copySync(newPath);
    }
  }
}

void copyBoilerplate(String projectDir) {
  copyDirectory('res/includes/boilerplate/server', projectDir);
}
