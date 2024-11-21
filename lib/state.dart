import 'package:blocks_solver/grid.dart';

class State {
  late Grid grid;
  late int gScore;
  late int fScore;
  late int hScore;
  State? parent;

  State({required this.grid, this.parent})
      : gScore = 1000000000,
        fScore = 1000000000,
        hScore = 1000000000;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State &&
          runtimeType == other.runtimeType &&
          grid.grid == other.grid.grid;

  @override
  // TODO: implement hashCode
  int get hashCode => grid.hashCode;
}
