import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vistanovedades_model.dart';
export 'vistanovedades_model.dart';

import '/services/bitacora_service.dart';
import '/models/institucion.dart';
import '/models/sucursal.dart';
import '/models/bitacora.dart';
import '/models/novedad.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VistanovedadesWidget extends StatefulWidget {
  const VistanovedadesWidget({super.key});

  static String routeName = 'vistanovedades';
  static String routePath = 'vistanovedades';

  @override
  State<VistanovedadesWidget> createState() => _VistanovedadesWidgetState();
}

class _VistanovedadesWidgetState extends State<VistanovedadesWidget>
    with TickerProviderStateMixin {
  late VistanovedadesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  // Cache para bitacora activa de la sucursal seleccionada (ya no se usa para fetch manual)
  // Se mantiene streamBitacoras para obtener actualización en tiempo real

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VistanovedadesModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: Offset(50.0, 0.0),
            end: Offset(0.0, 0.0),
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
    // Usamos StreamBuilder para cargar instituciones
    return StreamBuilder<List<Institucion>>(
      stream: BitacoraService().streamInstituciones(),
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
        List<Institucion> institucionesList = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                automaticallyImplyLeading: false,
                actions: [],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Novedades',
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          font: GoogleFonts.newsreader(
                            fontWeight: FlutterFlowTheme.of(context)
                                .displaySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .displaySmall
                                .fontStyle,
                          ),
                          fontSize: 30.0,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .displaySmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .displaySmall
                              .fontStyle,
                        ),
                  ),
                  centerTitle: false,
                  expandedTitleScale: 1.0,
                ),
                elevation: 2.0,
              ),
            ),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Selector de Institución y Agencia
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 0.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.entidadValueController ??=
                                FormFieldController<String>(
                              _model.entidadValue ??= null,
                            ),
                            options: institucionesList
                                .map((e) => e.id)
                                .toList(), // Valor es ID
                            optionLabels: institucionesList
                                .map((e) => e.nombre)
                                .toList(), // Label es Nombre
                            onChanged: (val) {
                              safeSetState(() {
                                _model.entidadValue = val;
                                _model.agenciaValue = null; // Reiniciar agencia
                                _model.agenciaValueController?.value = null;
                                _bitacoraSeleccionada =
                                    null; // Reiniciar bitacora
                              });
                            },
                            width: 300.0,
                            height: 56.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
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
                            hintText: 'Elija la entidad',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderWidth: 2.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                16.0, 4.0, 16.0, 4.0),
                            hidesUnderline: true,
                            disabled: false,
                            isOverButton: true,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ),
                      ),

                      // Dropdown de Agencias (Sucursales)
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 0.0),
                          child: _model.entidadValue != null
                              ? StreamBuilder<List<Sucursal>>(
                                  stream: BitacoraService()
                                      .streamSucursales(_model.entidadValue!),
                                  builder: (context, snapshotSuc) {
                                    if (!snapshotSuc.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final sucursales = snapshotSuc.data!;

                                    return FlutterFlowDropDown<String>(
                                      controller:
                                          _model.agenciaValueController ??=
                                              FormFieldController<String>(null),
                                      options: sucursales
                                          .map((e) => e.id)
                                          .toList(), // ID
                                      optionLabels: sucursales
                                          .map((e) => e.nombre)
                                          .toList(), // Nombre
                                      onChanged: (val) {
                                        safeSetState(
                                            () => _model.agenciaValue = val);
                                      },
                                      width: 300.0,
                                      height: 56.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      hintText: 'Elija la agencia',
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      elevation: 2.0,
                                      borderColor: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderWidth: 2.0,
                                      borderRadius: 8.0,
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 4.0, 16.0, 4.0),
                                      hidesUnderline: true,
                                      isOverButton: true,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24),
                                    );
                                  })
                              : Container(),
                        ),
                      ),
                    ],
                  ),

                  // Lista de Novedades
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Visibility(
                        visible: _model.agenciaValue != null,
                        child: StreamBuilder<List<Bitacora>>(
                            stream: _model.agenciaValue != null
                                ? BitacoraService()
                                    .streamBitacoras(_model.agenciaValue!)
                                : const Stream.empty(),
                            builder: (context, snapshotBit) {
                              if (snapshotBit.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              final bitacoras = snapshotBit.data ?? [];
                              final bitacoraSeleccionada =
                                  bitacoras.isNotEmpty ? bitacoras.first : null;

                              if (bitacoraSeleccionada == null) {
                                return Center(
                                    child: Text(_model.agenciaValue != null
                                        ? "No se encontró bitácora activa"
                                        : "Seleccione agencia"));
                              }

                              return StreamBuilder<List<Novedad>>(
                                    stream: BitacoraService().streamNovedades(
                                        bitacoraSeleccionada.id!),
                                    builder: (context, snapshotNov) {
                                      if (snapshotNov.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      final novedades = snapshotNov.data ?? [];

                                      if (novedades.isEmpty) {
                                        return Center(
                                            child: Text("Sin novedades"));
                                      }

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: novedades.length,
                                        itemBuilder: (context, novedadesIndex) {
                                          final novedadesItem =
                                              novedades[novedadesIndex];
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 12.0, 16.0, 12.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 4.0,
                                                    color: Color(0x230E151B),
                                                    offset: Offset(0.0, 2.0),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Stack(
                                                children: [
                                                  // Imagen
                                                  InkWell(
                                                    onTap: () async {
                                                      await Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child:
                                                              FlutterFlowExpandedImageView(
                                                            image:
                                                                Image.network(
                                                              valueOrDefault<
                                                                  String>(
                                                                novedadesItem
                                                                    .foto,
                                                                'https://cdn.pixabay.com/photo/2023/07/30/15/23/hand-8159118_1280.png',
                                                              ),
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            allowRotation:
                                                                false,
                                                            tag: valueOrDefault<
                                                                String>(
                                                              novedadesItem
                                                                  .foto,
                                                              'img-$novedadesIndex',
                                                            ),
                                                            useHeroAnimation:
                                                                true,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Hero(
                                                      tag: valueOrDefault<
                                                          String>(
                                                        novedadesItem.foto,
                                                        'img-$novedadesIndex',
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12.0),
                                                        ),
                                                        child: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            novedadesItem.foto,
                                                            'https://cdn.pixabay.com/photo/2023/07/30/15/23/hand-8159118_1280.png',
                                                          ),
                                                          width: 120.0,
                                                          height: 100.0,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // Texto Descripcion y Hora
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(130.0,
                                                                0.0, 12.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            novedadesItem
                                                                .descripcion,
                                                            'sin novedad',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyLarge
                                                              .override(
                                                                font: GoogleFonts.readexPro(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                color: Color(
                                                                    0xFF14181B),
                                                                fontSize: 16.0,
                                                              ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                      4.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              dateTimeFormat(
                                                                "relative",
                                                                novedadesItem
                                                                    .hora,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              '00:00',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                                'containerOnPageLoadAnimation']!),
                                          );
                                        },
                                      );
                                    });
                            }),
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
