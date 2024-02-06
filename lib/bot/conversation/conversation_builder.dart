import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/conversation/conversation_delimiters.dart';

class ConversationBuilder {
  final List<String> messages;
  final PartialTextChannel channel;
  late final StreamSubscription<MessageCreateEvent> stream;
  PartialMessage? replyMessage;
  bool isReply;
  PartialUser? user;

  ConversationBuilder({
    required String content,
    required this.channel,
    this.replyMessage,
    this.isReply = false,
    this.user,
  }) : messages = content.split(ConversationDelimiters.wait.delimiter) {
    stream = Bot().client.onMessageCreate.listen((event) async {
      if(event.member == null) return;

      var eventUser = (await event.member!.get()).user!;
      if(eventUser == Bot().user || (user != null && eventUser != user)) return;

      user ??= eventUser;
      replyMessage = event.message;

      sendMessage();
    });
  }

  void sendMessage() async {
    if(messages.isEmpty) {
      stream.cancel();
      return;
    }

    String message = messages.removeAt(0).trim();

    for(var content in message.split(ConversationDelimiters.chain.delimiter)) {
      // Reaction
      var regex = RegExp(r"h([^\w\d\s]{2})".replaceAll("h", ConversationDelimiters.reaction.delimiter));
      for(var match in regex.allMatches(content)) {
        content = content.replaceAll(match[0]!, "");

        try {
          var emoji = Bot().client.getTextEmoji(match[0]!.substring(ConversationDelimiters.reaction.delimiter.length));
          await replyMessage?.react(ReactionBuilder.fromEmoji(emoji));
          
        } catch (e) {
          
        }
      }

      await Future.delayed(Duration(milliseconds: 500));
      await channel.triggerTyping();
      await Future.delayed(Duration(milliseconds: 2000));
      await channel.sendMessage(MessageBuilder(
        content: content,
        replyId: isReply ? replyMessage?.id : null

      ));

      isReply = false;
    }
  }
}