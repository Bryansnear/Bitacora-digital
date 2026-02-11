import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Buscamos un fragmento de visitas
visitas_marker = "getVisitasListFirestoreData"
if visitas_marker in content:
    # Capturamos desde el await anterior
    match = re.search(r'await[\s\S]+?' + visitas_marker + r'[\s\S]+?\);', content)
    if match:
        print(f"Found match: {match.group(0)}")
        new_content = content.replace(match.group(0), 'await BitacoraService().marcarSalidaVisita(visitasDentroItem.id!);')
        content = new_content
    else:
        print("Marker found but regex failed to capture block")
else:
    print("Marker getVisitasListFirestoreData not found")

# Proveedores
prov_marker = "getProveedoresListFirestoreData"
if prov_marker in content:
    match = re.search(r'await[\s\S]+?' + prov_marker + r'[\s\S]+?\);', content)
    if match:
        print(f"Found match (prov): {match.group(0)}")
        new_content = content.replace(match.group(0), 'await BitacoraService().marcarSalidaProveedor(proveedoresDentroItem.id!);')
        content = new_content

# Vehiculos
veh_marker = "getVehiculosListFirestoreData"
if veh_marker in content:
    match = re.search(r'await[\s\S]+?' + veh_marker + r'[\s\S]+?\);', content)
    if match:
        print(f"Found match (veh): {match.group(0)}")
        new_content = content.replace(match.group(0), 'await BitacoraService().marcarSalidaVehiculo(vehiculosDentroItem.id!);')
        content = new_content

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Repair complete.")
