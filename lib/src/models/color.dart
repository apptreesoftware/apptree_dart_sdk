class Color {
  factory Color.fromHex(String hex) {
    return Color(hex);
  }

  static const String blue = 'blue';
  static const String red = 'red';
  static const String green = 'green';
  static const String yellow = 'yellow';
  static const String black = 'black';
  static const String white = 'white';
  static const String gray = 'gray';
  static const String purple = 'purple';
  static const String orange = 'orange';
  static const String pink = 'pink';
  static const String cyan = 'cyan';
  static const String magenta = 'magenta';
  static const String lime = 'lime';
  static const String teal = 'teal';
  static const String indigo = 'indigo';
  static const String brown = 'brown';
  static const String amber = 'amber';
  static const String navy = 'navy';
  static const String maroon = 'maroon';
  static const String olive = 'olive';

  static const Map<String, String> _colorMap = {
    blue: '#0000FF',
    red: '#FF0000',
    green: '#00FF00',
    yellow: '#FFFF00',
    black: '#000000',
    white: '#FFFFFF',
    gray: '#808080',
    purple: '#800080',
    orange: '#FFA500',
    pink: '#FFC0CB',
    cyan: '#00FFFF',
    magenta: '#FF00FF',
    lime: '#BFFF00',
    teal: '#008080',
    indigo: '#4B0082',
    brown: '#A52A2A',
    amber: '#FFBF00',
    navy: '#000080',
    maroon: '#800000',
    olive: '#808000',
  };

  factory Color.fromName(String name) {
    final hexValue = _colorMap[name.toLowerCase()];
    if (hexValue == null) {
      throw ArgumentError('Color name "$name" not found');
    }
    return Color(hexValue);
  }

  Color(this.hex);

  final String hex;
}
