import '/flutter_flow/flutter_flow_util.dart';
import 'edit_proveedores_widget.dart' show EditProveedoresWidget;
import 'package:flutter/material.dart';

class EditProveedoresModel extends FlutterFlowModel<EditProveedoresWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for empresa widget.
  FocusNode? empresaFocusNode;
  TextEditingController? empresaTextController;
  String? Function(BuildContext, String?)? empresaTextControllerValidator;
  // State field(s) for actividad widget.
  FocusNode? actividadFocusNode;
  TextEditingController? actividadTextController;
  String? Function(BuildContext, String?)? actividadTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    empresaFocusNode?.dispose();
    empresaTextController?.dispose();

    actividadFocusNode?.dispose();
    actividadTextController?.dispose();
  }
}
