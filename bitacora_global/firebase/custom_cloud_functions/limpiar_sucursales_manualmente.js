const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.limpiarSucursalesManualmente = functions.https.onCall(
  async (data, context) => {
    if (!context.auth || !context.auth.uid) {
      console.log("Intento de llamada no autenticado.");
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Debes estar autenticado para realizar esta acción.",
      );
    }

    // --- Inicia tu código ---
    console.log(
      `[INICIO] Limpieza manual iniciada por el usuario: ${context.auth.uid}`,
    );

    const db = admin.firestore();
    const institutionsRef = db.collection("Instituciones");

    // JSON para el informe de respuesta
    let informeDeCambios = {
      institucionesModificadas: [],
    };

    let sucursalesModificadasEnTotal = 0;

    try {
      const snapshot = await institutionsRef.get();

      if (snapshot.empty) {
        console.log('[INFO] La colección "Instituciones" está vacía.');
        return {
          success: true,
          message: "No se encontraron instituciones.",
          informe: informeDeCambios,
        };
      }

      console.log(
        `[INFO] Se encontraron ${snapshot.size} documentos en "Instituciones".`,
      );
      const batch = db.batch();

      snapshot.forEach((doc) => {
        console.log(`--- [REVISANDO]: Documento ID: ${doc.id} ---`);
        const institutionData = doc.data();
        const docRef = institutionsRef.doc(doc.id);

        let institucionModificada = {
          nombre: institutionData.nombreInstitucion || doc.id,
          sucursalesActualizadas: [],
        };

        let seHicieronCambiosEnEstaInstitucion = false;

        // Comprueba si el campo 'sucursales' existe y es un array
        if (
          Array.isArray(institutionData.sucursales) &&
          institutionData.sucursales.length > 0
        ) {
          const updatedSucursales = institutionData.sucursales.map(
            (sucursal, index) => {
              // *** NUEVA LÓGICA DE FILTRADO ***
              // Comprueba si el campo 'Estado' NO es "0"
              // (Comprobamos también que exista para evitar errores)
              if (
                sucursal.hasOwnProperty("Estado") &&
                sucursal.Estado !== "0"
              ) {
                console.log(
                  `[MODIFICANDO] ${doc.id}, Sucursal: "${sucursal.sucursalCiudad || index}". Estado anterior: "${sucursal.Estado}".`,
                );

                // Prepara el informe
                seHicieronCambiosEnEstaInstitucion = true;
                sucursalesModificadasEnTotal++;
                institucionModificada.sucursalesActualizadas.push({
                  nombreSucursal: sucursal.sucursalCiudad || `Índice ${index}`,
                  estadoAnterior: sucursal.Estado,
                });

                // 1. Borra los campos
                delete sucursal.bitacoraActual;
                delete sucursal.vigilanteActual;

                // 2. Establece el Estado a "0"
                sucursal.Estado = "0";
              } else if (
                sucursal.hasOwnProperty("bitacoraActual") ||
                sucursal.hasOwnProperty("vigilanteActual")
              ) {
                // Esta sucursal SÍ tiene estado "0", pero aún tiene los campos.
                // Los borramos para limpiar, pero no lo reportamos como un cambio principal.
                console.log(
                  `[LIMPIEZA] ${doc.id}, Sucursal: "${sucursal.sucursalCiudad || index}" (Estado 0). Limpiando campos remanentes.`,
                );
                delete sucursal.bitacoraActual;
                delete sucursal.vigilanteActual;
                seHicieronCambiosEnEstaInstitucion = true; // Marcamos para actualizar el array
              }

              return sucursal;
            },
          );

          // Solo añadimos al batch si se modificó esta institución
          if (seHicieronCambiosEnEstaInstitucion) {
            console.log(
              `[ÉXITO] Preparando actualización para el documento: ${doc.id}`,
            );
            batch.update(docRef, { sucursales: updatedSucursales });

            // Si hubo cambios reportables, añade la institución al informe
            if (institucionModificada.sucursalesActualizadas.length > 0) {
              informeDeCambios.institucionesModificadas.push(
                institucionModificada,
              );
            }
          } else {
            console.log(
              `[INFO] Documento ${doc.id} no requirió modificaciones.`,
            );
          }
        } else {
          console.log(
            `[INFO] Documento ${doc.id} no tiene un array 'sucursales' o está vacío. Se ignora.`,
          );
        }
      });

      // Ejecuta todas las operaciones a la vez
      await batch.commit();

      console.log(
        `[FIN] Limpieza completada. Se modificaron ${sucursalesModificadasEnTotal} sucursales que no estaban en estado 0.`,
      );

      // Devuelve el JSON con el informe
      return {
        success: true,
        message: `Se actualizaron ${sucursalesModificadasEnTotal} sucursales.`,
        informe: informeDeCambios,
      };
    } catch (error) {
      console.error("[ERROR] Error durante la limpieza manual:", error);
      throw new functions.https.HttpsError(
        "internal",
        "Ocurrió un error al limpiar los datos.",
      );
    }
    // --- Termina tu código ---
  },
);
