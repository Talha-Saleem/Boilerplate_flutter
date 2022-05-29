import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Util/constants.util.dart";
import "package:flutter_app/Widget/loader.widget.dart";
import "package:flutter_app/Widget/user.widget.dart";

class UsersScreen extends StatefulWidget {
  const UsersScreen({required this.loggedInUser, final Key? key}): super(key: key);
  final UserModel loggedInUser;

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(final BuildContext context) => SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Users",
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
                      .collection(collectionNames[Collections.users]!)
                      .where("id", isNotEqualTo: widget.loggedInUser.id)
                      .snapshots(),
                  builder: (final context, final snapshot) {
                    if (!snapshot.hasData) {
                      return const LoadingWidget();
                    }

                    final List<DocumentSnapshot> docs = snapshot.data!.docs;

                    final List<Widget> users = docs
                        .map((final doc) => UserModel.fromMap(
                            doc.data()! as Map<String, dynamic>))
                        .map((final user) =>
                            UserWidget(user, widget.loggedInUser))
                        .toList();

                    return users.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: const Text(
                                "You have no contacts at the moment.."),
                          )
                        : ListView(
                            children: users,
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      );
}
