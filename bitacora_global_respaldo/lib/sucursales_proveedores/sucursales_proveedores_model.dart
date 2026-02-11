import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/request_manager.dart';

import 'sucursales_proveedores_widget.dart' show SucursalesProveedoresWidget;
import 'package:flutter/material.dart';

class SucursalesProveedoresModel
    extends FlutterFlowModel<SucursalesProveedoresWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for entidad widget.
  String? entidadValue;
  FormFieldController<String>? entidadValueController;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Checkbox widget.
  Map<UsersRecord, bool> checkboxValueMap = {};
  List<UsersRecord> get checkboxCheckedItems =>
      checkboxValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  /// Query cache managers for this widget.

  final _proveeManager = StreamRequestManager<List<ListaProveedoresRecord>>();
  Stream<List<ListaProveedoresRecord>> provee({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<ListaProveedoresRecord>> Function() requestFn,
  }) =>
      _proveeManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearProveeCache() => _proveeManager.clear();
  void clearProveeCacheKey(String? uniqueKey) =>
      _proveeManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();

    /// Dispose query cache managers for this widget.

    clearProveeCache();
  }
}
