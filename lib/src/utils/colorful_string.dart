extension ColorfulString on String {
  String get _ansiEscape => '\x1B[';
  String get _ansiDefault => '${_ansiEscape}0m';

  String _putColor(String msg, int color) =>
      '${_ansiEscape}38;5;${color}m$msg$_ansiDefault';

  String black() => _putColor(this, 0);
  String red() => _putColor(this, 1);
  String green() => _putColor(this, 2);
  String yellow() => _putColor(this, 3);
  String blue() => _putColor(this, 4);
  String magenta() => _putColor(this, 5);
  String cyan() => _putColor(this, 6);
  String white() => _putColor(this, 7);
}
