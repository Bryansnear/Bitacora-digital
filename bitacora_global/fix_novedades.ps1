$path = "c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\pages\bit_complet\bit_complet_widget.dart"
$lines = Get-Content $path

# Rango a reemplazar: Builder de Novedades
# Inicio: child: Builder( (alrededor de 3406)
# Fin: Cierre de Builder (alrededor de 3665)
# Buscamos el inicio exacto
$startLine = 0
$endLine = 0

for ($i = 3400; $i -lt 3420; $i++) {
    if ($lines[$i] -match "child: Builder\(") {
        $startLine = $i
        break
    }
}

if ($startLine -eq 0) {
    Write-Host "No se encontró el inicio del bloque Builder."
    exit
}

# Buscamos el final (el cierre del Builder antes del cierre del Padding/Visibility)
# Sabemos que está identado.
# Vamos a buscar el cierre basado en la estructura de llaves, o hardcodear si confiamos en los números
# Como los números pueden haber variado levemente, mejor buscar el cierre del ListView y sus wrappers.
# El bloque termina con "}, ); }, ), ), ), )," sequence.
# Vamos a usar un enfoque de conteo de llaves o buscar el cierre del Visibility parent.

# Reemplazo seguro: desde $startLine hasta $startLine + 260 aprox
# Busquemos el cierre del Padding padre del Builder.
# El Padding abre en $startLine - 3 (aprox).

# Mejor estrategia: Encontrar las líneas exactas visualmente confirmadas antes y usar un rango fijo relativo.
# startLine es 3406 (index 3405).
# endLine es 3665 (index 3664).

$endLine = 3665 - 1 # Ajuste a index 0

# Verificamos
Write-Host "Reemplazando desde línea $($startLine + 1) hasta $($endLine + 1)"
Write-Host "Contenido inicio: $($lines[$startLine])"
Write-Host "Contenido fin: $($lines[$endLine])"

$newContent = @"
                                  child: StreamBuilder<List<Novedad>>(
                                    stream: BitacoraService().streamNovedades(widget.bitacoraId ?? ''),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      final novedades = snapshot.data!;
                                      if (novedades.isEmpty) {
                                         return Padding(
                                           padding: const EdgeInsets.all(20.0),
                                           child: Text(
                                             'No hay novedades registradas',
                                             style: FlutterFlowTheme.of(context).bodyMedium,
                                           ),
                                         );
                                      }
                                      return ListView.separated(
                                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: novedades.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 20.0),
                                        itemBuilder: (context, novedadesIndex) {
                                           final novedadesItem = novedades[novedadesIndex];
                                           return Card(
                                             clipBehavior: Clip.antiAliasWithSaveLayer,
                                             color: FlutterFlowTheme.of(context).secondaryBackground,
                                             child: Row(
                                               mainAxisSize: MainAxisSize.min,
                                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                               children: [
                                                 Padding(
                                                   padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 10.0, 10.0),
                                                   child: InkWell(
                                                     splashColor: Colors.transparent,
                                                     focusColor: Colors.transparent,
                                                     hoverColor: Colors.transparent,
                                                     highlightColor: Colors.transparent,
                                                     onTap: () async {
                                                       await Navigator.push(
                                                         context,
                                                         PageTransition(
                                                           type: PageTransitionType.fade,
                                                           child: FlutterFlowExpandedImageView(
                                                             image: Image.network(
                                                               valueOrDefault<String>(
                                                                 novedadesItem.foto,
                                                                 'https://static.vecteezy.com/system/resources/previews/004/141/669/non_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg',
                                                               ),
                                                               fit: BoxFit.contain,
                                                               errorBuilder: (context, error, stackTrace) =>
                                                                   Image.asset(
                                                                 'assets/images/error_image.png',
                                                                 fit: BoxFit.contain,
                                                               ),
                                                             ),
                                                             allowRotation: false,
                                                             tag: valueOrDefault<String>(
                                                               novedadesItem.foto,
                                                               'https://static.vecteezy.com/system/resources/previews/004/141/669/non_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg' +
                                                                   '`$novedadesIndex',
                                                             ),
                                                             useHeroAnimation: true,
                                                           ),
                                                         ),
                                                       );
                                                     },
                                                     child: Hero(
                                                       tag: valueOrDefault<String>(
                                                         novedadesItem.foto,
                                                         'https://static.vecteezy.com/system/resources/previews/004/141/669/non_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg' +
                                                             '`$novedadesIndex',
                                                       ),
                                                       transitionOnUserGestures: true,
                                                       child: ClipRRect(
                                                         borderRadius: BorderRadius.circular(10.0),
                                                         child: Image.network(
                                                           valueOrDefault<String>(
                                                             novedadesItem.foto,
                                                             'https://static.vecteezy.com/system/resources/previews/004/141/669/non_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg',
                                                           ),
                                                           width: 70.0,
                                                           height: 70.0,
                                                           fit: BoxFit.cover,
                                                           errorBuilder: (context, error, stackTrace) =>
                                                               Image.asset(
                                                             'assets/images/error_image.png',
                                                             width: 70.0,
                                                             height: 70.0,
                                                             fit: BoxFit.cover,
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                                 Flexible(
                                                   child: Column(
                                                     mainAxisSize: MainAxisSize.min,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                                                       RichText(
                                                         textScaler: MediaQuery.of(context).textScaler,
                                                         text: TextSpan(
                                                           children: [
                                                             const TextSpan(
                                                               text: 'Novedad\n',
                                                               style: TextStyle(),
                                                             ),
                                                             TextSpan(
                                                               text: valueOrDefault<String>(
                                                                 novedadesItem.descripcion,
                                                                 'sin novedad',
                                                               ),
                                                               style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                     font: GoogleFonts.newsreader(
                                                                       fontWeight: FontWeight.bold,
                                                                     ),
                                                                     color: const Color(0xFF57636C),
                                                                     fontWeight: FontWeight.bold,
                                                                   ),
                                                             )
                                                           ],
                                                           style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                 font: GoogleFonts.newsreader(),
                                                               ),
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                                 Padding(
                                                   padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                   child: Text(
                                                     valueOrDefault<String>(
                                                       dateTimeFormat(
                                                         "jm",
                                                         novedadesItem.hora,
                                                         locale: FFLocalizations.of(context).languageCode,
                                                       ),
                                                       '00:00',
                                                     ),
                                                     style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                           font: GoogleFonts.newsreader(),
                                                         ),
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           );
                                        },
                                      );
                                    },
                                  ),
"@

# Reemplazar líneas
$before = $lines[0..($startLine - 1)]
$after = $lines[($endLine + 1)..($lines.Count - 1)]
$newLines = $before + $newContent + $after

$newLines | Set-Content $path -Encoding UTF8
Write-Host "Reemplazo completado."
