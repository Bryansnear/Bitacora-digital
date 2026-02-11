import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\visitasall\visitasall_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Patrones multilínea para null safety
# Vehiculos
content = re.sub(r'visitasallBitacoraRecord\s*\.vehiculos\b', '(visitasallBitacoraRecord?.vehiculos ?? [])', content)

# Visitas
content = re.sub(r'visitasallBitacoraRecord\s*\.visitas\b', '(visitasallBitacoraRecord?.visitas ?? [])', content)

# Proveedores (recordar que cambiamos a proveedoresVisitas en el modelo, pero aqui buscamos lo que habia antes 'proveedores' o quizas ya se cambio parcialmente?)
# Mi script básico cambio 'visitasallBitacoraRecord.proveedores' a 'proveedoresVisitas'. 
# Si el script basico falló por multiline, entonces todavía dice 'proveedores'.
# Buscaré 'proveedores' primero y lo reemplazaré.

content = re.sub(r'visitasallBitacoraRecord\s*\.proveedores\b', '(visitasallBitacoraRecord?.proveedoresVisitas ?? [])', content)
# Y por si acaso ya se llama proveedoresVisitas pero sin check
content = re.sub(r'visitasallBitacoraRecord\s*\.proveedoresVisitas\b', '(visitasallBitacoraRecord?.proveedoresVisitas ?? [])', content)
# Corregir doble parentesis si ya tenía
content = content.replace('((visitasallBitacoraRecord?.proveedoresVisitas ?? []))', '(visitasallBitacoraRecord?.proveedoresVisitas ?? [])')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Multiline cleanup complete.")
