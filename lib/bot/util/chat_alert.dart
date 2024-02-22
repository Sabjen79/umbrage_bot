import 'package:nyxx/nyxx.dart';

class ChatAlert {
  static void sendAlert(Message message, String content) {
    if(content.isNotEmpty) {
      message.channel.sendMessage(MessageBuilder(content: content)).then((message) async {
        await Future.delayed(const Duration(seconds: 5));
        message.delete();
      });
    }
    message.delete();
  }
}