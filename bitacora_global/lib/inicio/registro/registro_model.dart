import '/flutter_flow/flutter_flow_util.dart';
import 'registro_widget.dart' show RegistroWidget;
import 'package:flutter/material.dart';

class RegistroModel extends FlutterFlowModel<RegistroWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadDataR6g = false;
  FFUploadedFile uploadedLocalFile_uploadDataR6g =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameTextController;
  String? Function(BuildContext, String?)? yourNameTextControllerValidator;
  String? _yourNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Nombre y Apellido is required';
    }

    return null;
  }

  // State field(s) for cedula widget.
  FocusNode? cedulaFocusNode;
  TextEditingController? cedulaTextController;
  String? Function(BuildContext, String?)? cedulaTextControllerValidator;
  String? _cedulaTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Numero de cédula is required';
    }

    return null;
  }

  // State field(s) for Proveedor widget.
  FocusNode? proveedorFocusNode;
  TextEditingController? proveedorTextController;
  String? Function(BuildContext, String?)? proveedorTextControllerValidator;
  // State field(s) for placa widget.
  FocusNode? placaFocusNode;
  TextEditingController? placaTextController;
  String? Function(BuildContext, String?)? placaTextControllerValidator;
  String? _placaTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Placa del vehiculo is required';
    }

    return null;
  }

  // State field(s) for pertenencias widget.
  FocusNode? pertenenciasFocusNode;
  TextEditingController? pertenenciasTextController;
  String? Function(BuildContext, String?)? pertenenciasTextControllerValidator;
  String? _pertenenciasTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Pertenencias is required';
    }

    return null;
  }

  // State field(s) for motivo widget.
  FocusNode? motivoFocusNode;
  TextEditingController? motivoTextController;
  String? Function(BuildContext, String?)? motivoTextControllerValidator;
  String? _motivoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Motivo de visita is required';
    }

    return null;
  }

  bool isDataUploading_uploadDataR7g = false;
  FFUploadedFile uploadedLocalFile_uploadDataR7g =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataR7g = '';

  @override
  void initState(BuildContext context) {
    yourNameTextControllerValidator = _yourNameTextControllerValidator;
    cedulaTextControllerValidator = _cedulaTextControllerValidator;
    placaTextControllerValidator = _placaTextControllerValidator;
    pertenenciasTextControllerValidator = _pertenenciasTextControllerValidator;
    motivoTextControllerValidator = _motivoTextControllerValidator;
  }

  @override
  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameTextController?.dispose();

    cedulaFocusNode?.dispose();
    cedulaTextController?.dispose();

    proveedorFocusNode?.dispose();
    proveedorTextController?.dispose();

    placaFocusNode?.dispose();
    placaTextController?.dispose();

    pertenenciasFocusNode?.dispose();
    pertenenciasTextController?.dispose();

    motivoFocusNode?.dispose();
    motivoTextController?.dispose();
  }
}
