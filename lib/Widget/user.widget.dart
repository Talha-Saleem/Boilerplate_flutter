import "package:flutter/material.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Screen/chat.screen.dart";
import "package:flutter_app/Util/functions.util.dart";
import "package:flutter_app/Widget/profile_picture.widget.dart";
import "package:persistent_bottom_nav_bar/persistent-tab-view.dart";

class UserWidget extends StatelessWidget {
  const UserWidget(
    this.selectedUser,
    this.loggedInUser, {
    final Key? key,
  }) : super(key: key);

  final UserModel selectedUser;
  final UserModel loggedInUser;
  // final UserModel currentUser;

  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                // open chat with selected user and current user
                pushNewScreen(context,
                    screen: ChatScreen(selectedUser, loggedInUser, null),
                    withNavBar: false);
              },
              child: Row(
                children: <Widget>[
                  ProfilePictureWidget(
                      path: selectedUser.profilePicture ??
                          getProfilePicture(selectedUser.gender ?? "male"),
                      size: 60),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(selectedUser.name)
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Divider(
              color: Colors.white38,
            ),
          ),
        ],
      );
}
