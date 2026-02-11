import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/inicio/side_nav02/side_nav02_widget.dart';
import 'inicio_administrador_widget.dart' show InicioAdministradorWidget;
import 'package:flutter/material.dart';

class InicioAdministradorModel
    extends FlutterFlowModel<InicioAdministradorWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for SideNav02 component.
  late SideNav02Model sideNav02Model;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for PaginatedDataTable widget.
  final paginatedDataTableController =
      FlutterFlowDataTableController<SucursalStruct>();

  @override
  void initState(BuildContext context) {
    sideNav02Model = createModel(context, () => SideNav02Model());
  }

  @override
  void dispose() {
    sideNav02Model.dispose();
    paginatedDataTableController.dispose();
  }
}
