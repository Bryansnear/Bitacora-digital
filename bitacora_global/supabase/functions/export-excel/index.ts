// Supabase Edge Function: Exportar Bitácora a Excel
// Ruta: supabase/functions/export-excel/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as XLSX from "https://cdn.sheetjs.com/xlsx-0.20.1/package/xlsx.mjs";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface ExportRequest {
  fecha: string; // ISO date string
  institucion_id: string;
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Crear cliente Supabase con el token del usuario
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      {
        global: {
          headers: { Authorization: req.headers.get("Authorization")! },
        },
      },
    );

    // Obtener parámetros
    const { fecha, institucion_id }: ExportRequest = await req.json();

    // Calcular rango del día
    const targetDate = new Date(fecha);
    const startOfDay = new Date(targetDate);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(targetDate);
    endOfDay.setHours(23, 59, 59, 999);

    // Consultar bitácoras
    const { data: bitacoras, error } = await supabaseClient
      .from("bitacoras")
      .select("*")
      .eq("institucion_id", institucion_id)
      .gte("fecha_hora_apertura", startOfDay.toISOString())
      .lte("fecha_hora_apertura", endOfDay.toISOString())
      .order("fecha_hora_apertura", { ascending: true });

    if (error) {
      throw new Error(`Error consultando bitácoras: ${error.message}`);
    }

    if (!bitacoras || bitacoras.length === 0) {
      return new Response(
        JSON.stringify({
          error: "No hay registros para la fecha seleccionada",
        }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        },
      );
    }

    // Formatear datos para Excel
    const formatTime = (dt: string | null): string => {
      if (!dt) return "";
      return new Date(dt).toLocaleTimeString("es-EC", {
        hour: "2-digit",
        minute: "2-digit",
      });
    };

    const formatDate = (dt: string | null): string => {
      if (!dt) return "";
      return new Date(dt).toLocaleDateString("es-EC");
    };

    const excelData = bitacoras.map((b) => ({
      Fecha: formatDate(b.fecha_hora_apertura),
      Sucursal: b.sucursal || "",
      Vigilante: b.vigilante_apertura || "",
      Llegada: formatTime(b.hora_llegada_vigilante),
      "Apertura Parcial": formatTime(b.fecha_hora_apertura),
      "Apertura Total": formatTime(b.hora_apertura_total),
      "Llegada Cajeros": formatTime(b.hora_llegada_cajeros),
      "Llegada Oficinas": formatTime(b.hora_llegada_oficinas),
      "Atención Público Cajeros": formatTime(b.hora_atencion_publico_cajeros),
      "Cierre Parcial": formatTime(b.fecha_hora_cierre),
      "Cierre Total": formatTime(b.hora_cierre_total),
      Salida: formatTime(b.hora_salida_vigilante),
      Estado: b.hora_salida_vigilante ? "Cerrado" : "Abierto",
      Novedades: Array.isArray(b.novedades) ? b.novedades.length : 0,
      Visitas: Array.isArray(b.visitas) ? b.visitas.length : 0,
      Vehículos: Array.isArray(b.vehiculos) ? b.vehiculos.length : 0,
    }));

    // Crear libro Excel
    const wb = XLSX.utils.book_new();
    const ws = XLSX.utils.json_to_sheet(excelData);

    // Ajustar anchos de columna
    const colWidths = [
      { wch: 12 }, // Fecha
      { wch: 20 }, // Sucursal
      { wch: 20 }, // Vigilante
      { wch: 10 }, // Llegada
      { wch: 15 }, // Apertura Parcial
      { wch: 15 }, // Apertura Total
      { wch: 15 }, // Llegada Cajeros
      { wch: 15 }, // Llegada Oficinas
      { wch: 22 }, // Atención Público
      { wch: 15 }, // Cierre Parcial
      { wch: 12 }, // Cierre Total
      { wch: 10 }, // Salida
      { wch: 10 }, // Estado
      { wch: 10 }, // Novedades
      { wch: 10 }, // Visitas
      { wch: 10 }, // Vehículos
    ];
    ws["!cols"] = colWidths;

    XLSX.utils.book_append_sheet(wb, ws, "Bitácora");

    // Generar archivo
    const buffer = XLSX.write(wb, { type: "buffer", bookType: "xlsx" });

    // Retornar archivo
    const filename = `bitacora_${fecha.replace(/-/g, "")}.xlsx`;

    return new Response(buffer, {
      headers: {
        ...corsHeaders,
        "Content-Type":
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "Content-Disposition": `attachment; filename="${filename}"`,
      },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
