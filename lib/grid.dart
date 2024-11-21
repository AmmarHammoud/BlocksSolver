import 'dart:io';
import 'dart:math' as math;
import 'package:blocks_solver/cell.dart';
import 'package:blocks_solver/cell_states.dart';
import 'package:blocks_solver/colored_circles.dart';

import 'constants.dart';

class Grid {
  /// represents the numbers of grid's rows
  late int rows;

  /// represents the numbers of grid's columns
  late int columns;

  /// a flag to decide whether to log some debugging information
  late bool enableLogging;

  /// represents the grid
  late List<dynamic> grid;

  /// to store the indexes that are set in every shape
  Map<String, CellStates> setIndexes = {};

  /// to store the number of forbidden cells
  late int _forbiddenCells;

  /// to store the number of taken cells
  late int takenCells;

  /// to store the first shape used in a grid in order not to use it again
  String? firstShape;

  /// to construct the main grid
  Grid({
    required this.rows,
    required this.columns,
    required this.grid,
    this.takenCells = 0,
    this.firstShape,
    ColoredCircles color = ColoredCircles.green,
    this.enableLogging = false,
  }) {
    _forbiddenCells = 0;
    grid = List.generate(
      rows,
      (rIndex) => List.generate(
        columns,
        (cIndex) {
          bool cellIsNotAvailable = grid[rIndex][cIndex] == 2;
          if (cellIsNotAvailable) _forbiddenCells++;
          bool cellIsTaken = grid[rIndex][cIndex] == 1;
          if (grid[rIndex][cIndex] is Cell) {
            cellIsNotAvailable = grid[rIndex][cIndex].value.value == 2;
            cellIsTaken = grid[rIndex][cIndex].value.value == 1;
          }
          return Cell(
            value: cellIsNotAvailable
                ? CellStates.notAvailable
                : cellIsTaken
                    ? CellStates.taken
                    : CellStates.empty,
            coloredCircle: cellIsNotAvailable
                ? ColoredCircles.black
                : cellIsTaken
                    ? color
                    : ColoredCircles.white,
          );
        },
      ),
    );
  }

  /// to construct a shape
  Grid.shape({
    required dynamic grid,
    ColoredCircles color = ColoredCircles.green,
    this.enableLogging = false,
  }) {
    /// represents the number of shape's rows
    int rows = 0;

    /// represents the number of shape's columns
    int columns = 0;

    /// an integer represents the maximum negative row index among all pairs of indexes
    int maxNegativeRowIndex = 0;

    /// an integer represents the maximum negative column index among all pairs of indexes
    int maxNegativeColumnIndex = 0;

    for (var pair in grid) {
      //we need to find the maximum negative integer in order to offset the grid
      maxNegativeRowIndex = math.min(maxNegativeRowIndex, pair[1]);
      maxNegativeColumnIndex = math.min(maxNegativeColumnIndex, pair[0]);
    }

    for (var pair in grid) {
      rows = math.max(rows, pair[1]);
      columns = math.max(columns, pair[0]);

      pair[1] += maxNegativeRowIndex.abs();
      pair[0] += maxNegativeColumnIndex.abs();

      setIndexes[pair.toString()] = CellStates.taken;
    }

    this.rows = rows + 1 + maxNegativeRowIndex.abs();
    this.columns = columns + 1 + maxNegativeColumnIndex.abs();

    this.grid = List.generate(
      this.rows,
      (rIndex) => List.generate(
        this.columns,
        (cIndex) {
          var currentIndexSet = setIndexes['[$cIndex, $rIndex]'];
          return Cell(
              value: currentIndexSet ?? CellStates.notAvailable,
              coloredCircle:
                  currentIndexSet != null ? color : ColoredCircles.black);
        },
      ),
    );

    if (!enableLogging) return;
    stdout.write('set indexes: $setIndexes\n');
    stdout.write('rows: ${this.rows}, columns: ${this.columns}\n');
    _logGrid(grid: grid);
    _logGrid(grid: this.grid);
  }

