import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kebaby_brno/core/firebase/database.dart';

Future<bool> isUserNameValid({
  required BuildContext context,
  required String? userName,
  required KebabDatabase db,
}) async {
  if (userName == null || userName.isEmpty) {
    return false;
  }

  final snapshot = await db.userCollection;
  for (var userDocument in snapshot.docs) {
    final data = userDocument.data() as Map<String, dynamic>?;

    if (data != null && data['userName'] == userName) {
      return false; // username already taken
    }
  }

  return true; // username is valid (not found in existing docs)
}

Future<String> enter_user_name_dialogue({
  required BuildContext context,
  required String? currentUserName,
  required KebabDatabase db,
}) async {
  final textController = TextEditingController();
  final userName = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Zadejte uživatelské jméno. (Je možno upravit v Nastavení).',
        ),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(labelText: 'Uživatelské jméno'),
        ),
        actions: [
          TextButton(
            onPressed: currentUserName == null
                ? null
                : () => Navigator.of(context).pop(null),
            child: const Text('Zrušit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(textController.text.trim());
            },
            child: const Text('Uložit', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );

  if (!await isUserNameValid(context: context, userName: userName, db: db)) {
    throw ("Uživatelské jméno není validní.");
  }

  return Future.value(userName);
}
