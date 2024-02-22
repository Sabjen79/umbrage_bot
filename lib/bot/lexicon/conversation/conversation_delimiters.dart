import 'dart:io';

enum ConversationDelimiters {
  chain("==>", "Chain Messages", "Sends two messages separately.\n\nUsage: \"a ==> b\"\nSends message a, then b."),
  wait("==?", "Wait For Response", "Sends a message, then waits for a response to send the other.\n\nUsage: \"a ==? b\"\nSends message a, then sends message b when the targeted user responds. If the event doesn't target a specific user, it will trigger at anyone."),
  reaction("react:", "Reaction", "Reacts to the message.\n\nUsage: \"Hello react:😂\"\nSends the message 'Hello' and reacts with 😂 to the replied message.");

  final String delimiter;
  final String name;
  final String _description;

  const ConversationDelimiters(this.delimiter, this.name, this._description);

  String get description => _description.replaceAll("\n", Platform.lineTerminator);
}