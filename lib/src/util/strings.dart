String separateCapitalsWithUnderscore(String input) {
  return input
      .replaceFirstMapped(RegExp(r'^[A-Z]'), (match) => match[0]!.toLowerCase())
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => '_${match[1]!.toLowerCase()}',
      );
}

String seperateCapitalsWithHyphen(String input) {
  return input
      .replaceFirstMapped(RegExp(r'^[A-Z]'), (match) => match[0]!.toLowerCase())
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => '-${match[1]!.toLowerCase()}',
      );
}

extension StringExtensions on String {
  String extendPath(String path) {
    if (isEmpty) {
      return path;
    }
    if (path.isEmpty) {
      return this;
    }
    return '$this.$path';
  }
}
