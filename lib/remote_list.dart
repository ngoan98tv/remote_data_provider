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
  int? page;

  /// Current page size
  int? pageSize;

  /// Current search string
  String? search;

  /// Current sort options
  List<SortOption>? sortOptions;

  /// Get last page based on total available items and page size
  int? get lastPage => pageSize != null ? (totalItem / pageSize!).ceil() : null;

  bool get isEnd => (lastPage != null && page != null)
      ? page! >= lastPage!
      : items.length >= totalItem;

  RemoteList({
    required this.items,
    required this.totalItem,
    this.page,
    this.pageSize,
    this.search,
    this.sortOptions,
  });

  /// Combine new list into current list
  ///
  /// Set `concatList = false` to replace list instead of concat list.
  ///
  /// Old properties will be overriten by the new properties if the new properties are not null.
  void combine(RemoteList<T> newList, {bool concatList = true}) {
    if (concatList) {
      items.addAll(newList.items);
    } else {
      items = newList.items;
    }
    totalItem = newList.totalItem;
    page = newList.page ?? page;
    pageSize = newList.pageSize ?? pageSize;
    search = newList.search ?? search;
    sortOptions = newList.sortOptions ?? sortOptions;
  }
}
