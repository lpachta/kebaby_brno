import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kebaby_brno/core/data/kebab_entry.dart';
import 'package:kebaby_brno/core/data/user_entry.dart';
import 'package:kebaby_brno/core/firebase/database.dart';
import 'package:kebaby_brno/core/widgets/settings_widget.dart';
import 'data_view_widget.dart';
import 'form_widget.dart';

class KebabAppScaffold extends StatefulWidget {
  final KebabDatabase db;
  final snapshotStream;
  final UserEntry user;

  @override
  State<KebabAppScaffold> createState() => _KebabAppScaffoldState();

  KebabAppScaffold({
    super.key,
    required this.db,
    required this.user,
    snapshotStream,
  }) : snapshotStream = snapshotStream ?? db.kebabSnapshots;

  void onSubmit(KebabEntry entry) => db.addKebab(entry);
}

class _KebabAppScaffoldState extends State<KebabAppScaffold> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    KebabFormWidget(onSubmit: widget.onSubmit, user: widget.user),
    KebabDataViewWidget(snapshotStream: widget.snapshotStream),
    KebabSettingsWidget(),
  ];

  late final _titles = [
    "Ahoj, ${widget.user.userName}!",
    'Favorites',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        foregroundColor: Theme.of(context).cardColor,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text('Navigation', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              selected: _selectedIndex == 0,
              onTap: () => _onItemSelected(0),
            ),
            ListTile(
              title: const Text('Favorites'),
              leading: const Icon(Icons.favorite),
              selected: _selectedIndex == 1,
              onTap: () => _onItemSelected(1),
            ),
            ListTile(
              title: const Text('Settings'),
              leading: const Icon(Icons.settings),
              selected: _selectedIndex == 2,
              onTap: () => _onItemSelected(2),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/sign-in');
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  void _onItemSelected(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context); // close the drawer
  }
}
