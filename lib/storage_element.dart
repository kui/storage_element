library storage_element.storage_element;

import 'dart:async';
import 'dart:html' hide Storage;
import 'package:polymer/polymer.dart';
import 'storage.dart';

abstract class StorageElement extends PolymerElement {
  /// The target element selector
  String get target;

  /// The milliseconds to save automatically
  /// If this value was less than or equal to 0, auto-save is disabled.
  /// default: 0
  int get autoSaveInterval; // msec

  Storage<String> get storage;

  bool get isAutoSaveEnable =>
      autoSaveInterval != null && autoSaveInterval > 0;
  bool get isRunningAutoSave => _autoSave != null;

  Duration get _autoSaveInterval =>
      new Duration(milliseconds: autoSaveInterval);
  Element get _targetElement =>
      (target == null) ? null : querySelector(target);
  Timer _autoSave;
  Element get _saveButtonElement =>
      this.querySelector(
          'button, input[type="button"], input[type="submit"], '
          'input[type="image"]');

  StorageElement.created() : super.created();

  @override
  void ready() {
    super.ready();

    final b = _saveButtonElement;
    if (b != null)
      b.onClick.listen((e) => save());
  }

  @override
  void attached() {
    super.attached();
    load();
    if (isAutoSaveEnable) startAutoSave();
  }

  @override
  void detached() {
    super.detached();
    stopAutoSave();
  }

  void load() {
    Element e = _targetElement;
    if (e == null) {
      window.console.warn('Abort load: Not found the target element: $target');
      return;
    }

    final v = storage.value;
    if (v == null) return;

    try {
      (e as dynamic).value = v;
    } on NoSuchMethodError {
      e.setAttribute('value', v);
    }
  }

  void autoSaveIntervalChanged() {
    if (isAutoSaveEnable && isRunningAutoSave)
      startAutoSave();
  }

  void startAutoSave() {
    stopAutoSave();
    _autoSave = new Timer.periodic(_autoSaveInterval, (_) => save());
  }

  void save() {
    final e = _targetElement;
    if (e == null) {
      window.console.warn('Abort save: Not found the target element: $target');
      return;
    }
    try {
      storage.value = (e as dynamic).value;
    } on NoSuchMethodError {
      storage.value = e.getAttribute('value');
    }
  }

  void stopAutoSave() {
    if (!isRunningAutoSave) return;
    _autoSave.cancel();
    _autoSave = null;
  }
}
