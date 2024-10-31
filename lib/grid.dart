import 'dart:io';

import 'constants.dart';

class Grid {
  late int rows;
  late int columns;

  // late List<List<int>> grid;
  late List<dynamic> grid;

  Grid({
    required this.rows,
    required this.columns,
    required this.grid,
  });

  _printDashes() {
    stdout.write('    ');
    for (int i = 0; i < rows * 2.15; i++) {
      stdout.write('___');
    }
  }

  _printRows() {
    stdout.write('     ');
    for (int i = 0; i < rows; i++) {
      printYellow('0${i.toString()}  |  ');
    }
  }

  _printCell(int c) {
    if (c == 0) {
      printCyan(c.toString());
    } else {
      stdout.write('x');
    }
    stdout.write('   |  ');
  }

  void print() {
    _printRows();
    stdout.write('\n');
    for (int i = 0; i < rows; i++) {
      _printDashes();
      stdout.write('\n');
      printYellow('0${i.toString()}   ');
      for (int j = 0; j < columns; j++) {
        //stdout.write('${_grid[i][j]}  |  ');
        // stdout.write('${grid[i][j]}  |  ');
        _printCell(grid[i][j]);
      }
      stdout.write('\n');
    }
    _printDashes();
  }
}
