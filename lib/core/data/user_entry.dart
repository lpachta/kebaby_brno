import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntry {
  String email;
  String userName;
  List<String> permissions = ["add", 'edit_own']; // edit_all, admin
  final date = FieldValue.serverTimestamp();

  UserEntry({required this.email, required this.userName});

  Map<String, dynamic> toJson() => {
    "email": email,
    "userName": userName,
    "permissions": permissions,
    "date": date,
  };
}
