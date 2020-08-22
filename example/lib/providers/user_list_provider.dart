import 'package:example/models/user.dart';
import 'package:remote_data_provider/data_list_provider.dart';

class UserListProvider extends DataListProvider<User> {
  @override
  Future<List<User>> onFetch() async {
    final userList = User.fetchUserList();
    return userList;
  }
}
