import 'dart:async';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';

/// Extend from `BaseClient`, adding caching and timeout features.
class ExtendedHttp extends BaseClient {
  final Client _client;
  Map<String, String> _headers;
  Duration _timeout = const Duration(seconds: 60);
  bool _networkFirst = true;

  static final _instance = ExtendedHttp._internal(Client());

  factory ExtendedHttp() {
    return _instance;
  }

  ExtendedHttp._internal(this._client);

  /// Override `ExtendedHttp` config
  ///
  /// `timeout` -- Request timeout, default `60 seconds`.
  ///
  /// `networkFirst` -- If `true`, fetch data from network first,
  /// then if failed, try get from cache. Versa if `false`.
  /// Only work with `GET` requests, default `true`.
  ///
  /// `headers` -- Custom request headers.
  void config({
    Duration timeout = const Duration(seconds: 60),
    bool networkFirst = true,
    Map<String, String> headers,
  }) {
    _networkFirst = networkFirst;
    _timeout = timeout;
    _headers = headers;
  }

  @override
  Future<StreamedResponse> send(BaseRequest req) async {
    if (_headers != null) req.headers.addAll(_headers);

    if (req.method == "GET") {
      return _networkFirst
          ? await _networkFirstRequest(req)
          : await _cacheFirstRequest(req);
    } else {
      return await _client.send(req).timeout(_timeout);
    }
  }

  Future<StreamedResponse> _networkFirstRequest(BaseRequest req) async {
    File file;
    try {
      file = await _downloadFile(req);
    } catch (e) {
      print(e);
      file = await _readCachedFile(req);
    }
    return StreamedResponse(
      file.readAsBytes().asStream(),
      200,
    );
  }

  Future<StreamedResponse> _cacheFirstRequest(BaseRequest req) async {
    File file;
    file = await _readCachedFile(req);
    return StreamedResponse(
      file.readAsBytes().asStream(),
      200,
    );
  }

  Future<File> _downloadFile(BaseRequest req) async {
    final fileInfo = await DefaultCacheManager()
        .downloadFile(
          req.url.toString(),
          authHeaders: req.headers,
        )
        .timeout(_timeout);
    return fileInfo.file;
  }

  Future<File> _readCachedFile(BaseRequest req) async {
    final file = await DefaultCacheManager().getSingleFile(
      req.url.toString(),
      headers: req.headers,
    );
    return file;
  }
}
