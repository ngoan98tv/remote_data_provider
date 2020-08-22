import 'package:example/helpers/json_reader.dart';
import 'package:remote_data_provider/extended_http.dart';

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
    final data = await ExtendedHttp().get("https://raw.githubusercontent.com/ngoan98tv/remote_data_provider/master/example/assets/user.json");
    final json = JsonHelper.parseString(data.body);
    return User.fromJson(json);
  }

  static Future<List<User>> fetchUserList() async {
    final data = await ExtendedHttp().get("https://raw.githubusercontent.com/ngoan98tv/remote_data_provider/master/example/assets/users_list.json");
    final json = JsonHelper.parseString(data.body);
    final userMap = List<Map<String, dynamic>>.from(json);
    final userList = userMap.map((e) => User.fromJson(e)).toList();
    return userList;
  }
}
