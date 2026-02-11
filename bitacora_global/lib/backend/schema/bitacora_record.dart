import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BitacoraRecord extends FirestoreRecord {
  BitacoraRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "vigilanteApertura" field.
  String? _vigilanteApertura;
  String get vigilanteApertura => _vigilanteApertura ?? '';
  bool hasVigilanteApertura() => _vigilanteApertura != null;

  // "fechayhoraApertura" field.
  DateTime? _fechayhoraApertura;
  DateTime? get fechayhoraApertura => _fechayhoraApertura;
  bool hasFechayhoraApertura() => _fechayhoraApertura != null;

  // "vigilanteCierre" field.
  String? _vigilanteCierre;
  String get vigilanteCierre => _vigilanteCierre ?? '';
  bool hasVigilanteCierre() => _vigilanteCierre != null;

  // "encargadoCierre" field.
  String? _encargadoCierre;
  String get encargadoCierre => _encargadoCierre ?? '';
  bool hasEncargadoCierre() => _encargadoCierre != null;

  // "novedaCierre" field.
  String? _novedaCierre;
  String get novedaCierre => _novedaCierre ?? '';
  bool hasNovedaCierre() => _novedaCierre != null;

  // "fechayhoraCierre" field.
  DateTime? _fechayhoraCierre;
  DateTime? get fechayhoraCierre => _fechayhoraCierre;
  bool hasFechayhoraCierre() => _fechayhoraCierre != null;

  // "encargadoApertura" field.
  String? _encargadoApertura;
  String get encargadoApertura => _encargadoApertura ?? '';
  bool hasEncargadoApertura() => _encargadoApertura != null;

  // "visitas" field.
  List<VisitasStruct>? _visitas;
  List<VisitasStruct> get visitas => _visitas ?? const [];
  bool hasVisitas() => _visitas != null;

  // "novedades" field.
  List<NovedadesStruct>? _novedades;
  List<NovedadesStruct> get novedades => _novedades ?? const [];
  bool hasNovedades() => _novedades != null;

  // "vehiculos" field.
  List<VehiculosStruct>? _vehiculos;
  List<VehiculosStruct> get vehiculos => _vehiculos ?? const [];
  bool hasVehiculos() => _vehiculos != null;

  // "fotoApertura" field.
  String? _fotoApertura;
  String get fotoApertura => _fotoApertura ?? '';
  bool hasFotoApertura() => _fotoApertura != null;

  // "novedadApertura" field.
  String? _novedadApertura;
  String get novedadApertura => _novedadApertura ?? '';
  bool hasNovedadApertura() => _novedadApertura != null;

  // "novedadCierre" field.
  String? _novedadCierre;
  String get novedadCierre => _novedadCierre ?? '';
  bool hasNovedadCierre() => _novedadCierre != null;

  // "sucursal" field.
  String? _sucursal;
  String get sucursal => _sucursal ?? '';
  bool hasSucursal() => _sucursal != null;

  // "supervision" field.
  SupervisionStruct? _supervision;
  SupervisionStruct get supervision => _supervision ?? SupervisionStruct();
  bool hasSupervision() => _supervision != null;

  // "encargadoAlarmado" field.
  String? _encargadoAlarmado;
  String get encargadoAlarmado => _encargadoAlarmado ?? '';
  bool hasEncargadoAlarmado() => _encargadoAlarmado != null;

  // "encargadoDesalarmado" field.
  String? _encargadoDesalarmado;
  String get encargadoDesalarmado => _encargadoDesalarmado ?? '';
  bool hasEncargadoDesalarmado() => _encargadoDesalarmado != null;

  // "horaLlegadaCajeros" field.
  DateTime? _horaLlegadaCajeros;
  DateTime? get horaLlegadaCajeros => _horaLlegadaCajeros;
  bool hasHoraLlegadaCajeros() => _horaLlegadaCajeros != null;

  // "horaLlegadaOficinas" field.
  DateTime? _horaLlegadaOficinas;
  DateTime? get horaLlegadaOficinas => _horaLlegadaOficinas;
  bool hasHoraLlegadaOficinas() => _horaLlegadaOficinas != null;

  // "horaAperturaTotal" field.
  DateTime? _horaAperturaTotal;
  DateTime? get horaAperturaTotal => _horaAperturaTotal;
  bool hasHoraAperturaTotal() => _horaAperturaTotal != null;

  // "horaCierreTotal" field.
  DateTime? _horaCierreTotal;
  DateTime? get horaCierreTotal => _horaCierreTotal;
  bool hasHoraCierreTotal() => _horaCierreTotal != null;

  // "horaLlegadaVigilante" field.
  DateTime? _horaLlegadaVigilante;
  DateTime? get horaLlegadaVigilante => _horaLlegadaVigilante;
  bool hasHoraLlegadaVigilante() => _horaLlegadaVigilante != null;

  // "proveedores" field.
  List<ProveedoresStruct>? _proveedores;
  List<ProveedoresStruct> get proveedores => _proveedores ?? const [];
  bool hasProveedores() => _proveedores != null;

  // "horaSalidaVigilante" field.
  DateTime? _horaSalidaVigilante;
  DateTime? get horaSalidaVigilante => _horaSalidaVigilante;
  bool hasHoraSalidaVigilante() => _horaSalidaVigilante != null;

  // "novedadCierreTotal" field.
  String? _novedadCierreTotal;
  String get novedadCierreTotal => _novedadCierreTotal ?? '';
  bool hasNovedadCierreTotal() => _novedadCierreTotal != null;

  // "relevo" field.
  RelevoStruct? _relevo;
  RelevoStruct get relevo => _relevo ?? RelevoStruct();
  bool hasRelevo() => _relevo != null;

  // "horaAtencionPublicoCajeros" field.
  DateTime? _horaAtencionPublicoCajeros;
  DateTime? get horaAtencionPublicoCajeros => _horaAtencionPublicoCajeros;
  bool hasHoraAtencionPublicoCajeros() => _horaAtencionPublicoCajeros != null;

  // "listaATM" field.
  List<AtmStruct>? _listaATM;
  List<AtmStruct> get listaATM => _listaATM ?? const [];
  bool hasListaATM() => _listaATM != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _vigilanteApertura = snapshotData['vigilanteApertura'] as String?;
    _fechayhoraApertura = snapshotData['fechayhoraApertura'] as DateTime?;
    _vigilanteCierre = snapshotData['vigilanteCierre'] as String?;
    _encargadoCierre = snapshotData['encargadoCierre'] as String?;
    _novedaCierre = snapshotData['novedaCierre'] as String?;
    _fechayhoraCierre = snapshotData['fechayhoraCierre'] as DateTime?;
    _encargadoApertura = snapshotData['encargadoApertura'] as String?;
    _visitas = getStructList(
      snapshotData['visitas'],
      VisitasStruct.fromMap,
    );
    _novedades = getStructList(
      snapshotData['novedades'],
      NovedadesStruct.fromMap,
    );
    _vehiculos = getStructList(
      snapshotData['vehiculos'],
      VehiculosStruct.fromMap,
    );
    _fotoApertura = snapshotData['fotoApertura'] as String?;
    _novedadApertura = snapshotData['novedadApertura'] as String?;
    _novedadCierre = snapshotData['novedadCierre'] as String?;
    _sucursal = snapshotData['sucursal'] as String?;
    _supervision = snapshotData['supervision'] is SupervisionStruct
        ? snapshotData['supervision']
        : SupervisionStruct.maybeFromMap(snapshotData['supervision']);
    _encargadoAlarmado = snapshotData['encargadoAlarmado'] as String?;
    _encargadoDesalarmado = snapshotData['encargadoDesalarmado'] as String?;
    _horaLlegadaCajeros = snapshotData['horaLlegadaCajeros'] as DateTime?;
    _horaLlegadaOficinas = snapshotData['horaLlegadaOficinas'] as DateTime?;
    _horaAperturaTotal = snapshotData['horaAperturaTotal'] as DateTime?;
    _horaCierreTotal = snapshotData['horaCierreTotal'] as DateTime?;
    _horaLlegadaVigilante = snapshotData['horaLlegadaVigilante'] as DateTime?;
    _proveedores = getStructList(
      snapshotData['proveedores'],
      ProveedoresStruct.fromMap,
    );
    _horaSalidaVigilante = snapshotData['horaSalidaVigilante'] as DateTime?;
    _novedadCierreTotal = snapshotData['novedadCierreTotal'] as String?;
    _relevo = snapshotData['relevo'] is RelevoStruct
        ? snapshotData['relevo']
        : RelevoStruct.maybeFromMap(snapshotData['relevo']);
    _horaAtencionPublicoCajeros =
        snapshotData['horaAtencionPublicoCajeros'] as DateTime?;
    _listaATM = getStructList(
      snapshotData['listaATM'],
      AtmStruct.fromMap,
    );
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('bitacora')
          : FirebaseFirestore.instance.collectionGroup('bitacora');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('bitacora').doc(id);

  static Stream<BitacoraRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BitacoraRecord.fromSnapshot(s));

  static Future<BitacoraRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BitacoraRecord.fromSnapshot(s));

  static BitacoraRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BitacoraRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BitacoraRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BitacoraRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BitacoraRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BitacoraRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBitacoraRecordData({
  String? vigilanteApertura,
  DateTime? fechayhoraApertura,
  String? vigilanteCierre,
  String? encargadoCierre,
  String? novedaCierre,
  DateTime? fechayhoraCierre,
  String? encargadoApertura,
  String? fotoApertura,
  String? novedadApertura,
  String? novedadCierre,
  String? sucursal,
  SupervisionStruct? supervision,
  String? encargadoAlarmado,
  String? encargadoDesalarmado,
  DateTime? horaLlegadaCajeros,
  DateTime? horaLlegadaOficinas,
  DateTime? horaAperturaTotal,
  DateTime? horaCierreTotal,
  DateTime? horaLlegadaVigilante,
  DateTime? horaSalidaVigilante,
  String? novedadCierreTotal,
  RelevoStruct? relevo,
  DateTime? horaAtencionPublicoCajeros,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'vigilanteApertura': vigilanteApertura,
      'fechayhoraApertura': fechayhoraApertura,
      'vigilanteCierre': vigilanteCierre,
      'encargadoCierre': encargadoCierre,
      'novedaCierre': novedaCierre,
      'fechayhoraCierre': fechayhoraCierre,
      'encargadoApertura': encargadoApertura,
      'fotoApertura': fotoApertura,
      'novedadApertura': novedadApertura,
      'novedadCierre': novedadCierre,
      'sucursal': sucursal,
      'supervision': SupervisionStruct().toMap(),
      'encargadoAlarmado': encargadoAlarmado,
      'encargadoDesalarmado': encargadoDesalarmado,
      'horaLlegadaCajeros': horaLlegadaCajeros,
      'horaLlegadaOficinas': horaLlegadaOficinas,
      'horaAperturaTotal': horaAperturaTotal,
      'horaCierreTotal': horaCierreTotal,
      'horaLlegadaVigilante': horaLlegadaVigilante,
      'horaSalidaVigilante': horaSalidaVigilante,
      'novedadCierreTotal': novedadCierreTotal,
      'relevo': RelevoStruct().toMap(),
      'horaAtencionPublicoCajeros': horaAtencionPublicoCajeros,
    }.withoutNulls,
  );

  // Handle nested data for "supervision" field.
  addSupervisionStructData(firestoreData, supervision, 'supervision');

  // Handle nested data for "relevo" field.
  addRelevoStructData(firestoreData, relevo, 'relevo');

  return firestoreData;
}

