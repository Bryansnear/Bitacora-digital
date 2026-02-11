import '/flutter_flow/flutter_flow_util.dart';
import 'apertura_parcial_widget.dart' show AperturaParcialWidget;
import 'package:flutter/material.dart';

class AperturaParcialModel extends FlutterFlowModel<AperturaParcialWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for encargadoDesalarmado widget.
  FocusNode? encargadoDesalarmadoFocusNode;
  TextEditingController? encargadoDesalarmadoTextController;
  String? Function(BuildContext, String?)?
      encargadoDesalarmadoTextControllerValidator;
  String? _encargadoDesalarmadoTextControllerValidator(
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

  bool isDataUploading_uploadDataM98 = false;
  FFUploadedFile uploadedLocalFile_uploadDataM98 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for noveda widget.
  FocusNode? novedaFocusNode;
  TextEditingController? novedaTextController;
  String? Function(BuildContext, String?)? novedaTextControllerValidator;
  bool isDataUploading_fotoapertura = false;
  FFUploadedFile uploadedLocalFile_fotoapertura =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_fotoapertura = '';

  @override
  void initState(BuildContext context) {
    encargadoDesalarmadoTextControllerValidator =
        _encargadoDesalarmadoTextControllerValidator;
    encargadoLlavesTextControllerValidator =
        _encargadoLlavesTextControllerValidator;
  }

  @override
  void dispose() {
    encargadoDesalarmadoFocusNode?.dispose();
    encargadoDesalarmadoTextController?.dispose();

    encargadoLlavesFocusNode?.dispose();
    encargadoLlavesTextController?.dispose();

    novedaFocusNode?.dispose();
    novedaTextController?.dispose();
  }
}
