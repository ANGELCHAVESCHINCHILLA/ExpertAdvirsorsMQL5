//+------------------------------------------------------------------+
//|                                         BasicHarmonicPattern.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <TradeManager.mqh>  // Clase para manejar las operaciones
#include <PatternAnalyzer.mqh> // Clase para manejar el análisis de patrones

//--- Configuración del EA
// Máximo porcentaje del balance a arriesgar por cada trade
input double MaxLoss = 0.02;
// Mínimo lotaje permitido para el activo en cuestión o el mínimo lotaje deseado por trade
input double MinLotSize = 0.1;
// Número Magic del EA
input ulong Magic = 1305;
// Relación mínima de beneficio con respecto al riesgo que deba tener el TP1 de cada señal generada por el BHP
input double MinRR = 1.0;

//--- Objetos principales
CTradeManager tradeManager;
CPatternAnalyzer patternAnalyzer;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   if (!patternAnalyzer.Initialize("Market//Basic Harmonic Pattern MT5", Magic)) {
      Print("Error al inicializar el analizador de patrones.");
      return INIT_FAILED;
   }
   tradeManager.SetParameters(MaxLoss, MinLotSize, MinRR);
   Print("EA inicializado correctamente.");
   return INIT_SUCCEEDED;
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   Print("EA desactivado. Razón: ", reason);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   if (PositionsTotal() == 0) {
      // Detectar nuevas señales de patrones
      STradeSignal signal = patternAnalyzer.GetTradeSignal();
      if (signal.IsValid()) {
         tradeManager.OpenTrade(signal);
      }
   } else {
      // Aplicar trailing stop dinámico si hay posiciones abiertas
      tradeManager.ApplyDynamicTrailingStop();
   }
}