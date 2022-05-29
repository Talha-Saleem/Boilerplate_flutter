import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_app/Util/constants.util.dart";

int getMaleRandomImageIndex() =>
    Random().nextInt(maleProfilePicturePaths.length);
int getFemaleRandomImageIndex() =>
    Random().nextInt(femaleProfilePicturePaths.length);

String getProfilePicture(final String gender) => gender == "male"
    ? maleProfilePicturePaths[getMaleRandomImageIndex()]
    : femaleProfilePicturePaths[getFemaleRandomImageIndex()];

Future<String> getUniqueProfilePicture(final String gender) async {
  final userData = await FirebaseFirestore.instance
      .collection(collectionNames[Collections.users]!)
      .get();
  if (userData.size > 0) {
    final List<String?> userImages = userData.docs
        .map((final e) => (e.data()["profilePicture"] ?? "").toString())
        .toList();
    if (gender == "male") {
      return maleProfilePicturePaths.firstWhere(
          (final element) => !userImages.contains(element),
          orElse: () => getProfilePicture(gender));
    } else {
      return femaleProfilePicturePaths.firstWhere(
          (final element) => !userImages.contains(element),
          orElse: () => getProfilePicture(gender));
    }
  } else {
    return getProfilePicture(gender);
  }
}
