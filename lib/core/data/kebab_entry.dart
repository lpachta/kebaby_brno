class KebabEntry {
  String accountName;
  String address;
  String type;
  int price;
  int? discount;
  int foodRating;
  int vibeRating;
  String? notes;

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
    return 'KebabEntry{accountName: $accountName, address: $address, type: $type, price: $price, discount: $discount, foodRating: $foodRating, vibeRating: $vibeRating, notes: $notes}';
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
    };
  }

  factory KebabEntry.fromJson(Map<String, dynamic> json) {
    return KebabEntry(
      accountName: json['accountName'] ?? '',
      address: json['address'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] ?? 0) as int,
      discount: (json['discount'] ?? 0).toInt(),
      foodRating: (json['foodRating'] ?? 0).toInt(),
      vibeRating: (json['vibeRating'] ?? 0).toInt(),
      notes: json['notes'] ?? '',
    );
  }
}
