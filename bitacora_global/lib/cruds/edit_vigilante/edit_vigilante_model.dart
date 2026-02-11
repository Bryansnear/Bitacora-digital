import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'edit_vigilante_widget.dart' show EditVigilanteWidget;
import 'package:flutter/material.dart';

class EditVigilanteModel extends FlutterFlowModel<EditVigilanteWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for nombreTxtEdit widget.
  FocusNode? nombreTxtEditFocusNode;
  TextEditingController? nombreTxtEditTextController;
  String? Function(BuildContext, String?)? nombreTxtEditTextControllerValidator;
  // State field(s) for cedulaTxt widget.
  FocusNode? cedulaTxtFocusNode;
  TextEditingController? cedulaTxtTextController;
  String? Function(BuildContext, String?)? cedulaTxtTextControllerValidator;
  // State field(s) for telefonoTxtEdit widget.
  FocusNode? telefonoTxtEditFocusNode;
  TextEditingController? telefonoTxtEditTextController;
  String? Function(BuildContext, String?)?
      telefonoTxtEditTextControllerValidator;
  // State field(s) for correoTxt widget.
  FocusNode? correoTxtFocusNode;
  TextEditingController? correoTxtTextController;
  String? Function(BuildContext, String?)? correoTxtTextControllerValidator;
  bool isDataUploading_uploadDataEditUser = false;
  FFUploadedFile uploadedLocalFile_uploadDataEditUser =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataEditUser = '';

  // State field(s) for rolEdit widget.
  String? rolEditValue;
  FormFieldController<String>? rolEditValueController;
  // State field(s) for entidadEdit widget.
  String? entidadEditValue;
  FormFieldController<String>? entidadEditValueController;
  // State field(s) for agenciaEdit widget.
  String? agenciaEditValue;
  FormFieldController<String>? agenciaEditValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombreTxtEditFocusNode?.dispose();
    nombreTxtEditTextController?.dispose();

    cedulaTxtFocusNode?.dispose();
    cedulaTxtTextController?.dispose();

    telefonoTxtEditFocusNode?.dispose();
    telefonoTxtEditTextController?.dispose();

    correoTxtFocusNode?.dispose();
    correoTxtTextController?.dispose();
  }
}
