String separateCapitalsWithUnderscore(String input) {
  return input
      .replaceFirstMapped(RegExp(r'^[A-Z]'), (match) => match[0]!.toLowerCase())
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => '_${match[1]!.toLowerCase()}',
      );
}

String seperateCapitalsWithHyphens(String input) {
  return input
      .replaceFirstMapped(RegExp(r'^[A-Z]'), (match) => match[0]!.toLowerCase())
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => '-${match[1]!.toLowerCase()}',
      );
}
