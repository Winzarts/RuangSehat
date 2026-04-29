class UserModel {
  final String? id;
  final String? name;
  final String? username;

  UserModel({this.id, this.name, this.username});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
    );
  }
}