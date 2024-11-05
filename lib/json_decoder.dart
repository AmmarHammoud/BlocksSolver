import 'dart:convert';
import 'dart:io';

/// to decode a json file from a given path
Future<dynamic> readJsonFile({
  required String filePath,
  bool withIndent = false,
}) async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input);
  var d = JsonEncoder.withIndent("   ");
  return withIndent ? d.convert(map) : map;
}
