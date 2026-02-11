import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/data/structs.dart';

bool verificarRangoHora(DateTime hora) {
  bool estadoRes;
  if (hora.hour > 18 && hora.minute >= 01 && hora.hour < 19) {
    estadoRes = true;
  } else {
    estadoRes = false;
  }
  return estadoRes;
}

String? ramdoStringID() {
  // Create a function that generates a random string of 20 characters between numbers and upper and lower case letters that each time it is generated the same string is never repeated.
  String generateRandomString() {
    final random = math.Random();
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    return String.fromCharCodes(Iterable.generate(
        20, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  final Set<String> usedStrings = {};

  String? generateUniqueRandomString() {
    String? newString;
    do {
      newString = generateRandomString();
    } while (usedStrings.contains(newString));
    usedStrings.add(newString);
    return newString;
  }

  return generateUniqueRandomString();
}

LatLng stringtoLatLang(String cordenadasLatLng) {
  try {
    final parts = cordenadasLatLng.split(',');
    if (parts.length != 2) return const LatLng(0, 0);

    final double? lat = double.tryParse(parts[0].trim());
    final double? lng = double.tryParse(parts[1].trim());

    if (lat == null || lng == null) return const LatLng(0, 0);
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180)
      return const LatLng(0, 0);

    return LatLng(lat, lng);
  } catch (e) {
    print(e);
    return const LatLng(0, 0);
  }
}

int? buscarIndex(
  String ciudad,
  List<SucursalStruct> listaSucursales,
) {
  // crea una funcion que devuelva el index del item dentro de la lista dada y que coincida con la ciudad dada
  for (int i = 0; i < listaSucursales.length; i++) {
    if (listaSucursales[i].sucursalCiudad == ciudad) {
      return i;
    }
  }
  return null;
}

String? latLangtoString(String? latLang) {
  // convierte un string del tipo "LatLng(lat: -0.21178029577287338, lng: -87.48356376251559" y pasalo a un string del tipo: "-0.21178029577287338, -87.48356376251559"
  if (latLang == null) {
    return null;
  }

  final regex = RegExp(r'LatLng\(lat: (.*), lng: (.*)\)');
  final match = regex.firstMatch(latLang);
  if (match != null && match.groupCount == 2) {
    final lat = match.group(1);
    final lng = match.group(2);
    if (lat != null && lng != null) {
      return '$lat, $lng';
    }
  }

  return null;
}
