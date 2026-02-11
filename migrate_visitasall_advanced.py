import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Patrón para Visitas
# Busca: await FFAppState().bitacoraRefTempPersistente!.update({...mapToFirestore({'visitas': ...})});
# La clave es escapear bien los parentesis y puntos.
# \.\.\.mapToFirestore equivale a ...mapToFirestore

# Visitas
p_vis = r'await FFAppState\(\)\s*\.bitacoraRefTempPersistente!\s*\.update\({\s*\.\.\.mapToFirestore\(\s*{\s*\'visitas\':\s*getVisitasListFirestoreData\([\s\S]+?\)\s*}\s*\),\s*}\);'
match_vis = re.search(p_vis, content)
if match_vis:
    print("Found Visitas block")
    content = re.sub(p_vis, 'await BitacoraService().marcarSalidaVisita(visitasDentroItem.id!);', content)
else:
    print("Visitas block NOT found")

# Proveedores
p_prov = r'await FFAppState\(\)\s*\.bitacoraRefTempPersistente!\s*\.update\({\s*\.\.\.mapToFirestore\(\s*{\s*\'proveedores\':\s*getProveedoresListFirestoreData\([\s\S]+?\)\s*}\s*\),\s*}\);'
match_prov = re.search(p_prov, content)
if match_prov:
    print("Found Proveedores block")
    content = re.sub(p_prov, 'await BitacoraService().marcarSalidaProveedor(proveedoresDentroItem.id!);', content)
else:
    print("Proveedores block NOT found")

# Vehículos
p_veh = r'await FFAppState\(\)\s*\.bitacoraRefTempPersistente!\s*\.update\({\s*\.\.\.mapToFirestore\(\s*{\s*\'vehiculos\':\s*getVehiculosListFirestoreData\([\s\S]+?\)\s*}\s*\),\s*}\);'
match_veh = re.search(p_veh, content)
if match_veh:
    print("Found Vehiculos block")
    content = re.sub(p_veh, 'await BitacoraService().marcarSalidaVehiculo(vehiculosDentroItem.id!);', content)
else:
    print("Vehiculos block NOT found")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Advanced regex migration complete.")
