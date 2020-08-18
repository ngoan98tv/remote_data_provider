import 'package:example/models/user.dart';
import 'package:remote_data_provider/data_list_provider.dart';

class UserListProvider extends DataListProvider<User> {
  @override
  Future<List<User>> fetchData() async {
    // simulate loading state
    await Future.delayed(const Duration(seconds: 3));

    final userList = User.fetchUserList();
    return userList;
  }
}
