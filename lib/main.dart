import 'package:flutter/material.dart';
import 'package:kebaby_brno/core/data/kebab_entry.dart';
import 'package:kebaby_brno/core/widgets/data_view_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kebaby_brno/firebase/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(db: KebabDatabase()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.db});

  final KebabDatabase db;

  void onSubmit(KebabEntry entry) {
    db.add(entry);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Example',
      // home: FormWidget(onSubmit: onSubmit),
      home: DataView(snapshotStream: db.snapshots),
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
