import 'package:flutter_test/flutter_test.dart';
import 'package:remote_data_provider/data_list_provider.dart';

void main() {
  test('data list provider on init', () async {
    final test = TestProvider();
    expect(test.isEmpty, true);
    expect(test.isError, false);
    expect(test.isLoading, true);
    expect(test.isAdding, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, []);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.isAdding, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, ["Data1", "Data2", "Data3"]);
  });

  test('data list provider on refresh', () async {
    final test = TestProvider();
    await Future.delayed(Duration(milliseconds: 150));

    test.refresh();

    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, true);
    expect(test.isAdding, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, ["Data1", "Data2", "Data3"]);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.isAdding, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, ["Data1", "Data2", "Data3"]);
  });

  test('data list provider on add', () async {
    final test = TestProvider();
    await Future.delayed(Duration(milliseconds: 150));

    test.add("newDataString");

    expect(test.isError, false);
    expect(test.isAdding, true);
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, ["Data1", "Data2", "Data3"]);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isError, false);
    expect(test.isAdding, false);
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, ["Data1", "Data2", "Data3", "newDataString"]);

    test.add("newDataString1", addToTheStart: true);

    expect(test.isError, false);
    expect(test.isAdding, true);
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, ["Data1", "Data2", "Data3", "newDataString"]);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isError, false);
    expect(test.isAdding, false);
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, [
      "newDataString1",
      "Data1",
      "Data2",
      "Data3",
      "newDataString",
    ]);
  });

  test('data list provider on remove', () async {
    final test = TestProvider();
    await Future.delayed(Duration(milliseconds: 150));

    test.removeAt(0);

    expect(test.isError, false);
    expect(test.isDeleting, true);
    expect(test.isEmpty, false);
    expect(test.isLoading, false);
    expect(test.isAdding, false);
    expect(test.isUpdating, false);
    expect(test.data, ["Data1", "Data2", "Data3"]);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isError, false);
    expect(test.isDeleting, false);
    expect(test.isEmpty, false);
    expect(test.isLoading, false);
    expect(test.isAdding, false);
    expect(test.isUpdating, false);
    expect(test.data, ["Data2", "Data3"]);
  });

  test('data list provider on update', () async {
    final test = TestProvider();
    await Future.delayed(Duration(milliseconds: 150));

    test.updateAt(0, "newData");

    expect(test.isError, false);
    expect(test.isUpdating, true);
    expect(test.isEmpty, false);
    expect(test.isLoading, false);
    expect(test.isAdding, false);
    expect(test.isDeleting, false);
    expect(test.data, ["Data1", "Data2", "Data3"]);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isError, false);
    expect(test.isUpdating, false);
    expect(test.isEmpty, false);
    expect(test.isLoading, false);
    expect(test.isAdding, false);
    expect(test.isDeleting, false);
    expect(test.data, ["newData", "Data2", "Data3"]);
  });

  test('data list provider on error', () async {
    final test = ErrorProvider();
    expect(test.isError, false);
    expect(test.isLoading, true);
    expect(test.isEmpty, true);
    expect(test.isAdding, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, []);

    await Future.delayed(Duration(milliseconds: 150));

    expect(test.isError, true);
    expect(test.isLoading, false);
    expect(test.isEmpty, true);
    expect(test.isAdding, false);
    expect(test.isDeleting, false);
    expect(test.isUpdating, false);
    expect(test.data, []);
    expect(test.error.runtimeType, Error);
  });
}

class TestProvider extends DataListProvider<String> {
  @override
  Future<List<String>> onFetch() async {
    return ["Data1", "Data2", "Data3"];
  }

  @override
  Future<String> onCreate(String newItem) async {
    await Future.delayed(Duration(milliseconds: 100));
    return newItem;
  }

  @override
  Future<bool> onDelete(String item) async {
    await Future.delayed(Duration(milliseconds: 100));
    return true;
  }

  @override
  Future<String> onUpdate(String newData) async {
    await Future.delayed(Duration(milliseconds: 100));
    return newData;
  }
}

class ErrorProvider extends DataListProvider<String> {
  @override
  Future<List<String>> onFetch() async {
    throw Error();
  }

  @override
  Future<String> onCreate(String newItem) {
    throw UnimplementedError();
  }

  @override
  Future<bool> onDelete(String item) {
    throw UnimplementedError();
  }

  @override
  Future<String> onUpdate(String newData) {
    throw UnimplementedError();
  }
}
