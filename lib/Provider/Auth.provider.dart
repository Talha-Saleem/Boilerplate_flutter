import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_app/Api/auth.api.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Util/constants.util.dart";
import "package:flutter_app/Util/functions.util.dart";

enum AuthStatus {
  uninitialized,
  unauthenticated,
  authenticating,
  authenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.uninitialized;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? user;

  AuthStatus get authStatus => _authStatus;

  set authStatus(final AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

  Future<void> signUp(final BuildContext context, final String email,
      final String password, final String username, final String gender) async {
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await result.user!.updateDisplayName(username);
      user = UserModel(result.user!.uid, email, username,
          await getUniqueProfilePicture(gender), gender);
      await AuthApiService().signUpUser(user!);
      await login(context, email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            e.message ?? "An error has occurred!",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red));
      rethrow;
    }
  }

  //Login user - (Firebase)
  Future<void> login(final BuildContext context,
      {required final String email, required final String password}) async {
    try {
      authStatus = AuthStatus.authenticating;
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = await _firestore
          .collection(collectionNames[Collections.users]!)
          .doc(result.user!.uid)
          .get();

      user = UserModel(
          result.user!.uid,
          result.user!.email!,
          result.user!.displayName!,
          (userData.data()?["profilePicture"] as String?) ??
              maleProfilePicturePaths.first,
          (userData.data()?["gender"] as String?) ?? "male");
      authStatus = AuthStatus.authenticated;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            e.message ?? "An error has occurred!",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red));
      authStatus = AuthStatus.unauthenticated;
      rethrow;
    }
  }

  //Checks if any user is Signed In, if yes then set status to authenticate - (Firebase)
  Future<void> isSignedIn({required final BuildContext context}) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        final userData = await _firestore
            .collection(collectionNames[Collections.users]!)
            .doc(currentUser.uid)
            .get();

        user = UserModel(
            currentUser.uid,
            currentUser.email!,
            currentUser.displayName!,
            (userData.data()?["profilePicture"] as String?) ??
                maleProfilePicturePaths.first,
            (userData.data()?["gender"] as String?) ?? "male");
        authStatus = AuthStatus.authenticated;
      } else {
        authStatus = AuthStatus.unauthenticated;
      }
    } catch (error) {
      //Handle Error
      authStatus = AuthStatus.unauthenticated;
      rethrow;
    }
  }

  //Signs out the current user - (Firebase)
  Future<void> signOut() async {
    try {
      await auth.signOut();
      authStatus = AuthStatus.unauthenticated;
    } catch (e) {
      rethrow;
    }
  }
}
