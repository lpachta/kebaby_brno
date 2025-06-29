import 'package:flutter/material.dart';
import 'package:kebaby_brno/core/data/kebab_entry.dart';
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
  var myApp = MyApp(db: KebabDatabase());
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.db});

  final KebabDatabase db;

  void onSubmit(KebabEntry entry) => db.addKebab(entry);

  void onSignedIn(context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    return MaterialApp(
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/sign-in'
          : '/home',
      routes: {
        '/sign-in': (context) => SignInScreen(
          providers: providers,
          actions: [
            AuthStateChangeAction<UserCreated>((context, state) async {
              // TODO: Add new account to the database
              final user = state.credential.user;
              final userName = await enter_user_name_dialogue(
                context: context,
                currentUserName: null,
                db: db,
              );
              if (user == null || user.email == null) {
                throw "user or email is null";
              }
              db.addUser(UserEntry(email: user.email!, userName: userName));

              onSignedIn(context);
            }),
            AuthStateChangeAction<SignedIn>((context, state) {
              onSignedIn(context);
            }),
          ],
        ),
        '/home': (context) => KebabAppScaffold(
          onSubmit: onSubmit,
          snapshotStream: db.kebabSnapshots,
        ),
        '/settings': (context) => const KebabSettingsWidget(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x228b22),
          brightness: Brightness.light,
        ),
      ),
    );
  }
}
