import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseUtils {
  ////////////////DB///////////////////
  static const String FIREBASE_DB_COLLECTION_USER_INSPECTIONS =
      "user_inspections";
  static const String FIREBASE_DB_COLLECTION_INSPECTIONS = "inspections";
  static String userId;
  // static const String FIREBASE_DB_FIELD_STATE = "state";

  static CollectionReference getUsersReference() {
    return FirebaseFirestore.instance
        .collection(FirebaseUtils.FIREBASE_DB_COLLECTION_USER_INSPECTIONS)
        .doc(userId)
        .collection(FirebaseUtils.FIREBASE_DB_COLLECTION_INSPECTIONS);
  }

  static CollectionReference getUsersReferenceUID(lotNo) {
    return FirebaseFirestore.instance
        .collection(FirebaseUtils.FIREBASE_DB_COLLECTION_USER_INSPECTIONS)
        .doc(userId)
        .collection("inspections");
  }

  static Future<void> firebaseCustomLogin(String token) async {
    var auth = FirebaseAuth.instance;
    // await auth.signInWithCustomToken(token).then((value) {
    //   debugPrint('Firebase Custom Login Success');
    // });
    try {
      var value = await auth.signInWithCustomToken(token);
      debugPrint('Firebase Custom Login Success');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
