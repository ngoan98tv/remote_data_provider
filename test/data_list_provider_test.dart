import 'package:flutter_test/flutter_test.dart';
import 'package:remote_data_provider/data_list_provider.dart';

void main() {
  test('data list provider on refresh', () async {
    final test = TestProvider();

    await test.refresh();
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isLoading, false);
    expect(test.data, ["Data1", "Data2", "Data3"]);
  });

  test('data list provider on add', () async {
    final test = TestProvider();

    await test.add("newDataString");
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isAdding, false);
    expect(test.data.last, "newDataString");
  });

  test('data list provider on remove', () async {
    final test = TestProvider();

    await test.removeAt(0);
    expect(test.isEmpty, false);
    expect(test.isError, false);
    expect(test.isRemoving, false);
    expect(test.data.first, "Data2");
  });

  test('data list provider on error', () async {
    final test = ErrorProvider();

    await test.refresh();
    expect(test.isEmpty, true);
    expect(test.isError, true);
    expect(test.isLoading, false);
    expect(test.error.runtimeType, Error);
  });
}

class TestProvider extends DataListProvider<String> {
  @override
  Future<List<String>> onFetch() async {
    return ["Data1", "Data2", "Data3"];
  }
}

class ErrorProvider extends DataListProvider<String> {
  @override
  Future<List<String>> onFetch() async {
    throw Error();
  }
}
