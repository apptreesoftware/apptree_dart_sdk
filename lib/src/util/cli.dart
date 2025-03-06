import 'dart:io';

// Start Generation Here
void runFlutterPubGet(String projectDir) {
  final result = Process.runSync('flutter', [
    'pub',
    'get',
  ], workingDirectory: projectDir);
  if (result.exitCode != 0) {
    stderr.writeln('Error running flutter pub get: ${result.stderr}');
  } else {
    stdout.writeln('Successfully ran flutter pub get.');
  }
}
