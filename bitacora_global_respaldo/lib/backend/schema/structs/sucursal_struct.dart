// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SucursalStruct extends FFFirebaseStruct {
  SucursalStruct({
    String? estado,
    String? sucursalCiudad,
    String? foto,
    LatLng? ubicacion,
    DocumentReference? bitacoraActual,
    DocumentReference? vigilanteActual,
    List<String>? listaEventos,
    int? idSucursal,
    List<String>? proveedores,
    DateTime? horaEstado,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _estado = estado,
        _sucursalCiudad = sucursalCiudad,
        _foto = foto,
        _ubicacion = ubicacion,
        _bitacoraActual = bitacoraActual,
        _vigilanteActual = vigilanteActual,
        _listaEventos = listaEventos,
        _idSucursal = idSucursal,
        _proveedores = proveedores,
        _horaEstado = horaEstado,
        super(firestoreUtilData);

  // "Estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  set estado(String? val) => _estado = val;

  bool hasEstado() => _estado != null;

  // "sucursalCiudad" field.
  String? _sucursalCiudad;
  String get sucursalCiudad => _sucursalCiudad ?? '';
  set sucursalCiudad(String? val) => _sucursalCiudad = val;

  bool hasSucursalCiudad() => _sucursalCiudad != null;

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  set foto(String? val) => _foto = val;

  bool hasFoto() => _foto != null;

  // "ubicacion" field.
  LatLng? _ubicacion;
  LatLng? get ubicacion => _ubicacion;
  set ubicacion(LatLng? val) => _ubicacion = val;

  bool hasUbicacion() => _ubicacion != null;

  // "bitacoraActual" field.
  DocumentReference? _bitacoraActual;
  DocumentReference? get bitacoraActual => _bitacoraActual;
  set bitacoraActual(DocumentReference? val) => _bitacoraActual = val;

  bool hasBitacoraActual() => _bitacoraActual != null;

  // "vigilanteActual" field.
  DocumentReference? _vigilanteActual;
  DocumentReference? get vigilanteActual => _vigilanteActual;
  set vigilanteActual(DocumentReference? val) => _vigilanteActual = val;

  bool hasVigilanteActual() => _vigilanteActual != null;

  // "listaEventos" field.
  List<String>? _listaEventos;
  List<String> get listaEventos => _listaEventos ?? const [];
  set listaEventos(List<String>? val) => _listaEventos = val;

  void updateListaEventos(Function(List<String>) updateFn) {
    updateFn(_listaEventos ??= []);
  }

  bool hasListaEventos() => _listaEventos != null;

  // "idSucursal" field.
  int? _idSucursal;
  int get idSucursal => _idSucursal ?? 0;
  set idSucursal(int? val) => _idSucursal = val;

  void incrementIdSucursal(int amount) => idSucursal = idSucursal + amount;

  bool hasIdSucursal() => _idSucursal != null;

  // "proveedores" field.
  List<String>? _proveedores;
  List<String> get proveedores => _proveedores ?? const [];
  set proveedores(List<String>? val) => _proveedores = val;

  void updateProveedores(Function(List<String>) updateFn) {
    updateFn(_proveedores ??= []);
  }

  bool hasProveedores() => _proveedores != null;

  // "horaEstado" field.
  DateTime? _horaEstado;
  DateTime? get horaEstado => _horaEstado;
  set horaEstado(DateTime? val) => _horaEstado = val;

  bool hasHoraEstado() => _horaEstado != null;

  static SucursalStruct fromMap(Map<String, dynamic> data) => SucursalStruct(
        estado: data['Estado'] as String?,
        sucursalCiudad: data['sucursalCiudad'] as String?,
        foto: data['foto'] as String?,
        ubicacion: data['ubicacion'] as LatLng?,
        bitacoraActual: data['bitacoraActual'] as DocumentReference?,
        vigilanteActual: data['vigilanteActual'] as DocumentReference?,
        listaEventos: getDataList(data['listaEventos']),
        idSucursal: castToType<int>(data['idSucursal']),
        proveedores: getDataList(data['proveedores']),
        horaEstado: data['horaEstado'] as DateTime?,
      );

  static SucursalStruct? maybeFromMap(dynamic data) =>
      data is Map ? SucursalStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'Estado': _estado,
        'sucursalCiudad': _sucursalCiudad,
        'foto': _foto,
        'ubicacion': _ubicacion,
        'bitacoraActual': _bitacoraActual,
        'vigilanteActual': _vigilanteActual,
        'listaEventos': _listaEventos,
        'idSucursal': _idSucursal,
        'proveedores': _proveedores,
        'horaEstado': _horaEstado,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'sucursalCiudad': serializeParam(
          _sucursalCiudad,
          ParamType.String,
        ),
        'foto': serializeParam(
          _foto,
          ParamType.String,
        ),
        'ubicacion': serializeParam(
          _ubicacion,
          ParamType.LatLng,
        ),
        'bitacoraActual': serializeParam(
          _bitacoraActual,
          ParamType.DocumentReference,
        ),
        'vigilanteActual': serializeParam(
          _vigilanteActual,
          ParamType.DocumentReference,
        ),
        'listaEventos': serializeParam(
          _listaEventos,
          ParamType.String,
          isList: true,
        ),
        'idSucursal': serializeParam(
          _idSucursal,
          ParamType.int,
        ),
        'proveedores': serializeParam(
          _proveedores,
          ParamType.String,
          isList: true,
        ),
        'horaEstado': serializeParam(
          _horaEstado,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static SucursalStruct fromSerializableMap(Map<String, dynamic> data) =>
      SucursalStruct(
        estado: deserializeParam(
          data['Estado'],
          ParamType.String,
          false,
        ),
        sucursalCiudad: deserializeParam(
          data['sucursalCiudad'],
          ParamType.String,
          false,
        ),
        foto: deserializeParam(
          data['foto'],
          ParamType.String,
          false,
        ),
        ubicacion: deserializeParam(
          data['ubicacion'],
          ParamType.LatLng,
          false,
        ),
        bitacoraActual: deserializeParam(
          data['bitacoraActual'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['Instituciones', 'bitacora'],
        ),
        vigilanteActual: deserializeParam(
          data['vigilanteActual'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
        listaEventos: deserializeParam<String>(
          data['listaEventos'],
          ParamType.String,
          true,
        ),
        idSucursal: deserializeParam(
          data['idSucursal'],
          ParamType.int,
          false,
        ),
        proveedores: deserializeParam<String>(
          data['proveedores'],
          ParamType.String,
          true,
        ),
        horaEstado: deserializeParam(
          data['horaEstado'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'SucursalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SucursalStruct &&
        estado == other.estado &&
        sucursalCiudad == other.sucursalCiudad &&
        foto == other.foto &&
        ubicacion == other.ubicacion &&
        bitacoraActual == other.bitacoraActual &&
        vigilanteActual == other.vigilanteActual &&
        listEquality.equals(listaEventos, other.listaEventos) &&
        idSucursal == other.idSucursal &&
        listEquality.equals(proveedores, other.proveedores) &&
        horaEstado == other.horaEstado;
  }

  @override
  int get hashCode => const ListEquality().hash([
        estado,
        sucursalCiudad,
        foto,
        ubicacion,
        bitacoraActual,
        vigilanteActual,
        listaEventos,
        idSucursal,
        proveedores,
        horaEstado
      ]);
}

SucursalStruct createSucursalStruct({
  String? estado,
  String? sucursalCiudad,
  String? foto,
  LatLng? ubicacion,
  DocumentReference? bitacoraActual,
  DocumentReference? vigilanteActual,
  int? idSucursal,
  DateTime? horaEstado,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SucursalStruct(
      estado: estado,
      sucursalCiudad: sucursalCiudad,
      foto: foto,
      ubicacion: ubicacion,
      bitacoraActual: bitacoraActual,
      vigilanteActual: vigilanteActual,
      idSucursal: idSucursal,
      horaEstado: horaEstado,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SucursalStruct? updateSucursalStruct(
  SucursalStruct? sucursal, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    sucursal
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSucursalStructData(
  Map<String, dynamic> firestoreData,
  SucursalStruct? sucursal,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (sucursal == null) {
    return;
  }
  if (sucursal.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && sucursal.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final sucursalData = getSucursalFirestoreData(sucursal, forFieldValue);
  final nestedData = sucursalData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = sucursal.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSucursalFirestoreData(
  SucursalStruct? sucursal, [
  bool forFieldValue = false,
]) {
  if (sucursal == null) {
    return {};
  }
  final firestoreData = mapToFirestore(sucursal.toMap());

  // Add any Firestore field values
  sucursal.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSucursalListFirestoreData(
  List<SucursalStruct>? sucursals,
) =>
    sucursals?.map((e) => getSucursalFirestoreData(e, true)).toList() ?? [];
