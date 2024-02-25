class ConversationMessage {
  int type;
  String message;

  ConversationMessage(this.type, this.message);

  Map<String, dynamic> toJson() => {
    'type': type,
    'message': message
  };
}