import 'package:softi_common_module/src/controllers/collection_controller.dart';
import 'package:softi_common_module/src/controllers/record_controller.dart';
import 'package:softi_core_module/softi_core_module.dart';

class DatabaseController {
  final ICollectionService _api;
  final Map<dynamic, dynamic> _resourceMapper;

  DatabaseController(this._api, this._resourceMapper);

  DataCollection<T> collection<T extends IResourceData>([IResource<T> _res]) {
    return DataCollection<T>(_api, _res ?? _resourceMapper[T]);
  }

  DataRecord<T> record<T extends IResourceData>([IResource<T> _res]) {
    return DataRecord<T>(_api, _res ?? _resourceMapper[T]);
  }

  //  Transition helper

  String endpointResolver<T extends IResourceData>([Type doc]) {
    if (_resourceMapper[doc ?? T] == null) {
      throw ('${T.toString()} not registred for endpoint resolution');
    }

    return _resourceMapper[doc ?? T].endpointResolver();
  }

  T deserializer<T extends IResourceData>(map) {
    return _resourceMapper[T].deserializer(map);
  }

  // IResource<T> res<T extends IResourceData>() {
  //   return _resourceMapper[T];
  // }

  // Expose API

  Stream<T> get<T extends IResourceData>(String id, {IResource<T> res}) {
    return _api.get<T>(res ?? _resourceMapper[T], id);
  }

  Future<T> save<T extends IResourceData>(T record, {bool refresh = false, IResource<T> res}) {
    return _api.save<T>(res ?? _resourceMapper[T], record, refresh: refresh);
  }

  Future<void> update<T extends IResourceData>(String id, Map<String, dynamic> values, {IResource<T> res}) {
    return _api.update<T>(res ?? _resourceMapper[T], id, values);
  }

  Future<void> delete<T extends IResourceData>(String id, {IResource<T> res}) {
    return _api.delete<T>(res ?? _resourceMapper[T], id);
  }

  Future<Stream<QueryResult<T>>> find<T extends IResourceData>(
    QueryParameters params, {
    int limit = 10,
    int skip = 0,
    dynamic cursor,
    bool reactive = true,
    IResource<T> res,
  }) {
    return _api.find(
      res ?? _resourceMapper[T],
      params,
      reactive: reactive,
    );
  }
}
