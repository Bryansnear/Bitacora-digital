import '/flutter_flow/flutter_flow_util.dart';
import 'cierretotal_widget.dart' show CierretotalWidget;
import 'package:flutter/material.dart';

class CierretotalModel extends FlutterFlowModel<CierretotalWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for encargadoAlarmado widget.
  FocusNode? encargadoAlarmadoFocusNode;
  TextEditingController? encargadoAlarmadoTextController;
  String? Function(BuildContext, String?)?
      encargadoAlarmadoTextControllerValidator;
  String? _encargadoAlarmadoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for encargadoLlaves widget.
  FocusNode? encargadoLlavesFocusNode;
  TextEditingController? encargadoLlavesTextController;
  String? Function(BuildContext, String?)?
      encargadoLlavesTextControllerValidator;
  String? _encargadoLlavesTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for noveda widget.
  FocusNode? novedaFocusNode;
  TextEditingController? novedaTextController;
  String? Function(BuildContext, String?)? novedaTextControllerValidator;

  @override
  void initState(BuildContext context) {
    encargadoAlarmadoTextControllerValidator =
        _encargadoAlarmadoTextControllerValidator;
    encargadoLlavesTextControllerValidator =
        _encargadoLlavesTextControllerValidator;
  }

  @override
  void dispose() {
    encargadoAlarmadoFocusNode?.dispose();
    encargadoAlarmadoTextController?.dispose();

    encargadoLlavesFocusNode?.dispose();
    encargadoLlavesTextController?.dispose();

    novedaFocusNode?.dispose();
    novedaTextController?.dispose();
  }
}
