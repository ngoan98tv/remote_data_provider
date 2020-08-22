import 'package:example/models/user.dart';
import 'package:remote_data_provider/basic_data_provider.dart';

class UserProvider extends BasicDataProvider<User> {
  @override
  Future<User> onFetch() async {
    final user = await User.fetchUser();
    return user;
  }
}
