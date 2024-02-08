import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/conversation_delimiters.dart';

class Conversation {
  final List<String> messages;
  final PartialTextChannel channel;
  PartialMessage? replyMessage;
  bool isReply;
  PartialUser? user;

  Conversation({
    required String content,
    required this.channel,
    this.replyMessage,
    this.isReply = false,
    this.user,
  }) : messages = content.split(ConversationDelimiters.wait.delimiter) {
    Future.delayed(const Duration(minutes: 5)).then((value) {
      cancel();
    });
  }

  Future<void> advance(MessageCreateEvent event) async {
    var eventUser = (await event.member!.get()).user!;
    if(user != null && eventUser != user) return;

    user ??= eventUser;
    replyMessage = event.message;

    sendMessage();
  }

  void sendMessage() async {
    if(messages.isEmpty) {
      cancel();
      return;
    }

    String message = messages.removeAt(0).trim();

    await Future.delayed(const Duration(milliseconds: 1500));
    for(var content in message.split(ConversationDelimiters.chain.delimiter)) {
      await Future.delayed(const Duration(milliseconds: 100));

      // Reaction
      var regex = RegExp(r"h([^\w\d\s]{2})".replaceAll("h", ConversationDelimiters.reaction.delimiter));
      for(var match in regex.allMatches(content)) {
        content = content.replaceAll(match[0]!, "");

        try {
          var emoji = Bot().client.getTextEmoji(match[0]!.substring(ConversationDelimiters.reaction.delimiter.length));
          await replyMessage?.react(ReactionBuilder.fromEmoji(emoji));
          
        } catch (e) {
          print("Unkown emoji");
        }
      }
      
      if(content.trim().isNotEmpty) {
        await channel.triggerTyping();
        await Future.delayed(Duration(milliseconds: (content.length / 30 * 1000).toInt()));
        await channel.sendMessage(MessageBuilder(
          content: content,
          replyId: isReply ? replyMessage?.id : null

        ));
      }

      isReply = false;
    }
  }

  void cancel() {
    messages.clear();
  }
}