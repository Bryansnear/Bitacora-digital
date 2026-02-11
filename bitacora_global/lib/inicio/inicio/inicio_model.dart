import '/models/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/inicio/inicio_administrador/inicio_administrador_widget.dart';
import '/inicio/inicio_guardia/inicio_guardia_widget.dart';
import '/inicio/inicio_jefe_seguridad/inicio_jefe_seguridad_widget.dart';
import '/inicio/side_nav02/side_nav02_widget.dart';
import '/index.dart';
import 'inicio_widget.dart' show InicioWidget;
import 'package:flutter/material.dart';

class InicioModel extends FlutterFlowModel<InicioWidget> {
  ///  State fields for stateful widgets in this page.

  // Reemplazando InstitucionesRecord por Institucion (Supabase)
  Institucion? insticucionActual;
  // Model for inicioGuardia component.
  late InicioGuardiaModel inicioGuardiaModel;
  // Model for inicioJefeSeguridad component.
  late InicioJefeSeguridadModel inicioJefeSeguridadModel;
  // Model for inicioAdministrador component.
  late InicioAdministradorModel inicioAdministradorModel;
  // Model for SideNav02 component.
  late SideNav02Model sideNav02Model;

  @override
  void initState(BuildContext context) {
    inicioGuardiaModel = createModel(context, () => InicioGuardiaModel());
    inicioJefeSeguridadModel =
        createModel(context, () => InicioJefeSeguridadModel());
    inicioAdministradorModel =
        createModel(context, () => InicioAdministradorModel());
    sideNav02Model = createModel(context, () => SideNav02Model());
  }

  @override
  void dispose() {
    inicioGuardiaModel.dispose();
    inicioJefeSeguridadModel.dispose();
    inicioAdministradorModel.dispose();
    sideNav02Model.dispose();
  }
}
