# Feature Comparison: OLD (FlutterFlow/Firebase) vs NEW (Supabase Screens)

> Generated: 2026-02-10  
> Project: `bitacora_global`

---

## 1. SCREEN-BY-SCREEN INVENTORY

### NEW Screens (`lib/screens/`)

| # | Screen File | Purpose | Key Features |
|---|------------|---------|--------------|
| 1 | `screens/auth/login_screen.dart` | Login | Email/password auth via `AuthProvider.signIn()`, form validation, logo, "forgot password" button (TODO - not implemented) |
| 2 | `screens/auth/setup_screen.dart` | Initial setup | Wrapper → delegates to `pages/setup_admin_page.dart` |
| 3 | `screens/guardia/home_guardia_screen.dart` | Guard home | Select institución/sucursal via dropdowns, start shift (`llegadaVigilante` RPC), show active shift card with quick-action buttons (Registro, Novedad, Cierre), welcome card, logout |
| 4 | `screens/guardia/apertura_screen.dart` | Branch opening | Encargado name field, novedad text, photo capture+upload (`StorageService`), calls `registrarApertura` RPC |
| 5 | `screens/guardia/cierre_screen.dart` | Shift close | Shift summary (duration), encargado cierre, novedad cierre, photo capture+upload, confirmation dialog, calls `registrarCierre` RPC, `finalizarTurno()` |
| 6 | `screens/guardia/registro_screen.dart` | Register entries | **3 tabs**: Visitas (nombre, cédula, motivo, foto), Vehículos (placa, conductor, tipo, foto), Proveedores (empresa, nombre, motivo, foto). Each with photo capture/upload and calls respective RPC |
| 7 | `screens/guardia/novedad_screen.dart` | Register novelty | Description field, photo capture/upload, calls `addNovedad` RPC, live stream list of current shift novedades at bottom |
| 8 | `screens/admin/dashboard_screen.dart` | Admin dashboard | Sidebar listing instituciones (stream), main area: sucursales grid per institución, cards show active/inactive status, navigate to bitácora detail. "Nueva Sucursal" button (TODO) |
| 9 | `screens/admin/bitacora_detail_screen.dart` | Bitácora detail | **4 tabs**: General (open/close state, apertura/cierre details), Visitas (list), Novedades (stream), Vehículos (list) |
| 10 | `screens/shared/profile_screen.dart` | User profile | Avatar, name, email, role badge. Read-only. "Edit Profile" (TODO), "Change Password" (TODO), "Notifications" (TODO), sign-out button |

### OLD Screens (FlutterFlow widgets)

| # | Old Widget File | Purpose |
|---|----------------|---------|
| 1 | `inicio/inicio/inicio_widget.dart` | Login/entry |
| 2 | `inicio/inicio_guardia/inicio_guardia_widget.dart` | Guard main screen (massive ~6400 lines) |
| 3 | `inicio/inicio_administrador/inicio_administrador_widget.dart` | Admin home |
| 4 | `inicio/inicio_jefe_seguridad/inicio_jefe_seguridad_widget.dart` | Security chief home |
| 5 | `inicio/apertura_parcial/apertura_parcial_widget.dart` | Partial opening |
| 6 | `inicio/apertura_total/apertura_total_widget.dart` | Total opening |
| 7 | `inicio/cierre_p_arcial/cierre_p_arcial_widget.dart` | Partial close |
| 8 | `inicio/cierretotal/cierretotal_widget.dart` | Total close |
| 9 | `inicio/registro/registro_widget.dart` | Register (visits/vehicles/providers) |
| 10 | `inicio/novedad/novedad_widget.dart` | Register novelty / ATM |
| 11 | `inicio/visitasall/visitasall_widget.dart` | View all visits/providers/vehicles with exit marking |
| 12 | `inicio/side_nav02/side_nav02_widget.dart` | Sidebar navigation |
| 13 | `novedades/novedades_widget.dart` | List novedades/cajeros for current bitácora |
| 14 | `vistanovedades/vistanovedades_widget.dart` | Cross-institution novedades viewer |
| 15 | `consolidadoo/consolidadoo_widget.dart` | Consolidated bitácoras report |
| 16 | `sucursales_proveedores/sucursales_proveedores_widget.dart` | Manage sucursales, vigilantes, proveedores |
| 17 | `pages/sucursal/sucursal_widget.dart` | Branch list → navigate to bitácoras |
| 18 | `pages/profile/profile_widget.dart` | User profile with photo, edit, sign-out |
| 19 | `pages/forgot_paswword/forgot_paswword_widget.dart` | Password recovery email |
| 20 | `components/clientedetalle/clientedetalle_widget.dart` | Visit detail bottom sheet (photo, data) |
| 21 | `components/supervision_reporte/supervision_reporte_widget.dart` | Supervision report (photo + text observation) |
| 22 | `cruds/new_vigilante/` | Create guard (nombre, cédula, teléfono, correo, contraseña, foto) |
| 23 | `cruds/edit_vigilante/` | Edit guard |
| 24 | `cruds/new_entidad/` | Create entity/institución (tipo, empresa, agencia, ubicación, actividad, foto) |
| 25 | `cruds/edit_entidad/` | Edit entity |
| 26 | `cruds/new_agencia/` | Create branch/agencia (nombre, ubicación) |
| 27 | `cruds/edit_agencia/` | Edit branch |
| 28 | `cruds/edit_proveedores/` | Edit proveedor (empresa, actividad) |

