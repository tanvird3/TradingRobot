//+------------------------------------------------------------------+
//|                                           TakeProfitStopLoss.mqh |
//|                                       Copyright 2020, khantanvir |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, khantanvir"
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
double TPLong(string MySymbol, double LotSize, double ProfitTarget)
  {
//---
   string QuoteCurrency = StringSubstr(MySymbol, 3);
   string BaseCurrency = StringSubstr(MySymbol, 0, 3);

   double TP;

   if(QuoteCurrency == "USD")
     {
      double TradingUSD = Ask;
      TP = TradingUSD + 1 / (100000 * LotSize) * ProfitTarget;
     }
   else
      if(BaseCurrency == "USD")
        {
         double TradingUSD = 1;
         TP = (TradingUSD + 1 / (100000 * LotSize) * 1) * Ask;
        }
      else
        {
         double TradingUSD = MarketInfo("USD"+QuoteCurrency, MODE_ASK);
         if(TradingUSD == 0)
           {
            TradingUSD = 1 / MarketInfo(QuoteCurrency+"USD", MODE_ASK);
           }
         TP = (Ask / TradingUSD + 1 / (100000 * LotSize) * ProfitTarget) * TradingUSD ;
        }
   return (TP);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TPShort(string MySymbol, double LotSize, double ProfitTarget)
  {
//---
   string QuoteCurrency = StringSubstr(MySymbol, 3);
   string BaseCurrency = StringSubstr(MySymbol, 0, 3);

   double TP;

   if(QuoteCurrency == "USD")
     {
      double TradingUSD = Bid;
      TP = TradingUSD - 1 / (100000 * LotSize) * ProfitTarget;
     }
   else
      if(BaseCurrency == "USD")
        {
         double TradingUSD = 1;
         TP = (TradingUSD - 1 / (100000 * LotSize) * 1) * Bid;
        }
      else
        {
         double TradingUSD = MarketInfo("USD"+QuoteCurrency, MODE_BID);
         if(TradingUSD == 0)
           {
            TradingUSD = 1 / MarketInfo(QuoteCurrency+"USD", MODE_BID);
           }
         TP = (Bid / TradingUSD - 1 / (100000 * LotSize) * ProfitTarget) * TradingUSD ;
        }
   return (TP);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SLLong(string MySymbol, double LotSize, double StopLoss)
  {
//---
   string QuoteCurrency = StringSubstr(MySymbol, 3);
   string BaseCurrency = StringSubstr(MySymbol, 0, 3);

   double SL;

   if(QuoteCurrency == "USD")
     {
      double TradingUSD = Ask;
      SL = TradingUSD - 1 / (100000 * LotSize) * StopLoss;
     }
   else
      if(BaseCurrency == "USD")
        {
         double TradingUSD = 1;
         SL = (TradingUSD - 1 / (100000 * LotSize) * StopLoss) * Ask;
        }
      else
        {
         double TradingUSD = MarketInfo("USD"+QuoteCurrency, MODE_ASK);
         if(TradingUSD == 0)
           {
            TradingUSD = 1 / MarketInfo(QuoteCurrency+"USD", MODE_ASK);
           }
         SL = (Ask / TradingUSD - 1 / (100000 * LotSize) * StopLoss) * TradingUSD ;
        }
   return (SL);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SLShort(string MySymbol, double LotSize, double StopLoss)
  {
//---
   string QuoteCurrency = StringSubstr(MySymbol, 3);
   string BaseCurrency = StringSubstr(MySymbol, 0, 3);

   double SL;

   if(QuoteCurrency == "USD")
     {
      double TradingUSD = Bid;
      SL = TradingUSD + 1 / (100000 * LotSize) * StopLoss;
     }
   else
      if(BaseCurrency == "USD")
        {
         double TradingUSD = 1;
         SL = (TradingUSD + 1 / (100000 * LotSize) * StopLoss) * Bid;
        }
      else
        {
         double TradingUSD = MarketInfo("USD"+QuoteCurrency, MODE_BID);
         if(TradingUSD == 0)
           {
            TradingUSD = 1 / MarketInfo(QuoteCurrency+"USD", MODE_BID);
           }
         SL = (Bid / TradingUSD + 1 / (100000 * LotSize) * StopLoss) * TradingUSD ;
        }
   return (SL);
  }
//+------------------------------------------------------------------+
