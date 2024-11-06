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

  /// to construct the main grid
  Grid({
    required this.rows,
    required this.columns,
    required this.grid,
    this.enableLogging = false,
  }) {
    grid = List.generate(
      rows,
          (rIndex) =>
          List.generate(
            columns,
                (cIndex) {
              bool cellIsAvailable = grid[rIndex][cIndex] == 2;
              return Cell(
                value: cellIsAvailable
                    ? CellStates.notAvailable
                    : CellStates.empty,
                coloredCircle: cellIsAvailable
                    ? ColoredCircles.black
                    : ColoredCircles.white,
              );
            },
          ),
    );
  }

  /// to construct a shape
  Grid.shape({required dynamic grid, this.enableLogging = false}) {
    /// represents the number of shape's rows
    int rows = 0;

    /// represents the number of shape's columns
    int columns = 0;

    /// to store the indexes that are set in every shape
    Map<String, CellStates> setIndexes = {};

    /// a flag to decide whether the rows of the shape contains a negative index
    bool rowContainsANegativeIndex = false;

    /// a flag to decide whether the columns of the shape contains a negative index
    bool columnContainsANegativeIndex = false;

    for (var pair in grid) {
      rowContainsANegativeIndex = rowContainsANegativeIndex || pair[0] < 0;
      columnContainsANegativeIndex =
          columnContainsANegativeIndex || pair[1] < 0;
    }

    for (var pair in grid) {
      rows = math.max(rows, pair[0]);
      columns = math.max(columns, pair[1]);

      // if the shape contains a negative index, then we should offset the indexes accordingly
      pair[0] += rowContainsANegativeIndex ? 1 : 0;
      pair[1] += columnContainsANegativeIndex ? 1 : 0;

      setIndexes[pair.toString()] = CellStates.taken;
    }

    this.rows = rows + 1 + (rowContainsANegativeIndex ? 1 : 0);
    this.columns = columns + 1 + (columnContainsANegativeIndex ? 1 : 0);

    this.grid = List.generate(
      this.rows,
          (rIndex) =>
          List.generate(
            this.columns,
                (cIndex) {
              var currentIndexSet = setIndexes['[$rIndex, $cIndex]'];
              return Cell(
                  value: currentIndexSet ?? CellStates.notAvailable,
                  coloredCircle: currentIndexSet != null
                      ? ColoredCircles.green
                      : ColoredCircles.black);
            },
          ),
    );

    if (!enableLogging) return;
    stdout.write('set indexes: $setIndexes\n');
    stdout.write('rows: ${this.rows}, columns: ${this.columns}\n');
    _logGrid(grid: grid);
    _logGrid(grid: this.grid);
  }

  /// to log a given grid in a readable way
  _logGrid({dynamic grid}) {
    stdout.write('[\n');
    for (var row in grid) {
      stdout.write('  $row\n');
    }
    stdout.write(']\n');
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
  _printCell(Cell c, {
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
  }

  /// <---------- TODO ---------->
  /// to log the shapes side by side
  static void printShapesSideBySide({required List<Grid> shapes}) {}
}
