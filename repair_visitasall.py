import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Definimos patrones que busquen desde 'await FFAppState().bitacoraRefTempPersistente!.update' 
# hasta el cierre del update '});' pasando por las funciones de backend de FF.

# Visitas
pattern_visita = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\s*\.update\({\s*\.\.\(\s*{\s*\'visitas\':\s*getVisitasListFirestoreData\([\s\S]+?\)\s*}\s*\),\s*}\);'
content = re.sub(pattern_visita, 'await BitacoraService().marcarSalidaVisita(visitasDentroItem.id!);', content)

# Proveedores
pattern_prov = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\s*\.update\({\s*\.\.\(\s*{\s*\'proveedores\':\s*getProveedoresListFirestoreData\([\s\S]+?\)\s*}\s*\),\s*}\);'
content = re.sub(pattern_prov, 'await BitacoraService().marcarSalidaProveedor(proveedoresDentroItem.id!);', content)

# Vehículos
pattern_veh = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\s*\.update\({\s*\.\.\(\s*{\s*\'vehiculos\':\s*getVehiculosListFirestoreData\([\s\S]+?\)\s*}\s*\),\s*}\);'
content = re.sub(pattern_veh, 'await BitacoraService().marcarSalidaVehiculo(vehiculosDentroItem.id!);', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Repair of visitasall_widget.dart complete.")
