import '/flutter_flow/flutter_flow_util.dart';
import 'cierre_p_arcial_widget.dart' show CierrePArcialWidget;
import 'package:flutter/material.dart';

class CierrePArcialModel extends FlutterFlowModel<CierrePArcialWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for noveda widget.
  FocusNode? novedaFocusNode;
  TextEditingController? novedaTextController;
  String? Function(BuildContext, String?)? novedaTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    novedaFocusNode?.dispose();
    novedaTextController?.dispose();
  }
}
