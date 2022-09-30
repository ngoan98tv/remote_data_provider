import 'package:flutter/foundation.dart';

/// A basic provider to provide a single data object with type `T`
abstract class BasicDataProvider<T> with ChangeNotifier {
  T? _data;
  bool _isLoading = false;
  bool _isMounted = false;
  dynamic _error;

  BasicDataProvider({bool manual = false}) {
    _isMounted = true;
    notifyListeners();
    if (!manual) {
      _isLoading = true;
      notifyListeners();
      _fetchData();
    }
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
  T? get data => _data;

  /// Get status of `data`. Return `true` if `data == null`.
  bool get isEmpty => _data == null;

  /// Refresh value of `data` by recall `fetch` data.
  Future<void> refresh({bool isQuiet = false}) async {
    _error = null;
    _isLoading = true;
    if (_isMounted && !isQuiet) notifyListeners();
    await _fetchData();
  }

  /// Called when trying to fetch data.
  /// Must return the fetched data or throw an `error` if it's failed to fetch.
  @protected
  Future<T> onFetch();

  /// Called when trying to update the data.
  /// Must return the new data, or throw and `error` when it's failed to update.
  @protected
  Future<T> onUpdate(T newData) async {
    return newData;
  }

  /// Update data by `newData`.
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
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
