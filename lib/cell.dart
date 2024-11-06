import 'package:blocks_solver/cell_states.dart';
import 'package:blocks_solver/colored_circles.dart';

class Cell {
  late CellStates value;
  late ColoredCircles coloredCircle;

  Cell({
    required this.value,
    required this.coloredCircle,
  });

  @override
  String toString() {
    return 'value: ${value.value}, color: ${coloredCircle.circle}';
  }
}
