import sys

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Imports
content = content.replace("import '/auth/firebase_auth/auth_util.dart';", "import '/auth/supabase_auth/auth_util.dart';\nimport '/services/bitacora_service.dart';\nimport '/models/bitacora.dart';\nimport '/models/visita.dart';\nimport '/models/vehiculo.dart';\nimport '/models/proveedor_visita.dart';")
content = content.replace("import '/backend/backend.dart';", "")
content = content.replace("import '/backend/firebase_storage/storage.dart';", "")

# 2. StreamBuilder y BitacoraRecord
content = content.replace('StreamBuilder<BitacoraRecord>(', 'StreamBuilder<Bitacora?>(')
content = content.replace('BitacoraRecord.getDocument(FFAppState().bitacoraRefTempPersistente!)', 'BitacoraService().streamBitacora(FFAppState().bitacoraRefTempPersistente!)')
content = content.replace('final visitasallBitacoraRecord = snapshot.data!;', 'final visitasallBitacoraRecord = snapshot.data;')

# 3. Campos
content = content.replace('visitasallBitacoraRecord.visitas', '(visitasallBitacoraRecord?.visitas ?? [])')
# Ojo: en el modelo de Supabase es proveedoresVisitas, en Firestore era proveedores
content = content.replace('visitasallBitacoraRecord.proveedores', '(visitasallBitacoraRecord?.proveedoresVisitas ?? [])')
content = content.replace('visitasallBitacoraRecord.vehiculos', '(visitasallBitacoraRecord?.vehiculos ?? [])')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Basic migration complete.")
