import 'dart:io';

import 'package:blocks_solver/constants.dart';

import 'grid.dart';

class UserInteraction {
  static late int userInput;

  static void printWelcomingMessage() {
    printGreen('Welcome to Blocks game\n');
  }

  static void printUserOptions() {
    stdout.write('These are the available options for your:\n');
    stdout.write('1. print the main grid\n');
    stdout.write('2. print the shapes\n');
    stdout.write('3. print a specific shape\n');
    stdout.write('4. assemble a specific shape on the grid\n');
    stdout.write('5. delete a specific shape from the grid\n');
    stdout.write('6. exit\n');
  }

  static void readUserInput() {
    stdout.write('enter you option: ');
    userInput = int.parse(stdin.readLineSync()!);
  }

  static dynamic executeUserOption({
    required Grid mainGrid,
    required List<Grid> shapes,
  }) {
    switch (userInput) {
      case 1:
        mainGrid.print();
        stdout.write('\n');
        return;
      case 2:
        for (int i = 0; i < shapes.length; i++) {
          stdout.write('index: $i\n');
          shapes[i].print();
          stdout.write('\n\n');
        }
        return;
      case 3:
        stdout.write('enter the shape index: ');
        int shapeIndex = int.parse(stdin.readLineSync()!);
        if (shapeIndex > shapes.length - 1) {
          printRed('shape index out of range!\n');
          return;
        }
        shapes[shapeIndex].print();
        stdout.write('\n');
        return;
      case 4:
        mainGrid.print();
        stdout.write('\n');
        stdout.write(
            'enter the ROW index where you want to assemble the shape: ');
        int row = int.parse(stdin.readLineSync()!);
        if (row > mainGrid.rows - 1) {
          printRed('ROW out of range!\n');
          return;
        }
        stdout.write(
            'enter the COLUMN index where you want to assemble the shape: ');
        int column = int.parse(stdin.readLineSync()!);
        if (column > mainGrid.columns - 1) {
          printRed('COLUMN out of range!\n');
          return;
        }
        stdout.write('enter the index of the shape you want to assemble: ');
        int shapeIndex = int.parse(stdin.readLineSync()!);
        mainGrid.fillWithShape(
            shape: shapes[shapeIndex], row: row, column: column);
        return;
      case 5:
        stdout.write(
            'enter the ROW index where you want to delete the shape: ');
        int row = int.parse(stdin.readLineSync()!);
        if (row > mainGrid.rows - 1) {
          printRed('ROW out of range!\n');
          return;
        }
        stdout.write(
            'enter the COLUMN index where you want to delete the shape: ');
        int column = int.parse(stdin.readLineSync()!);
        if (column > mainGrid.columns - 1) {
          printRed('COLUMN out of range!\n');
          return;
        }
        stdout.write('enter the index of the shape you want to delete: ');
        int shapeIndex = int.parse(stdin.readLineSync()!);
        mainGrid.deleteShape(shape: shapes[shapeIndex], row: row, column: column);
      default:
        return false;
    }
  }
}
