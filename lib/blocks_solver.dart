import 'dart:collection';
import 'dart:io';
import 'package:blocks_solver/grid.dart';

abstract class Algorithms {
  /// to hold the nodes that represent the path
  static final List<Grid> path = [];

  /// to hold the number of DFS algorithm states
  static int dfsStatesCount = 0;

  /// to hold the number of BFS algorithm states
  static int bfsStatesCount = 0;

  /// to generate all the neighbor states
  /// it tries to put every shape in every index [i, j] for the current state
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

  static void dfs(
    Grid startGrid,
    List<Grid> shapes,
    Set<String> visitedGrids,
  ) {
    Stopwatch stopwatch = Stopwatch()..start();
    _dfs(startGrid, shapes, visitedGrids);
    stdout.write('dfs executed in ${stopwatch.elapsed}\n');
    stdout.write('all possible states $dfsStatesCount\n');
  }

  static void _dfs(
    Grid startGrid,
    List<Grid> shapes,
    Set<String> visitedGrids,
  ) {
    String gridUnique = startGrid.grid.toString();
    if (visitedGrids.contains(gridUnique)) return;

    visitedGrids.add(gridUnique);

    dfsStatesCount++;

    if (startGrid.filledCells() == startGrid.rows * startGrid.columns) {
      stdout.write('found a solution\n');
      startGrid.print();
    }

    List<Grid> neighbors = generateNeighbors(startGrid, shapes);

    for (var neighbor in neighbors) {
      _dfs(neighbor, shapes, visitedGrids);
    }
  }

  static void bfs(Grid startGrid, List<Grid> shapes) {
    Stopwatch stopwatch = Stopwatch()..start();
    _bfs(startGrid, shapes);
    stdout.write('dfs executed in ${stopwatch.elapsed}\n');
    stdout.write('all possible states $bfsStatesCount\n');
  }

  static void _bfs(Grid startGrid, List<Grid> shapes) {
    final Set<String> visited = {};
    Queue<Grid> queue = Queue();

    visited.add(startGrid.toString());
    queue.add(startGrid);

    while (queue.isNotEmpty) {
      var g = queue.removeFirst();
      bfsStatesCount++;
      if (g.filledCells() == startGrid.rows * startGrid.columns) {
        g.print();
      }
      var neighbors = generateNeighbors(g, shapes);
      for (var neighbor in neighbors) {
        if (!visited.contains(neighbor.toString())) {
          visited.add(neighbor.toString());
          queue.add(neighbor);
        }
      }
    }
  }
}
