import '/auth/supabase_auth/auth_util.dart';
import '/core/supabase_config.dart';
import '/services/bitacora_service.dart';
import '/models/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/inicio/inicio_administrador/inicio_administrador_widget.dart';
import '/inicio/inicio_guardia/inicio_guardia_widget.dart';
import '/inicio/inicio_jefe_seguridad/inicio_jefe_seguridad_widget.dart';
import '/inicio/side_nav02/side_nav02_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'inicio_model.dart';
export 'inicio_model.dart';

class InicioWidget extends StatefulWidget {
  const InicioWidget({super.key});

  static String routeName = 'Inicio';
  static String routePath = 'inicio';

  @override
  State<InicioWidget> createState() => _InicioWidgetState();
}

class _InicioWidgetState extends State<InicioWidget>
    with TickerProviderStateMixin {
  late InicioModel _model;
  final BitacoraService _bitacoraService = BitacoraService();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InicioModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final authController = context.read<AuthController>();
      final profile = authController.userProfile;

      if (profile != null && profile.instituciones.isNotEmpty) {
        // Obtenemos las instituciones del usuario de Supabase
        final instituciones = await _bitacoraService.getInstitucionesUsuario();
        _model.insticucionActual = instituciones.firstOrNull;

        if (_model.insticucionActual != null) {
          // Obtenemos sucursales de la institución
          _bitacoraService
              .streamSucursales(_model.insticucionActual!.id)
              .first
              .then((sucursales) {
            // Buscamos la sucursal que coincide con la agencia del usuario (manteniendo lógica original)
            // Nota: En Supabase deberíamos tener una relación más directa, pero por ahora emulamos:
            final userAgencia =
                profile.cedula; // O el campo que mapee a agencia

            // Por ahora, solo tomamos la primera sucursal para que no explote
            final sucursal = sucursales.firstOrNull;
            if (sucursal != null) {
              FFAppState().sucursal = SucursalStruct(
                id: sucursal.id,
                nombre: sucursal.nombre,
                estado: sucursal.estado,
                bitacoraActual: sucursal.bitacoraActualId,
                vigilanteActual: sucursal.vigilanteActualId,
                foto: sucursal.foto,
                latitud: sucursal.latitud,
                longitud: sucursal.longitud,
                ubicacion: sucursal.hasLocation
                    ? LatLng(sucursal.latitud!, sucursal.longitud!)
                    : null,
                horaEstado: sucursal.horaEstado,
              );
              FFAppState().bitacoraRefTempPersistente =
                  sucursal.bitacoraActualId;
            }
            safeSetState(() {});
          });
        }
      }
      safeSetState(() {});
    });

    animationsMap.addAll({
      'sideNav02OnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(300.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'sideNav02OnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 0.0),
            end: Offset(400.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final profile = AuthController().userProfile;

    return StreamBuilder<List<Institucion>>(
      stream: _bitacoraService.streamInstituciones(),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<Institucion> inicioInstitucionesList = snapshot.data!;
        // Filtramos por las que el usuario tenga asignadas
        final inicioInstitucion = inicioInstitucionesList.firstWhereOrNull(
                (inst) => profile?.instituciones.contains(inst.id) ?? false) ??
            (inicioInstitucionesList.isNotEmpty
                ? inicioInstitucionesList.first
                : null);

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.85,
                            height: MediaQuery.sizeOf(context).height * 0.08,
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 10.0, 16.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context
                                          .pushNamed(ProfileWidget.routeName);
                                    },
                                    child: Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Image.network(
                                          currentUserPhoto,
                                          width: 60.0,
                                          height: 60.0,
                                          fit: BoxFit.scaleDown,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            'assets/images/error_image.png',
                                            width: 60.0,
                                            height: 60.0,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            FFAppState()
                                                    .bitacoraRefTempPersistente =
                                                null;
                                            FFAppState().llegado = true;
                                            FFAppState().aperturaparcial = true;
                                            FFAppState().aperturaTotal = true;
                                            FFAppState().visitas = [];
                                            FFAppState().vehiculos = [];
                                            FFAppState().novedades = [];
                                            FFAppState().proveedores = [];
                                            FFAppState().update(() {});

                                            // TODO: Migrar funciones de búsqueda de index para Supabase IDs

                                            FFAppState()
                                                    .bitacoraRefTempPersistente =
                                                null;
                                            FFAppState().updateSucursalStruct(
                                              (e) => e
                                                ..bitacoraActual = null
                                                ..vigilanteActual = null,
                                            );
                                            safeSetState(() {});

                                            context.goNamed(
                                                InicioWidget.routeName);
                                          },
                                          child: Text(
                                            currentUserDisplayName,
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  font: GoogleFonts.newsreader(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            profile?.rol ?? '',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.newsreader(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (responsiveVisibility(
                            context: context,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  Icons.menu,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  FFAppState().varflotante = true;
                                  safeSetState(() {});
                                },
                              ),
                            ),
                        ],
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: MediaQuery.sizeOf(context).height * 0.9,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Builder(
                                builder: (context) {
                                  if (profile?.isVigilante ?? false) {
                                    return wrapWithModel(
                                      model: _model.inicioGuardiaModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: InicioGuardiaWidget(
                                        institucionId: inicioInstitucion?.id,
                                      ),
                                    );
                                  } else if (profile?.isJefeSeguridad ??
                                      false) {
                                    return Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: wrapWithModel(
                                        model: _model.inicioJefeSeguridadModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: InicioJefeSeguridadWidget(),
                                      ),
                                    );
                                  } else {
                                    return wrapWithModel(
                                      model: _model.inicioAdministradorModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: InicioAdministradorWidget(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (FFAppState().varflotante == true)
                    wrapWithModel(
                      model: _model.sideNav02Model,
                      updateCallback: () => safeSetState(() {}),
                      child: SideNav02Widget(),
                    )
                        .animateOnPageLoad(
                            animationsMap['sideNav02OnPageLoadAnimation']!)
                        .animateOnActionTrigger(
                          animationsMap['sideNav02OnActionTriggerAnimation']!,
                        ),
                  Opacity(
                    opacity: 0.5,
                    child: Align(
                      alignment: AlignmentDirectional(-1.0, 1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 0.0, 20.0),
                        child: Text(
                          'v.0.6.0',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.newsreader(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
