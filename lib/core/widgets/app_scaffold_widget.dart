import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data_view_widget.dart';
import 'form_widget.dart';

class KebabAppScaffold extends StatefulWidget {
  final onSubmit;
  final snapshotStream;

  @override
  State<KebabAppScaffold> createState() => _KebabAppScaffoldState();

  const KebabAppScaffold({
    super.key,
    required this.onSubmit,
    required this.snapshotStream,
  });
}

class _KebabAppScaffoldState extends State<KebabAppScaffold> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    KebabFormWidget(onSubmit: widget.onSubmit),
    KebabDataViewWidget(snapshotStream: widget.snapshotStream),
  ];

  final _titles = ['Home', 'Favorites', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
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
