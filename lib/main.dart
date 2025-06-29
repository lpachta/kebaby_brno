import 'package:flutter/material.dart';
import 'package:kebaby_brno/core/data/user_entry.dart';
import 'package:kebaby_brno/core/widgets/app_scaffold_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kebaby_brno/core/widgets/settings_widget.dart';
import 'firebase_options.dart';
import 'package:kebaby_brno/core/firebase/database.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:kebaby_brno/core/widgets/enter_user_name_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var myApp = MyApp();
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final KebabDatabase db = KebabDatabase();

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final User? user = snapshot.data;

          /// Waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          /// User is not signed in
          if (user == null) {
            return SignInScreen(
              providers: providers,
              actions: [
                AuthStateChangeAction<UserCreated>((context, state) async {
                  final User? user = state.credential.user;
                  final userName = await enter_user_name_dialogue(
                    context: context,
                    currentUserName: null,
                    db: db,
                  );
                  if (user == null || user.email == null) {
                    throw "user or email is null";
                  }
                  db.addUser(
                    UserEntry(email: user.email!, userName: userName),
                    user.uid,
                  );
                }),
              ],
            );

            /// User is signed in
          } else {
            return FutureBuilder(
              future: db.getUserWithId(user.uid),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                final mapTemp = snapshot.data!.data();
                if (mapTemp == null) {
                  throw ("mapTemp should not be null because it should have been in the database what");
                }

                final UserEntry foundUser = UserEntry.fromJson(mapTemp);

                return KebabAppScaffold(db: db, user: foundUser);
              },
            );
          }
        },
      ),
      routes: {'/settings': (context) => const KebabSettingsWidget()},
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x228b22),
          brightness: Brightness.light,
        ),
      ),
    );
  }
}
