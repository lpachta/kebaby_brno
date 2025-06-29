import 'package:cloud_firestore/cloud_firestore.dart';

class KebabEntry {
  String accountName;
  String address;
  String type;
  int price;
  int? discount;
  int foodRating;
  int vibeRating;
  String? notes;
  final date = FieldValue.serverTimestamp();

  KebabEntry({
    required this.accountName,
    required this.address,
    required this.type,
    required this.price,
    required this.discount,
    required this.foodRating,
    required this.vibeRating,
    required this.notes,
  });

  @override
  String toString() {
    return 'KebabEntry{accountName: $accountName, address: $address, type: $type, price: $price, discount: $discount, foodRating: $foodRating, vibeRating: $vibeRating, notes: $notes, date: $date}';
  }

  Map<String, dynamic> toJson() {
    return {
      "accountName": accountName,
      "address": address,
      "type": type,
      "price": price,
      "discount": discount,
      "foodRating": foodRating,
      "vibeRating": vibeRating,
      "notes": notes,
      "date": date,
    };
  }
}
