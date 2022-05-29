class MessageModel {
  const MessageModel(
      this.text, this.from, this.conversation, this.date, this.fromName);

  MessageModel.fromJson(final Map<String, dynamic> json)
      : text = json["text"] as String,
        conversation = json["conversation"] as String,
        date = json["date"] as String,
        from = json["from"] as String,
        fromName = json["fromName"] as String? ?? json["from"] as String;

  final String text;
  final String from;
  final String fromName;
  final String conversation;
  final String date;

  Map<String, dynamic> toJson() => {
        "text": text,
        "conversation": conversation,
        "from": from,
        "date": date,
        "fromName": fromName
      };
}
