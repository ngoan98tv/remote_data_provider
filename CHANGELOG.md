## [2.2.2] - Oct 7, 2022.

Added `fetch` method which equivalent to `refresh` but it is more meaningful in some use cases.

Improve some code blocks.

## [2.2.1] - Oct 5, 2022.

Support infinity list

## [2.1.1] - Oct 5, 2022.

Update readme

## [2.1.0] - Oct 5, 2022.

Splitted [extended_http](https://pub.dev/packages/extended_http)

## [2.0.0] - Oct 2, 2022.

Basic data provider:

- Added `delete` method which is corresponding with `isDeleting` and `isDeleted`
- Now `update` method will trigger `isUpdating` state instead of `isLoading`
- `isLoading` state will be triggered only on initialization and on `refresh`

Data list provider:

- Rename `data` to `items`
- Added a new class, `RemoteList` for managing remote data list
- Added pagination, search and sort states

## [1.0.2] - Sept 30, 2022.

Update example

Update Sdk constraint

## [1.0.1] - Sept 30, 2022.

Update README.md

Move code in README.md to example

## [1.0.0] - Sept 30, 2022.

Upgrade dependencies

Remove old example, a new one will be added on next release

Added `baseURL` to `ExtendedHttp` config

Added `manual` option to providers

## [0.1.5] - Aug 22, 2020.

Add `ExtendedHttp` to example

## [0.1.4] - Aug 22, 2020.

Update tests

## [0.1.3] - Aug 22, 2020.

Update Readme and setup CI testing.

## [0.1.2] - Aug 21, 2020.

Update README

## [0.1.1] - Aug 21, 2020.

`BasicDataProvider`: Rename `fetchData` to `onFetch`, Add `update`, `onUpdate` method, update docs.

`DataListProvider`: Rename `fetchData` to `onFetch`, Add `add`, `onAdd`, `remove` and `onRemove` method, update docs.

`ExtendedHttp`: Add `config` method, update docs.

## [0.0.1] - Aug 18, 2020.

Initial package with `BasicDataProvider`, `DataListProvider` and `ExtendedHttp`.
