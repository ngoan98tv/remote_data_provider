import 'package:flutter/foundation.dart';

/// A basic provider to provide a single data object with type `T`
abstract class BasicDataProvider<T> with ChangeNotifier {
  T? _data;
  bool _isLoading = false;
  bool _isMounted = false;
  bool _isDeleting = false;
  bool _isUpdating = false;
  bool _isDeleted = false;
  dynamic _error;

  /// `manual = true` mean don't fetch data at create time
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

  /// Get `updating` status
  bool get isUpdating => _isUpdating;

  /// Get `deleting` status
  bool get isDeleting => _isDeleting;

  /// Get `deleted` status
  bool get isDeleted => _isDeleted;

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

  /// Delete current data
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  Future<void> delete({bool isQuiet = false}) async {
    _error = null;
    _isDeleting = true;
    if (_isMounted && !isQuiet) notifyListeners();

    try {
      _isDeleted = await onDelete();
    } catch (e) {
      _error = e;
    }

    _isDeleting = false;
    if (_isMounted && !isQuiet) notifyListeners();
  }

  /// Update data by `newData`.
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  Future<void> update(T newData, {bool isQuiet = false}) async {
    _error = null;
    _isUpdating = true;
    if (_isMounted && !isQuiet) notifyListeners();

    try {
      final result = await onUpdate(newData);
      _data = result;
    } catch (e) {
      _error = e;
    }

    _isUpdating = false;
    if (_isMounted && !isQuiet) notifyListeners();
  }

  /// Called when trying to fetch data.
  /// Must return the fetched data or throw an `error` if it's failed to fetch.
  @protected
  Future<T> onFetch();

  /// Called when trying to update the data.
  /// Must return the new data, or throw and `error` when it's failed to update.
  @protected
  Future<T> onUpdate(T newData);

  /// Called when trying to delete the data.
  /// Must return a boolean (`true` mean deleted), or throw and `error` when it's failed.
  @protected
  Future<bool> onDelete();

  Future<void> _fetchData() async {
    try {
      final result = await onFetch();
      _data = result;
    } catch (e) {
      _error = e;
    }

    _isLoading = false;
    if (_isMounted) notifyListeners();
  }
}
