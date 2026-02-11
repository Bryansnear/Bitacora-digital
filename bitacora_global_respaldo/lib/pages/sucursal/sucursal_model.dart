import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'sucursal_widget.dart' show SucursalWidget;
import 'package:flutter/material.dart';

class SucursalModel extends FlutterFlowModel<SucursalWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for entidad widget.
  String? entidadValue;
  FormFieldController<String>? entidadValueController;

  /// Query cache managers for this widget.

  final _sucursalesManager = StreamRequestManager<List<InstitucionesRecord>>();
  Stream<List<InstitucionesRecord>> sucursales({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<InstitucionesRecord>> Function() requestFn,
  }) =>
      _sucursalesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearSucursalesCache() => _sucursalesManager.clear();
  void clearSucursalesCacheKey(String? uniqueKey) =>
      _sucursalesManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    /// Dispose query cache managers for this widget.

    clearSucursalesCache();
  }
}
