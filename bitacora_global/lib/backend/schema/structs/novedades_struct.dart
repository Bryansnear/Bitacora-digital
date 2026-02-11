// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class NovedadesStruct extends FFFirebaseStruct {
  NovedadesStruct({
    String? descripcion,
    String? foto,
    DateTime? hora,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _descripcion = descripcion,
        _foto = foto,
        _hora = hora,
        super(firestoreUtilData);

  // "descripcion" field.
  String? _descripcion;
  String get descripcion => _descripcion ?? '';
  set descripcion(String? val) => _descripcion = val;

  bool hasDescripcion() => _descripcion != null;

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  set foto(String? val) => _foto = val;

  bool hasFoto() => _foto != null;

  // "hora" field.
  DateTime? _hora;
  DateTime? get hora => _hora;
  set hora(DateTime? val) => _hora = val;

  bool hasHora() => _hora != null;

  static NovedadesStruct fromMap(Map<String, dynamic> data) => NovedadesStruct(
        descripcion: data['descripcion'] as String?,
        foto: data['foto'] as String?,
        hora: data['hora'] as DateTime?,
      );

  static NovedadesStruct? maybeFromMap(dynamic data) => data is Map
      ? NovedadesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'descripcion': _descripcion,
        'foto': _foto,
        'hora': _hora,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'descripcion': serializeParam(
          _descripcion,
          ParamType.String,
        ),
        'foto': serializeParam(
          _foto,
          ParamType.String,
        ),
        'hora': serializeParam(
          _hora,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static NovedadesStruct fromSerializableMap(Map<String, dynamic> data) =>
      NovedadesStruct(
        descripcion: deserializeParam(
          data['descripcion'],
          ParamType.String,
          false,
        ),
        foto: deserializeParam(
          data['foto'],
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
  String toString() => 'NovedadesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NovedadesStruct &&
        descripcion == other.descripcion &&
        foto == other.foto &&
        hora == other.hora;
  }

  @override
  int get hashCode => const ListEquality().hash([descripcion, foto, hora]);
}

NovedadesStruct createNovedadesStruct({
  String? descripcion,
  String? foto,
  DateTime? hora,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    NovedadesStruct(
      descripcion: descripcion,
      foto: foto,
      hora: hora,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

NovedadesStruct? updateNovedadesStruct(
  NovedadesStruct? novedades, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    novedades
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addNovedadesStructData(
  Map<String, dynamic> firestoreData,
  NovedadesStruct? novedades,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (novedades == null) {
    return;
  }
  if (novedades.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && novedades.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final novedadesData = getNovedadesFirestoreData(novedades, forFieldValue);
  final nestedData = novedadesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = novedades.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getNovedadesFirestoreData(
  NovedadesStruct? novedades, [
  bool forFieldValue = false,
]) {
  if (novedades == null) {
    return {};
  }
  final firestoreData = mapToFirestore(novedades.toMap());

  // Add any Firestore field values
  novedades.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getNovedadesListFirestoreData(
  List<NovedadesStruct>? novedadess,
) =>
    novedadess?.map((e) => getNovedadesFirestoreData(e, true)).toList() ?? [];
