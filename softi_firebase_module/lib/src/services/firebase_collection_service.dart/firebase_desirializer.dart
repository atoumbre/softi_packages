import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softi_core_module/softi_core_module.dart';
import 'package:softi_firebase_module/src/services/firebase_collection_service.dart/firebase_resource.dart';

T fromFirestore<T extends IBaseModel>(Resource<T> res, DocumentSnapshot docSnap) {
  Map<String, dynamic> map = docSnap.data();
  if (map == null) return null;

  Map<String, dynamic> _map = firestireMap(map, true);
  if (_map == null) return null;

  T _result = res.deserializer({
    'id': docSnap.id,
    ..._map,
  });

  return _result;
}

Map<String, dynamic> toFirestore(IBaseModel doc) {
  Map<String, dynamic> map = doc.toJson();
  if (map == null) return null;

  Map<String, dynamic> _map = firestireMap(map, false);
  if (_map == null) return null;

  return _map;
}

Map<String, dynamic> firestireMap(Map<String, dynamic> input, bool fromFirestore, [bool skipNull = true]) {
  Map<String, dynamic> result = {};

  input.forEach((k, v) {
    if (skipNull && v == null)
      return;
    else if (v is Map)
      result[k] = firestireMap(v, fromFirestore);
    else if (v is List)
      result[k] = firestireList(v, fromFirestore);
    else
      result[k] = firestoreTransform(v, fromFirestore);
  });
  return result;
}

List firestireList(List input, bool fromFirestore, [bool skipNull = true]) {
  List result = [];

  input.forEach((v) {
    if (skipNull && v == null)
      return;
    else if (v is Map)
      result.add(firestireMap(v, fromFirestore));
    else if (v is List)
      result.add(firestireList(v, fromFirestore));
    else
      result.add(firestoreTransform(v, fromFirestore));
  });

  return result;
}

dynamic firestoreTransform(dynamic v, bool fromFirestore) {
  if (fromFirestore) {
    //FROM FIRESTORE

    if (v is Timestamp)
      return v.toDate();
    else if (v is DocumentReference)
      return v.id;
    else
      return v;
  } else {
    // TO FIRESTORE

    if (v is DateTime)
      return Timestamp.fromDate(v);
    else
      return v;
  }
}
