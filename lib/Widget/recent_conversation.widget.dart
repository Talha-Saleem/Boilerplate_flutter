import "package:flutter/material.dart";
import "package:flutter_app/Model/conversation.model.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Screen/chat.screen.dart";
import "package:flutter_app/Widget/profile_picture.widget.dart";
import "package:jiffy/jiffy.dart";
import "package:persistent_bottom_nav_bar/persistent-tab-view.dart";

class RecentConversation extends StatefulWidget {
  const RecentConversation(
    this.conversationModel,
    this.loggedInUser, {
    final Key? key,
  }) : super(key: key);
  final ConversationModel conversationModel;
  final UserModel loggedInUser;

  @override
  _RecentConversationState createState() => _RecentConversationState();
}

class _RecentConversationState extends State<RecentConversation>
    with SingleTickerProviderStateMixin {
  UserModel? selectedUser;
  String _lastMessage = "";

  late AnimationController _animationController;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _lastMessage = widget.conversationModel.lastMessage ?? "";

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _opacity = Tween<double>(begin: 0, end: 0.7)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController);

    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.conversationModel.lastMessage != _lastMessage) {
      _lastMessage = widget.conversationModel.lastMessage ?? "";
      _animationController.forward();
    }
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _opacity,
          builder: (final context, final child) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueAccent.withOpacity(_opacity.value),
            ),
            child: child,
          ),
          child: TextButton(
            onPressed: () {
              // open chat with selected user and current user
              pushNewScreen(context,
                  screen: ChatScreen(
                      null, widget.loggedInUser, widget.conversationModel),
                  withNavBar: false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ProfilePictureWidget(path: getProfilePicture(), size: 60),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              getConvTitle()!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (widget.conversationModel.lastMessageDate!.isEmpty)
                              ? ""
                              : (widget.conversationModel.lastMessage!.length >
                                      20)
                                  ? "${widget.conversationModel.lastMessage!.substring(0, 20)}..."
                                  : widget.conversationModel.lastMessage!,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text((widget.conversationModel.lastMessageDate!.isEmpty)
                    ? ""
                    : Jiffy(widget.conversationModel.lastMessageDate)
                        .fromNow()),
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

  //========== Functions ===========//
  String? getConvTitle() {
    String? topic = "";

    for (final member in widget.conversationModel.members!) {
      if (member.email != widget.loggedInUser.email) {
        topic = member.name;
      }
    }
    return topic;
  }

  String getProfilePicture() {
    String profilePicture = "";

    for (final member in widget.conversationModel.members!) {
      if (member.email != widget.loggedInUser.email) {
        profilePicture = member.profilePicture;
      }
    }
    return profilePicture;
  }
}
