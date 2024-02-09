import 'dart:convert';
import 'dart:io';

mixin JsonSerializable {
  String get jsonFilepath;
  Map<String, dynamic> toJson();

  void saveToJson() {
    var json = const JsonEncoder.withIndent("  ").convert(this);

    File file = File(jsonFilepath);

    file.writeAsStringSync(json);
  }

  Map<String, dynamic>? loadFromJson() {
    File file = File(jsonFilepath);

    if(!file.existsSync()) {
      saveToJson();
      return null;
    }

    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}