import sys
import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Imports
content = content.replace("import '/auth/firebase_auth/auth_util.dart';", "import '/auth/supabase_auth/auth_util.dart';\nimport '/services/bitacora_service.dart';\nimport '/models/bitacora.dart';\nimport '/models/visita.dart';\nimport '/models/vehiculo.dart';\nimport '/models/proveedor_visita.dart';")
# Quitar otros de backend
content = re.sub(r"import '/backend/backend\.dart';", "", content)
content = re.sub(r"import '/backend/firebase_storage/storage\.dart';", "", content)

# 2. StreamBuilder y BitacoraRecord
content = content.replace('StreamBuilder<BitacoraRecord>(', 'StreamBuilder<Bitacora?>(')
content = content.replace('BitacoraRecord.getDocument(FFAppState().bitacoraRefTempPersistente!)', 'BitacoraService().streamBitacora(FFAppState().bitacoraRefTempPersistente!)')
content = content.replace('final visitasallBitacoraRecord = snapshot.data!;', 'final visitasallBitacoraRecord = snapshot.data;')

# 3. Manejo de nulos y nombres de campos
# Usamos regex para atrapar visitasallBitacoraRecord.visitas etc.
content = content.replace('visitasallBitacoraRecord.visitas', '(visitasallBitacoraRecord?.visitas ?? [])')
content = content.replace('visitasallBitacoraRecord.proveedores', '(visitasallBitacoraRecord?.proveedoresVisitas ?? [])')
content = content.replace('visitasallBitacoraRecord.vehiculos', '(visitasallBitacoraRecord?.vehiculos ?? [])')

# 4. Reemplazos de bloques de salida (Lógica Supabase)

# Visita output
pattern_visita_out = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\.update\({\s+\.\.\(\s+{\s+\'visitas\':\s+getVisitasListFirestoreData\([\s\S]+?FFAppState\(\)\.visitas,\s+\),\s+},\s+\),\s+}\);'
visita_out_repl = 'await BitacoraService().marcarSalidaVisita(visitasDentroItem.id!);'

# Proveedor output
pattern_prov_out = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\.update\({\s+\.\.\(\s+{\s+\'proveedores\':\s+getProveedoresListFirestoreData\([\s\S]+?FFAppState\(\)\.proveedores,\s+\),\s+},\s+\),\s+}\);'
prov_out_repl = 'await BitacoraService().marcarSalidaProveedor(proveedoresDentroItem.id!);'

# Vehiculo output
pattern_veh_out = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\.update\({\s+\.\.\(\s+{\s+\'vehiculos\':\s+getVehiculosListFirestoreData\([\s\S]+?FFAppState\(\)\.vehiculos,\s+\),\s+},\s+\),\s+}\);'
veh_out_repl = 'await BitacoraService().marcarSalidaVehiculo(vehiculosDentroItem.id!);'

content = re.sub(pattern_visita_out, visita_out_repl, content)
content = re.sub(pattern_prov_out, prov_out_repl, content)
content = re.sub(pattern_veh_out, veh_out_repl, content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Migration of visitasall_widget.dart complete.")
