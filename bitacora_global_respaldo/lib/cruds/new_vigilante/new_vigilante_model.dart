import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'new_vigilante_widget.dart' show NewVigilanteWidget;
import 'package:flutter/material.dart';

class NewVigilanteModel extends FlutterFlowModel<NewVigilanteWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for nombreTxt widget.
  FocusNode? nombreTxtFocusNode;
  TextEditingController? nombreTxtTextController;
  String? Function(BuildContext, String?)? nombreTxtTextControllerValidator;
  // State field(s) for cedulaTxt widget.
  FocusNode? cedulaTxtFocusNode;
  TextEditingController? cedulaTxtTextController;
  String? Function(BuildContext, String?)? cedulaTxtTextControllerValidator;
  // State field(s) for telefonoTxt widget.
  FocusNode? telefonoTxtFocusNode;
  TextEditingController? telefonoTxtTextController;
  String? Function(BuildContext, String?)? telefonoTxtTextControllerValidator;
  // State field(s) for correoTxt widget.
  FocusNode? correoTxtFocusNode;
  TextEditingController? correoTxtTextController;
  String? Function(BuildContext, String?)? correoTxtTextControllerValidator;
  bool isDataUploading_uploadData8r6 = false;
  FFUploadedFile uploadedLocalFile_uploadData8r6 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadData8r6 = '';

  // State field(s) for rol widget.
  String? rolValue;
  FormFieldController<String>? rolValueController;
  // State field(s) for entidad widget.
  String? entidadValue;
  FormFieldController<String>? entidadValueController;
  // State field(s) for agencia widget.
  String? agenciaValue;
  FormFieldController<String>? agenciaValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreTxtFocusNode?.dispose();
    nombreTxtTextController?.dispose();

    cedulaTxtFocusNode?.dispose();
    cedulaTxtTextController?.dispose();

    telefonoTxtFocusNode?.dispose();
    telefonoTxtTextController?.dispose();

    correoTxtFocusNode?.dispose();
    correoTxtTextController?.dispose();
  }
}
