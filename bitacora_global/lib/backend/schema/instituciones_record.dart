import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InstitucionesRecord extends FirestoreRecord {
  InstitucionesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nombreInstitucion" field.
  String? _nombreInstitucion;
  String get nombreInstitucion => _nombreInstitucion ?? '';
  bool hasNombreInstitucion() => _nombreInstitucion != null;

  // "sucursales" field.
  List<SucursalStruct>? _sucursales;
  List<SucursalStruct> get sucursales => _sucursales ?? const [];
  bool hasSucursales() => _sucursales != null;

  // "logo" field.
  String? _logo;
  String get logo => _logo ?? '';
  bool hasLogo() => _logo != null;

  void _initializeFields() {
    _nombreInstitucion = snapshotData['nombreInstitucion'] as String?;
    _sucursales = getStructList(
      snapshotData['sucursales'],
      SucursalStruct.fromMap,
    );
    _logo = snapshotData['logo'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Instituciones');

  static Stream<InstitucionesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InstitucionesRecord.fromSnapshot(s));

  static Future<InstitucionesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => InstitucionesRecord.fromSnapshot(s));

  static InstitucionesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InstitucionesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InstitucionesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InstitucionesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InstitucionesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InstitucionesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInstitucionesRecordData({
  String? nombreInstitucion,
  String? logo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nombreInstitucion': nombreInstitucion,
      'logo': logo,
    }.withoutNulls,
  );

  return firestoreData;
}

class InstitucionesRecordDocumentEquality
    implements Equality<InstitucionesRecord> {
  const InstitucionesRecordDocumentEquality();

  @override
  bool equals(InstitucionesRecord? e1, InstitucionesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.nombreInstitucion == e2?.nombreInstitucion &&
        listEquality.equals(e1?.sucursales, e2?.sucursales) &&
        e1?.logo == e2?.logo;
  }

  @override
  int hash(InstitucionesRecord? e) =>
      const ListEquality().hash([e?.nombreInstitucion, e?.sucursales, e?.logo]);

  @override
  bool isValidKey(Object? o) => o is InstitucionesRecord;
}
