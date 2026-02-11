
import sys
import os
import re

def migrate(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 1. widget.institucion -> widget.institucionId
    content = content.replace('widget.institucion', 'widget.institucionId')
    
    # 2. authUtil vars (currentUserReference -> currentUserDocument?.id)
    content = content.replace('currentUserReference', 'currentUserDocument?.id')
    
    # 3. Fix cases where we have .id.id or similar after double replacements
    content = content.replace('.id.id', '.id')
    
    # 4. Fix .update missing methods (last resort)
    # Si queda algun .id!.update o .id.update
    content = re.sub(r'([_a-zA-Z0-9\.\!]+)\.id\.update\s*\(', r'BitacoraService().updateBitacora(\1.id, ', content)

    # 5. Fix .institucionId!.update
    content = content.replace('widget.institucionId!.update(', 'BitacoraService().updateUserProfile(')

    # 6. .id.set
    content = content.replace('.id!.set(', 'BitacoraService().createBitacora(')

    # 7. mapToFirestore cleanup
    content = re.sub(r'mapToFirestore\([\s\S]*?\{([\s\S]*?)\}[\s\S]*?\)', r'{\1}', content)

    # Guardar cambios
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        migrate(sys.argv[1])
