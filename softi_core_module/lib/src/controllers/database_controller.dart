import 'package:softi_core_module/softi_core_module.dart';
import 'package:softi_core_module/src/controllers/collection_controller.dart';
import 'package:softi_core_module/src/controllers/record_controller.dart';

class DatabaseController {
  final ICollectionService _api;

  DatabaseController(this._api);

  get api => _api;

  DataCollection collection<T extends IBaseModel>() {
    return DataCollection<T>(_api); //..requestData(queryParam, pageSize: pageSize, limit: limit, realtime: realtime);
  }

  Record record<T extends IBaseModel>(String id) {
    return Record(id, _api);
  }
}
