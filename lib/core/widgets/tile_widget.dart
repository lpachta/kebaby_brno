import 'package:flutter/material.dart';

class KebabTile extends StatelessWidget {
  final String accountName;
  final String address;
  final String type;
  final int price;
  final int? discount;
  final int foodRating;
  final int vibeRating;
  final String? notes;

  const KebabTile({
    super.key,
    required this.accountName,
    required this.address,
    required this.type,
    required this.price,
    required this.foodRating,
    required this.vibeRating,
    this.discount,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(address, style: Theme.of(context).textTheme.titleLarge),
                Text(
                  type,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Address
            Text(accountName, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 8),

            // Price & Discount
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.green[700], size: 20),
                Text(
                  '$price Kč',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (discount != null) ...[
                  const SizedBox(width: 10),
                  Icon(
                    Icons.keyboard_double_arrow_down,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  Text(
                    '-$discount Kč',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Ratings
            Row(
              children: [
                const Icon(Icons.fastfood, size: 20, color: Colors.orange),
                const SizedBox(width: 4),
                Text("Jídlo: $foodRating / 100"),
                const SizedBox(width: 16),
                const Icon(Icons.mood, size: 20, color: Colors.purple),
                const SizedBox(width: 4),
                Text("Atmosféra: $vibeRating / 100"),
              ],
            ),

            // Notes (if present)
            if (notes != null && notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Poznámky:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(notes!),
            ],
          ],
        ),
      ),
    );
  }
}
