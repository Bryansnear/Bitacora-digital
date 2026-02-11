import '/flutter_flow/flutter_flow_util.dart';
import 'novedad_widget.dart' show NovedadWidget;
import 'package:flutter/material.dart';

class NovedadModel extends FlutterFlowModel<NovedadWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_fotoNovedad = false;
  FFUploadedFile uploadedLocalFile_fotoNovedad =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for novedades widget.
  FocusNode? novedadesFocusNode;
  TextEditingController? novedadesTextController;
  String? Function(BuildContext, String?)? novedadesTextControllerValidator;
  bool isDataUploading_fotoNovedadCajero = false;
  FFUploadedFile uploadedLocalFile_fotoNovedadCajero =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_fotoNovedadCajero = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    novedadesFocusNode?.dispose();
    novedadesTextController?.dispose();
  }
}
