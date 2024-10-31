import 'package:blocks_solver/blocks_solver.dart';
import 'package:blocks_solver/grid.dart';

void main(List<String> arguments) async {
  // print('Hello world: ${blocks_solver.calculate()}!');
  var json = await readJsonFile(filePath: 'lib/example.json');
  // print(json);
  Grid grid = Grid(
    rows: json['width'],
    columns: json['width'],
    grid: json['shape'],
  );

  grid.print();
}
