import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

def smart_replace(text, marker, replacement):
    idx = text.find(marker)
    if idx == -1:
        print(f"Marker '{marker}' not found")
        return text
    
    # Buscar hacia atrás el 'await' correspondiente
    # Limitar busqueda atrás para no irnos demasiado lejos
    start_idx = text.rfind('await', 0, idx)
    if start_idx == -1:
        print(f"Could not find start 'await' for marker '{marker}'")
        return text

    # Verificar que estamos dentro de un bloque update
    # Buscar hacia adelante desde await el cierre ';'
    end_idx = text.find(';', idx)
    if end_idx == -1:
        print(f"Could not find end ';' for marker '{marker}'")
        return text
    
    end_idx += 1 # Incluir el ;

    original_block = text[start_idx:end_idx]
    print(f"Replacing block for {marker}...")
    # print(original_block) # Debug
    
    return text[:start_idx] + replacement + text[end_idx:]

# Visitas
content = smart_replace(content, 'getVisitasListFirestoreData', 'await BitacoraService().marcarSalidaVisita(visitasDentroItem.id!);')

# Proveedores
content = smart_replace(content, 'getProveedoresListFirestoreData', 'await BitacoraService().marcarSalidaProveedor(proveedoresDentroItem.id!);')

# Vehiculos
content = smart_replace(content, 'getVehiculosListFirestoreData', 'await BitacoraService().marcarSalidaVehiculo(vehiculosDentroItem.id!);')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Smart replace complete.")
