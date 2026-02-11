// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class RelevoStruct extends FFFirebaseStruct {
  RelevoStruct({
    String? guardiaEntrante,
    String? guardiaSaliente,
    DateTime? horaRelevo,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _guardiaEntrante = guardiaEntrante,
        _guardiaSaliente = guardiaSaliente,
        _horaRelevo = horaRelevo,
        super(firestoreUtilData);

  // "guardiaEntrante" field.
  String? _guardiaEntrante;
  String get guardiaEntrante => _guardiaEntrante ?? '';
  set guardiaEntrante(String? val) => _guardiaEntrante = val;

  bool hasGuardiaEntrante() => _guardiaEntrante != null;

  // "guardiaSaliente" field.
  String? _guardiaSaliente;
  String get guardiaSaliente => _guardiaSaliente ?? '';
  set guardiaSaliente(String? val) => _guardiaSaliente = val;

  bool hasGuardiaSaliente() => _guardiaSaliente != null;

  // "horaRelevo" field.
  DateTime? _horaRelevo;
  DateTime? get horaRelevo => _horaRelevo;
  set horaRelevo(DateTime? val) => _horaRelevo = val;

  bool hasHoraRelevo() => _horaRelevo != null;

  static RelevoStruct fromMap(Map<String, dynamic> data) => RelevoStruct(
        guardiaEntrante: data['guardiaEntrante'] as String?,
        guardiaSaliente: data['guardiaSaliente'] as String?,
        horaRelevo: data['horaRelevo'] as DateTime?,
      );

  static RelevoStruct? maybeFromMap(dynamic data) =>
      data is Map ? RelevoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'guardiaEntrante': _guardiaEntrante,
        'guardiaSaliente': _guardiaSaliente,
        'horaRelevo': _horaRelevo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'guardiaEntrante': serializeParam(
          _guardiaEntrante,
          ParamType.String,
        ),
        'guardiaSaliente': serializeParam(
          _guardiaSaliente,
          ParamType.String,
        ),
        'horaRelevo': serializeParam(
          _horaRelevo,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static RelevoStruct fromSerializableMap(Map<String, dynamic> data) =>
      RelevoStruct(
        guardiaEntrante: deserializeParam(
          data['guardiaEntrante'],
          ParamType.String,
          false,
        ),
        guardiaSaliente: deserializeParam(
          data['guardiaSaliente'],
          ParamType.String,
          false,
        ),
        horaRelevo: deserializeParam(
          data['horaRelevo'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'RelevoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RelevoStruct &&
        guardiaEntrante == other.guardiaEntrante &&
        guardiaSaliente == other.guardiaSaliente &&
        horaRelevo == other.horaRelevo;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([guardiaEntrante, guardiaSaliente, horaRelevo]);
}

RelevoStruct createRelevoStruct({
  String? guardiaEntrante,
  String? guardiaSaliente,
  DateTime? horaRelevo,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RelevoStruct(
      guardiaEntrante: guardiaEntrante,
      guardiaSaliente: guardiaSaliente,
      horaRelevo: horaRelevo,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RelevoStruct? updateRelevoStruct(
  RelevoStruct? relevo, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    relevo
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRelevoStructData(
  Map<String, dynamic> firestoreData,
  RelevoStruct? relevo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (relevo == null) {
    return;
  }
  if (relevo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && relevo.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final relevoData = getRelevoFirestoreData(relevo, forFieldValue);
  final nestedData = relevoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = relevo.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRelevoFirestoreData(
  RelevoStruct? relevo, [
  bool forFieldValue = false,
]) {
  if (relevo == null) {
    return {};
  }
  final firestoreData = mapToFirestore(relevo.toMap());

  // Add any Firestore field values
  relevo.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRelevoListFirestoreData(
  List<RelevoStruct>? relevos,
) =>
    relevos?.map((e) => getRelevoFirestoreData(e, true)).toList() ?? [];
