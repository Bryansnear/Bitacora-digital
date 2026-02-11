import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/inicio/side_nav02/side_nav02_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart'; // Ya no se usa
import 'bitacoras_model.dart';
export 'bitacoras_model.dart';

import '/services/bitacora_service.dart';
import '/models/sucursal.dart';
import '/models/bitacora.dart';
import '/pages/bit_complet/bit_complet_widget.dart'; // Para navegación

class BitacorasWidget extends StatefulWidget {
  const BitacorasWidget({
    super.key,
    required this.sucursalEscogida,
  });

  final Sucursal? sucursalEscogida;

  static String routeName = 'bitacoras';
  static String routePath = 'bitacoras';

  @override
  State<BitacorasWidget> createState() => _BitacorasWidgetState();
}

class _BitacorasWidgetState extends State<BitacorasWidget> {
  late BitacorasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BitacorasModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          '${widget.sucursalEscogida?.nombre ?? "Sucursal"} - Bitacoras',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.newsreader(fontWeight: FontWeight.w700),
                color: Color(0xF6D2950B),
                fontSize: 22.0,
              ),
        ),
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (responsiveVisibility(
                    context: context,
                    phone: false,
                    tablet: false,
                  ))
                    wrapWithModel(
                      model: _model.sideNav02Model,
                      updateCallback: () => safeSetState(() {}),
                      child: SideNav02Widget(),
                    ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Lista de Bitacoras',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.newsreader(),
                                  fontSize: 40.0,
                                ),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.sizeOf(context).width *
                                  (responsiveVisibility(
                                          context: context, phone: true)
                                      ? 1.0
                                      : 0.7),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 12.0),
                                child: StreamBuilder<List<Bitacora>>(
                                    stream: widget.sucursalEscogida?.id != null
                                        ? BitacoraService().streamBitacoras(
                                            widget.sucursalEscogida!.id!)
                                        : Stream.value([]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                          child: Image.asset(
                                            'assets/images/sinregistros.png',
                                            height: 200,
                                          ),
                                        );
                                      }

                                      final bitacoras = snapshot.data!;

                                      return ListView.builder(
                                          itemCount: bitacoras.length,
                                          itemBuilder: (context, index) {
                                            final bitacora = bitacoras[index];
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 12.0, 16.0, 16.0),
                                              child: InkWell(
                                                onTap: () async {
                                                  context.pushNamed(
                                                    BitCompletWidget.routeName,
                                                    queryParameters: {
                                                      'bitacoraId': bitacora.id,
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 12.0,
                                                          color:
                                                              Color(0x34000000),
                                                          offset:
                                                              Offset(-2.0, 5.0))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Info Izquierda: Fecha y Vigilante
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              dateTimeFormat(
                                                                  "d/M/y",
                                                                  bitacora.fechaHoraApertura ??
                                                                      DateTime
                                                                          .now(),
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode),
                                                              style: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .bodyMedium
                                                                  .override(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(children: [
                                                              Icon(Icons.person,
                                                                  color: Colors
                                                                      .grey),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  bitacora.vigilanteApertura ??
                                                                      "Vigilante",
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium)
                                                            ]),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              "${dateTimeFormat("jm", bitacora.fechaHoraApertura, locale: FFLocalizations.of(context).languageCode)} / ${bitacora.fechaHoraCierre != null ? dateTimeFormat("jm", bitacora.fechaHoraCierre, locale: FFLocalizations.of(context).languageCode) : '...'}",
                                                              style: FlutterFlowTheme
                                                                      .of(
                                                                          context)
                                                                  .headlineSmall
                                                                  .override(
                                                                      fontSize:
                                                                          18,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent1),
                                                            ),
                                                          ],
                                                        ),

                                                        // Info Derecha: Contadores
                                                        Column(
                                                          children: [
                                                            Text("Visitas",
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall),
                                                            Text(
                                                                "${bitacora.visitas.length}",
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall), // NOTA: Esto solo funcionará si el stream trae visitas con join, si no será 0. Por ahora 0 es aceptable o se requeriría count query.
                                                            Icon(
                                                                Icons
                                                                    .manage_accounts,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 20),
                                                            Text(
                                                                bitacora.supervision
                                                                        .isNotEmpty
                                                                    ? (bitacora.supervision[
                                                                            'hora_supervision'] ??
                                                                        '')
                                                                    : '--:--',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
