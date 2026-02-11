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

// D// NO REMUEVAS NI MODIFIQUES EL CÓDIGO DE ARRIBA

Future editarSucursal(
  String sucursalId,
  String nombreInstitucion, // String no-null
  String? ciudad,
  String? ubicacion, // esperado "lat,lng"
  String? estado,
  DateTime? hora,
  List<String>? eventos,
  DocumentReference? bitacoraActual,
) async {
  try {
    // 1) Buscar institución por nombre
    final institucionesRef =
        FirebaseFirestore.instance.collection('Instituciones');
    final query = await institucionesRef
        .where('nombreInstitucion', isEqualTo: nombreInstitucion)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      print('No se encontró la institución');
      return;
    }

    final entidadDoc = query.docs.first;
    final entidadRef = entidadDoc.reference;

    // 2) Obtener lista de sucursales de forma segura
    final data = entidadDoc.data() as Map<String, dynamic>;
    final List<dynamic> sucursalesRaw =
        (data['sucursales'] as List<dynamic>?) ?? <dynamic>[];

    final List<Map<String, dynamic>> sucursales =
        sucursalesRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    // 3) Ubicar la sucursal: intenta por 'sucursalId' o por 'sucursalCiudad' (fallback)
    final index = sucursales.indexWhere((s) {
      final id = s['sucursalId']?.toString();
      final city = s['sucursalCiudad']?.toString();
      return id == sucursalId || city == sucursalId;
    });

    if (index == -1) {
      print('No se encontró la sucursal en la institución dada');
      return;
    }

    final sucursal = Map<String, dynamic>.from(sucursales[index]);

    // 4) Actualizaciones opcionales
    if (ciudad != null) {
      sucursal['sucursalCiudad'] = ciudad;
    }

    if (ubicacion != null) {
      final partes = ubicacion.split(',');
      if (partes.length == 2) {
        final lat = double.tryParse(partes[0].trim());
        final lng = double.tryParse(partes[1].trim());
        if (lat != null && lng != null) {
          // Mantengo el mismo esquema (string). Si usas GeoPoint, cambia aquí.
          sucursal['ubicacion'] = GeoPoint(lat, lng);
        } else {
          print('Coordenadas no son números válidos');
        }
      } else {
        print('Formato de coordenadas inválido (usa "lat,lng")');
      }
    }

    if (estado != null) sucursal['Estado'] = estado;
    if (hora != null) sucursal['horaEstado'] = hora;
    if (eventos != null) sucursal['listaEventos'] = eventos;

    if (bitacoraActual == null) {
      sucursal['bitacoraActual'] = bitacoraActual;
    } // ← esta llave faltaba

    // 5) Persistir cambios
    sucursales[index] = sucursal;
    await entidadRef.update({'sucursales': sucursales});
    print(['Sucursal editada bien', ubicacion]);
  } catch (e /*, stack*/) {
    print('Error al editar la sucursal: $e');
    // print(stack); // si quieres ver el stack completo
  }
}
