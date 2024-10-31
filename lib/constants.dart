/*
Green:   \x1B[32m
Blue:    \x1B[34m
Red:     \x1B[31m
Cyan:    \x1B[36m
Black:   \x1B[30m
Yellow:  \x1B[33m
Magenta: \x1B[35m
White:   \x1B[37m
Reset:   \x1B[0m
*/

import 'dart:io';

const String cyan = '\x1B[36m';
const String red = '\x1B[31m';
const String green = '\x1B[32m';
const String blue = '\x1B[34m';
const String yellow = '\x1B[33m';
const String reset = '\x1B[0m';

printCyan(String t) {
  stdout.write('$cyan$t$reset');
}

printRed(String t) {
  stdout.write('$red$t$reset');
}

printGreen(String t) {
  stdout.write('$green$t$reset');
}

printBlue(String t) {
  stdout.write('$blue$t$reset');
}

printYellow(String t) {
  stdout.write('$yellow$t$reset');
}