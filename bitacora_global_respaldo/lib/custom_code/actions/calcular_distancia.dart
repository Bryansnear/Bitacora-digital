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

Future<bool> calcularDistancia(
  LatLng puntoCliente,
  LatLng punto2,
) async {
  // calculate the distance in meters between 2 points LatLng
  double distancia = await Geolocator.distanceBetween(
    puntoCliente.latitude,
    puntoCliente.longitude,
    punto2.latitude,
    punto2.longitude,
  );

  if (distancia < 60) {
    return true;
  } else {
    return false;
  }
}
