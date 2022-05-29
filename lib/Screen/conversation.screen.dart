import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_app/Model/conversation.model.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Util/constants.util.dart";
import "package:flutter_app/Widget/loader.widget.dart";
import "package:flutter_app/Widget/recent_conversation.widget.dart";

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({required this.loggedInUser, final Key? key})
      : super(key: key);
  final UserModel loggedInUser;

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Conversations",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      letterSpacing: 1.1),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection(collectionNames[Collections.conversations]!)
                      .where("members",
                          arrayContains: Member(
                                  name: widget.loggedInUser.name,
                                  email: widget.loggedInUser.email,
                                  profilePicture:
                                      widget.loggedInUser.profilePicture!)
                              .toMap())
                      .snapshots(),
                  builder: (final context, final snapshot) {
                    if (!snapshot.hasData) {
                      return const LoadingWidget();
                    }

                    final List<DocumentSnapshot> docs = snapshot.data!.docs;

                    final List users = docs
                        .map((final doc) => ConversationModel.fromMap(
                            doc.data()! as Map<String, dynamic>, doc.id))
                        .map((final conversation) => RecentConversation(
                            conversation, widget.loggedInUser))
                        .toList();

                    return users.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: const Text(
                                "You have no active conversations.."),
                          )
                        : ListView(
                            children: users as List<Widget>,
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      );
}
