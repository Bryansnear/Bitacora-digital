import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'edit_agencia_widget.dart' show EditAgenciaWidget;
import 'package:flutter/material.dart';

class EditAgenciaModel extends FlutterFlowModel<EditAgenciaWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for agencia widget.
  FocusNode? agenciaFocusNode;
  TextEditingController? agenciaTextController;
  String? Function(BuildContext, String?)? agenciaTextControllerValidator;
  // State field(s) for ubicacion widget.
  FocusNode? ubicacionFocusNode;
  TextEditingController? ubicacionTextController;
  String? Function(BuildContext, String?)? ubicacionTextControllerValidator;
  // State field(s) for CheckboxListTile widget.
  Map<EventosBitacora, bool> checkboxListTileValueMap = {};
  List<EventosBitacora> get checkboxListTileCheckedItems =>
      checkboxListTileValueMap.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    agenciaFocusNode?.dispose();
    agenciaTextController?.dispose();

    ubicacionFocusNode?.dispose();
    ubicacionTextController?.dispose();
  }
}
