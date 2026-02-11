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

import 'package:geolocator/geolocator.dart';

Future<String> distanciaentredospuntos(
  LatLng puntomio,
  LatLng puntocliente,
) async {
  double distancia = await Geolocator.distanceBetween(
    puntocliente.latitude,
    puntocliente.longitude,
    puntomio.latitude,
    puntomio.longitude,
  );
  String cadenaDistancia = distancia.toStringAsFixed(1);

  return "estas a: " + cadenaDistancia + "metros de distancia del punto.";
  // Add your function code here!
}
