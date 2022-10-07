# Easy API Integration with Providers

![Test](https://github.com/ngoan98tv/remote_data_provider/workflows/Test/badge.svg)
![DryRun](https://github.com/ngoan98tv/remote_data_provider/workflows/Pub%20Dry%20Run/badge.svg)
![Publish](https://github.com/ngoan98tv/remote_data_provider/workflows/Publish/badge.svg)
![PubVersion](https://img.shields.io/pub/v/remote_data_provider)
![Issues](https://img.shields.io/github/issues/ngoan98tv/remote_data_provider)

Help implementing providers easier with predefined abstract classes, special is for working with remote data like REST API.

## Usages

### DataListProvider

Good for handling a list of data items, such as list of posts, list of users,...

All you need to do is just extends `DataListProvider` and define `onFetch` method (to call your API or whatever to fetch your data)

Features:

- Supported infinity list with predefined `loadMore` and combine fetched data automatically
- Fetch/refresh data with predefined `isLoading` state
- Add data with predefined `isAdding` state
- Update data with predefined `isUpdating` state
- Delete data with predefined `isDeleting` state
- Pagination with predefined `page`, `pageSize`, `lastPage` states
- Sorting with predefined `sortOptions` state
- Searching with predefined `search` state and integrated `debounce`

### BasicDataProvider

Good for any kind of data that is not a list, such as user detail, post detail, login, register,...

Features:

- Fetch/refresh data with predefined `isLoading` state
- Update data with predefined `isUpdating` state
- Delete data with predefined `isDeleting` state
- Support infinity list

See more in the example

## References

[provider](https://pub.dev/packages/provider)

## Feel free to [leave an issue](https://github.com/ngoan98tv/remote_data_provider/issues) if you need help or see something wrong in this package.
