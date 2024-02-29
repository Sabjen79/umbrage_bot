import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:umbrage_bot/bot/bot.dart';
import 'package:umbrage_bot/bot/lexicon/conversation/conversation_message.dart';
import 'package:umbrage_bot/bot/lexicon/events/lexicon_private_event.dart';

class Conversation {
  final List<ConversationMessage> messages;
  final PartialTextChannel channel;
  PartialMessage? replyMessage;
  bool isReply;
  PartialUser? user;
  bool _blocked = false;

  Conversation({
    required List<ConversationMessage> messages,
    required this.channel,
    this.replyMessage,
    this.isReply = false,
    this.user,
  }) : messages = messages.toList() {
    Future.delayed(const Duration(minutes: 5)).then((value) {
      cancel();
    });
  }

  Future<void> advance(MessageCreateEvent event) async {
    if(_blocked) return;
    var eventUser = (await event.member!.get()).user!;
    if(user != null && eventUser.id != user?.id) return;

    user ??= eventUser;
    replyMessage = event.message;

    try {
      sendMessage();
    } catch(e) {
      _blocked = false;
    }
  }

  Future<void> advancePrivate(PrivateMessageEvent event) async {
    if(_blocked) return;
    if(event.message.author is! User || user?.id != event.message.author.id) return;

    user ??= event.message.author as User;
    replyMessage = event.message;

    try {
      sendMessage();
    } catch(e) {
      _blocked = false;
    }
  }

  void sendMessage() async {
    if(messages.isEmpty) {
      cancel();
      return;
    }

    _blocked = true;

    await Future.delayed(Duration(milliseconds: Bot().config.randomReactionSpeed));

    ConversationMessage message;
    do {
      if(messages.isEmpty) return;
      message = messages.removeAt(0);

      if(message.type == 0) { // Message
        if(message.message.trim().isNotEmpty) {
          await channel.triggerTyping();
          await Future.delayed(Duration(milliseconds: (message.message.length / Bot().config.typingSpeed * 1000).toInt()));
          await channel.sendMessage(MessageBuilder(
            content: message.message,
            replyId: isReply ? replyMessage?.id : null
          ));
        } else {
          logging.logger.warning("Bot tried to send an empty message!");
        }

        isReply = false;
        await Future.delayed(const Duration(milliseconds: 100)); // Little delay between messages

      } else if(message.type == 2) { // Reaction
        try {
          var emoji = Bot().client.getTextEmoji(message.message);
          await replyMessage?.react(ReactionBuilder.fromEmoji(emoji));
          
        } catch (e) {
          logging.logger.warning("Unkown emoji: ${message.message}");
        }
      }
    } while(messages.isNotEmpty && message.type != 1); // If wait for response or end of messages

    _blocked = false;
  }

  void cancel() {
    messages.clear();
  }
}