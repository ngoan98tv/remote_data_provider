import 'package:flutter/foundation.dart';

/// A provider to provide a list of data with type `T`
abstract class DataListProvider<T> with ChangeNotifier {
  List<T> _data;
  bool _isLoading;
  dynamic _error;
  bool _isMounted;

  DataListProvider() {
    _data = List();
    _error = null;
    _isLoading = true;
    _isMounted = true;
    _makeData();
  }

  @override
  void dispose() {
    super.dispose();
    _isMounted = false;
  }

  /// Get `loading` status
  bool get isLoading => _isLoading;

  /// Get `error` status
  bool get isError => _error != null;

  /// Get `error` value
  dynamic get error => _error;

  /// Get value `data`
  List<T> get data => _data;

  /// Get status of `data`. Return `true` if `data == null`.
  bool get isEmpty => _data.isEmpty;

  /// Refresh value of `data` by recall `fetchData`
  Future<void> refresh() async {
    _error = null;
    _isLoading = true;
    if (_isMounted) notifyListeners();
    await _makeData();
  }

  /// Fetch data from your APIs or files asynchronous.
  /// You will need to throw an error when this process is failed
  /// to make `isError` work properly or simply omit the try-catch statements here.
  Future<List<T>> fetchData();

  Future<void> _makeData() async {
    try {
      final result = await fetchData();
      _setData(result);
    } catch (e) {
      _setError(e);
    }
  }

  /// set error and turn off loading then notify listeners
  void _setError(value) {
    _error = value;
    _isLoading = false;
    if (_isMounted) notifyListeners();
  }

  /// set data and turn off loading then notify listeners
  void _setData(List<T> value) {
    _data = value;
    _isLoading = false;
    if (_isMounted) notifyListeners();
  }
}
