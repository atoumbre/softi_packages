import 'dart:async';

import 'package:get/get.dart';
import 'package:softi_core_module/softi_core_module.dart';

class DataRecord<T extends IResourceData> {
  DataRecord(this._api, this._res);

  final Rx<T> _data = Rx<T>();
  bool _reactive = false;
  // bool _initialized = false;

  get id => _data.value?.getId();
  get exist => id != null;
  get data => _data.value;
  get isReactive => _reactive;

  final ICollectionService _api;
  final IResource<T> _res;

  Future<void> init(
    T record, {
    bool fetch = true,
    bool reactive = true,
  }) async {
    _reactive = reactive;
    _data(record);

    if (fetch)
      return this.fetch();
    else
      return Future.value(null);
  }

  Future<void> fetch() {
    Completer<bool> _initCompleter = Completer<bool>();

    _api.get<T>(_res, id, reactive: _reactive).listen((event) {
      _data(event);
      _initCompleter.complete(true);
    });

    return _initCompleter.future;
  }

  Future<void> save() async {
    return _api.save<T>(_res, _data.value, refresh: false);
  }

  Future<void> delete() async {
    await _api.delete<T>(_res, id);
  }

  Future<void> update(Map<String, dynamic> data) async {
    return _api.update(_res, id, data);
  }

  void deserialize(Map<String, dynamic> data) {
    _data(_res.deserializer(data));
  }

  call() => _data.value;
}
