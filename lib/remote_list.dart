enum SortOrder { ASC, DESC }

class SortOption {
  String field;
  SortOrder order;

  SortOption({required this.field, required this.order});
}

class RemoteList<T> {
  /// Current local items
  List<T> items;

  /// Total available remote items
  int totalItem;

  /// Current page
  int page;

  /// Current page size
  int pageSize;

  /// Current search string
  String? search;

  /// Current sort options
  List<SortOption>? sortOptions;

  /// Get last page based on total available items and page size
  int get lastPage => (totalItem / pageSize).ceil();

  RemoteList({
    required this.items,
    required this.totalItem,
    this.page = 1,
    this.pageSize = 10,
    this.search,
    this.sortOptions,
  });
}
