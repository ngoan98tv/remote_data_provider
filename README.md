# Remote Data Provider

![Test](https://github.com/ngoan98tv/remote_data_provider/workflows/Test/badge.svg)
![DryRun](https://github.com/ngoan98tv/remote_data_provider/workflows/Pub%20Dry%20Run/badge.svg)
![Publish](https://github.com/ngoan98tv/remote_data_provider/workflows/Publish/badge.svg)
![PubVersion](https://img.shields.io/pub/v/remote_data_provider)
![Issues](https://img.shields.io/github/issues/ngoan98tv/remote_data_provider)

Help implementing providers easier with predefined abstract classes, special is for working with remote data.

## Features

Work with RESTful APIs

DataListProvider supports:

- Fetch/refresh data
- Create, remove data

BasicDataProvider supports:

- Fetch/refresh data
- Update data

Extended HTTP supports:

- Caching API response (for GET requests only)
- Set request timeout
- Set request headers (authorization token,...)
- Set request baseURL (http:// yourhost .com /api)

See more in the example

## Dependencies

[http](https://pub.dev/packages/http)

[flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)

## References

[provider](https://pub.dev/packages/provider)

## Feel free to [leave an issue](https://github.com/ngoan98tv/remote_data_provider/issues) if you need help or see something wrong in this package.
