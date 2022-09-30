import 'package:flutter/foundation.dart';

/// A provider to provide a list of data with type `T`
abstract class DataListProvider<T> with ChangeNotifier {
  List<T> _data = List.empty(growable: true);
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isRemoving = false;
  bool _isMounted = false;
  dynamic _error;

  /// `manual = true` mean don't fetch data at create time
  DataListProvider({bool manual = false}) {
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

  /// Check if it's `adding` new item or not
  bool get isAdding => _isAdding;

  /// Check if it's `removing` an item or not
  bool get isRemoving => _isRemoving;

  /// Get current `error` status
  bool get isError => _error != null;

  /// Get latest `error` value
  dynamic get error => _error;

  /// Get value `data`
  List<T> get data => _data;

  /// Get status of `data`. Return `true` if `data == null`.
  bool get isEmpty => _data.isEmpty;

  /// Refresh value of `data` by recall `fetch`.
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  Future<void> refresh({bool isQuiet = false}) async {
    _error = null;
    _isLoading = true;
    if (_isMounted && !isQuiet) notifyListeners();
    await _fetchData();
  }

  /// Called when trying to fetch data for initial or on refreshing.
  /// Must return a list of data as the result,
  /// or throw an `error` when it's failed to fetch.
  @protected
  Future<List<T>> onFetch();

  /// Called when trying to add a new item,
  /// Must return the added item,
  /// or throw an `error` if it's failed to add.
  @protected
  Future<T> onAdd(T newItem) async {
    return newItem;
  }

  /// Called when trying to remove an item.
  /// Must return the removed item,
  /// or throw an `error` when it's failed to remove.
  @protected
  Future<int> onRemove(int index) async {
    return index;
  }

  /// Add a new item to the end of data list.
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  Future<void> add(T newItem, {bool isQuiet = false}) async {
    _error = null;
    _isAdding = true;
    if (_isMounted && !isQuiet) notifyListeners();

    try {
      final result = await onAdd(newItem);
      _data.add(result);
      _isAdding = false;
      if (_isMounted && !isQuiet) notifyListeners();
    } catch (e) {
      _isAdding = false;
      _setError(e);
    }
  }

  /// Remove the item at `index`.
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  Future<void> removeAt(int index, {bool isQuiet = false}) async {
    _error = null;
    _isRemoving = true;
    if (_isMounted && !isQuiet) notifyListeners();

    try {
      final result = await onRemove(index);
      _data.removeAt(result);
      _isRemoving = false;
      if (_isMounted && !isQuiet) notifyListeners();
    } catch (e) {
      _isRemoving = false;
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
  void _setData(List<T> value) {
    _data = value;
    _isLoading = false;
    if (_isMounted) notifyListeners();
  }
}
