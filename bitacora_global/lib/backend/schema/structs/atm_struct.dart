// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AtmStruct extends FFFirebaseStruct {
  AtmStruct({
    String? foto,
    String? novedad,
    DateTime? hora,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _foto = foto,
        _novedad = novedad,
        _hora = hora,
        super(firestoreUtilData);

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  set foto(String? val) => _foto = val;

  bool hasFoto() => _foto != null;

  // "novedad" field.
  String? _novedad;
  String get novedad => _novedad ?? '';
  set novedad(String? val) => _novedad = val;

  bool hasNovedad() => _novedad != null;

  // "hora" field.
  DateTime? _hora;
  DateTime? get hora => _hora;
  set hora(DateTime? val) => _hora = val;

  bool hasHora() => _hora != null;

  static AtmStruct fromMap(Map<String, dynamic> data) => AtmStruct(
        foto: data['foto'] as String?,
        novedad: data['novedad'] as String?,
        hora: data['hora'] as DateTime?,
      );

  static AtmStruct? maybeFromMap(dynamic data) =>
      data is Map ? AtmStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'foto': _foto,
        'novedad': _novedad,
        'hora': _hora,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'foto': serializeParam(
          _foto,
          ParamType.String,
        ),
        'novedad': serializeParam(
          _novedad,
          ParamType.String,
        ),
        'hora': serializeParam(
          _hora,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static AtmStruct fromSerializableMap(Map<String, dynamic> data) => AtmStruct(
        foto: deserializeParam(
          data['foto'],
          ParamType.String,
          false,
        ),
        novedad: deserializeParam(
          data['novedad'],
          ParamType.String,
          false,
        ),
        hora: deserializeParam(
          data['hora'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'AtmStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AtmStruct &&
        foto == other.foto &&
        novedad == other.novedad &&
        hora == other.hora;
  }

  @override
  int get hashCode => const ListEquality().hash([foto, novedad, hora]);
}

AtmStruct createAtmStruct({
  String? foto,
  String? novedad,
  DateTime? hora,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AtmStruct(
      foto: foto,
      novedad: novedad,
      hora: hora,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AtmStruct? updateAtmStruct(
  AtmStruct? atm, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    atm
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAtmStructData(
  Map<String, dynamic> firestoreData,
  AtmStruct? atm,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (atm == null) {
    return;
  }
  if (atm.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && atm.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final atmData = getAtmFirestoreData(atm, forFieldValue);
  final nestedData = atmData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = atm.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAtmFirestoreData(
  AtmStruct? atm, [
  bool forFieldValue = false,
]) {
  if (atm == null) {
    return {};
  }
  final firestoreData = mapToFirestore(atm.toMap());

  // Add any Firestore field values
  atm.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAtmListFirestoreData(
  List<AtmStruct>? atms,
) =>
    atms?.map((e) => getAtmFirestoreData(e, true)).toList() ?? [];
