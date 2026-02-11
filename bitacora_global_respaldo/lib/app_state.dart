import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _fotoNovedad = prefs.getString('ff_fotoNovedad') ?? _fotoNovedad;
    });
    _safeInit(() {
      _bitacoraRefTempPersistente =
          prefs.getString('ff_bitacoraRefTempPersistente')?.ref ??
              _bitacoraRefTempPersistente;
    });
    _safeInit(() {
      _visitas = prefs
              .getStringList('ff_visitas')
              ?.map((x) {
                try {
                  return VisitasStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _visitas;
    });
    _safeInit(() {
      _vehiculos = prefs
              .getStringList('ff_vehiculos')
              ?.map((x) {
                try {
                  return VehiculosStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _vehiculos;
    });
    _safeInit(() {
      _novedades = prefs
              .getStringList('ff_novedades')
              ?.map((x) {
                try {
                  return NovedadesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _novedades;
    });
    _safeInit(() {
      _supervisado = prefs.getBool('ff_supervisado') ?? _supervisado;
    });
    _safeInit(() {
      _llegado = prefs.getBool('ff_llegado') ?? _llegado;
    });
    _safeInit(() {
      _aperturaparcial =
          prefs.getBool('ff_aperturaparcial') ?? _aperturaparcial;
    });
    _safeInit(() {
      _proveedores = prefs
              .getStringList('ff_proveedores')
              ?.map((x) {
                try {
                  return ProveedoresStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _proveedores;
    });
    _safeInit(() {
      _salidaParcial = prefs.getBool('ff_salidaParcial') ?? _salidaParcial;
    });
    _safeInit(() {
      _salidaTotal = prefs.getBool('ff_salidaTotal') ?? _salidaTotal;
    });
    _safeInit(() {
      _location0 =
          latLngFromString(prefs.getString('ff_location0')) ?? _location0;
    });
    _safeInit(() {
      _punto1 = latLngFromString(prefs.getString('ff_punto1')) ?? _punto1;
    });
    _safeInit(() {
      _aperturaTotal = prefs.getBool('ff_aperturaTotal') ?? _aperturaTotal;
    });
    _safeInit(() {
      _indexSucursal = prefs.getInt('ff_indexSucursal') ?? _indexSucursal;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _fotoVisita = '';
  String get fotoVisita => _fotoVisita;
  set fotoVisita(String value) {
    _fotoVisita = value;
  }

  String _fotoProveedor = '';
  String get fotoProveedor => _fotoProveedor;
  set fotoProveedor(String value) {
    _fotoProveedor = value;
  }

  String _fotoVehiculo = '';
  String get fotoVehiculo => _fotoVehiculo;
  set fotoVehiculo(String value) {
    _fotoVehiculo = value;
  }

  String _fotoNovedad = '';
  String get fotoNovedad => _fotoNovedad;
  set fotoNovedad(String value) {
    _fotoNovedad = value;
    prefs.setString('ff_fotoNovedad', value);
  }

  DocumentReference? _bitacoraRefTempPersistente;
  DocumentReference? get bitacoraRefTempPersistente =>
      _bitacoraRefTempPersistente;
  set bitacoraRefTempPersistente(DocumentReference? value) {
    _bitacoraRefTempPersistente = value;
    value != null
        ? prefs.setString('ff_bitacoraRefTempPersistente', value.path)
        : prefs.remove('ff_bitacoraRefTempPersistente');
  }

  List<VisitasStruct> _visitas = [];
  List<VisitasStruct> get visitas => _visitas;
  set visitas(List<VisitasStruct> value) {
    _visitas = value;
    prefs.setStringList('ff_visitas', value.map((x) => x.serialize()).toList());
  }

  void addToVisitas(VisitasStruct value) {
    visitas.add(value);
    prefs.setStringList(
        'ff_visitas', _visitas.map((x) => x.serialize()).toList());
  }

  void removeFromVisitas(VisitasStruct value) {
    visitas.remove(value);
    prefs.setStringList(
        'ff_visitas', _visitas.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromVisitas(int index) {
    visitas.removeAt(index);
    prefs.setStringList(
        'ff_visitas', _visitas.map((x) => x.serialize()).toList());
  }

  void updateVisitasAtIndex(
    int index,
    VisitasStruct Function(VisitasStruct) updateFn,
  ) {
    visitas[index] = updateFn(_visitas[index]);
    prefs.setStringList(
        'ff_visitas', _visitas.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInVisitas(int index, VisitasStruct value) {
    visitas.insert(index, value);
    prefs.setStringList(
        'ff_visitas', _visitas.map((x) => x.serialize()).toList());
  }

  List<VehiculosStruct> _vehiculos = [];
  List<VehiculosStruct> get vehiculos => _vehiculos;
  set vehiculos(List<VehiculosStruct> value) {
    _vehiculos = value;
    prefs.setStringList(
        'ff_vehiculos', value.map((x) => x.serialize()).toList());
  }

  void addToVehiculos(VehiculosStruct value) {
    vehiculos.add(value);
    prefs.setStringList(
        'ff_vehiculos', _vehiculos.map((x) => x.serialize()).toList());
  }

  void removeFromVehiculos(VehiculosStruct value) {
    vehiculos.remove(value);
    prefs.setStringList(
        'ff_vehiculos', _vehiculos.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromVehiculos(int index) {
    vehiculos.removeAt(index);
    prefs.setStringList(
        'ff_vehiculos', _vehiculos.map((x) => x.serialize()).toList());
  }

  void updateVehiculosAtIndex(
    int index,
    VehiculosStruct Function(VehiculosStruct) updateFn,
  ) {
    vehiculos[index] = updateFn(_vehiculos[index]);
    prefs.setStringList(
        'ff_vehiculos', _vehiculos.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInVehiculos(int index, VehiculosStruct value) {
    vehiculos.insert(index, value);
    prefs.setStringList(
        'ff_vehiculos', _vehiculos.map((x) => x.serialize()).toList());
  }

  List<NovedadesStruct> _novedades = [];
  List<NovedadesStruct> get novedades => _novedades;
  set novedades(List<NovedadesStruct> value) {
    _novedades = value;
    prefs.setStringList(
        'ff_novedades', value.map((x) => x.serialize()).toList());
  }

  void addToNovedades(NovedadesStruct value) {
    novedades.add(value);
    prefs.setStringList(
        'ff_novedades', _novedades.map((x) => x.serialize()).toList());
  }

  void removeFromNovedades(NovedadesStruct value) {
    novedades.remove(value);
    prefs.setStringList(
        'ff_novedades', _novedades.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromNovedades(int index) {
    novedades.removeAt(index);
    prefs.setStringList(
        'ff_novedades', _novedades.map((x) => x.serialize()).toList());
  }

  void updateNovedadesAtIndex(
    int index,
    NovedadesStruct Function(NovedadesStruct) updateFn,
  ) {
    novedades[index] = updateFn(_novedades[index]);
    prefs.setStringList(
        'ff_novedades', _novedades.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInNovedades(int index, NovedadesStruct value) {
    novedades.insert(index, value);
    prefs.setStringList(
        'ff_novedades', _novedades.map((x) => x.serialize()).toList());
  }

  bool _supervisado = false;
  bool get supervisado => _supervisado;
  set supervisado(bool value) {
    _supervisado = value;
    prefs.setBool('ff_supervisado', value);
  }

  bool _llegado = true;
  bool get llegado => _llegado;
  set llegado(bool value) {
    _llegado = value;
    prefs.setBool('ff_llegado', value);
  }

  bool _aperturaparcial = true;
  bool get aperturaparcial => _aperturaparcial;
  set aperturaparcial(bool value) {
    _aperturaparcial = value;
    prefs.setBool('ff_aperturaparcial', value);
  }

  List<ProveedoresStruct> _proveedores = [];
  List<ProveedoresStruct> get proveedores => _proveedores;
  set proveedores(List<ProveedoresStruct> value) {
    _proveedores = value;
    prefs.setStringList(
        'ff_proveedores', value.map((x) => x.serialize()).toList());
  }

  void addToProveedores(ProveedoresStruct value) {
    proveedores.add(value);
    prefs.setStringList(
        'ff_proveedores', _proveedores.map((x) => x.serialize()).toList());
  }

  void removeFromProveedores(ProveedoresStruct value) {
    proveedores.remove(value);
    prefs.setStringList(
        'ff_proveedores', _proveedores.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromProveedores(int index) {
    proveedores.removeAt(index);
    prefs.setStringList(
        'ff_proveedores', _proveedores.map((x) => x.serialize()).toList());
  }

  void updateProveedoresAtIndex(
    int index,
    ProveedoresStruct Function(ProveedoresStruct) updateFn,
  ) {
    proveedores[index] = updateFn(_proveedores[index]);
    prefs.setStringList(
        'ff_proveedores', _proveedores.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInProveedores(int index, ProveedoresStruct value) {
    proveedores.insert(index, value);
    prefs.setStringList(
        'ff_proveedores', _proveedores.map((x) => x.serialize()).toList());
  }

  bool _salidaParcial = true;
  bool get salidaParcial => _salidaParcial;
  set salidaParcial(bool value) {
    _salidaParcial = value;
    prefs.setBool('ff_salidaParcial', value);
  }

  bool _salidaTotal = true;
  bool get salidaTotal => _salidaTotal;
  set salidaTotal(bool value) {
    _salidaTotal = value;
    prefs.setBool('ff_salidaTotal', value);
  }

  LatLng? _location0 = LatLng(0, 0);
  LatLng? get location0 => _location0;
  set location0(LatLng? value) {
    _location0 = value;
    value != null
        ? prefs.setString('ff_location0', value.serialize())
        : prefs.remove('ff_location0');
  }

  LatLng? _punto1 = LatLng(0, 0);
  LatLng? get punto1 => _punto1;
  set punto1(LatLng? value) {
    _punto1 = value;
    value != null
        ? prefs.setString('ff_punto1', value.serialize())
        : prefs.remove('ff_punto1');
  }

  bool _aperturaTotal = true;
  bool get aperturaTotal => _aperturaTotal;
  set aperturaTotal(bool value) {
    _aperturaTotal = value;
    prefs.setBool('ff_aperturaTotal', value);
  }

  bool _visitasDropList = false;
  bool get visitasDropList => _visitasDropList;
  set visitasDropList(bool value) {
    _visitasDropList = value;
  }

  bool _varflotante = false;
  bool get varflotante => _varflotante;
  set varflotante(bool value) {
    _varflotante = value;
  }

  bool _vehiculosDropList = false;
  bool get vehiculosDropList => _vehiculosDropList;
  set vehiculosDropList(bool value) {
    _vehiculosDropList = value;
  }

  bool _novedadesDropList = false;
  bool get novedadesDropList => _novedadesDropList;
  set novedadesDropList(bool value) {
    _novedadesDropList = value;
  }

  bool _proveedoresDropList = false;
  bool get proveedoresDropList => _proveedoresDropList;
  set proveedoresDropList(bool value) {
    _proveedoresDropList = value;
  }

  SucursalStruct _sucursal = SucursalStruct();
  SucursalStruct get sucursal => _sucursal;
  set sucursal(SucursalStruct value) {
    _sucursal = value;
  }

  void updateSucursalStruct(Function(SucursalStruct) updateFn) {
    updateFn(_sucursal);
  }

  List<SucursalStruct> _copiaSucursales = [];
  List<SucursalStruct> get copiaSucursales => _copiaSucursales;
  set copiaSucursales(List<SucursalStruct> value) {
    _copiaSucursales = value;
  }

  void addToCopiaSucursales(SucursalStruct value) {
    copiaSucursales.add(value);
  }

  void removeFromCopiaSucursales(SucursalStruct value) {
    copiaSucursales.remove(value);
  }

  void removeAtIndexFromCopiaSucursales(int index) {
    copiaSucursales.removeAt(index);
  }

  void updateCopiaSucursalesAtIndex(
    int index,
    SucursalStruct Function(SucursalStruct) updateFn,
  ) {
    copiaSucursales[index] = updateFn(_copiaSucursales[index]);
  }

  void insertAtIndexInCopiaSucursales(int index, SucursalStruct value) {
    copiaSucursales.insert(index, value);
  }

  int _indexSucursal = 0;
  int get indexSucursal => _indexSucursal;
  set indexSucursal(int value) {
    _indexSucursal = value;
    prefs.setInt('ff_indexSucursal', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
