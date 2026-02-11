import '/flutter_flow/flutter_flow_util.dart';
import 'supervision_reporte_widget.dart' show SupervisionReporteWidget;
import 'package:flutter/material.dart';

class SupervisionReporteModel
    extends FlutterFlowModel<SupervisionReporteWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadDataO9h = false;
  FFUploadedFile uploadedLocalFile_uploadDataO9h =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataO9h = '';

  // State field(s) for reproteSupervision widget.
  FocusNode? reproteSupervisionFocusNode;
  TextEditingController? reproteSupervisionTextController;
  String? Function(BuildContext, String?)?
      reproteSupervisionTextControllerValidator;
  String? _reproteSupervisionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for nombreSupervisor widget.
  FocusNode? nombreSupervisorFocusNode;
  TextEditingController? nombreSupervisorTextController;
  String? Function(BuildContext, String?)?
      nombreSupervisorTextControllerValidator;
  String? _nombreSupervisorTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    reproteSupervisionTextControllerValidator =
        _reproteSupervisionTextControllerValidator;
    nombreSupervisorTextControllerValidator =
        _nombreSupervisorTextControllerValidator;
  }

  @override
  void dispose() {
    reproteSupervisionFocusNode?.dispose();
    reproteSupervisionTextController?.dispose();

    nombreSupervisorFocusNode?.dispose();
    nombreSupervisorTextController?.dispose();
  }
}
