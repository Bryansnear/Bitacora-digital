import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'inicio_guardia_widget.dart' show InicioGuardiaWidget;
import 'package:flutter/material.dart';

class InicioGuardiaModel extends FlutterFlowModel<InicioGuardiaWidget> {
  ///  Local state fields for this component.

  BitacoraRecord? bitacoraActual;

  LatLng? ubicacionSucursal;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Read Document] action in inicioGuardia widget.
  BitacoraRecord? bitacoraLeida;
  // State field(s) for TabBar widget.
  TabController? tabBarController1;
  int get tabBarCurrentIndex1 =>
      tabBarController1 != null ? tabBarController1!.index : 0;
  int get tabBarPreviousIndex1 =>
      tabBarController1 != null ? tabBarController1!.previousIndex : 0;

  // Stores action output result for [Custom Action - calcularDistancia] action in Button widget.
  bool? dist;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  BitacoraRecord? refBit1;
  // Stores action output result for [Custom Action - distanciaentredospuntos] action in Button widget.
  String? distancia;
  // State field(s) for TabBar widget.
  TabController? tabBarController2;
  int get tabBarCurrentIndex2 =>
      tabBarController2 != null ? tabBarController2!.index : 0;
  int get tabBarPreviousIndex2 =>
      tabBarController2 != null ? tabBarController2!.previousIndex : 0;

  // Stores action output result for [Custom Action - calcularDistancia] action in Container widget.
  bool? dist2;
  // Stores action output result for [Custom Action - distanciaentredospuntos] action in Container widget.
  String? distanciaDelPunto2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController1?.dispose();
    tabBarController2?.dispose();
  }
}
