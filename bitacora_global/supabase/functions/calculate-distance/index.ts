// Supabase Edge Function: Calcular distancia entre dos puntos
// Ruta: supabase/functions/calculate-distance/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface DistanceRequest {
  lat1: number;
  lng1: number;
  lat2: number;
  lng2: number;
}

interface DistanceResponse {
  distanceMeters: number;
  distanceKm: number;
  isWithinRange: boolean;
  maxRangeMeters: number;
}

// Fórmula de Haversine para calcular distancia entre dos puntos geográficos
function haversineDistance(
  lat1: number,
  lng1: number,
  lat2: number,
  lng2: number
): number {
  const R = 6371000; // Radio de la Tierra en metros
  const dLat = toRadians(lat2 - lat1);
  const dLng = toRadians(lng2 - lng1);
  
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(lat1)) *
      Math.cos(toRadians(lat2)) *
      Math.sin(dLng / 2) *
      Math.sin(dLng / 2);
  
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  
  return R * c; // Distancia en metros
}

function toRadians(degrees: number): number {
  return degrees * (Math.PI / 180);
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { lat1, lng1, lat2, lng2 }: DistanceRequest = await req.json();

    // Validar parámetros
    if (
      typeof lat1 !== "number" ||
      typeof lng1 !== "number" ||
      typeof lat2 !== "number" ||
      typeof lng2 !== "number"
    ) {
      throw new Error("Coordenadas inválidas");
    }

    // Calcular distancia
    const distanceMeters = haversineDistance(lat1, lng1, lat2, lng2);
    const distanceKm = distanceMeters / 1000;
    
    // Rango máximo permitido (100 metros por defecto para verificar ubicación)
    const maxRangeMeters = 100;
    const isWithinRange = distanceMeters <= maxRangeMeters;

    const response: DistanceResponse = {
      distanceMeters: Math.round(distanceMeters * 100) / 100,
      distanceKm: Math.round(distanceKm * 1000) / 1000,
      isWithinRange,
      maxRangeMeters,
    };

    return new Response(JSON.stringify(response), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
