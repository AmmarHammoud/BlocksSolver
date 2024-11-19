import 'dart:io';
import 'package:blocks_solver/grid.dart';

class Algorithms {
  static final List<Grid> path = [];
  static int statesCount = 0;

  static void dfs(Grid startGrid, List<Grid> shapes, Set<String> visitedGrids) {
    Stopwatch stopwatch = Stopwatch()..start();
    _dfs(startGrid, shapes, visitedGrids);
    stdout.write('dfs executed in ${stopwatch.elapsed}\n');
    stdout.write('all possible states $statesCount\n');
  }

  static List<Grid> generateNeighbors(
    Grid grid,
    List<Grid> shapes,
  ) {
    List<Grid> neighbors = [];
    for (int k = 0; k < shapes.length; k++) {
      for (int i = 0; i < grid.rows; i++) {
        for (int j = 0; j < grid.columns; j++) {
          Grid newGrid = Grid(
            rows: grid.rows,
            columns: grid.columns,
            grid: grid.grid,
            takenCells: grid.filledCells(),
          );
          var filledWithShape =
              newGrid.fillWithShape(shape: shapes[k], row: i, column: j);
          if (filledWithShape) neighbors.add(newGrid);
        }
      }
    }
    return neighbors;
  }

  static int maxDepth = 0;

  static void _dfs(
    Grid startGrid,
    List<Grid> shapes,
    Set<String> visitedGrids,
  ) {
    String gridUnique = startGrid.grid.toString();
    if (visitedGrids.contains(gridUnique)) return;

    visitedGrids.add(gridUnique);

    statesCount++;

    if (startGrid.filledCells() == startGrid.rows * startGrid.columns) {
      stdout.write('found a solution\n');
      startGrid.print();
    }

    List<Grid> neighbors = generateNeighbors(startGrid, shapes);

    for (var neighbor in neighbors) {
      _dfs(neighbor, shapes, visitedGrids);
    }
  }
}
