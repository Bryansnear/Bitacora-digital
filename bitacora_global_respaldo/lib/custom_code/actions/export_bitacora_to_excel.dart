// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:universal_html/html.dart' as html; // web download
import 'package:universal_io/io.dart' show File; // mobile/desktop file
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;

String _fmtTime(DateTime? dt) =>
    dt == null ? '' : DateFormat('HH:mm').format(dt);
String _fmtDateTime(DateTime? dt) =>
    dt == null ? '' : DateFormat('d/M/y HH:mm').format(dt);
String _fmtDate(DateTime? dt) =>
    dt == null ? '' : DateFormat('d/M/y').format(dt);
Future<String?> exportBitacoraToExcel(
  BuildContext context,
  List<DocumentReference>? rows,
  DateTime? fechaFiltro,
) async {
// 0) Normalizar y validar input
  final refs = rows ?? const <DocumentReference>[];
  if (refs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No hay referencias para exportar')),
    );
    return null;
  }

  // 1) Resolver refs -> BitacoraRecord
  final futures = refs.map((ref) async {
    try {
      try {
        final rec = await BitacoraRecord.getDocumentOnce(ref);
        if (rec != null) return rec;
      } catch (_) {}
      final snap = await ref.get();
      if (!snap.exists) return null;
      return BitacoraRecord.fromSnapshot(snap);
    } catch (_) {
      return null;
    }
  }).toList();

  final resolved = await Future.wait(futures);
  final items = resolved.whereType<BitacoraRecord>().toList();
  if (items.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No hay registros para exportar')),
    );
    return null;
  }

  // 2) Crear libro y hoja
  final excel = Excel.createExcel();
  final sheet = excel['Bitacora'];
  final defaultSheet = excel.getDefaultSheet();
  if (defaultSheet != null && defaultSheet != 'Bitacora') {
    excel.delete(defaultSheet);
  }

  // 3) Encabezados
  final headers = <String>[
    'Fecha',
    'Sucursal',
    'Vigilante',
    'Llegada',
    'Apertura Parcial',
    'Apertura Total',
    'Llegada cajeros',
    'Atención al público operativos',
    'Atención publico cajeros',
    'Cierre Parcial',
    'Cierre total',
    'Salida',
    'Estado',
  ];
  sheet.appendRow(headers.map<CellValue?>((h) => TextCellValue(h)).toList());

  // 3.1) Rango de filtro por fecha (día completo)
  final target = fechaFiltro ?? DateTime.now();
  final start = DateTime(target.year, target.month, target.day);
  final end = start.add(const Duration(days: 1));

  // 4) Filas (solo las que caen en el día filtrado)
  var filasAgregadas = 0;
  for (final item in items) {
    final dt = item.fechayhoraApertura;
    if (dt == null) continue;

    final dentroDeLaFecha = !dt.isBefore(start) && dt.isBefore(end);
    if (!dentroDeLaFecha) continue;

    final estado = (item.horaSalidaVigilante == null) ? 'Abierto' : 'Cerrado';
    sheet.appendRow(<CellValue?>[
      TextCellValue(_fmtDate(item.horaLlegadaVigilante)),
      TextCellValue(item.sucursal ?? ''),
      TextCellValue(item.vigilanteApertura ?? ''),
      TextCellValue(_fmtTime(item.horaLlegadaVigilante)),
      TextCellValue(_fmtTime(item.fechayhoraApertura)),
      TextCellValue(_fmtTime(item.horaAperturaTotal)),
      TextCellValue(_fmtTime(item.horaLlegadaCajeros)),
      TextCellValue(_fmtTime(item.horaLlegadaOficinas)),
      TextCellValue(_fmtTime(item.horaAtencionPublicoCajeros)),
      TextCellValue(_fmtTime(item.fechayhoraCierre)),
      TextCellValue(_fmtTime(item.horaCierreTotal)),
      TextCellValue(_fmtTime(item.horaSalidaVigilante)),
      TextCellValue(estado),
    ]);
    filasAgregadas++;
  }

  if (filasAgregadas == 0) {
    final labelDia = DateFormat('d/M/y').format(start);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No hay registros para la fecha $labelDia')),
    );
  }

  // 5) Codificar
  final bytes = excel.encode();
  if (bytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo generar el Excel')),
    );
    return null;
  }
  final data = Uint8List.fromList(bytes);

  // 6) Guardar / Descargar
  final fileName =
      'bitacora_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

  if (kIsWeb) {
    final blob = html.Blob(
      [data],
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Descargando $fileName...')),
    );
    return null;
  } else {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$fileName';
    final file = File(path);
    await file.writeAsBytes(data, flush: true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Archivo guardado en: $path')),
    );
    return path;
  }
}
