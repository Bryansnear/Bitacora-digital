/// Structs base limpios - Sin dependencias de Firebase
/// Usados para estado local y persistencia en SharedPreferences
library;

import 'dart:convert';
import '/flutter_flow/flutter_flow_util.dart';

/// Clase base para todos los structs
abstract class BaseStruct {
  Map<String, dynamic> toSerializableMap();
  String serialize() => json.encode(toSerializableMap());
}

/// Struct para visitas
class VisitasStruct extends BaseStruct {
  VisitasStruct({
    this.nombre,
    this.motivo,
    this.pertenencias,
    this.horaEntrada,
    this.horaSalida,
    this.foto,
    this.cedula,
  });

  String? nombre;
  String? motivo;
  String? pertenencias;
  DateTime? horaEntrada;
  DateTime? horaSalida;
  String? foto;
  String? cedula;

  static VisitasStruct fromSerializableMap(Map<String, dynamic> data) =>
      VisitasStruct(
        nombre: data['nombre'] as String?,
        motivo: data['motivo'] as String?,
        pertenencias: data['pertenencias'] as String?,
        horaEntrada: data['horaEntrada'] != null
            ? DateTime.tryParse(data['horaEntrada'].toString())
            : null,
        horaSalida: data['horaSalida'] != null
            ? DateTime.tryParse(data['horaSalida'].toString())
            : null,
        foto: data['foto'] as String?,
        cedula: data['cedula'] as String?,
      );

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nombre': nombre,
        'motivo': motivo,
        'pertenencias': pertenencias,
        'horaEntrada': horaEntrada?.toIso8601String(),
        'horaSalida': horaSalida?.toIso8601String(),
        'foto': foto,
        'cedula': cedula,
      };
}

/// Struct para vehículos
class VehiculosStruct extends BaseStruct {
  VehiculosStruct({
    this.placa,
    this.marca,
    this.modelo,
    this.color,
    this.tipoVehiculo,
    this.horaEntrada,
    this.horaSalida,
    this.foto,
    this.observaciones,
  });

  String? placa;
  String? marca;
  String? modelo;
  String? color;
  String? tipoVehiculo;
  DateTime? horaEntrada;
  DateTime? horaSalida;
  String? foto;
  String? observaciones;

  static VehiculosStruct fromSerializableMap(Map<String, dynamic> data) =>
      VehiculosStruct(
        placa: data['placa'] as String?,
        marca: data['marca'] as String?,
        modelo: data['modelo'] as String?,
        color: data['color'] as String?,
        tipoVehiculo: data['tipoVehiculo'] as String?,
        horaEntrada: data['horaEntrada'] != null
            ? DateTime.tryParse(data['horaEntrada'].toString())
            : null,
        horaSalida: data['horaSalida'] != null
            ? DateTime.tryParse(data['horaSalida'].toString())
            : null,
        foto: data['foto'] as String?,
        observaciones: data['observaciones'] as String?,
      );

  @override
  Map<String, dynamic> toSerializableMap() => {
        'placa': placa,
        'marca': marca,
        'modelo': modelo,
        'color': color,
        'tipoVehiculo': tipoVehiculo,
        'horaEntrada': horaEntrada?.toIso8601String(),
        'horaSalida': horaSalida?.toIso8601String(),
        'foto': foto,
        'observaciones': observaciones,
      };
}

/// Struct para novedades
class NovedadesStruct extends BaseStruct {
  NovedadesStruct({
    this.titulo,
    this.descripcion,
    this.foto,
    this.fecha,
    this.tipoNovedad,
  });

  String? titulo;
  String? descripcion;
  String? foto;
  DateTime? fecha;
  String? tipoNovedad;

  static NovedadesStruct fromSerializableMap(Map<String, dynamic> data) =>
      NovedadesStruct(
        titulo: data['titulo'] as String?,
        descripcion: data['descripcion'] as String?,
        foto: data['foto'] as String?,
        fecha: data['fecha'] != null
            ? DateTime.tryParse(data['fecha'].toString())
            : null,
        tipoNovedad: data['tipoNovedad'] as String?,
      );

  @override
  Map<String, dynamic> toSerializableMap() => {
        'titulo': titulo,
        'descripcion': descripcion,
        'foto': foto,
        'fecha': fecha?.toIso8601String(),
        'tipoNovedad': tipoNovedad,
      };
}

/// Struct para proveedores
class ProveedoresStruct extends BaseStruct {
  ProveedoresStruct({
    this.nombre,
    this.empresa,
    this.cedula,
    this.motivo,
    this.horaEntrada,
    this.horaSalida,
    this.foto,
    this.autorizado,
  });

  String? nombre;
  String? empresa;
  String? cedula;
  String? motivo;
  DateTime? horaEntrada;
  DateTime? horaSalida;
  String? foto;
  bool? autorizado;

  static ProveedoresStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProveedoresStruct(
        nombre: data['nombre'] as String?,
        empresa: data['empresa'] as String?,
        cedula: data['cedula'] as String?,
        motivo: data['motivo'] as String?,
        horaEntrada: data['horaEntrada'] != null
            ? DateTime.tryParse(data['horaEntrada'].toString())
            : null,
        horaSalida: data['horaSalida'] != null
            ? DateTime.tryParse(data['horaSalida'].toString())
            : null,
        foto: data['foto'] as String?,
        autorizado: data['autorizado'] as bool?,
      );

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nombre': nombre,
        'empresa': empresa,
        'cedula': cedula,
        'motivo': motivo,
        'horaEntrada': horaEntrada?.toIso8601String(),
        'horaSalida': horaSalida?.toIso8601String(),
        'foto': foto,
        'autorizado': autorizado,
      };
}

