import 'dart:io';
import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';

class ProfilePictureManager {
  final List<File> _pictures = [];
  final _directory = BotFiles().getDir("profile_pictures");
  late final BotTimer timer;

  List<File> get pictures => _pictures;

  ProfilePictureManager() {
    loadPictures();

    timer = BotTimer.periodic(() => Bot().config.profilePictureCooldown, () {
      if(!Bot().config.profilePictureEnable) return;
      final file = _pictures[Random().nextInt(_pictures.length)];
      
      ImageBuilder? image;
      switch(file.path.split('.').last.toLowerCase()) {
        case 'jpg':
        case 'jpeg':
          image = ImageBuilder.jpeg(File(file.path).readAsBytesSync());
          break;
        case 'png':
          image = ImageBuilder.png(File(file.path).readAsBytesSync());
          break;
      }

      if(image != null) {
        Bot().client.user.manager.updateCurrentUser(UserUpdateBuilder(avatar: image));
        logging.logger.info("Bot updated his profile picture.");
      }
    });
  }

  void loadPictures() {
    _pictures.clear();

    for(final file in _directory.listSync()) {
      final filename = file.path.split(r'\').last;
      if(!filename.contains('.')) continue;

      final extension = filename.split('.').last;
      if(!['jpg', 'jpeg', 'png'].contains(extension)) continue;

      _pictures.add(File(file.path));
    }
  }

  void setImages(List<File> newFiles) {
    for(final file in pictures) {
      if(!newFiles.contains(file)) file.deleteSync();
    }


    for(final file in newFiles) {
      if(_pictures.contains(file)) continue;
      final name = file.path.hashCode.toString();
      final extension = file.path.split('.').last;

      file.copySync("${_directory.path}\\$name.$extension");
    }

    loadPictures();
  }
}