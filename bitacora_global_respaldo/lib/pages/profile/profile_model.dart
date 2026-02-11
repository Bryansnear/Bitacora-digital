import '/backend/custom_cloud_functions/custom_cloud_function_response_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Cloud Function - limpiarSucursalesManualmente] action in Button widget.
  LimpiarSucursalesManualmenteCloudFunctionCallResponse? cloudFunction4uq;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