/// Struct para sucursal (Compatible con FlutterFlow original pero sin Firebase)
class SucursalStruct extends BaseStruct {
  SucursalStruct({
    this.id,
    this.nombre,
    this.direccion,
    this.latitud,
    this.longitud,
    this.estado,
    this.radio,
    this.sucursalCiudad,
    this.foto,
    this.ubicacion,
    this.bitacoraActual,
    this.vigilanteActual,
    this.listaEventos = const [],
    this.idSucursal = 0,
    this.proveedores = const [],
    this.horaEstado,
  });

  String? id;
  String? nombre;
  String? direccion;
  double? latitud;
  double? longitud;
  String? estado;
  double? radio;
  String? sucursalCiudad;
  String? foto;
  LatLng? ubicacion;
  String? bitacoraActual; // Antes DocumentReference
  String? vigilanteActual; // Antes DocumentReference
  List<String> listaEventos;
  int idSucursal;
  List<String> proveedores;
  DateTime? horaEstado;

  static SucursalStruct fromSerializableMap(Map<String, dynamic> data) =>
      SucursalStruct(
        id: data['id'] as String?,
        nombre: data['nombre'] as String?,
        direccion: data['direccion'] as String?,
        latitud: (data['latitud'] as num?)?.toDouble(),
        longitud: (data['longitud'] as num?)?.toDouble(),
        estado: data['Estado'] as String? ?? data['estado'] as String?,
        radio: (data['radio'] as num?)?.toDouble(),
        sucursalCiudad: data['sucursalCiudad'] as String?,
        foto: data['foto'] as String?,
        ubicacion: data['ubicacion'] != null
            ? latLngFromString(data['ubicacion'].toString())
            : null,
        bitacoraActual: data['bitacoraActual'] as String?,
        vigilanteActual: data['vigilanteActual'] as String?,
        listaEventos: data['listaEventos'] is List
            ? List<String>.from(data['listaEventos'])
            : [],
        idSucursal: data['idSucursal'] as int? ?? 0,
        proveedores: data['proveedores'] is List
            ? List<String>.from(data['proveedores'])
            : [],
        horaEstado: data['horaEstado'] != null
            ? DateTime.tryParse(data['horaEstado'].toString())
            : null,
      );

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': id,
        'nombre': nombre,
        'direccion': direccion,
        'latitud': latitud,
        'longitud': longitud,
        'Estado': estado,
        'radio': radio,
        'sucursalCiudad': sucursalCiudad,
        'foto': foto,
        'ubicacion': ubicacion?.serialize(),
        'bitacoraActual': bitacoraActual,
        'vigilanteActual': vigilanteActual,
        'listaEventos': listaEventos,
        'idSucursal': idSucursal,
        'proveedores': proveedores,
        'horaEstado': horaEstado?.toIso8601String(),
      };
}

/// Struct para ATM
class AtmStruct extends BaseStruct {
  AtmStruct({
    this.nombre,
    this.ubicacion,
    this.estado,
    this.ultimaRevision,
  });

  String? nombre;
  String? ubicacion;
  String? estado;
  DateTime? ultimaRevision;

  static AtmStruct fromSerializableMap(Map<String, dynamic> data) => AtmStruct(
        nombre: data['nombre'] as String?,
        ubicacion: data['ubicacion'] as String?,
        estado: data['estado'] as String?,
        ultimaRevision: data['ultimaRevision'] != null
            ? DateTime.tryParse(data['ultimaRevision'].toString())
            : null,
      );

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nombre': nombre,
        'ubicacion': ubicacion,
        'estado': estado,
        'ultimaRevision': ultimaRevision?.toIso8601String(),
      };
}

/// Struct para Relevo
class RelevoStruct extends BaseStruct {
  RelevoStruct({
    this.vigilanteEntrante,
    this.vigilanteSaliente,
    this.fechaHora,
    this.observaciones,
  });

  String? vigilanteEntrante;
  String? vigilanteSaliente;
  DateTime? fechaHora;
  String? observaciones;

  static RelevoStruct fromSerializableMap(Map<String, dynamic> data) =>
      RelevoStruct(
        vigilanteEntrante: data['vigilanteEntrante'] as String?,
        vigilanteSaliente: data['vigilanteSaliente'] as String?,
        fechaHora: data['fechaHora'] != null
            ? DateTime.tryParse(data['fechaHora'].toString())
            : null,
        observaciones: data['observaciones'] as String?,
      );

  @override
  Map<String, dynamic> toSerializableMap() => {
        'vigilanteEntrante': vigilanteEntrante,
        'vigilanteSaliente': vigilanteSaliente,
        'fechaHora': fechaHora?.toIso8601String(),
        'observaciones': observaciones,
      };
}

/// Struct para Supervisión
class SupervisionStruct extends BaseStruct {
  SupervisionStruct({
    this.supervisorId,
    this.fechaHora,
    this.novedadesEncontradas,
    this.firma,
  });

  String? supervisorId;
  DateTime? fechaHora;
  String? novedadesEncontradas;
  String? firma;

  static SupervisionStruct fromSerializableMap(Map<String, dynamic> data) =>
      SupervisionStruct(
        supervisorId: data['supervisorId'] as String?,
        fechaHora: data['fechaHora'] != null
            ? DateTime.tryParse(data['fechaHora'].toString())
            : null,
        novedadesEncontradas: data['novedadesEncontradas'] as String?,
        firma: data['firma'] as String?,
      );

  @override
  Map<String, dynamic> toSerializableMap() => {
        'supervisorId': supervisorId,
        'fechaHora': fechaHora?.toIso8601String(),
        'novedadesEncontradas': novedadesEncontradas,
        'firma': firma,
      };
}
