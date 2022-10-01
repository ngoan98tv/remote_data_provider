import 'package:flutter_test/flutter_test.dart';

import 'package:remote_data_provider/basic_data_provider.dart';

void main() {
  test('basic provider on init', () async {
    final test = TestProvider();

    expect(test.isEmpty, true);
    expect(test.isLoading, true);
    expect(test.isError, false);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.data, "DataString");
  });

  test('basic provider on refresh', () async {
    final test = TestProvider();
    await Future.delayed(Duration(milliseconds: 150));

    test.refresh();

    expect(test.isEmpty, false);
    expect(test.isLoading, true);
    expect(test.isError, false);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.data, "DataString");
  });

  test('basic provider on update', () async {
    final test = TestProvider();
    await Future.delayed(Duration(milliseconds: 150));

    test.update("newDataString");

    expect(test.isUpdating, true);
    expect(test.isError, false);
    expect(test.data, "DataString");

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isUpdating, false);
    expect(test.isError, false);
    expect(test.data, "newDataString");
  });

  test('basic provider on delete', () async {
    final test = TestProvider();
    await Future.delayed(Duration(milliseconds: 150));

    test.delete();

    expect(test.isDeleting, true);
    expect(test.isDeleted, false);
    expect(test.isError, false);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isDeleting, false);
    expect(test.isDeleted, true);
    expect(test.isError, false);
  });

  test('basic provider on error', () async {
    final test = ErrorProvider();
    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isEmpty, true);
    expect(test.isError, true);
    expect(test.isLoading, false);
    expect(test.data, null);
    expect(test.error.toString(), 'Exception: Unexpected Error');
  });
}

class TestProvider extends BasicDataProvider<String> {
  @override
  Future<String> onFetch() async {
    await Future.delayed(Duration(milliseconds: 100));
    return "DataString";
  }

  @override
  Future<bool> onDelete() async {
    await Future.delayed(Duration(milliseconds: 100));
    return true;
  }

  @override
  Future<String> onUpdate(String newData) async {
    await Future.delayed(Duration(milliseconds: 100));
    return newData;
  }
}

class ErrorProvider extends BasicDataProvider<String> {
  @override
  Future<String> onFetch() async {
    throw Exception('Unexpected Error');
  }

  @override
  Future<bool> onDelete() {
    throw UnimplementedError();
  }

  @override
  Future<String> onUpdate(String newData) {
    throw UnimplementedError();
  }
}
