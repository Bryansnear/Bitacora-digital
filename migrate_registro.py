import sys
import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\registro\registro_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Imports
content = content.replace("import '/auth/firebase_auth/auth_util.dart';", "import '/auth/supabase_auth/auth_util.dart';\nimport '/services/bitacora_service.dart';\nimport '/models/bitacora.dart';\nimport '/models/visita.dart';\nimport '/models/vehiculo.dart';\nimport '/models/proveedor_visita.dart';")
content = content.replace("import '/backend/firebase_storage/storage.dart';", "")

# 2. Reemplazos de bloques de actualización (Lógica Supabase)

# Visita replacement
visita_replacement = """                                                            await BitacoraService().addVisita(
                                                              Visita(
                                                                bitacoraId: FFAppState().bitacoraRefTempPersistente!,
                                                                nombre: _model.yourNameTextController.text,
                                                                motivo: _model.motivoTextController.text,
                                                                pertenencias: _model.pertenenciasTextController.text,
                                                                horaEntrada: getCurrentTimestamp,
                                                                foto: valueOrDefault<String>(
                                                                  _model.uploadedFileUrl_uploadDataR7g,
                                                                  'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg',
                                                                ),
                                                                cedula: _model.cedulaTextController.text,
                                                              ),
                                                            );"""

# Proveedor replacement
proveedor_replacement = """                                                            await BitacoraService().addProveedorVisita(
                                                              ProveedorVisita(
                                                                bitacoraId: FFAppState().bitacoraRefTempPersistente!,
                                                                nombre: _model.yourNameTextController.text,
                                                                empresa: _model.proveedorTextController.text,
                                                                motivo: _model.motivoTextController.text,
                                                                pertenencias: _model.pertenenciasTextController.text,
                                                                horaEntrada: getCurrentTimestamp,
                                                                foto: valueOrDefault<String>(
                                                                  _model.uploadedFileUrl_uploadDataR7g,
                                                                  'https://firebasestorage.googleapis.com/v0/b/bitacoraglobaldigital.appspot.com/o/assets%2Fregistros%2Fproveedor.jpg?alt=media&token=8e041957-04e6-4e05-a44e-7eaf3c0292b1',
                                                                ),
                                                              ),
                                                            );"""

# Vehiculo replacement
vehiculo_replacement = """                                                            await BitacoraService().addVehiculo(
                                                              Vehiculo(
                                                                bitacoraId: FFAppState().bitacoraRefTempPersistente!,
                                                                placa: _model.placaTextController.text,
                                                                nombre: _model.yourNameTextController.text,
                                                                motivo: _model.motivoTextController.text,
                                                                horaEntrada: getCurrentTimestamp,
                                                                foto: valueOrDefault<String>(
                                                                  _model.uploadedFileUrl_uploadDataR7g,
                                                                  'https://firebasestorage.googleapis.com/v0/b/bitacoraglobaldigital.appspot.com/o/assets%2Fregistros%2Fimagen_2025-06-02_122638001.png?alt=media&token=f98b17fe-80a5-468f-a0c3-b83ff1ee805c',
                                                                ),
                                                                cedula: _model.cedulaTextController.text,
                                                              ),
                                                            );"""

# Patrones regex para capturar los bloques mal formados/anteriores
# Nota: Usamos una búsqueda menos estricta por si hay variaciones en espacios
pattern_visita = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\.update\({\s+\.\.\(\s+{\s+\'visitas\':\s+FieldValue\.arrayUnion\(\[\s+getVisitasFirestoreData\([\s\S]+?true,\s+\)\s+\]\),\s+},\s+\),\s+}\);'
pattern_proveedor = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\.update\({\s+\.\.\(\s+{\s+\'proveedores\':\s+FieldValue\.arrayUnion\(\[\s+getProveedoresFirestoreData\([\s\S]+?true,\s+\)\s+\]\),\s+},\s+\),\s+}\);'
pattern_vehiculo = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\.update\({\s+\.\.\(\s+{\s+\'vehiculos\':\s+FieldValue\.arrayUnion\(\[\s+getVehiculosFirestoreData\([\s\S]+?true,\s+\)\s+\]\),\s+},\s+\),\s+}\);'

content = re.sub(pattern_visita, visita_replacement, content)
content = re.sub(pattern_proveedor, proveedor_replacement, content)
content = re.sub(pattern_vehiculo, vehiculo_replacement, content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Migration of registro_widget.dart complete.")
