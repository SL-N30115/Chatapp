class UserModel {
  String email;
  String username;
  String uid;

  UserModel({
    required this.email,
    required this.username,
    required this.uid,
  });

  // Factory constructor to create a User from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      username: json['username'],
      uid: json['uid'],
    );
  }

  // Method to convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'uid': uid,
    };
  }
}
