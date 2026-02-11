import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sucursal_model.dart';
export 'sucursal_model.dart';

class SucursalWidget extends StatefulWidget {
  const SucursalWidget({super.key});

  static String routeName = 'Sucursal';
  static String routePath = 'sucursal';

  @override
  State<SucursalWidget> createState() => _SucursalWidgetState();
}

class _SucursalWidgetState extends State<SucursalWidget> {
  late SucursalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SucursalModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<InstitucionesRecord>>(
      stream: _model.sucursales(
        requestFn: () => queryInstitucionesRecord(),
      ),
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
        List<InstitucionesRecord> sucursalInstitucionesRecordList =
            snapshot.data!;

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
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.pop();
                  },
                ),
                actions: [],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Sucursales',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.newsreader(
                            fontWeight: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                          color: Color(0xF6D2950B),
                          fontSize: 22.0,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                  ),
                  centerTitle: true,
                  expandedTitleScale: 1.0,
                ),
                elevation: 2.0,
              ),
            ),
            body: SafeArea(
              top: true,
              child: Container(
                decoration: BoxDecoration(),
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (valueOrDefault(currentUserDocument?.rol, '') ==
                            'Administrador')
                          AuthUserStreamWidget(
                            builder: (context) => FlutterFlowDropDown<String>(
                              controller: _model.entidadValueController ??=
                                  FormFieldController<String>(
                                _model.entidadValue ??= '',
                              ),
                              options: List<String>.from(
                                  sucursalInstitucionesRecordList
                                      .map((e) => e.nombreInstitucion)
                                      .toList()),
                              optionLabels: sucursalInstitucionesRecordList
                                  .map((e) => e.nombreInstitucion)
                                  .toList(),
                              onChanged: (val) =>
                                  safeSetState(() => _model.entidadValue = val),
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: 50.0,
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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 2.0,
                              borderColor:
                                  FlutterFlowTheme.of(context).alternate,
                              borderWidth: 2.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 4.0, 16.0, 4.0),
                              hidesUnderline: true,
                              isOverButton: true,
                              isSearchable: false,
                              isMultiSelect: false,
                            ),
                          ),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: AuthUserStreamWidget(
                              builder: (context) =>
                                  StreamBuilder<List<InstitucionesRecord>>(
                                stream: queryInstitucionesRecord(
                                  queryBuilder: (institucionesRecord) =>
                                      institucionesRecord.where(
                                    'nombreInstitucion',
                                    isEqualTo: valueOrDefault<String>(
                                      valueOrDefault(currentUserDocument?.rol,
                                                  '') ==
                                              'Administrador'
                                          ? valueOrDefault<String>(
                                              _model.entidadValue,
                                              'Imbaya',
                                            )
                                          : valueOrDefault(
                                              currentUserDocument?.entidad, ''),
                                      'BDP',
                                    ),
                                  ),
                                  singleRecord: true,
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<InstitucionesRecord>
                                      listViewInstitucionesRecordList =
                                      snapshot.data!;
                                  if (listViewInstitucionesRecordList.isEmpty) {
                                    return Center(
                                      child: Image.asset(
                                        'assets/images/sinregistros.png',
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.2,
                                      ),
                                    );
                                  }
                                  final listViewInstitucionesRecord =
                                      listViewInstitucionesRecordList.isNotEmpty
                                          ? listViewInstitucionesRecordList
                                              .first
                                          : null;

                                  return Builder(
                                    builder: (context) {
                                      final sucursales =
                                          listViewInstitucionesRecord
                                                  ?.sucursales
                                                  .toList() ??
                                              [];
                                      if (sucursales.isEmpty) {
                                        return Center(
                                          child: Image.asset(
                                            'assets/images/sinregistros.png',
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.2,
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: sucursales.length,
                                        itemBuilder:
                                            (context, sucursalesIndex) {
                                          final sucursalesItem =
                                              sucursales[sucursalesIndex];
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (valueOrDefault(
                                                      currentUserDocument?.rol,
                                                      '') ==
                                                  'Administrador') {
                                                context.pushNamed(
                                                  BitacorasWidget.routeName,
                                                  queryParameters: {
                                                    'sucursalEscogida':
                                                        serializeParam(
                                                      sucursalesItem,
                                                      ParamType.DataStruct,
                                                    ),
                                                    'institucionRef':
                                                        serializeParam(
                                                      listViewInstitucionesRecord
                                                          ?.reference,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              } else {
                                                context.pushNamed(
                                                  BitacorasWidget.routeName,
                                                  queryParameters: {
                                                    'sucursalEscogida':
                                                        serializeParam(
                                                      sucursalesItem,
                                                      ParamType.DataStruct,
                                                    ),
                                                    'institucionRef':
                                                        serializeParam(
                                                      listViewInstitucionesRecord
                                                          ?.reference,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.network(
                                                        sucursalesItem.foto,
                                                        width: 100.0,
                                                        height: 100.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        sucursalesItem
                                                            .sucursalCiudad,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .newsreader(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      30.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
