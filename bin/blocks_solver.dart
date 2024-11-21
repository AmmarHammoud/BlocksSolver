import 'dart:io';
import 'package:blocks_solver/blocks_solver.dart';
import 'package:blocks_solver/colored_circles.dart';
import 'package:blocks_solver/grid.dart';
import 'package:blocks_solver/json_decoder.dart';
import 'package:blocks_solver/user_interaction.dart';

void main(List<String> arguments) async {
  /// decode the json file that contains the game's data (grid, and shapes...)
  var json = await readJsonFile(filePath: 'lib/example_2.json');

  /// the main grid that the shapes are going to be put on
  Grid mainGrid = Grid(
    rows: json['field']['width'],
    columns: json['field']['width'],
    grid: json['field']['shape'],
  );
  // mainGrid.print(includeBars: false, includeDashes: false);
  // stdout.write('\n\n');
  // stdout.write(mainGrid.toString());

  /// represents the shapes that are going to be put on the main grid
  List<Grid> shapes = [];

  /// represents the different colors that could be assigned to the shapes
  List<ColoredCircles> colors = [];
  for (var color in ColoredCircles.values) {
    if (color == ColoredCircles.black || color == ColoredCircles.white) {
      continue;
    }
    colors.add(color);
  }

  /// an integer to decide the color of the shape randomly
  int i = 1;

  for (var shape in json['pieces']) {
    shapes.add(Grid.shape(
        grid: shape['blocks'], color: colors[(colors.length - 1) % i++]));
  }

  // var startGridNeighbors = Algorithms.generateNeighbors(mainGrid, shapes);
  // for(var neighbor in startGridNeighbors){
  //   neighbor.print();
  // }

  /// implementing DFS algorithm on the grid
  // Algorithms.dfs(mainGrid, shapes);

  /// implementing BFS algorithm on the grid
  // Algorithms.bfs(mainGrid, shapes);

  /// implementing USC algorithm on the grid
  Algorithms.usc(mainGrid, shapes);

  /// implementing A* algorithm on the grid
  // Algorithms.aStart(mainGrid, shapes);

  /// implementing Hell Climbing algorithm on the gird
  // Algorithms.hellClimbing(mainGrid, shapes);

  // while (true) {
  //   UserInteraction.printWelcomingMessage();
  //   UserInteraction.printUserOptions();
  //   UserInteraction.readUserInput();
  //   var c =
  //       UserInteraction.executeUserOption(mainGrid: mainGrid, shapes: shapes);
  //   if (c != null && !c) return;
  // }
}
