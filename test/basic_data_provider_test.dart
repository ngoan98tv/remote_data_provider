import 'package:flutter_test/flutter_test.dart';

import 'package:remote_data_provider/basic_data_provider.dart';

void main() {
  test('init basic provider', () {
    final test = TestProvider();
    expect(test.isEmpty, true);
  });
}

class TestProvider extends BasicDataProvider {
  @override
  Future fetchData() async {
    return null;
  }
}