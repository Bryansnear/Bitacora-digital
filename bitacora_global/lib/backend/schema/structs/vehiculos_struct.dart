// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class VehiculosStruct extends FFFirebaseStruct {
  VehiculosStruct({
    String? placa,
    String? motivo,
    DateTime? horaSalida,
    DateTime? horaEntrada,
    String? foto,
    String? cedula,
    String? nombre,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _placa = placa,
        _motivo = motivo,
        _horaSalida = horaSalida,
        _horaEntrada = horaEntrada,
        _foto = foto,
        _cedula = cedula,
        _nombre = nombre,
        super(firestoreUtilData);

  // "placa" field.
  String? _placa;
  String get placa => _placa ?? '';
  set placa(String? val) => _placa = val;

  bool hasPlaca() => _placa != null;

  // "motivo" field.
  String? _motivo;
  String get motivo => _motivo ?? '';
  set motivo(String? val) => _motivo = val;

  bool hasMotivo() => _motivo != null;

  // "horaSalida" field.
  DateTime? _horaSalida;
  DateTime? get horaSalida => _horaSalida;
  set horaSalida(DateTime? val) => _horaSalida = val;

  bool hasHoraSalida() => _horaSalida != null;

  // "horaEntrada" field.
  DateTime? _horaEntrada;
  DateTime? get horaEntrada => _horaEntrada;
  set horaEntrada(DateTime? val) => _horaEntrada = val;

  bool hasHoraEntrada() => _horaEntrada != null;

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

  // "nombre" field.
  String? _nombre;
  String get nombre => _nombre ?? '';
  set nombre(String? val) => _nombre = val;

  bool hasNombre() => _nombre != null;

  static VehiculosStruct fromMap(Map<String, dynamic> data) => VehiculosStruct(
        placa: data['placa'] as String?,
        motivo: data['motivo'] as String?,
        horaSalida: data['horaSalida'] as DateTime?,
        horaEntrada: data['horaEntrada'] as DateTime?,
        foto: data['foto'] as String?,
        cedula: data['cedula'] as String?,
        nombre: data['nombre'] as String?,
      );

  static VehiculosStruct? maybeFromMap(dynamic data) => data is Map
      ? VehiculosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'placa': _placa,
        'motivo': _motivo,
        'horaSalida': _horaSalida,
        'horaEntrada': _horaEntrada,
        'foto': _foto,
        'cedula': _cedula,
        'nombre': _nombre,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'placa': serializeParam(
          _placa,
          ParamType.String,
        ),
        'motivo': serializeParam(
          _motivo,
          ParamType.String,
        ),
        'horaSalida': serializeParam(
          _horaSalida,
          ParamType.DateTime,
        ),
        'horaEntrada': serializeParam(
          _horaEntrada,
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
        'nombre': serializeParam(
          _nombre,
          ParamType.String,
        ),
      }.withoutNulls;

  static VehiculosStruct fromSerializableMap(Map<String, dynamic> data) =>
      VehiculosStruct(
        placa: deserializeParam(
          data['placa'],
          ParamType.String,
          false,
        ),
        motivo: deserializeParam(
          data['motivo'],
          ParamType.String,
          false,
        ),
        horaSalida: deserializeParam(
          data['horaSalida'],
          ParamType.DateTime,
          false,
        ),
        horaEntrada: deserializeParam(
          data['horaEntrada'],
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
        nombre: deserializeParam(
          data['nombre'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VehiculosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VehiculosStruct &&
        placa == other.placa &&
        motivo == other.motivo &&
        horaSalida == other.horaSalida &&
        horaEntrada == other.horaEntrada &&
        foto == other.foto &&
        cedula == other.cedula &&
        nombre == other.nombre;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([placa, motivo, horaSalida, horaEntrada, foto, cedula, nombre]);
}

VehiculosStruct createVehiculosStruct({
  String? placa,
  String? motivo,
  DateTime? horaSalida,
  DateTime? horaEntrada,
  String? foto,
  String? cedula,
  String? nombre,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    VehiculosStruct(
      placa: placa,
      motivo: motivo,
      horaSalida: horaSalida,
      horaEntrada: horaEntrada,
      foto: foto,
      cedula: cedula,
      nombre: nombre,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

VehiculosStruct? updateVehiculosStruct(
  VehiculosStruct? vehiculos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    vehiculos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addVehiculosStructData(
  Map<String, dynamic> firestoreData,
  VehiculosStruct? vehiculos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (vehiculos == null) {
    return;
  }
  if (vehiculos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && vehiculos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final vehiculosData = getVehiculosFirestoreData(vehiculos, forFieldValue);
  final nestedData = vehiculosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = vehiculos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getVehiculosFirestoreData(
  VehiculosStruct? vehiculos, [
  bool forFieldValue = false,
]) {
  if (vehiculos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(vehiculos.toMap());

  // Add any Firestore field values
  vehiculos.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getVehiculosListFirestoreData(
  List<VehiculosStruct>? vehiculoss,
) =>
    vehiculoss?.map((e) => getVehiculosFirestoreData(e, true)).toList() ?? [];
