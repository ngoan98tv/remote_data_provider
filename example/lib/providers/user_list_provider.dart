import 'package:example/helpers/json_reader.dart';
import 'package:example/models/user.dart';
import 'package:remote_data_provider/data_list_provider.dart';

class UserListProvider extends DataListProvider<User> {
  @override
  Future<List<User>> fetchData() async {
    // simulate loading state
    await Future.delayed(const Duration(seconds: 3));

    final json = await JsonHelper.readAsset("assets/users_list.json");
    final userMap = List<Map<String, dynamic>>.from(json);
    final userList = userMap.map((e) => User.fromJson(e)).toList();
    return userList;
  }
}
