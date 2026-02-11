import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListaProveedoresRecord extends FirestoreRecord {
  ListaProveedoresRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "empresa" field.
  String? _empresa;
  String get empresa => _empresa ?? '';
  bool hasEmpresa() => _empresa != null;

  // "actividad" field.
  String? _actividad;
  String get actividad => _actividad ?? '';
  bool hasActividad() => _actividad != null;

  // "logo" field.
  String? _logo;
  String get logo => _logo ?? '';
  bool hasLogo() => _logo != null;

  // "agencia" field.
  String? _agencia;
  String get agencia => _agencia ?? '';
  bool hasAgencia() => _agencia != null;

  void _initializeFields() {
    _empresa = snapshotData['empresa'] as String?;
    _actividad = snapshotData['actividad'] as String?;
    _logo = snapshotData['logo'] as String?;
    _agencia = snapshotData['agencia'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('listaProveedores');

  static Stream<ListaProveedoresRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ListaProveedoresRecord.fromSnapshot(s));

  static Future<ListaProveedoresRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ListaProveedoresRecord.fromSnapshot(s));

  static ListaProveedoresRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ListaProveedoresRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ListaProveedoresRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ListaProveedoresRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ListaProveedoresRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ListaProveedoresRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createListaProveedoresRecordData({
  String? empresa,
  String? actividad,
  String? logo,
  String? agencia,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'empresa': empresa,
      'actividad': actividad,
      'logo': logo,
      'agencia': agencia,
    }.withoutNulls,
  );

  return firestoreData;
}

class ListaProveedoresRecordDocumentEquality
    implements Equality<ListaProveedoresRecord> {
  const ListaProveedoresRecordDocumentEquality();

  @override
  bool equals(ListaProveedoresRecord? e1, ListaProveedoresRecord? e2) {
    return e1?.empresa == e2?.empresa &&
        e1?.actividad == e2?.actividad &&
        e1?.logo == e2?.logo &&
        e1?.agencia == e2?.agencia;
  }

  @override
  int hash(ListaProveedoresRecord? e) => const ListEquality()
      .hash([e?.empresa, e?.actividad, e?.logo, e?.agencia]);

  @override
  bool isValidKey(Object? o) => o is ListaProveedoresRecord;
}
