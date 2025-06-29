import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kebaby_brno/core/data/kebab_entry.dart';
import 'package:kebaby_brno/core/data/user_entry.dart';

class KebabDatabase {
  final _db = FirebaseFirestore.instance;
  final KEBAB_COLLECTION_NAME = "kebaby";
  final USER_COLLECTION_NAME = 'users';

  void addKebab(KebabEntry data) async {
    //await _db.collection(COLLECTION_NAME).add(data.toJson());
    _db
        .collection(KEBAB_COLLECTION_NAME)
        .doc()
        .set(data.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }

  void addUser(UserEntry data) async {
    //await _db.collection(COLLECTION_NAME).add(data.toJson());
    _db
        .collection(USER_COLLECTION_NAME)
        .doc()
        .set(data.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<String?> get userNameFromCurrentEmail async {
    final snapshot = await _db.collection(USER_COLLECTION_NAME).get();
    for (var doc in snapshot.docs) {
      if (doc['email'] == FirebaseAuth.instance.currentUser?.email) {
        return doc['userName'];
      }
    }
    return null;
  }

  get kebabSnapshots {
    return _db.collection(KEBAB_COLLECTION_NAME).snapshots();
  }

  Future<QuerySnapshot> get userCollection async {
    return await _db.collection(USER_COLLECTION_NAME).get();
  }

  /// id is email
  getUserWithId(String id) {
    return _db.collection(USER_COLLECTION_NAME).doc(id).get();
  }
}
