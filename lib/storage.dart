library storage_element.storage;

import 'dart:html';
import 'base64_zip.dart' as base64;

abstract class Storage<T> {
  T get value;
  set value(T t);
}

abstract class UrlStorage implements Storage<String> {
  String _value;

  @override
  String get value => _value;

  @override
  set value(String t) {
    _value = t;
    _save();
  }

  UrlStorage() {
    _value = getFromUrl();
  }

  void _save() {
    final url = getUrl();
    window.history.pushState(null, document.title, url.toString());
  }

  Uri getUrl();

  String getFromUrl();
}

class QueryStorage extends UrlStorage {
  /// The query parameter name
  final String name;

  QueryStorage(this.name): super();

  @override
  Uri getUrl() => generateUrl(name, value);

  @override
  String getFromUrl() {
    final uri = Uri.parse(window.location.href);
    final zipped = uri.queryParameters[name];
    if (zipped == null || zipped.isEmpty) return null;
    return base64.unzip(zipped);
  }

  static Uri generateUrl(String paramName, String value) {
    final uri = Uri.parse(window.location.href);
    final qp = new Map<String, String>();
    qp.addAll(uri.queryParameters);
    qp[paramName] = base64.zip(value, urlSafe: true);

    return new Uri(queryParameters: qp, fragment: uri.fragment,
        host: uri.host, path: uri.path, port: uri.port, scheme: uri.scheme,
        userInfo: uri.userInfo);
  }
}

class FragmentStorage extends UrlStorage {
  FragmentStorage(): super();

  @override
  Uri getUrl() => generateUrl(value);

  @override
  String getFromUrl() {
    final uri = Uri.parse(window.location.href);
    final zipped = uri.fragment;
    if (zipped == null || zipped.isEmpty) return null;
    return base64.unzip(zipped);
  }

  static Uri generateUrl(String value) {
    final uri = Uri.parse(window.location.href);
    return new Uri(fragment: base64.zip(value, urlSafe: true), query: uri.query,
        host: uri.host, path: uri.path, port: uri.port, scheme: uri.scheme,
        userInfo: uri.userInfo);
  }
}

class LocalStorage implements Storage<String> {
  /// The localstorage key
  final String name;
  final bool useZip;

  LocalStorage(this.name, {bool useZip: false}): useZip = useZip;

  @override
  String get value {
    final v = window.localStorage[name];
    return (useZip) ? base64.unzip(v) : v;
  }

  @override
  set value(String t) {
    final v = (useZip) ? base64.zip(t) : t;
    window.localStorage[name] = v;
  }
}