  /// to get the filledCells which consists of taken and forbidden cells
  int filledCells() {
    return _forbiddenCells + takenCells;
  }

  /// to log a given grid in a readable way
  _logGrid({dynamic grid}) {
    stdout.write('[\n');
    for (var row in grid) {
      stdout.write('  $row\n');
    }
    stdout.write(']\n');
  }

  logGrid() {
    _logGrid(grid: grid);
  }

  /// <--- some helper function to print the grid with colored cells --->

  /// to print the dashes that separate between rows
  _printDashes({bool includeIndexes = true}) {
    if (includeIndexes) stdout.write('    ');
    for (int i = 0; i < columns * (includeIndexes ? 2.5 : 2.1); i++) {
      stdout.write('___');
    }
  }

  /// to print every column number
  _printColumnsNumbers() {
    printYellow('   |  ');
    for (int i = 0; i < columns; i++) {
      printYellow('0${i.toString()}   |  ');
    }
  }

  _printARowNumber(int i) {
    printYellow('0${i.toString()} |  ');
  }

  /// to print a colored cell
  _printCell(
    Cell c, {
    bool includeBars = true,
    bool includeIndexes = true,
  }) {
    includeIndexes
        ? stdout.write('${c.coloredCircle.circle}   ')
        : stdout.write('${c.coloredCircle.circle}  ');
    if (includeBars) {
      includeIndexes ? stdout.write('|  ') : stdout.write(' | ');
    } else {
      includeIndexes ? stdout.write('   ') : stdout.write(' ');
    }
  }

  /// to print the grid with colored cells in a readable way
  void print({
    bool includeIndexes = true,
    bool includeDashes = true,
    bool includeBars = true,
  }) {
    if (includeIndexes) {
      _printColumnsNumbers();
      stdout.write('\n');
    }
    for (int i = 0; i < rows; i++) {
      if (includeDashes) _printDashes(includeIndexes: includeIndexes);
      stdout.write('\n');
      if (includeIndexes) _printARowNumber(i);
      for (int j = 0; j < columns; j++) {
        _printCell(grid[i][j],
            includeBars: includeBars, includeIndexes: includeIndexes);
      }
      stdout.write('\n');
    }
    if (includeDashes) _printDashes(includeIndexes: includeIndexes);
    stdout.write('\n\n');
  }

  /// to fill a part of the grid (given by row and column) with a given shape
  bool fillWithShape({
    required Grid shape,
    required int row,
    required int column,
  }) {
    bool availablePosition = true;
    for (var pair in shape.setIndexes.entries) {
      int i = int.parse(pair.key[4]);
      int j = int.parse(pair.key[1]);
      availablePosition = availablePosition &&
          row + i < rows &&
          column + j < columns &&
          grid[row + i][column + j].value == CellStates.empty;
    }

    if (!availablePosition) {
      // stdout.write(
      //     'this positions {$row, $column} is not available to fill with this shape\n');
      return false;
    }

    for (var pair in shape.setIndexes.entries) {
      int i = int.parse(pair.key[4]);
      int j = int.parse(pair.key[1]);
      grid[row + i][column + j] = shape.grid[i][j];
      grid[row + i][column + j].value = CellStates.taken;
      takenCells++;
    }
    return true;
  }

  /// to delete a shape from the grid
  void deleteShape({
    required Grid shape,
    required int row,
    required int column,
  }) {
    for (var pair in shape.setIndexes.entries) {
      int i = int.parse(pair.key[4]);
      int j = int.parse(pair.key[1]);
      grid[row + i][column + j] = shape.grid[i][j];
      grid[row + i][column + j] = Cell(
        value: CellStates.empty,
        coloredCircle: ColoredCircles.white,
      );
    }
    print(includeDashes: false, includeBars: false);
    stdout.write('\n');
  }

  /// <---------- TODO ---------->
  /// to log the shapes side by side
  static void printShapesSideBySide({required List<Grid> shapes}) {}

  @override
  String toString() {
    return grid.toString();
  }
}
