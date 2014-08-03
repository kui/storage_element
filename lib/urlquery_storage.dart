library storage_element.urlfragment_storage_element;

import 'package:polymer/polymer.dart';
import 'storage.dart';
import 'storage_element.dart';

@CustomTag('urlquery-storage')
class UrlQueryStorageElement extends StorageElement {

  @published
  String name;

  @published
  String target;

  @published
  int autoSaveInterval = 0;

  @override
  QueryStorage get storage {
    if (name == null) {
      throw new StateError('<urlquery-storage> require the attribute "paramName"');
    }
    if (_storage != null && _storage.name == name) {
      return _storage;
    }
    _storage = new QueryStorage(name);
    return _storage;
  }
  QueryStorage _storage;

  UrlQueryStorageElement.created() : super.created();
}
