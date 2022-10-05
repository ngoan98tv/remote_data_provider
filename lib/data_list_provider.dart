import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:remote_data_provider/remote_list.dart';

/// A provider to provide a list of data with type `T`
abstract class DataListProvider<T> with ChangeNotifier {
  RemoteList<T> _data = RemoteList(items: [], totalItem: 0);
  dynamic _error;

  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  bool _isMounted = false;

  Timer? _debounceTimer;

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
    _isMounted = false;
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Get `loading` status
  bool get isLoading => _isLoading;

  /// Check if it's `adding` new item or not
  bool get isAdding => _isAdding;

  /// Check if it's `updating` a item or not
  bool get isUpdating => _isUpdating;

  /// Check if it's `removing` an item or not
  bool get isDeleting => _isDeleting;

  /// Get current `error` status
  bool get isError => _error != null;

  /// Get latest `error` value
  dynamic get error => _error;

  /// Get value `data`
  List<T> get items => _data.items;

  /// Get status of `data`. Return `true` if `data == null`.
  bool get isEmpty => _data.items.isEmpty;

  /// Get total available items
  int get totalItem => _data.totalItem;

  /// Get current page
  int get page => _data.page;

  /// Get current page size
  int get pageSize => _data.pageSize;

  /// Get last page
  int get lastPage => _data.lastPage;

  /// Get current search value
  String? get search => _data.search;

  /// Get current sort options
  List<SortOption>? get sortOptions => _data.sortOptions;

  /// Set search value and refresh data
  void setSearch(String val, {bool noRefresh = false, int debounceMs = 500}) {
    _data.search = val;
    _data.page = 1;
    notifyListeners();
    if (noRefresh) return;
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: debounceMs), refresh);
  }

  /// Set new page and refresh data
  void setPage(int val, {bool noRefresh = false}) {
    _data.page = val;
    notifyListeners();
    if (noRefresh) return;
    refresh();
  }

  /// Go next page and refresh data
  void nextPage({bool noRefresh = false}) {
    if (_data.page >= _data.lastPage) return;
    _data.page += 1;
    notifyListeners();
    if (noRefresh) return;
    refresh();
  }

  /// Go previous page and refresh data
  void prevPage({bool noRefresh = false}) {
    if (_data.page <= 1) return;
    _data.page -= 1;
    notifyListeners();
    if (noRefresh) return;
    refresh();
  }

  /// Set new page size and refresh data
  void setPageSize(int val, {bool noRefresh = false}) {
    _data.pageSize = val;
    _data.page = 1;
    notifyListeners();
    if (noRefresh) return;
    refresh();
  }

  /// Set new sorts and refresh data
  void setSortOptions(List<SortOption> val, {bool noRefresh = false}) {
    _data.sortOptions = val;
    _data.page = 1;
    notifyListeners();
    if (noRefresh) return;
    refresh();
  }

  /// Called when trying to fetch data for initial or on refreshing.
  /// Must return a list of data as the result,
  /// or throw an `error` when it's failed to fetch.
  @protected
  Future<RemoteList<T>> onFetch();

  /// Called when trying to add a new item,
  /// Must return the added item,
  /// or throw an `error` if it's failed to add.
  @protected
  Future<T> onCreate(T newItem);

  /// Called when trying to update the data.
  /// Must return the new data, or throw and `error` when it's failed to update.
  @protected
  Future<T> onUpdate(T newData);

  /// Called when trying to delete the data.
  /// Must return a boolean (`true` mean deleted), or throw and `error` when it's failed.
  @protected
  Future<bool> onDelete(T item);

  /// Refresh value of `data` by recall `fetch`.
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  Future<void> refresh({bool isQuiet = false}) async {
    _error = null;
    _isLoading = true;
    if (_isMounted && !isQuiet) notifyListeners();
    await _fetchData();
  }

  /// Add a new item to the end of data list.
  ///
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  ///
  /// Set `addToTheStart = true` to add the new item to the start of the list, default `false`.
  Future<void> add(
    T newItem, {
    bool isQuiet = false,
    bool addToTheStart = false,
  }) async {
    _error = null;
    _isAdding = true;
    if (_isMounted && !isQuiet) notifyListeners();

    try {
      final result = await onCreate(newItem);
      if (addToTheStart) {
        _data.items.insert(0, result);
        _data.totalItem += 1;
      } else {
        _data.items.add(result);
        _data.totalItem += 1;
      }
    } catch (e) {
      _error = e;
    }

    _isAdding = false;
    if (_isMounted && !isQuiet) notifyListeners();
  }

  /// Remove the item at `index`.
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  Future<void> removeAt(int index, {bool isQuiet = false}) async {
    _error = null;
    _isDeleting = true;
    if (_isMounted && !isQuiet) notifyListeners();

    try {
      final result = await onDelete(items[index]);
      if (result) {
        _data.items.removeAt(index);
        _data.totalItem -= 1;
      }
    } catch (e) {
      _error = e;
    }

    _isDeleting = false;
    if (_isMounted && !isQuiet) notifyListeners();
  }

  /// Update data by `newData`.
  /// Set `isQuiet = true` to avoid rendering loading state, default `false`.
  Future<void> updateAt(int index, T newData, {bool isQuiet = false}) async {
    _error = null;
    _isUpdating = true;
    if (_isMounted && !isQuiet) notifyListeners();

    try {
      final result = await onUpdate(newData);
      _data.items[index] = result;
    } catch (e) {
      _error = e;
    }

    _isUpdating = false;
    if (_isMounted && !isQuiet) notifyListeners();
  }

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
