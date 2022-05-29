import "dart:convert";

class UserModel {
  UserModel(
    this.id,
    this.email,
    this.name,
    this.profilePicture,
    this.gender,
  );

  factory UserModel.fromMap(final Map<String, dynamic> map) => UserModel(
        map["id"] as String,
        map["email"] as String,
        map["name"] as String,
        map["profilePicture"] as String?,
        map["gender"] as String? ?? "male",
      );

  factory UserModel.fromJson(final String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String id;
  final String email;
  final String name;
  final String? profilePicture;
  final String? gender;

  UserModel copyWith({
    final String? id,
    final String? email,
    final String? name,
    final String? profilePicture,
    final String? gender,
  }) =>
      UserModel(
        id ?? this.id,
        email ?? this.email,
        name ?? this.name,
        profilePicture ?? this.profilePicture,
        gender ?? this.gender,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "profilePicture": profilePicture,
        "gender": gender,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      "UserModel(id: $id, email: $email, name: $name, profilePicture: $profilePicture)";

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.profilePicture == profilePicture;
  }

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ profilePicture.hashCode;
}
