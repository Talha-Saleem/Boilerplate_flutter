import "dart:convert";

import "package:flutter/foundation.dart";

import "package:flutter_app/Util/constants.util.dart";

class ConversationModel {
  const ConversationModel({
    this.members,
    this.lastMessage,
    this.lastMessageDate,
    this.id,
  });

  factory ConversationModel.fromMap(
          final Map<String, dynamic> map, final String id) =>
      ConversationModel(
        members: map["members"] != null
            ? List<Member>.from((map["members"] as List<dynamic>)
                .map((final x) => Member.fromMap(x as Map<String, dynamic>))
                .toList())
            : null,
        lastMessage: map["lastMessage"] as String?,
        lastMessageDate: map["lastMessageDate"] as String?,
        id: map["id"] as String? ?? id,
      );

  factory ConversationModel.fromJson(final String source, final String id) =>
      ConversationModel.fromMap(
          json.decode(source) as Map<String, dynamic>, id);

  final List<Member>? members;
  final String? lastMessage;
  final String? lastMessageDate;
  final String? id;

  ConversationModel copyWith({
    final List<Member>? members,
    final String? lastMessage,
    final String? lastMessageDate,
    final String? id,
  }) =>
      ConversationModel(
        members: members ?? this.members,
        lastMessage: lastMessage ?? this.lastMessage,
        lastMessageDate: lastMessageDate ?? this.lastMessageDate,
        id: id ?? this.id,
      );

  Map<String, dynamic> toMap() => {
        "members": members?.map((final x) => x.toMap()).toList(),
        "lastMessage": lastMessage,
        "lastMessageDate": lastMessageDate,
        //'id': id,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      "ConversationModel(members: $members, lastMessage: $lastMessage, lastMessageDate: $lastMessageDate, id: $id)";

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ConversationModel &&
        listEquals(other.members, members) &&
        other.lastMessage == lastMessage &&
        other.lastMessageDate == lastMessageDate &&
        other.id == id;
  }

  @override
  int get hashCode =>
      members.hashCode ^
      lastMessage.hashCode ^
      lastMessageDate.hashCode ^
      id.hashCode;
}

class Member {
  const Member({
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  factory Member.fromMap(final Map<String, dynamic> map) => Member(
        name: map["name"] as String,
        email: map["email"] as String,
        profilePicture:
            map["profilePicture"] as String? ?? maleProfilePicturePaths.first,
      );

  factory Member.fromJson(final String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);

  final String name;
  final String email;
  final String profilePicture;

  Member copyWith({
    final String? name,
    final String? email,
    final String? profilePicture,
  }) =>
      Member(
        name: name ?? this.name,
        email: email ?? this.email,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "profilePicture": profilePicture,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      "Member(name: $name, email: $email, profilePicture: $profilePicture)";

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Member &&
        other.name == name &&
        other.email == email &&
        other.profilePicture == profilePicture;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ profilePicture.hashCode;
}
