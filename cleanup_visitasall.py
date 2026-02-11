import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Reemplazar accesos directos por null-safe
# Proveedores (cambio de nombre incluido)
content = re.sub(r'visitasallBitacoraRecord\.proveedores\b', '(visitasallBitacoraRecord?.proveedoresVisitas ?? [])', content)

# Visitas
content = re.sub(r'visitasallBitacoraRecord\.visitas\b', '(visitasallBitacoraRecord?.visitas ?? [])', content)

# Vehiculos
content = re.sub(r'visitasallBitacoraRecord\.vehiculos\b', '(visitasallBitacoraRecord?.vehiculos ?? [])', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Null safety cleanup complete.")