---

## 2. DETAILED FEATURE COMPARISON TABLE

| Feature / Capability | OLD Code (FlutterFlow) | NEW Code (Supabase screens) | Status |
|---------------------|----------------------|---------------------------|--------|
| **AUTH & ROLES** | | | |
| Email/password login | ✅ `inicio_widget.dart` via Firebase Auth | ✅ `login_screen.dart` via Supabase Auth | ✅ Done |
| Forgot password (email reset) | ✅ `forgot_paswword_widget.dart` – sends reset email | ❌ Button exists but is TODO stub | 🔴 **MISSING** |
| Role-based routing (guard/admin/jefe) | ✅ 3 separate home screens per role | ✅ Router redirects based on role | ✅ Done |
| **GUARD FLOW** | | | |
| Select institución | ✅ Auto-assigned from user record | ✅ Dropdown from `streamInstituciones()` | ✅ Done |
| Select sucursal | ✅ From user's assigned sucursales | ✅ Dropdown from `streamSucursales()` | ✅ Done |
| Start shift (llegada vigilante) | ✅ Auto on screen load / explicit | ✅ "Iniciar Turno" button → `llegadaVigilante` RPC | ✅ Done |
| **Apertura Parcial** (partial opening) | ✅ Separate screen: encargado desalarmado, encargado llaves, novedad, photo, multiple apertura sections | ❌ Only generic "AperturaScreen" (one encargado + novedad + photo) | 🔴 **MISSING** (no partial/total distinction) |
| **Apertura Total** (total opening) | ✅ Separate screen: full apertura with 3 sections (bancaria/cajero/total), each with encargado + photo + toggle | ❌ Only generic "AperturaScreen" | 🔴 **MISSING** (no multi-section apertura) |
| Apertura state tracking (parcial vs total flags) | ✅ `FFAppState().aperturaTotal`, `aperturaParcial` flags control flow | ❌ Single `registrarApertura` RPC, no partial/total split | 🔴 **MISSING** |
| **Cierre Parcial** (partial close) | ✅ Separate screen: novedad cierre, writes partial cierre data | ❌ Only generic "CierreScreen" | 🔴 **MISSING** (no partial/total distinction) |
| **Cierre Total** (total close) | ✅ Separate screen: encargado alarmado, encargado llaves, novedad, multi-section close | ❌ Only generic "CierreScreen" | 🔴 **MISSING** (no multi-section cierre) |
| Cierre confirmation dialog | ✅ Yes | ✅ `AlertDialog` before closing | ✅ Done |
| Cierre shift summary | ❌ Implicit | ✅ Shows sucursal, start time, duration | ✅ Improved |
| **REGISTRO (Entries)** | | | |
| Register visit (nombre, cédula, motivo, pertenencias, foto) | ✅ Full form with `upload_data.dart`, camera, writes to Firestore | ✅ Form with nombre, cédula, motivo, photo. **No pertenencias field** | 🟡 **PARTIAL** – missing belongings |
| Register vehicle (placa, conductor, tipo, foto) | ✅ Full form | ✅ Full form | ✅ Done |
| Register proveedor (empresa, nombre, motivo, foto) | ✅ Via `tipoRegistro='proveedores'` param | ✅ 3rd tab in `registro_screen.dart` | ✅ Done |
| Tab-based navigation between tipo registro | ✅ Param-driven (separate instances) | ✅ 3-tab layout (Visitas/Vehículos/Proveedores) | ✅ Improved |
| Photo capture (camera) | ✅ `FFUploadedFile` + Firebase Storage | ✅ `ImageUtils.takePhoto()` + Supabase Storage | ✅ Done |
| Photo preview + delete | ✅ Container with image preview | ✅ `_FotoPreview` widget with delete button | ✅ Done |
| **VISITASALL (View all entries + mark exit)** | | | |
| View all visits inside (no exit yet) | ✅ Filtered list: `horaSalida == null` | ❌ No "all visits" listing screen | 🔴 **MISSING** |
| View all visits outside (exited) | ✅ Filtered list: `horaSalida != null` | ❌ No such screen | 🔴 **MISSING** |
| **Mark exit for visit** (`marcarSalidaVisita`) | ✅ Button per card, updates `horaSalida` | ❌ No exit-marking UI | 🔴 **MISSING** |
| **Mark exit for vehicle** (`marcarSalidaVehiculo`) | ✅ Button per card | ❌ No exit-marking UI | 🔴 **MISSING** |
| **Mark exit for proveedor** (`marcarSalidaProveedor`) | ✅ Button per card | ❌ No exit-marking UI | 🔴 **MISSING** |
| Visit detail bottom sheet | ✅ `ClientedetalleWidget` – shows photo, data, motivo | ❌ No detail view, just list items | 🔴 **MISSING** |
| 3 TabControllers (visits, providers, vehicles) | ✅ VisitasAll has 3 tab categories | ❌ — | 🔴 **MISSING** |
| **NOVEDADES** | | | |
| Register novedad (description + photo) | ✅ `novedad_widget.dart` | ✅ `novedad_screen.dart` | ✅ Done |
| Register **cajero/ATM** event (description + photo) – reuses novedad with `cajero: true` | ✅ `novedad_widget.dart` with `cajero` param | ❌ No cajero/ATM distinction | 🔴 **MISSING** |
| List novedades for current bitácora | ✅ `novedades_widget.dart` with stream | ✅ Stream at bottom of `novedad_screen.dart` | ✅ Done |
| List cajeros/ATMs for current bitácora | ✅ `novedades_widget.dart` with `cajeros: true` | ❌ No ATM list | 🔴 **MISSING** |
| **ATM management** (listado ATM, ATM actuales, count badge) | ✅ Dedicated sections in guard screen | ❌ Not present | 🔴 **MISSING** |
| **CROSS-INSTITUTION NOVEDADES** | | | |
| `vistanovedades_widget.dart` – browse novedades across all instituciones/sucursales with dropdown filters | ✅ Institution dropdown → sucursal dropdown → filtered novedad list | ❌ No equivalent screen | 🔴 **MISSING** |
| **ADMIN FEATURES** | | | |
| Admin dashboard (list instituciones + sucursales) | ✅ `inicio_administrador_widget.dart` + `SideNav02Widget` sidebar | ✅ `dashboard_screen.dart` sidebar + grid | ✅ Done |
| View bitácora per sucursal | ✅ Navigate: Sucursal → BitacorasWidget → detail | ✅ Click card → `bitacora_detail_screen.dart` | ✅ Done |
| Bitácora detail tabs (general, visits, novedades, vehicles) | ✅ Via `ClientedetalleWidget` and inline | ✅ 4-tab `BitacoraDetailScreen` | ✅ Done |
| **Proveedores in bitácora detail** | ✅ Visible in old widgets | ❌ Tab exists but no proveedores tab in detail screen | 🔴 **MISSING** |
| **SECURITY CHIEF (Jefe Seguridad) SCREEN** | | | |
| Dedicated dashboard with `FlutterFlowDataTable` | ✅ `inicio_jefe_seguridad_widget.dart` – data table of bitácoras, "All sucursales" view, navigate to Consolidado and Bitacoras | ❌ No Jefe Seguridad screen | 🔴 **MISSING** |
| DataTable of bitácoras across sucursales | ✅ Sortable, filterable | ❌ — | 🔴 **MISSING** |
| **SIDEBAR NAVIGATION** | | | |
| `side_nav02_widget.dart` – links to Sucursales, Consolidado, Sucursales/Proveedores, Profile, Logout | ✅ Full sidebar with icons, labels, navigation | ❌ No sidebar component; admin uses inline AppBar actions | 🟡 **PARTIAL** (AppBar has profile + logout only) |
| **CONSOLIDATED REPORT** | | | |
| `consolidadoo_widget.dart` – date picker, select sucursal, DataTable of bitácoras for date | ✅ Full consolidated view | ❌ No consolidado screen at all | 🔴 **MISSING** |
| **Excel/CSV export** (`exportBitacoraToExcel`) | ✅ Download button in consolidado | ❌ No export functionality | 🔴 **MISSING** |
| Date picker for report filtering | ✅ `showDatePicker` in consolidado | ❌ — | 🔴 **MISSING** |
| **SUCURSALES/PROVEEDORES MANAGEMENT** | | | |
| `sucursales_proveedores_widget.dart` – manage branches, guards, providers with CRUD modals | ✅ Opens edit/create modals for: agencias, vigilantes, proveedores | ❌ No management screen | 🔴 **MISSING** |
| **CRUD: New Vigilante** (nombre, cédula, teléfono, correo, contraseña, foto) | ✅ `cruds/new_vigilante/` | ❌ No screen | 🔴 **MISSING** |
| **CRUD: Edit Vigilante** | ✅ `cruds/edit_vigilante/` | ❌ No screen | 🔴 **MISSING** |
| **CRUD: New Entidad/Institución** (tipo, empresa, agencia, ubicación, actividad, foto) | ✅ `cruds/new_entidad/` | ❌ No screen | 🔴 **MISSING** |
| **CRUD: Edit Entidad** | ✅ `cruds/edit_entidad/` | ❌ No screen | 🔴 **MISSING** |
| **CRUD: New Agencia/Branch** (nombre, ubicación) | ✅ `cruds/new_agencia/` | ❌ TODO "Nueva Sucursal" button in dashboard | 🔴 **MISSING** |
| **CRUD: Edit Agencia** | ✅ `cruds/edit_agencia/` | ❌ No screen | 🔴 **MISSING** |
| **CRUD: Edit Proveedores** (empresa, actividad) | ✅ `cruds/edit_proveedores/` | ❌ No screen | 🔴 **MISSING** |
| **SUCURSAL → BITACORAS LIST** | ✅ `pages/sucursal/sucursal_widget.dart` – dropdown entidad, list sucursales, navigate to BitacorasWidget | ❌ No separate bitácoras-list screen (dashboard inlines it) | 🟡 **PARTIAL** |
| **PROFILE** | | | |
| View profile (photo, name, email, role) | ✅ `pages/profile/profile_widget.dart` | ✅ `shared/profile_screen.dart` | ✅ Done |
| Edit profile (photo upload, name change) | ✅ Photo upload + update user doc | ❌ "Edit Profile" is TODO stub | 🔴 **MISSING** |
| Sign out | ✅ Yes | ✅ Yes | ✅ Done |
| **SUPERVISION REPORT** | ✅ `components/supervision_reporte/` – photo upload + observation text, saves supervision data to bitácora | ❌ No supervision UI | 🔴 **MISSING** |
| **RELEVO (Guard Relief/Shift Change)** | | | |
| Relevo tab in guard screen | ✅ Dedicated "Relevos" tab with relevo status, "Salida del Vigilante" button | ❌ No relevo UI | 🔴 **MISSING** |
| Salida vigilante (exit confirmation dialog) | ✅ Dialog → calls `salidaVigilante` RPC, updates `salidaParcial`/`salidaTotal` flags | ❌ No such flow (embedded in CierreScreen's `finalizarTurno` only) | 🟡 **PARTIAL** |
| **RESPONSIVE / ADAPTIVE LAYOUT** | | | |
| Responsive breakpoints (mobile/tablet) | ✅ `responsiveVisibility()` throughout | ❌ Not implemented (fixed desktop-ish layout) | 🔴 **MISSING** |

---

## 3. SUPABASE SERVICE METHODS vs. SCREEN USAGE

### `BitacoraService` methods and their usage in NEW screens:

| Service Method | Used by NEW Screen? | Notes |
|---------------|--------------------|----|
| `streamBitacora(id)` | ✅ `BitacoraProvider` | Used internally |
| `getBitacora(id)` | ✅ `BitacoraDetailScreen` | |
| `createBitacora(bitacora)` | ✅ `BitacoraProvider.iniciarTurno` | |
| `updateBitacora(id, bitacora)` | ❌ **Not used by any screen** | No edit bitácora UI |
| `deleteBitacora(id)` | ❌ **Not used by any screen** | No delete bitácora UI |
| `streamInstituciones()` | ✅ `DashboardScreen`, `HomeGuardiaScreen` | |
| `getInstitucionesUsuario()` | ❌ **Not used by any screen** | User-filtered query not wired |
| `updateUserProfile(updates)` | ❌ **Not used by any screen** | Profile edit is TODO |
| `streamSucursales(instId)` | ✅ `DashboardScreen`, `HomeGuardiaScreen` | |
| `getSucursal(id)` | ❌ **Not used by any screen** | Available but unused |
| `llegadaVigilante(...)` | ✅ `BitacoraProvider` → `HomeGuardiaScreen` | |
| `salidaVigilante(...)` | ❌ **Not used by any NEW screen** | Old code referenced it; no relevo UI |
| `registrarApertura(...)` | ✅ `AperturaScreen` | |
| `registrarCierre(...)` | ✅ `CierreScreen` | |
| `addNovedad(novedad)` | ✅ `NovedadScreen` | |
| `addVisita(visita)` | ✅ `RegistroScreen` (Visitas tab) | |
| `addVehiculo(vehiculo)` | ✅ `RegistroScreen` (Vehículos tab) | |
| `addProveedorVisita(proveedor)` | ✅ `RegistroScreen` (Proveedores tab) | |
| `streamNovedades(bitacoraId)` | ✅ `NovedadScreen`, `BitacoraDetailScreen` | |
| `addAtm(bitacoraId, data)` | ❌ **Not used by any screen** | No ATM/cajero UI |
| `marcarSalidaVisita(id)` | ❌ **Not used by any screen** | No exit-marking UI |
| `marcarSalidaVehiculo(id)` | ❌ **Not used by any screen** | No exit-marking UI |
| `marcarSalidaProveedor(id)` | ❌ **Not used by any screen** | No exit-marking UI |
| `updateSupervision(id, data)` | ❌ **Not used by any screen** | No supervision UI |
| `updateRelevo(id, data)` | ❌ **Not used by any screen** | No relevo UI |
| `streamBitacoras(sucId)` | ❌ **Not used by any screen** | No bitácora history list |

**Summary: 11 of 27 service methods are unused by any NEW screen.**

---

## 4. PRIORITY MISSING FEATURES (sorted by impact)

### 🔴 Critical (core guard workflow gaps)

1. **Visitasall / Exit-Marking Screen** – Guards cannot mark visitor/vehicle/provider exits. 3 service methods (`marcarSalida*`) exist but have no UI.
2. **Partial vs Total Apertura/Cierre** – The old system had 4 separate screens (apertura parcial, apertura total, cierre parcial, cierre total) with different fields (encargado desalarmado/alarmado, encargado llaves). The new system merges everything into one generic screen.
3. **ATM/Cajero Registration** – No way to register ATM events. `addAtm` service exists unused.
4. **Relevo (Guard Relief)** – No UI for guard shift handoff. `salidaVigilante` and `updateRelevo` services exist unused.
5. **Forgot Password** – Button present but not functional.

### 🟠 High (admin/management gaps)

6. **Consolidated Report** – No screen to view all bitácoras by date with DataTable. No Excel export.
7. **CRUD Management** – No screens to create/edit vigilantes, entidades, agencias, or proveedores (7 CRUD screens missing).
8. **Sucursales/Proveedores Management Screen** – No equivalent to old management hub.
9. **Security Chief Dashboard** – No `InicioJefeSeguridad` equivalent.
10. **Cross-Institution Novedades Viewer** (`VistanovedadesWidget`) – No equivalent.

### 🟡 Medium (polish/UX gaps)

11. **Profile Edit** (photo upload, name change) – Stub only.
12. **Supervision Report** component – Not ported.
13. **Visit Detail Bottom Sheet** (`ClientedetalleWidget`) – No detail view for entries.
14. **Proveedores tab in BitacoraDetailScreen** – Missing 5th tab.
15. **Sidebar Navigation** – Admin only has AppBar icons; no full sidebar.
16. **Responsive breakpoints** – No mobile/tablet adaptation.
17. **Pertenencias (belongings) field** in visit registration – Missing from new form.
18. **Bitácora history list** per sucursal – `streamBitacoras` unused.

---

## 5. SUMMARY COUNTS

| Metric | Count |
|--------|-------|
| OLD screens/widgets total | 28 |
| NEW screens total | 10 |
| Features fully ported (✅) | 17 |
| Features partially ported (🟡) | 5 |
| Features completely missing (🔴) | 24 |
| Service methods implemented but unused | 11 of 27 |
