import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Revertir proveedoresVisitas a proveedores (ya que el modelo Bitacora usa 'proveedores')
content = content.replace('proveedoresVisitas', 'proveedores')

# 2. Asegurar que haya ! en las llamadas de salida, si me olvidé ponerlo o si se borró
# Visitas
content = content.replace('marcarSalidaVisita(visitasDentroItem.id)', 'marcarSalidaVisita(visitasDentroItem.id!)')
# Proveedores
content = content.replace('marcarSalidaProveedor(proveedoresDentroItem.id)', 'marcarSalidaProveedor(proveedoresDentroItem.id!)')
# Vehiculos
content = content.replace('marcarSalidaVehiculo(vehiculosDentroItem.id)', 'marcarSalidaVehiculo(vehiculosDentroItem.id!)')

# También revisar si hay alguno sin '!' que cause el error
# El error puede ser en otra llamada si existe.

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Final fix complete.")
