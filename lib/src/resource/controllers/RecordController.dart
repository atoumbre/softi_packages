// import 'package:softi_common/src/core/base_controller.dart';
// import 'package:softi_common/src/resource/classes/ResourceRecord.dart';
// import 'package:softi_common/src/resource/classes/resource.dart';
// import 'package:softi_common/src/resource/classes/ResourceBase.dart';

// abstract class BaseRecordController<T extends IResourceData> extends BaseController {
//   BaseRecordController(this.intialData, [ResourceBase db]) : record = db.record<T>();

//   final ResourceDAO<T> record;
//   final T intialData;

//   Future<void> init() {
//     return record.init(intialData);
//   }

//   @override
//   Future<void> onReady() {
//     super.onReady();
//     return init();
//   }
// }
