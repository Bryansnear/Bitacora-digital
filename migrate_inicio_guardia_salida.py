import re

file_path = r'c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\inicio\inicio_guardia\inicio_guardia_widget.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Pattern con whitespace flexible
pattern = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\.update\(createBitacoraData\(\s+horaSalidaVigilante:\s+getCurrentTimestamp,\s+\)\);'
replacement = r'''await BitacoraService().salidaVigilante(
                                                                                  bitacoraId: FFAppState()
                                                                                      .bitacoraRefTempPersistente!,
                                                                                  sucursalId: _model
                                                                                      .bitacoraActual!
                                                                                      .sucursalId,
                                                                                );'''

new_content = re.sub(pattern, replacement, content)

if new_content != content:
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Replaced successfully")
else:
    # Intento con menos rigidez si el anterior falla
    pattern2 = r'await FFAppState\(\)\.bitacoraRefTempPersistente!\.update\([\s\S]+?horaSalidaVigilante:[\s\S]+?getCurrentTimestamp,[\s\S]+?\)\);'
    new_content2 = re.sub(pattern2, replacement, content)
    if new_content2 != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content2)
        print("Replaced with pattern2 successfully")
    else:
        print("Pattern not found even with pattern2")
