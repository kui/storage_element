library storage_element.local_storage_element;

import 'package:polymer/polymer.dart';
import 'storage.dart';
import 'storage_element.dart';

@CustomTag('local-storage')
class LocalStorageElement extends StorageElement {

  @published
  String name;

  @published
  String target;

  @published
  int autoSaveInterval = 0;

  @override
  LocalStorage get storage {
    if (name == null) {
      throw new StateError('<local-storage> require the attribute "name"');
    }
    if (_storage != null && _storage.name == name) {
      return _storage;
    }
    _storage = new LocalStorage(name, useZip: true);
    return _storage;
  }
  LocalStorage _storage;

  LocalStorageElement.created() : super.created();
}
