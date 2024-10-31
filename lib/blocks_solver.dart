import 'dart:convert';
import 'dart:io';

Future<dynamic> readJsonFile({
  required String filePath,
  bool withIndent = false,
}) async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input);
  var d = JsonEncoder.withIndent("   ");
  return withIndent ? d.convert(map) : map['field'];
}
