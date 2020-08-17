import 'package:example/helpers/json_reader.dart';
import 'package:example/models/user.dart';
import 'package:remote_data_provider/basic_data_provider.dart';

class UserProvider extends BasicDataProvider<User> {
  @override
  Future<User> fetchData() async {
    // simulate loading state
    await Future.delayed(const Duration(seconds: 3));

    final json = await JsonHelper.readAsset("assets/user.json");

    return User.fromJson(json);
  }
}
