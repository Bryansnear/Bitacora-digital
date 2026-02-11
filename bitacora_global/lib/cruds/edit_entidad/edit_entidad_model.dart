import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'edit_entidad_widget.dart' show EditEntidadWidget;
import 'package:flutter/material.dart';

class EditEntidadModel extends FlutterFlowModel<EditEntidadWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadDataJpd = false;
  FFUploadedFile uploadedLocalFile_uploadDataJpd =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for entidad widget.
  String? entidadValue;
  FormFieldController<String>? entidadValueController;
  // State field(s) for empresa widget.
  FocusNode? empresaFocusNode1;
  TextEditingController? empresaTextController1;
  String? Function(BuildContext, String?)? empresaTextController1Validator;
  // State field(s) for empresa widget.
  FocusNode? empresaFocusNode2;
  TextEditingController? empresaTextController2;
  String? Function(BuildContext, String?)? empresaTextController2Validator;
  // State field(s) for agencia widget.
  FocusNode? agenciaFocusNode;
  TextEditingController? agenciaTextController;
  String? Function(BuildContext, String?)? agenciaTextControllerValidator;
  // State field(s) for ubicacion widget.
  FocusNode? ubicacionFocusNode;
  TextEditingController? ubicacionTextController;
  String? Function(BuildContext, String?)? ubicacionTextControllerValidator;
  // State field(s) for actividad widget.
  FocusNode? actividadFocusNode;
  TextEditingController? actividadTextController;
  String? Function(BuildContext, String?)? actividadTextControllerValidator;
  bool isDataUploading_imagenEntidadEditada = false;
  FFUploadedFile uploadedLocalFile_imagenEntidadEditada =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_imagenEntidadEditada = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    empresaFocusNode1?.dispose();
    empresaTextController1?.dispose();

    empresaFocusNode2?.dispose();
    empresaTextController2?.dispose();

    agenciaFocusNode?.dispose();
    agenciaTextController?.dispose();

    ubicacionFocusNode?.dispose();
    ubicacionTextController?.dispose();

    actividadFocusNode?.dispose();
    actividadTextController?.dispose();
  }
}
