enum ColoredCircles {
  // 🟣🟢🟡⚪⚫🟤🔵🔴🟠
  white,
  black,
  purple,
  green,
  yellow,
  brown,
  blue,
  red,
  orange;

  String get circle {
    switch (this) {
      case ColoredCircles.white:
        return '⚪ ';
      case ColoredCircles.black:
        return '⚫ ';
      case ColoredCircles.purple:
        return '🟣';
      case ColoredCircles.green:
        return '🟢';
      case ColoredCircles.yellow:
        return '🟡';
      case ColoredCircles.brown:
        return '🟤';
      case ColoredCircles.blue:
        return '🔵';
      case ColoredCircles.red:
        return '🔴';
      case ColoredCircles.orange:
        return '🟠';
    }
  }
}
