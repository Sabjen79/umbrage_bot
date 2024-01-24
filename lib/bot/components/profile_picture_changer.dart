import 'dart:io';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nyxx/nyxx.dart';
import 'package:file_picker/file_picker.dart';

class ProfilePictureChanger {
  List<File> files = [];

  void afterConnect(NyxxGateway client) async {
    final prefs = await SharedPreferences.getInstance();

    String? selectedDirectory = prefs.getString("pfp_directory");
    while(selectedDirectory == null) {
      selectedDirectory = await FilePicker.platform.getDirectoryPath();
    }
    prefs.setString("pfp_directory", selectedDirectory);

    Directory dir = Directory(selectedDirectory);
      await dir.list(recursive: false).forEach((f) {
        files.add(File(f.path));
      });

      var image = ImageBuilder.jpeg(await files[Random().nextInt(files.length)].readAsBytes());
      client.user.manager.updateCurrentUser(UserUpdateBuilder(avatar: image));
  }
}