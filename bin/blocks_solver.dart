import 'dart:io';
import 'package:blocks_solver/grid.dart';
import 'package:blocks_solver/json_decoder.dart';

void main(List<String> arguments) async {
  /// decode the json file that contains the game's data (grid, and shapes...)
  var json = await readJsonFile(filePath: 'lib/example.json');

  /// the main grid that the shapes are going to be put on
  Grid mainGrid = Grid(
    rows: json['field']['width'],
    columns: json['field']['width'],
    grid: json['field']['shape'],
  );
  mainGrid.print(includeBars: false, includeDashes: false);
  stdout.write('\n\n');

  /// represents the shapes that are going to be put on the main grid
  List<Grid> shapes = [];

  for (var shape in json['pieces']) {
    shapes.add(Grid.shape(grid: shape['blocks']));
  }

  for (int i = 0; i < shapes.length; i++) {
    stdout.write('shape index: $i\n');
    shapes[i].print(
        // includeDashes: false,
        // includeIndexes: false,
        // includeBars: false,
        );
    stdout.write('\n\n');
  }
}
