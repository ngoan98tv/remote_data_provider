# Remote Data Provider

![Test](https://github.com/ngoan98tv/remote_data_provider/workflows/Test/badge.svg)
![DryRun](https://github.com/ngoan98tv/remote_data_provider/workflows/Pub%20Dry%20Run/badge.svg)
![Publish](https://github.com/ngoan98tv/remote_data_provider/workflows/Publish/badge.svg)

Help implementing providers easier with predefined abstract classes, special is for working with remote data.

## Usage

### Single Data Object

**Define your provider**

```dart
import 'package:remote_data_provider/basic_data_provider.dart';

class ExampleProvider extends BasicDataProvider<ExampleType> {
  @override
  Future<ExampleType> onFetch() async {

    ExampleType result = await // Future<ExampleType> fetch data

    return result;
  }

  @override
  Future<ExampleType> onUpdate(ExampleType newData) async {

    ExampleType result = await // Future<ExampleType> update newData;

    return result;
  }
}
```

**In the parent widget**

```dart
ChangeNotifierProvider(
  create: (context) => ExampleProvider(),
  child: YourChildWidget()
)
```

**In the `build` function of the child widget**

```dart
final example = Provider.of<ExampleProvider>(context);

bool isLoading = example.isLoading;
bool isError = example.error;
bool isEmpty = example.isEmpty;

ExampleType data = example.data;

Future<void> refresh = example.refresh;
Future<void> update = example.update;
```

### A List of Data Object

**Define your provider**

```dart
import 'package:remote_data_provider/data_list_provider.dart';

class ExampleListProvider extends DataListProvider<ExampleType> {
  @override
  Future<List<ExampleType>> onFetch() async {
    
    List<ExampleType> result = await // Future<List<ExampleType>> fetch data
    
    return result;
  }

  @override
  Future<ExampleType> onAdd(ExampleType newItem) async {
    
    ExampleType result = await // Future<ExampleType> save new item to your databases or APIs
    
    return result;
  }

  @override
  Future<int> onRemove(int index) async {
    ExampleType item = data[index];

    await // remove the item;
    
    return index;
  }
}
```

**In the parent widget**

```dart
ChangeNotifierProvider(
  create: (context) => ExampleListProvider(),
  child: YourChildWidget()
)
```

**In the `build` function of the child widget**

```dart
final exampleList = Provider.of<ExampleListProvider>(context);

bool isLoading = exampleList.isLoading;
bool isError = exampleList.error;
bool isEmpty = exampleList.isEmpty;
bool isAdding = exampleList.isAdding;
bool isRemoving = exampleList.isRemoving;

List<ExampleType> data = exampleList.data;

Future<void> refresh = exampleList.refresh;
Future<void> add = exampleList.add;
Future<void> removeAt = exampleList.removeAt;
```

### Extended HTTP - fetch data from your API with caching and timeout options

All methods from `BaseClient` is inherited, including `get`, `post`, `put`, `patch` and more. See at [BaseClient APIs](https://pub.dev/documentation/http/latest/http/BaseClient-class.html)

```dart
import 'package:remote_data_provider/extended_http.dart';

// Call config at the App init to apply for all following requests, skip to use default config.
ExtendedHttp().config(
  timeout: Duration, // default `Duration(seconds: 60)`
  networkFirst: bool, // default `true`
  headers: Map<String,String>, // default `null`
);
```

## Dependencies

[http](https://pub.dev/packages/http)

[flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)

## References

[provider](https://pub.dev/packages/provider)

## Feel free to [leave an issue](https://github.com/ngoan98tv/remote_data_provider/issues) if you need help or see something wrong in this package.
