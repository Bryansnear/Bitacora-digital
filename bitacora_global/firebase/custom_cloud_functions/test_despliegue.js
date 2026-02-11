const functions = require("firebase-functions");

exports.testDespliegue = functions
  .region("us-central1") // O la región que uses
  .https.onCall((data, context) => {
    console.log(
      "La función de prueba se ejecutó y está a punto de devolver una respuesta.",
    );

    // ¡ESTA LÍNEA ES OBLIGATORIA!
    // Devuelve un objeto que se convertirá en JSON.
    return "Funciono sin problema";
  });
