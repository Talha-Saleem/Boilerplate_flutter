import "package:flutter/material.dart";
import "package:jiffy/jiffy.dart";

class DateMessageWidget extends StatelessWidget {
  const DateMessageWidget({
    required this.title,
    required this.messages,
    final Key? key,
  }) : super(key: key);
  final String title;
  final List<MessageWidget> messages;

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              title,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: messages,
          ),
        ],
      );
}

class MessageWidget extends StatelessWidget {
  const MessageWidget(
    this.from,
    this.text,
    this.date, {
    required this.me,
    required this.printName,
    final Key? key,
  }) : super(key: key);

  final String from;
  final String text;
  final bool me;
  final bool printName;
  final String date;

  @override
  Widget build(final BuildContext context) => SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment:
                me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              if (printName)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    from.split(" ").first,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                )
              else
                const SizedBox.shrink(),
              Material(
                color: me ? Colors.teal : Colors.red,
                borderRadius: BorderRadius.circular(10),
                elevation: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  Jiffy(date).fromNow(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w200, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );
}
