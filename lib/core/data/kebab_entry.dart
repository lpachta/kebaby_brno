class KebabEntry {
  String accountName;
  String address;
  String type;
  int price;
  int? discount;
  int foodRating;
  int vibeRating;
  String? notes;

  KebabEntry(
    this.accountName,
    this.address,
    this.type,
    this.price,
    this.discount,
    this.foodRating,
    this.vibeRating,
    this.notes,
  );

  @override
  String toString() {
    return 'KebabEntry{accountName: $accountName, address: $address, type: $type, price: $price, discount: $discount, foodRating: $foodRating, vibeRating: $vibeRating, notes: $notes}';
  }
}
