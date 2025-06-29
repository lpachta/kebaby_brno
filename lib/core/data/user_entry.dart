class UserEntry {
  String email;
  String userName;
  List<String> permissions; // edit_all, admin
  final date;

  UserEntry({
    required String this.email,
    required String this.userName,
    List<String>? permissions,
    this.date,
  }) : this.permissions = permissions ?? ['add', 'edit_own'];

  Map<String, dynamic> toJson() => {
    "email": email,
    "userName": userName,
    "permissions": permissions,
    "date": date,
  };

  factory UserEntry.fromJson(Map<String, dynamic> json) {
    return UserEntry(email: json['email'], userName: json['userName']);
  }
}
