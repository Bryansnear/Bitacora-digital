import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_data_table.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/inicio/side_nav02/side_nav02_widget.dart';
import 'inicio_jefe_seguridad_widget.dart' show InicioJefeSeguridadWidget;
import 'package:flutter/material.dart';

class InicioJefeSeguridadModel
    extends FlutterFlowModel<InicioJefeSeguridadWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for SideNav02 component.
  late SideNav02Model sideNav02Model;
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
