import 'package:flutter/foundation.dart';

/// A basic provider to provide a single data object with type `T`
abstract class BasicDataProvider<T> with ChangeNotifier {
  T _data;
  bool _isLoading;
  dynamic _error;
  bool _isMounted;

  BasicDataProvider() {
    _data = null;
    _error = null;
    _isLoading = true;
    _isMounted = true;
    _fetchData();
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
  T get data => _data;

  /// Get status of `data`. Return `true` if `data == null`.
  bool get isEmpty => _data == null;

  /// Refresh value of `data` by recall `fetchData`
  Future<void> refresh({bool isQuiet = false}) async {
    _error = null;
    _isLoading = true;
    if (_isMounted && !isQuiet) notifyListeners();
    await _fetchData();
  }

  /// Fetch data from your APIs or databases.
  /// You will need to throw an error when this process is failed
  /// to make `isError` work properly or simply omit the try-catch statements here.
  @protected
  Future<T> onFetch();

  /// Update data to your APIs or databases
  @protected
  Future<T> onUpdate(T newData);

  Future<void> update(T newData, {bool isQuiet = false}) async {
    _error = null;
    _isLoading = true;
    if (_isMounted && !isQuiet) notifyListeners();

    try {
      final result = await onUpdate(newData);
      _setData(result);
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> _fetchData() async {
    try {
      final result = await onFetch();
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
  void _setData(value) {
    _data = value;
    _isLoading = false;
    if (_isMounted) notifyListeners();
  }
}
