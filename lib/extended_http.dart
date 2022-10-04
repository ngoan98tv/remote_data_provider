import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

/// Extend from `BaseClient`, adding caching and timeout features.
class ExtendedHttp extends BaseClient {
  final Client _client;
  Map<String, String> _headers = {};
  Duration _timeout = const Duration(seconds: 5);
  Duration _cacheAge = const Duration(seconds: 60);
  bool _disableCache = false;
  String _baseURL = '';
  Future<void> Function()? onUnauthorized;

  Box<String>? _httpCacheBody;
  Box<String>? _httpCacheHeader;

  static final _instance = ExtendedHttp._internal(
    RetryClient(
      Client(),
      when: _shouldRetry,
      whenError: (e, stack) => e is TimeoutException || e is SocketException,
      onRetry: _beforeRetry,
    ),
  );

  factory ExtendedHttp() {
    if (_instance._httpCacheBody == null ||
        _instance._httpCacheHeader == null) {
      _instance.init();
    }
    return _instance;
  }

  ExtendedHttp._internal(this._client);

  static bool _shouldRetry(BaseResponse res) {
    if ([401, 503].contains(res.statusCode)) {
      return true;
    }
    return false;
  }

  static Future<void> _beforeRetry(
    BaseRequest req,
    BaseResponse? res,
    int retryCount,
  ) async {
    _instance._log("Retry ($retryCount) ${req.method} ${req.url}");
    _instance._log("Headers ${req.headers}");
    if (res?.statusCode == 401 && _instance.onUnauthorized != null) {
      await _instance.onUnauthorized!();
      req.headers.addAll(_instance._headers);
    }
  }

  Future<void> init() async {
    await Hive.initFlutter();
    _httpCacheBody = await Hive.openBox<String>('httpCacheBody');
    _httpCacheHeader = await Hive.openBox<String>('httpCacheHeader');
  }

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
    String? baseURL,
    Duration? timeout,
    bool? disableCache,
    Duration? cacheAge,
    Map<String, String>? headers,
  }) {
    _timeout = timeout ?? _timeout;
    _headers = headers ?? _headers;
    _baseURL = baseURL ?? _baseURL;
    _cacheAge = cacheAge ?? _cacheAge;
    _disableCache = disableCache ?? _disableCache;
  }

  Uri createURI(String path, {Map<String, String>? params}) {
    final u = Uri.parse(_baseURL + path);
    return Uri(
      scheme: u.scheme,
      host: u.host,
      port: u.port,
      path: u.path,
      queryParameters: params,
    );
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers.addAll(_headers);

    _log("${request.method} ${request.url}");

    if (_disableCache || request.method != "GET") {
      return _client.send(request).timeout(_timeout);
    }

    _log("Read from cache");
    final cachedResponse = _responseFromCache(request.url);
    if (cachedResponse != null) {
      return cachedResponse;
    }

    _log("Cache empty");
    _log("Send request");

    final response = await _client.send(request).timeout(_timeout);

    if (response.statusCode != 200) {
      return response;
    }

    _log("Write to cache");
    final bodyString = await response.stream.bytesToString();
    await _cacheResponse(request.url, bodyString, response.headers);

    return StreamedResponse(
      Stream.value(utf8.encode(bodyString)),
      200,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
      contentLength: response.contentLength,
      request: response.request,
    );
  }

  Future<void> _cacheResponse(
    Uri uri,
    String bodyString,
    Map<String, String> headers,
  ) async {
    final cacheKey = uri.toString();

    await _httpCacheBody?.put(
      cacheKey,
      bodyString,
    );

    final validTo = DateTime.now().add(_cacheAge).toIso8601String();
    headers['cache-valid-to'] = validTo;

    final headerString = jsonEncode(headers);

    await _httpCacheHeader?.put(
      cacheKey,
      headerString,
    );
  }

  StreamedResponse? _responseFromCache(
    Uri uri, {
    bool ignoreValidDate = false,
  }) {
    final cacheKey = uri.toString();
    final bodyString = _httpCacheBody?.get(cacheKey);
    final headerString = _httpCacheHeader?.get(cacheKey);

    if (bodyString == null || bodyString.isEmpty) {
      return null;
    }

    final headerMap = jsonDecode(headerString ?? "{}") as Map<String, dynamic>;
    final headers = headerMap.map((key, value) => MapEntry(key, "$value"));

    if (!ignoreValidDate) {
      if (headers['cache-valid-to'] == null) {
        return null;
      }

      final validDate = DateTime.parse(headers['cache-valid-to']!);

      if (validDate.isBefore(DateTime.now())) {
        return null;
      }
    }

    return StreamedResponse(
      Stream.value(utf8.encode(bodyString)),
      203,
      headers: headers,
      reasonPhrase: "Cached Response",
    );
  }

  void _log(String message) {
    debugPrint("ExtendedHttp: $message");
  }
}
