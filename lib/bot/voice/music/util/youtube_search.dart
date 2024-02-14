import 'package:umbrage_bot/bot/bot.dart';
import 'package:yt/yt.dart';

class YoutubeSearch {
  static Future<String?> searchUrl(String query) async {
    late Yt yt;
    try {
      yt = Yt.withKey(Bot().config.ytApiKey);
      var videoResult = await yt.search.list(q: query, part: 'snippet', type: 'video', maxResults: 1);
      for(var element in videoResult.items) {
        if(element.id.videoId != null) {
          return "https://youtu.be/${element.id.videoId}";
        }
      }
    } catch(e) {
      return null;
    }
    
    return null;
  }
}