class BitacoraRecordDocumentEquality implements Equality<BitacoraRecord> {
  const BitacoraRecordDocumentEquality();

  @override
  bool equals(BitacoraRecord? e1, BitacoraRecord? e2) {
    const listEquality = ListEquality();
    return e1?.vigilanteApertura == e2?.vigilanteApertura &&
        e1?.fechayhoraApertura == e2?.fechayhoraApertura &&
        e1?.vigilanteCierre == e2?.vigilanteCierre &&
        e1?.encargadoCierre == e2?.encargadoCierre &&
        e1?.novedaCierre == e2?.novedaCierre &&
        e1?.fechayhoraCierre == e2?.fechayhoraCierre &&
        e1?.encargadoApertura == e2?.encargadoApertura &&
        listEquality.equals(e1?.visitas, e2?.visitas) &&
        listEquality.equals(e1?.novedades, e2?.novedades) &&
        listEquality.equals(e1?.vehiculos, e2?.vehiculos) &&
        e1?.fotoApertura == e2?.fotoApertura &&
        e1?.novedadApertura == e2?.novedadApertura &&
        e1?.novedadCierre == e2?.novedadCierre &&
        e1?.sucursal == e2?.sucursal &&
        e1?.supervision == e2?.supervision &&
        e1?.encargadoAlarmado == e2?.encargadoAlarmado &&
        e1?.encargadoDesalarmado == e2?.encargadoDesalarmado &&
        e1?.horaLlegadaCajeros == e2?.horaLlegadaCajeros &&
        e1?.horaLlegadaOficinas == e2?.horaLlegadaOficinas &&
        e1?.horaAperturaTotal == e2?.horaAperturaTotal &&
        e1?.horaCierreTotal == e2?.horaCierreTotal &&
        e1?.horaLlegadaVigilante == e2?.horaLlegadaVigilante &&
        listEquality.equals(e1?.proveedores, e2?.proveedores) &&
        e1?.horaSalidaVigilante == e2?.horaSalidaVigilante &&
        e1?.novedadCierreTotal == e2?.novedadCierreTotal &&
        e1?.relevo == e2?.relevo &&
        e1?.horaAtencionPublicoCajeros == e2?.horaAtencionPublicoCajeros &&
        listEquality.equals(e1?.listaATM, e2?.listaATM);
  }

  @override
  int hash(BitacoraRecord? e) => const ListEquality().hash([
        e?.vigilanteApertura,
        e?.fechayhoraApertura,
        e?.vigilanteCierre,
        e?.encargadoCierre,
        e?.novedaCierre,
        e?.fechayhoraCierre,
        e?.encargadoApertura,
        e?.visitas,
        e?.novedades,
        e?.vehiculos,
        e?.fotoApertura,
        e?.novedadApertura,
        e?.novedadCierre,
        e?.sucursal,
        e?.supervision,
        e?.encargadoAlarmado,
        e?.encargadoDesalarmado,
        e?.horaLlegadaCajeros,
        e?.horaLlegadaOficinas,
        e?.horaAperturaTotal,
        e?.horaCierreTotal,
        e?.horaLlegadaVigilante,
        e?.proveedores,
        e?.horaSalidaVigilante,
        e?.novedadCierreTotal,
        e?.relevo,
        e?.horaAtencionPublicoCajeros,
        e?.listaATM
      ]);

  @override
  bool isValidKey(Object? o) => o is BitacoraRecord;
}
