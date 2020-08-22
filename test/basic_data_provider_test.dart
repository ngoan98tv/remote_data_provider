import 'package:flutter_test/flutter_test.dart';

import 'package:remote_data_provider/basic_data_provider.dart';

void main() {
  test('basic provider on refresh', () async {
    final test = TestProvider();

    await test.refresh();
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.data, "DataString");
  });

  test('basic provider on update', () async {
    final test = TestProvider();

    await test.update("newDataString");
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.data, "newDataString");
  });

  test('basic provider on error', () async {
    final test = ErrorProvider();

    await test.refresh();
    expect(test.isEmpty, true);
    expect(test.isError, true);
    expect(test.isLoading, false);
    expect(test.data, null);
    expect(test.error.runtimeType, Error);
  });
}

class TestProvider extends BasicDataProvider<String> {
  @override
  Future<String> onFetch() async {
    return "DataString";
  }
}

class ErrorProvider extends BasicDataProvider<String> {
  @override
  Future<String> onFetch() async {
    throw Error();
  }
}