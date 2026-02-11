import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/bitacora.dart';
import '../models/sucursal.dart';
import '../models/institucion.dart';
import '../services/bitacora_service.dart';

/// Provider para manejar el estado de la bitácora activa y datos relacionados.
/// Usa Supabase Realtime para que los cambios se reflejen automáticamente.
class BitacoraProvider extends ChangeNotifier {
  final BitacoraService _service = BitacoraService();

  // Suscripción Realtime
  StreamSubscription<Bitacora?>? _bitacoraSubscription;

  // Estado actual
  Institucion? _institucionActual;
  Sucursal? _sucursalActual;
  Bitacora? _bitacoraActiva;
  bool _isLoading = false;
  String? _error;

  // Getters
  Institucion? get institucionActual => _institucionActual;
  Sucursal? get sucursalActual => _sucursalActual;
  Bitacora? get bitacoraActiva => _bitacoraActiva;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get tieneBitacoraActiva => _bitacoraActiva != null;

  /// Seleccionar institución
  void setInstitucion(Institucion institucion) {
    _institucionActual = institucion;
    _sucursalActual = null;
    _cancelSubscription();
    _bitacoraActiva = null;
    notifyListeners();
  }

  /// Seleccionar sucursal y suscribirse al stream de la bitácora activa
  Future<void> setSucursal(Sucursal sucursal) async {
    _sucursalActual = sucursal;
    _cancelSubscription();
    _isLoading = true;
    notifyListeners();

    try {
      if (sucursal.bitacoraActualId != null) {
        // Suscribirse al stream Realtime de la bitácora
        _bitacoraSubscription = _service
            .streamBitacora(sucursal.bitacoraActualId!)
            .listen(
          (bitacora) {
            _bitacoraActiva = bitacora;
            _isLoading = false;
            _error = null;
            notifyListeners();
          },
          onError: (e) {
            _error = 'Error en stream de bitácora: $e';
            _isLoading = false;
            notifyListeners();
          },
        );
      } else {
        _bitacoraActiva = null;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error cargando bitácora: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Suscribirse a una bitácora específica por ID (usado después de crear una nueva)
  void subscribeToBitacora(String bitacoraId) {
    _cancelSubscription();
    _bitacoraSubscription = _service
        .streamBitacora(bitacoraId)
        .listen(
      (bitacora) {
        _bitacoraActiva = bitacora;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Error en stream de bitácora: $e';
        notifyListeners();
      },
    );
  }

  /// Iniciar turno (llegada del vigilante)
  Future<bool> iniciarTurno(String vigilanteId) async {
    if (_institucionActual == null || _sucursalActual == null) {
      _error = 'Debe seleccionar institución y sucursal';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _bitacoraActiva = await _service.llegadaVigilante(
        institucionId: _institucionActual!.id,
        sucursalId: _sucursalActual!.id,
        vigilanteId: vigilanteId,
      );

      // Suscribirse al stream de la nueva bitácora para actualizaciones en tiempo real
      if (_bitacoraActiva?.id != null) {
        subscribeToBitacora(_bitacoraActiva!.id!);
      }

      _isLoading = false;
      notifyListeners();
      return _bitacoraActiva != null;
    } catch (e) {
      _error = 'Error iniciando turno: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Finalizar turno (salida del vigilante)
  Future<bool> finalizarTurno() async {
    if (_bitacoraActiva == null || _sucursalActual == null) {
      _error = 'No hay bitácora activa';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _service.salidaVigilante(
        bitacoraId: _bitacoraActiva!.id!,
        sucursalId: _sucursalActual!.id,
      );

      _cancelSubscription();
      _bitacoraActiva = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error finalizando turno: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Recargar bitácora activa (ahora es un no-op, el stream se encarga).
  /// Se mantiene por compatibilidad pero no necesita hacer nada.
  Future<void> recargarBitacora() async {
    // No hace falta recargar manualmente, el stream Realtime
    // se encarga de mantener _bitacoraActiva actualizada.
  }

  void _cancelSubscription() {
    _bitacoraSubscription?.cancel();
    _bitacoraSubscription = null;
  }

  /// Limpiar estado
  void reset() {
    _cancelSubscription();
    _institucionActual = null;
    _sucursalActual = null;
    _bitacoraActiva = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelSubscription();
    super.dispose();
  }
}
