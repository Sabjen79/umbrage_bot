import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation_delimiters.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_private_event.dart';

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

  Future<void> advancePrivate(PrivateMessageEvent event) async {
    if(event.message.author is! User || user?.id != event.message.author.id) return;

    user ??= event.message.author as User;
    replyMessage = event.message;

    sendMessage();
  }

  void sendMessage() async {
    if(messages.isEmpty) {
      cancel();
      return;
    }

    String message = messages.removeAt(0).trim();

    await Future.delayed(Duration(milliseconds: Bot().config.randomReactionSpeed));
    for(var content in message.split(ConversationDelimiters.chain.delimiter)) {
      await Future.delayed(const Duration(milliseconds: 100));

      // Reaction
      var regex = RegExp(r"h([^\w\d\s]{2})".replaceAll("h", ConversationDelimiters.reaction.delimiter));
      for(var match in regex.allMatches(content)) {
        content = content.replaceAll(match[0]!, "");

        var textEmoji = match[0]!.substring(ConversationDelimiters.reaction.delimiter.length);
        try {
          var emoji = Bot().client.getTextEmoji(textEmoji);
          await replyMessage?.react(ReactionBuilder.fromEmoji(emoji));
          
        } catch (e) {
          logging.logger.warning("Unkown emoji: $textEmoji");
        }
      }
      
      if(content.trim().isNotEmpty) {
        await channel.triggerTyping();
        await Future.delayed(Duration(milliseconds: (content.length / Bot().config.typingSpeed * 1000).toInt()));
        await channel.sendMessage(MessageBuilder(
          content: content,
          replyId: isReply ? replyMessage?.id : null

        ));
      } else {
        logging.logger.warning("Bot tried to send an empty message!");
      }

      isReply = false;
    }
  }

  void cancel() {
    messages.clear();
  }
}