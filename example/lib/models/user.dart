import 'package:example/helpers/json_reader.dart';

class User {
  final int id;
  String name;

  User({this.id, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }

  static Future<User> fetchUser() async {
    final json = await JsonHelper.readAsset("assets/user.json");
    return User.fromJson(json);
  }

  static Future<List<User>> fetchUserList() async {
    final json = await JsonHelper.readAsset("assets/users_list.json");
    final userMap = List<Map<String, dynamic>>.from(json);
    final userList = userMap.map((e) => User.fromJson(e)).toList();
    return userList;
  }
}
