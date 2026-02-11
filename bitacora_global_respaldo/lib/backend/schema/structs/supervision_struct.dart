// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SupervisionStruct extends FFFirebaseStruct {
  SupervisionStruct({
    String? supervisor,
    String? informe,
    String? fotoSupervisado,
    DateTime? horaSupervision,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _supervisor = supervisor,
        _informe = informe,
        _fotoSupervisado = fotoSupervisado,
        _horaSupervision = horaSupervision,
        super(firestoreUtilData);

  // "supervisor" field.
  String? _supervisor;
  String get supervisor => _supervisor ?? '';
  set supervisor(String? val) => _supervisor = val;

  bool hasSupervisor() => _supervisor != null;

  // "informe" field.
  String? _informe;
  String get informe => _informe ?? '';
  set informe(String? val) => _informe = val;

  bool hasInforme() => _informe != null;

  // "fotoSupervisado" field.
  String? _fotoSupervisado;
  String get fotoSupervisado => _fotoSupervisado ?? '';
  set fotoSupervisado(String? val) => _fotoSupervisado = val;

  bool hasFotoSupervisado() => _fotoSupervisado != null;

  // "horaSupervision" field.
  DateTime? _horaSupervision;
  DateTime? get horaSupervision => _horaSupervision;
  set horaSupervision(DateTime? val) => _horaSupervision = val;

  bool hasHoraSupervision() => _horaSupervision != null;

  static SupervisionStruct fromMap(Map<String, dynamic> data) =>
      SupervisionStruct(
        supervisor: data['supervisor'] as String?,
        informe: data['informe'] as String?,
        fotoSupervisado: data['fotoSupervisado'] as String?,
        horaSupervision: data['horaSupervision'] as DateTime?,
      );

  static SupervisionStruct? maybeFromMap(dynamic data) => data is Map
      ? SupervisionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'supervisor': _supervisor,
        'informe': _informe,
        'fotoSupervisado': _fotoSupervisado,
        'horaSupervision': _horaSupervision,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'supervisor': serializeParam(
          _supervisor,
          ParamType.String,
        ),
        'informe': serializeParam(
          _informe,
          ParamType.String,
        ),
        'fotoSupervisado': serializeParam(
          _fotoSupervisado,
          ParamType.String,
        ),
        'horaSupervision': serializeParam(
          _horaSupervision,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static SupervisionStruct fromSerializableMap(Map<String, dynamic> data) =>
      SupervisionStruct(
        supervisor: deserializeParam(
          data['supervisor'],
          ParamType.String,
          false,
        ),
        informe: deserializeParam(
          data['informe'],
          ParamType.String,
          false,
        ),
        fotoSupervisado: deserializeParam(
          data['fotoSupervisado'],
          ParamType.String,
          false,
        ),
        horaSupervision: deserializeParam(
          data['horaSupervision'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'SupervisionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SupervisionStruct &&
        supervisor == other.supervisor &&
        informe == other.informe &&
        fotoSupervisado == other.fotoSupervisado &&
        horaSupervision == other.horaSupervision;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([supervisor, informe, fotoSupervisado, horaSupervision]);
}

SupervisionStruct createSupervisionStruct({
  String? supervisor,
  String? informe,
  String? fotoSupervisado,
  DateTime? horaSupervision,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SupervisionStruct(
      supervisor: supervisor,
      informe: informe,
      fotoSupervisado: fotoSupervisado,
      horaSupervision: horaSupervision,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SupervisionStruct? updateSupervisionStruct(
  SupervisionStruct? supervision, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    supervision
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSupervisionStructData(
  Map<String, dynamic> firestoreData,
  SupervisionStruct? supervision,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (supervision == null) {
    return;
  }
  if (supervision.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && supervision.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final supervisionData =
      getSupervisionFirestoreData(supervision, forFieldValue);
  final nestedData =
      supervisionData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = supervision.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSupervisionFirestoreData(
  SupervisionStruct? supervision, [
  bool forFieldValue = false,
]) {
  if (supervision == null) {
    return {};
  }
  final firestoreData = mapToFirestore(supervision.toMap());

  // Add any Firestore field values
  supervision.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSupervisionListFirestoreData(
  List<SupervisionStruct>? supervisions,
) =>
    supervisions?.map((e) => getSupervisionFirestoreData(e, true)).toList() ??
    [];
