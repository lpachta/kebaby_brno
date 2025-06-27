import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kebaby_brno/core/widgets/tile_widget.dart';

class DataView extends StatelessWidget {
  final Stream<QuerySnapshot> snapshotStream;

  const DataView({super.key, required this.snapshotStream});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Viewer"),
        foregroundColor: theme.secondaryHeaderColor,
        backgroundColor: theme.primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: snapshotStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Něco se pokazilo.");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return KebabTile(
                    accountName: data['accountName'] ?? 'Neznámý podnik',
                    address: data['address'] ?? 'Neznámá adresa',
                    type: data['type'] ?? '???',
                    price: data['price'] ?? 0,
                    discount: data['discount'],
                    foodRating: data['foodRating'] ?? 0,
                    vibeRating: data['vibeRating'] ?? 0,
                    notes: data['notes'],
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }
}
