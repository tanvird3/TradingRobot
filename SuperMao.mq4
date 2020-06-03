//+------------------------------------------------------------------+
//|                                                      SuperMao.mq4 |
//|                                        Copyright 2020, khantanvir |
//|                                       https://github.com/tanvird3 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, khantanvir"
#property link      "https://github.com/tanvird3"
#property version   "1.00"
#property strict
#include <openordercheck.mqh>

input string MySymbol = "EURUSD"; // provide the symbol
input ENUM_TIMEFRAMES MyTimeFrame = PERIOD_M1; // For per minute, hour or monthly
input int MyAvgPeriod = 20; // time frame for calculating moving average
input ENUM_APPLIED_PRICE MyPrice = PRICE_CLOSE; // what price do we want to consider
input double LotSize = 0.01; // the lot size we wish to trade

int MagicNumber = 9228+Period()+StringGetChar(MySymbol, 0)+StringGetChar(MySymbol, 3); //set the unique number for each comb of currency pair and timeframe
int OrderId;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Alert("You Have Just Awakened Super Mao");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Alert("Super Mao Is Going Into Hybernation");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

// first band is at 1 std
   double UBBAND1 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, 1, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND1 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, 1, 0, MyPrice, MODE_LOWER, 0);

// first band is at 2 std
   double UBBAND2 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, 2, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND2 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, 2, 0, MyPrice, MODE_LOWER, 0);
   double MBBAND = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, 2, 0, MyPrice, MODE_MAIN, 0);

// second band is at 4 std
   double UBBAND4 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, 4, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND4 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, 4, 0, MyPrice, MODE_LOWER, 0);

// macd histogram value for confirmation
   double MACDMAIN = iMACD(MySymbol, MyTimeFrame, 12, 26, 9, MyPrice, MODE_MAIN, 0);
   double MACDSIGNAL = iMACD(MySymbol, MyTimeFrame, 12, 26, 9, MyPrice, MODE_SIGNAL, 0);

// if there is no order only then a new order would be sent
   if(!CheckOpenOrder(MagicNumber))
     {
      if(Ask >= LBBAND2 && Ask <= LBBAND1 && MACDMAIN > MACDSIGNAL) //if price is between lower band 1 and 2 and macd line above macd signal go long
        {

         Alert("Buy Now at "+ NormalizeDouble(Ask, Digits));
         Alert("Take Proft at "+ NormalizeDouble(MBBAND, Digits));
         Alert("Stop Loss at "+ NormalizeDouble(LBBAND4, Digits));
         OrderId = OrderSend(MySymbol, OP_BUYLIMIT, LotSize, Ask, 10, NormalizeDouble(LBBAND4, Digits), NormalizeDouble(MBBAND, Digits), NULL, MagicNumber);
         if(OrderId < 0)
            Alert("The Order Could Not Be Sent, ErrorCode: " + GetLastError());
        }
      else
         if(Bid <= UBBAND2 && Bid >= UBBAND1 && MACDMAIN < MACDSIGNAL) //if price is between upper band 1 and 2 and macd below signal go short
           {
            Alert("Sell Now at "+ NormalizeDouble(Bid, Digits));
            Alert("Take Proft at "+ NormalizeDouble(MBBAND, Digits));
            Alert("Stop Loss at "+ NormalizeDouble(UBBAND4, Digits));
            OrderId = OrderSend(MySymbol, OP_SELLLIMIT, LotSize, Bid, 10, NormalizeDouble(UBBAND4, Digits), NormalizeDouble(MBBAND, Digits), NULL, MagicNumber);
            if(OrderId < 0)
               Alert("The Order Could Not Be Sent, ErrorCode: " + GetLastError());
           }
      /*else
        {
         Alert("Hold Your Nerve");
        }*/
     }
  }
