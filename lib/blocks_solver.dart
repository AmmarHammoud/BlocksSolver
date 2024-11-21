import 'dart:collection';
import 'dart:io';
import 'package:blocks_solver/grid.dart';
import 'package:collection/collection.dart';

import 'state.dart';

abstract class Algorithms {
  /// to hold the nodes that represent the path
  static final List<Grid> path = [];

  /// to hold the number of DFS algorithm states
  static int dfsStatesCount = 0;

  /// to hold the number of BFS algorithm states
  static int bfsStatesCount = 0;

  /// to hold the number of USC algorithm states
  static int uscStatesCount = 0;

  static Map<String, bool> usedShapes = {};

  /// to generate all the neighbor states
  /// it tries to put every shape in every index [i, j] for the current state
  static List<Grid> generateNeighbors(
    Grid grid,
    List<Grid> shapes,
  ) {
    List<Grid> neighbors = [];
    for (int k = 0; k < shapes.length; k++) {
      if (grid.firstShape != null && grid.firstShape == shapes[k].toString())
        continue;
      for (int i = 0; i < grid.rows; i++) {
        for (int j = 0; j < grid.columns; j++) {
          Grid newGrid = Grid(
            rows: grid.rows,
            columns: grid.columns,
            grid: grid.grid,
            takenCells: grid.filledCells(),
            firstShape: shapes[k].toString(),
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
  ) {
    Stopwatch stopwatch = Stopwatch()..start();
    _dfs(startGrid, shapes, {});
    stdout.write('dfs executed in ${stopwatch.elapsed}\n');
    stdout.write('all possible states $dfsStatesCount\n');
  }

  static void _dfs(
    Grid startGrid,
    List<Grid> shapes,
    Set<String> visitedGrids,
  ) {
    String gridUnique = startGrid.toString();
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
    stdout.write('bfs executed in ${stopwatch.elapsed}\n');
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

  static void usc(Grid startGrid, List<Grid> shapes) {
    Stopwatch stopwatch = Stopwatch()..start();
    _usc(startGrid, shapes);
    stdout.write('usc executed in ${stopwatch.elapsed}\n');
    stdout.write('usc states count: $uscStatesCount\n');
  }

  static void _usc(Grid startGrid, List<Grid> shapes) {
    final Map<String, int> visited = {};
    PriorityQueue<MapEntry<Grid, int>> queue =
        PriorityQueue((a, b) => a.value.compareTo(b.value));
    visited[startGrid.toString()] = 0;
    queue.add(MapEntry(startGrid, 0));

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      uscStatesCount++;

      var currentGrid = current.key;
      var currentCost = current.value;

      var neighbors = generateNeighbors(startGrid, shapes);

      for (var neighbor in neighbors) {
        var neighborStr = neighbor.toString();
        int newCost = currentCost + 1;

        if (!visited.containsKey(neighborStr) ||
            newCost < visited[neighborStr]!) {
          visited[neighborStr] = newCost;
          queue.add(MapEntry(neighbor, newCost));
        }
      }
    }
  }

  static void aStart(Grid startGrid, List<Grid> shapes) {
    /// generate the goal state, where every cell should be 1
    var goalList = List.generate(
      startGrid.rows,
      (rIndex) => List.generate(startGrid.columns,
          (cIndex) => startGrid.grid[rIndex][cIndex] == 2 ? 2 : 1),
    );
    var goalGrid =
        Grid(rows: startGrid.rows, columns: startGrid.columns, grid: goalList);

    _aStar(startGrid, goalGrid, shapes);
  }

  // static void _aStar(State startState, List<Grid> shapes) {
  //   PriorityQueue<State> openList =
  //       PriorityQueue((a, b) => a.fScore.compareTo(b.fScore));
  //   List<State> closedSet = [];
  //   openList.add(startState);
  //
  //   while (openList.isNotEmpty) {
  //     final currentState = openList.removeFirst();
  //     closedSet.add(currentState);
  //     var neighbors = generateNeighbors(startState.grid, shapes);
  //
  //     for (var neighbor in neighbors) {
  //       var neighborState = State(grid: neighbor, parent: currentState);
  //       if (closedSet.contains(neighborState)) continue;
  //       // if (neighborState == goal) {
  //       //   return;
  //       // }
  //
  //       // neighborState.gScore = currentState.gScore + ;
  //       // neighborState.hScore =
  //       // neighborState.fScore = neighborState.gScore + neighborState.hScore;
  //
  //       if(!openList.contains(neighborState)){
  //
  //       }
  //     }
  //   }
  // }
  static void _aStar(Grid startGrid, Grid goalGrid, List<Grid> shapes) {
    Set<String> visitedGrids = {};
    PriorityQueue<State> openSet =
        PriorityQueue<State>((a, b) => a.fScore.compareTo(b.fScore));
    State startState = State(grid: startGrid);
    startState.gScore = 0;
    startState.fScore = heuristic(startGrid, goalGrid);

    openSet.add(startState);

    while (openSet.isNotEmpty) {
      State current = openSet.removeFirst();
      String gridUnique = current.grid.toString();

      if (gridUnique == goalGrid.toString()) {
        stdout.write('found a solution\n');
        current.grid.print();
        return;
      }

      visitedGrids.add(gridUnique);

      List<Grid> neighbors = generateNeighbors(current.grid, shapes);

      for (Grid neighborGrid in neighbors) {
        State neighborState = State(grid: neighborGrid, parent: current);
        String neighborUnique = neighborGrid.toString();

        if (visitedGrids.contains(neighborUnique)) continue;

        int tentativeGScore = current.gScore + 1;

        if (tentativeGScore < neighborState.gScore) {
          neighborState.gScore = tentativeGScore;
          neighborState.hScore = heuristic(neighborGrid, goalGrid);
          neighborState.fScore = neighborState.gScore + neighborState.hScore;

          if (!openSet.contains(neighborState)) {
            openSet.add(neighborState);
          }
        }
      }
    }

    stdout.write('no solution found\n');
  }

  static int heuristic(Grid current, Grid goal) {
    // Implement your heuristic function here.
    // For example, using Manhattan distance.
    // int distance = 0;
    // for (int i = 0; i < current.rows; i++) {
    //   for (int j = 0; j < current.columns; j++) {
    //     if (current.grid[i][j].value != goal.grid[i][j].value) {
    //       distance++;
    //     }
    //   }
    // }
    return 1;
  }

  static void hellClimbing(Grid startGrid, List<Grid> shapes) {
    Stopwatch stopwatch = Stopwatch()..start();
    _hellClimbing(startGrid, shapes);
    stdout.write('hell climbing executed in ${stopwatch.elapsed}\n');
  }

  static Grid? _bestNeighbor(List<Grid> neighbors) {
    int maxCellsIndex = 0;
    for (int i = 0; i < neighbors.length; i++) {
      if (neighbors[i].filledCells() > neighbors[maxCellsIndex].filledCells()) {
        maxCellsIndex = i;
      }
    }
    return maxCellsIndex < neighbors.length ? neighbors[maxCellsIndex] : null;
  }

  static void _hellClimbing(Grid startGrid, List<Grid> shapes) {
    var x0 = Grid(
      rows: startGrid.rows,
      columns: startGrid.columns,
      grid: startGrid.grid,
      takenCells: startGrid.filledCells(),
    );
    while (true) {
      var neighbors = generateNeighbors(x0, shapes);
      var bestNeighbor = _bestNeighbor(neighbors);
      if (bestNeighbor == null ||
          bestNeighbor.filledCells() <= x0.filledCells()) {
        return;
      }
      x0 = Grid(
          rows: bestNeighbor.rows,
          columns: bestNeighbor.columns,
          grid: bestNeighbor.grid,
          takenCells: bestNeighbor.filledCells());
    }
  }
}
