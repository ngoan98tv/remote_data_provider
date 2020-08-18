# Remote Data Provider

Help implementing providers easier with predefined abstract classes, special is for working with remote data.

## Usage

### Single Data Object

```dart
import 'package:remote_data_provider/basic_data_provider.dart';

class /*ProviderName*/ extends BasicDataProvider</*DataType*/> {
  @override
  Future</*DataType*/> fetchData() async {
    
    // Fetch data from API or database or read from files.

    return /*FetchedData*/;
  }
}
```

### A List of Data Object

```dart
import 'package:remote_data_provider/data_list_provider.dart';

class /*ProviderName*/ extends DataListProvider</*DataType*/> {
  @override
  Future<List</*DataType*/>> fetchData() async {
    
    // Fetch data from API or database or read from files.
    
    return /*FetchedData*/;
  }
}
```