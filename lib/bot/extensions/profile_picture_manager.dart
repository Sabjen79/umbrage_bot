import 'dart:io';

import 'package:nyxx/nyxx.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/util/bot_files.dart';
import 'package:umbrage_bot/bot/util/bot_timer.dart';
import 'package:umbrage_bot/bot/util/pseudo_random_index.dart';

class ProfilePictureManager {
  final List<File> _pictures = [];
  late PseudoRandomIndex _pseudoRandomIndex;
  final _directory = BotFiles().getDir("profile_pictures");
  late final BotTimer timer;

  List<File> get pictures => _pictures;

  ProfilePictureManager() {
    loadPictures();

    timer = BotTimer.periodic(() => Bot().config.profilePictureCooldown, () {
      if(!Bot().config.profilePictureEnable) return;
      final file = _pictures[_pseudoRandomIndex.getNextIndex()];
      
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
        Bot().client.user.manager.updateCurrentUser(UserUpdateBuilder(avatar: image)).then((value) {
          logging.logger.info("Bot updated his profile picture.");
        }, onError: (e, s) {
          logging.logger.warning("You are changing the bot's avatar too fast. Try again later...");
        });
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

    _pseudoRandomIndex = PseudoRandomIndex(_pictures.length);
  }

  void setImages(List<File> newFiles) {
    for(final file in pictures) {
      if(!newFiles.map((e) => e.absolute.path).contains(file.absolute.path)) file.deleteSync();
    }

    for(final file in newFiles) {
      if(_pictures.contains(file)) continue;
      String filename = file.path.split('\\').last.split('.').first;
      final extension = file.path.split('.').last;
      String newPath = "${_directory.path}\\$filename.$extension";

      while(_directory.listSync().map((e) => e.path).contains(newPath)) {
        filename = '${filename}0';
        newPath = "${_directory.path}\\$filename.$extension";
      }

      file.copySync(newPath);
    }

    loadPictures();
  }
}