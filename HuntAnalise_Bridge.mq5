//+------------------------------------------------------------------+
//|                                         HuntAnalise_Bridge       |
//|                                  Copyright 2024, Hunt Trading    |
//+------------------------------------------------------------------+
#property copyright "Hunt Trading"
#property link      "https://hunttrading.com"
#property version   "2.00"
#property strict

// Configurações do EA
input int      InpUpdateMinutes = 5;      // Frequência de atualização (minutos)
input string   InpPathBatch     = "C:\\HuntAnalise\\ABRIR_HUNT.bat";

// Globals
datetime lastUpdate = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   EventSetTimer(10); // Checa a cada 10 segundos se deve atualizar
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert timer function                                            |
//+------------------------------------------------------------------+
void OnTimer() {
   datetime now = TimeCurrent();
   
   // Verifica se já passou o tempo configurado
   if(now - lastUpdate >= InpUpdateMinutes * 60) {
      RunHuntAnalysis();
      lastUpdate = now;
   }
}

//+------------------------------------------------------------------+
//| Função principal de captura e envio                              |
//+------------------------------------------------------------------+
void RunHuntAnalysis() {
   string symbol = _Symbol;
   string tf = StringSubstr(EnumToString(_Period), 7);
   string price = DoubleToString(SymbolInfoDouble(symbol, SYMBOL_BID), _Digits);
   
   // Indicadores
   double rsi[]; ArraySetAsSeries(rsi, true);
   int hRsi = iRSI(symbol, _Period, 14, PRICE_CLOSE);
   CopyBuffer(hRsi, 0, 0, 1, rsi);
   
   double tenkan[], kijun[];
   ArraySetAsSeries(tenkan, true); ArraySetAsSeries(kijun, true);
   int hIchi = iIchimoku(symbol, _Period, 9, 26, 52);
   CopyBuffer(hIchi, 0, 0, 1, tenkan);
   CopyBuffer(hIchi, 1, 0, 1, kijun);
   
   // Screenshot
   string imgName = "hunt_shot.png";
   ChartScreenShot(0, imgName, 1200, 800, ALIGN_RIGHT);
   
   // URL com parâmetros
   string url = "file:///C:/HuntAnalise/hunt_analise.html";
   url += "?pair=" + symbol;
   url += "&tf=" + tf;
   url += "&price=" + price;
   url += "&rsi=" + DoubleToString(rsi[0], 1);
   url += "&tenkan=" + DoubleToString(tenkan[0], _Digits);
   url += "&kijun=" + DoubleToString(kijun[0], _Digits);
   
   // Tags Contexto (Exemplo simples)
   string ctx = "";
   if(rsi[0] > 70) ctx += "Sobrecompra, ";
   if(rsi[0] < 30) ctx += "Sobrevenda, ";
   if(tenkan[0] > kijun[0]) ctx += "Golden cross, ";
   
   url += "&ctx=" + ctx;

   // Executa o Batch para abrir o Chrome
   ShellExecuteW(0, "open", InpPathBatch, url, "", 1);
   
   Print("Hunt Análise: Dados enviados às ", TimeToString(now));
}

// Importação necessária para rodar o .bat
#import "shell32.dll"
int ShellExecuteW(int hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, int nShowCmd);
#import
