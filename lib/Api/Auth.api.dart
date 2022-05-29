import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Util/constants.util.dart";

class AuthApiService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpUser(final UserModel userModel) async {
    await _firestore
        .collection(collectionNames[Collections.users]!)
        .doc(userModel.id)
        .set(userModel.toMap());
  }
}
