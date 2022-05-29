import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_app/Model/conversation.model.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Util/constants.util.dart";

class UserApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // conversation exists or not
  Future<ConversationModel?> getConversation(
      final Member chatUser1, final Member chatUser2) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(collectionNames[Collections.conversations]!)
        .where("members",
            isEqualTo: List.from(getSortedUsersMap([chatUser1, chatUser2])))
        .get();

    final List<ConversationModel> conversations = snapshot.docs
        .map((final doc) => ConversationModel.fromMap(
            doc.data()! as Map<String, dynamic>, doc.id))
        .toList();

    if (conversations.isNotEmpty) {
      return conversations[0];
    } else {
      return null;
    }
  }

  Future<ConversationModel> makeConversation(
      final Member chatUser1, final Member chatUser2) async {
    final ConversationModel conversationModel = ConversationModel(
        members: getSortedUsers([chatUser1, chatUser2]),
        lastMessage: "",
        lastMessageDate: "");

    final DocumentReference doc = await _firestore
        .collection(collectionNames[Collections.conversations]!)
        .add(conversationModel.toMap());

    final DocumentSnapshot snapshot = await _firestore
        .collection(collectionNames[Collections.conversations]!)
        .doc(doc.id)
        .get();

    return ConversationModel.fromMap(
        snapshot.data()! as Map<String, dynamic>, snapshot.id);
  }

  List<Member> getSortedUsers(final List<Member> userModels) {
    userModels.sort(
        (final a, final b) => a.email.compareTo(b.email));
    return userModels;
  }

  List<Map<String, dynamic>> getSortedUsersMap(final List<Member> userModels) {
    userModels.sort(
        (final a, final b) => a.email.compareTo(b.email));
    return userModels.map((final e) => e.toMap()).toList();
  }

  // conversation exists or not
  Future<UserModel> getUserWithEmail(final String? selectedUserEmail) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(collectionNames[Collections.users]!)
        .where("email", isEqualTo: selectedUserEmail)
        .get();
    return UserModel.fromMap(
        snapshot.docs.first.data()! as Map<String, dynamic>);
  }
}
