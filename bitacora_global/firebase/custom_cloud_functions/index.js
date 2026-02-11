const admin = require("firebase-admin/app");
admin.initializeApp();

const testDespliegue = require("./test_despliegue.js");
exports.testDespliegue = testDespliegue.testDespliegue;
const limpiarSucursalesManualmente = require("./limpiar_sucursales_manualmente.js");
exports.limpiarSucursalesManualmente =
  limpiarSucursalesManualmente.limpiarSucursalesManualmente;
const limpiarSucursalesDiariamente = require("./limpiar_sucursales_diariamente.js");
exports.limpiarSucursalesDiariamente =
  limpiarSucursalesDiariamente.limpiarSucursalesDiariamente;
