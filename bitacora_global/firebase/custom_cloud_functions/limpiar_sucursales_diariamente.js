const functions = require("firebase-functions");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

exports.limpiarSucursalesDiariamente = functions
  .region("us-central1") // O la región que uses
  .pubsub.schedule("every day 05:00")
  .timeZone("America/Guayaquil")
  .onRun(async (context) => {
    console.log("[INICIO] Ejecutando limpieza diaria programada (5:00 AM).");

    const db = admin.firestore();
    const institutionsRef = db.collection("Instituciones");
    let sucursalesModificadasEnTotal = 0;

    try {
      const snapshot = await institutionsRef.get();

      if (snapshot.empty) {
        console.log(
          '[INFO] La colección "Instituciones" está vacía. No hay nada que hacer.',
        );
        return null; // Termina la función
      }

      console.log(
        `[INFO] Se encontraron ${snapshot.size} documentos en "Instituciones".`,
      );
      const batch = db.batch();

      snapshot.forEach((doc) => {
        console.log(`--- [REVISANDO]: Documento ID: ${doc.id} ---`);
        const institutionData = doc.data();
        const docRef = institutionsRef.doc(doc.id);

        let seHicieronCambiosEnEstaInstitucion = false;

        // Comprueba si el campo 'sucursales' existe y es un array
        if (
          Array.isArray(institutionData.sucursales) &&
          institutionData.sucursales.length > 0
        ) {
          const updatedSucursales = institutionData.sucursales.map(
            (sucursal, index) => {
              // *** LÓGICA DE FILTRADO ***
              // Comprueba si el campo 'Estado' NO es "0"
              if (
                sucursal.hasOwnProperty("Estado") &&
                sucursal.Estado !== "0"
              ) {
                console.log(
                  `[MODIFICANDO] ${doc.id}, Sucursal: "${sucursal.sucursalCiudad || index}". Estado anterior: "${sucursal.Estado}".`,
                );

                seHicieronCambiosEnEstaInstitucion = true;
                sucursalesModificadasEnTotal++;

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
                // Los borramos para limpiar.
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
        `[FIN] Limpieza diaria completada. Se modificaron ${sucursalesModificadasEnTotal} sucursales que no estaban en estado 0.`,
      );
      return null; // Termina la función exitosamente
    } catch (error) {
      console.error(
        "[ERROR] Error durante la limpieza diaria programada:",
        error,
      );
      return null; // Termina la función con error (pero no reintenta)
    }
  });
