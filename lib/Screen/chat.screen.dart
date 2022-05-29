import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_app/Api/user.api.dart";
import "package:flutter_app/Model/conversation.model.dart";
import "package:flutter_app/Model/message.model.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Provider/auth.provider.dart";
import "package:flutter_app/Util/constants.util.dart";
import "package:flutter_app/Util/functions.util.dart";
import "package:flutter_app/Widget/loader.widget.dart";
import "package:flutter_app/Widget/message.widget.dart";
import "package:flutter_app/Widget/profile_picture.widget.dart";
import "package:provider/provider.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.selectedUser, this.loggedInUser, this.conversationModel,
      {final Key? key})
      : super(key: key);

  final UserModel? selectedUser;
  final UserModel loggedInUser;
  final ConversationModel? conversationModel;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  ConversationModel? _conversationModel;
  final FocusNode _focusNode = FocusNode();
  String? _lastMessageSenderName;
  final ScrollController _scrollController = ScrollController();
  final UserApi _userApi = UserApi();

  @override
  void initState() {
    super.initState();
    getInitialData();

    WidgetsBinding.instance!.addPostFrameCallback((final _) {
      _scrollController.jumpTo(0);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final Member? selectedMember = _conversationModel?.members!.firstWhere(
        (final element) => element.email != widget.loggedInUser.email);
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF303030),
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_conversationModel == null ? "" : selectedMember!.name),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: selectedMember?.profilePicture == null
                      ? const SizedBox()
                      : ProfilePictureWidget(
                          path: selectedMember?.profilePicture ??
                              getProfilePicture("male"),
                          size: 40),
                )
              ],
            ),
          ),
          body: (_conversationModel != null)
              ? SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection(
                                  collectionNames[Collections.messages]!)
                              .where("conversation",
                                  isEqualTo: _conversationModel!.id)
                              .orderBy("date")
                              .snapshots(),
                          builder: (final context, final snapshot) {
                            if (snapshot.hasData) {
                              final List<MessageModel> allMessages = snapshot
                                  .data!.docs
                                  .map((final doc) => MessageModel.fromJson(
                                      doc.data()! as Map<String, dynamic>))
                                  .toList();

                              // query issue
                              // allMessages.sort((a, b) => a.date.compareTo(b.date));

                              final Map<String, List<MessageWidget>>
                                  messagesWidget =
                                  <String, List<MessageWidget>>{};
                              for (final doc in allMessages) {
                                if (messagesWidget[getDateString(doc.date)] ==
                                    null) {
                                  messagesWidget[getDateString(doc.date)] = [];
                                }
                                messagesWidget[getDateString(doc.date)]!
                                    .add(MessageWidget(
                                  doc.fromName,
                                  doc.text,
                                  doc.date,
                                  me: widget.loggedInUser.email == doc.from,
                                  printName: _lastMessageSenderName == null ||
                                          doc == allMessages.first
                                      ? true
                                      : _lastMessageSenderName != doc.from,
                                ));
                              }
                              return ListView(
                                controller: _scrollController,
                                reverse: true,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                children: List<Widget>.generate(
                                    messagesWidget.keys.length,
                                    (final index) => DateMessageWidget(
                                        title: messagesWidget.keys.elementAt(
                                            (messagesWidget.keys.length - 1) -
                                                index),
                                        messages: messagesWidget[messagesWidget
                                                .keys
                                                .elementAt((messagesWidget
                                                            .keys.length -
                                                        1) -
                                                    index)] ??
                                            [])),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF303030),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, -4),
                                  blurRadius: 4)
                            ]),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: TextField(
                                  focusNode: _focusNode,
                                  onSubmitted: (final value) => sendMessage(),
                                  decoration: InputDecoration(
                                    hintText: "Enter a Message...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  controller: messageController,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: sendMessage,
                              style: TextButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: const CircleBorder()),
                              child: const Padding(
                                padding: EdgeInsets.all(14),
                                child: Icon(Icons.send),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: LoadingWidget()),
        ),
      ),
    );
  }

  //========== Functions ===========//

  Future<void> getInitialData() async {
    // ConversationModel conversationModel;

    // if conversation model is sent through function (comming from recent screen)
    // and get messages
    if (widget.conversationModel != null) {
      _conversationModel = widget.conversationModel;
    } else {
      // check if conversation exists between
      _conversationModel = await _userApi.getConversation(
        Member(
            name: widget.selectedUser!.name,
            email: widget.selectedUser!.email,
            profilePicture: widget.selectedUser!.profilePicture!),
        Member(
            name: widget.loggedInUser.name,
            email: widget.loggedInUser.email,
            profilePicture: widget.loggedInUser.profilePicture!),
      );

      // if exists then get conversation and than its messages
      _conversationModel ??= await _userApi.makeConversation(
        Member(
            name: widget.selectedUser!.name,
            email: widget.selectedUser!.email,
            profilePicture: widget.selectedUser!.profilePicture!),
        Member(
            name: widget.loggedInUser.name,
            email: widget.loggedInUser.email,
            profilePicture: widget.loggedInUser.profilePicture!),
      );
    }

    setState(() {});
  }

  String getDateString(final String recievedDate) {
    if (isSameDay(DateTime.parse(recievedDate), DateTime.now())) {
      return "Today";
    } else {
      return recievedDate.split("T").first;
    }
  }

  bool isSameDay(final DateTime? a, final DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> sendMessage() async {
    if (_conversationModel != null && messageController.text.isNotEmpty) {
      final MessageModel messageModel = MessageModel(
        messageController.text,
        widget.loggedInUser.email,
        _conversationModel!.id!,
        DateTime.now().toIso8601String(),
        widget.loggedInUser.name,
      );
      messageController.clear();
      _focusNode.requestFocus();
      await _firestore
          .collection(collectionNames[Collections.messages]!)
          .add(messageModel.toJson());
    }
  }
}
