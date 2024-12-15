class User {
  final String username;
  final String password;
  final String? email;

  User({required this.username, required this.password, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String? ?? "",
      password: json['password'] as String? ?? "",
      email: json['email'] as String? ?? "",
    );
  }
}
