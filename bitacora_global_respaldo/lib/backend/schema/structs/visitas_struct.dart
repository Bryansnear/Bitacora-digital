// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class VisitasStruct extends FFFirebaseStruct {
  VisitasStruct({
    String? nombre,
    String? motivo,
    String? pertenencias,
    DateTime? horaEntrada,
    DateTime? horaSalida,
    String? foto,
    String? cedula,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nombre = nombre,
        _motivo = motivo,
        _pertenencias = pertenencias,
        _horaEntrada = horaEntrada,
        _horaSalida = horaSalida,
        _foto = foto,
        _cedula = cedula,
        super(firestoreUtilData);

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  set nombre(String? val) => _nombre = val;

  bool hasNombre() => _nombre != null;

  // "motivo" field.
  String? _motivo;
  String get motivo => _motivo ?? '';
  set motivo(String? val) => _motivo = val;

  bool hasMotivo() => _motivo != null;

  // "pertenencias" field.
  String? _pertenencias;
  String get pertenencias => _pertenencias ?? '';
  set pertenencias(String? val) => _pertenencias = val;

  bool hasPertenencias() => _pertenencias != null;

  // "horaEntrada" field.
  DateTime? _horaEntrada;
  DateTime? get horaEntrada => _horaEntrada;
  set horaEntrada(DateTime? val) => _horaEntrada = val;

  bool hasHoraEntrada() => _horaEntrada != null;

  // "horaSalida" field.
  DateTime? _horaSalida;
  DateTime? get horaSalida => _horaSalida;
  set horaSalida(DateTime? val) => _horaSalida = val;

  bool hasHoraSalida() => _horaSalida != null;

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  set foto(String? val) => _foto = val;

  bool hasFoto() => _foto != null;

  // "cedula" field.
  String? _cedula;
  String get cedula => _cedula ?? '';
  set cedula(String? val) => _cedula = val;

  bool hasCedula() => _cedula != null;

  static VisitasStruct fromMap(Map<String, dynamic> data) => VisitasStruct(
        nombre: data['nombre'] as String?,
        motivo: data['motivo'] as String?,
        pertenencias: data['pertenencias'] as String?,
        horaEntrada: data['horaEntrada'] as DateTime?,
        horaSalida: data['horaSalida'] as DateTime?,
        foto: data['foto'] as String?,
        cedula: data['cedula'] as String?,
      );

  static VisitasStruct? maybeFromMap(dynamic data) =>
      data is Map ? VisitasStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nombre': _nombre,
        'motivo': _motivo,
        'pertenencias': _pertenencias,
        'horaEntrada': _horaEntrada,
        'horaSalida': _horaSalida,
        'foto': _foto,
        'cedula': _cedula,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nombre': serializeParam(
          _nombre,
          ParamType.String,
        ),
        'motivo': serializeParam(
          _motivo,
          ParamType.String,
        ),
        'pertenencias': serializeParam(
          _pertenencias,
          ParamType.String,
        ),
        'horaEntrada': serializeParam(
          _horaEntrada,
          ParamType.DateTime,
        ),
        'horaSalida': serializeParam(
          _horaSalida,
          ParamType.DateTime,
        ),
        'foto': serializeParam(
          _foto,
          ParamType.String,
        ),
        'cedula': serializeParam(
          _cedula,
          ParamType.String,
        ),
      }.withoutNulls;

  static VisitasStruct fromSerializableMap(Map<String, dynamic> data) =>
      VisitasStruct(
        nombre: deserializeParam(
          data['nombre'],
          ParamType.String,
          false,
        ),
        motivo: deserializeParam(
          data['motivo'],
          ParamType.String,
          false,
        ),
        pertenencias: deserializeParam(
          data['pertenencias'],
          ParamType.String,
          false,
        ),
        horaEntrada: deserializeParam(
          data['horaEntrada'],
          ParamType.DateTime,
          false,
        ),
        horaSalida: deserializeParam(
          data['horaSalida'],
          ParamType.DateTime,
          false,
        ),
        foto: deserializeParam(
          data['foto'],
          ParamType.String,
          false,
        ),
        cedula: deserializeParam(
          data['cedula'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VisitasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VisitasStruct &&
        nombre == other.nombre &&
        motivo == other.motivo &&
        pertenencias == other.pertenencias &&
        horaEntrada == other.horaEntrada &&
        horaSalida == other.horaSalida &&
        foto == other.foto &&
        cedula == other.cedula;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [nombre, motivo, pertenencias, horaEntrada, horaSalida, foto, cedula]);
}

VisitasStruct createVisitasStruct({
  String? nombre,
  String? motivo,
  String? pertenencias,
  DateTime? horaEntrada,
  DateTime? horaSalida,
  String? foto,
  String? cedula,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    VisitasStruct(
      nombre: nombre,
      motivo: motivo,
      pertenencias: pertenencias,
      horaEntrada: horaEntrada,
      horaSalida: horaSalida,
      foto: foto,
      cedula: cedula,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

VisitasStruct? updateVisitasStruct(
  VisitasStruct? visitas, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    visitas
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addVisitasStructData(
  Map<String, dynamic> firestoreData,
  VisitasStruct? visitas,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (visitas == null) {
    return;
  }
  if (visitas.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && visitas.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final visitasData = getVisitasFirestoreData(visitas, forFieldValue);
  final nestedData = visitasData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = visitas.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getVisitasFirestoreData(
  VisitasStruct? visitas, [
  bool forFieldValue = false,
]) {
  if (visitas == null) {
    return {};
  }
  final firestoreData = mapToFirestore(visitas.toMap());

  // Add any Firestore field values
  visitas.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getVisitasListFirestoreData(
  List<VisitasStruct>? visitass,
) =>
    visitass?.map((e) => getVisitasFirestoreData(e, true)).toList() ?? [];
