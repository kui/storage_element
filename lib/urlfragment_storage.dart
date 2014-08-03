library storage_element.urlfragment_storage_element;

import 'package:polymer/polymer.dart';
import 'storage.dart';
import 'storage_element.dart';

@CustomTag('urlfragment-storage')
class UrlFragmentStorageElement extends StorageElement {

  @published
  String target;

  @published
  int autoSaveInterval = 0;

  @override
  FragmentStorage get storage => _storage;
  final Storage<String> _storage;

  UrlFragmentStorageElement.created() : super.created(),
      this._storage = new FragmentStorage();
}
