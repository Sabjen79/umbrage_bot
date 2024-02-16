import 'dart:convert';
import 'dart:io';

mixin JsonSerializable {
  String get jsonFilepath;
  Map<String, dynamic> toJson();

  void saveToJson() {
    var json = const JsonEncoder.withIndent("  ").convert(this);

    File(jsonFilepath)..createSync(recursive: true)..writeAsStringSync(json);
  }

  Map<String, dynamic> loadFromJson() {
    File file = File(jsonFilepath);

    if(!file.existsSync()) {
      File(jsonFilepath)..createSync(recursive: true)..writeAsStringSync("{}");
      return {};
    }

    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}