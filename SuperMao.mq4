//+------------------------------------------------------------------+
//|                                                      SuperMao.mq4 |
//|                                        Copyright 2020, khantanvir |
//|                                       https://github.com/tanvird3 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, khantanvir"
#property link      "https://github.com/tanvird3"
#property version   "2.00"
#property strict
#include <openordercheck.mqh>

input string MySymbol = NULL; // provide the symbol
input ENUM_TIMEFRAMES MyTimeFrame = PERIOD_CURRENT; // For per minute, hour or monthly
input int MyAvgPeriod = 50; // time frame for calculating moving average
input ENUM_APPLIED_PRICE MyPrice = PRICE_CLOSE; // what price do we want to consider
input double LotSize = 0.01; // the lot size we wish to trade
input int FirstBBand = 1;
input int SecondBBand = 2;
input int ThirdBBand = 6;
input int MacdFast = 25;
input int MacdSlow = 52;
input int MacdSignal = 18;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
   double UBBAND1 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, FirstBBand, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND1 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, FirstBBand, 0, MyPrice, MODE_LOWER, 0);

// second band is at 2 std
   double UBBAND2 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, SecondBBand, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND2 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, SecondBBand, 0, MyPrice, MODE_LOWER, 0);
   double MBBAND = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, SecondBBand, 0, MyPrice, MODE_MAIN, 0);

// third band is at 6 std
   double UBBAND6 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, ThirdBBand, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND6 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, ThirdBBand, 0, MyPrice, MODE_LOWER, 0);

// macd histogram value for confirmation
   double MACDMAIN = iMACD(MySymbol, MyTimeFrame, MacdFast, MacdSlow, MacdSignal, MyPrice, MODE_MAIN, 0);
   double MACDSIGNAL = iMACD(MySymbol, MyTimeFrame, MacdFast, MacdSlow, MacdSignal, MyPrice, MODE_SIGNAL, 0);

// if there is no order only then a new order would be sent
   if(!CheckOpenOrder(MagicNumber))
     {
      if(Ask >= LBBAND2 && Ask < UBBAND1 && MACDMAIN > MACDSIGNAL) //if price is between lower band 2 and upper band 1 and macd line above macd signal go long
        {

         Alert("Buy Now at "+ NormalizeDouble(Ask, Digits));
         Alert("Take Proft at "+ NormalizeDouble(UBBAND1, Digits));
         Alert("Stop Loss at "+ NormalizeDouble(LBBAND6, Digits));
         OrderId = OrderSend(MySymbol, OP_BUYLIMIT, LotSize, Ask, 10, NormalizeDouble(LBBAND6, Digits), NormalizeDouble(UBBAND1, Digits), NULL, MagicNumber);
         if(OrderId < 0)
            Alert("The Order Could Not Be Sent, ErrorCode: " + GetLastError());
        }
      else
         if(Bid <= UBBAND2 && Bid > LBBAND1 && MACDMAIN < MACDSIGNAL) //if price is between upper band 2 and lower band 1 and macd below signal go short
           {
            Alert("Sell Now at "+ NormalizeDouble(Bid, Digits));
            Alert("Take Proft at "+ NormalizeDouble(LBBAND1, Digits));
            Alert("Stop Loss at "+ NormalizeDouble(UBBAND6, Digits));
            OrderId = OrderSend(MySymbol, OP_SELLLIMIT, LotSize, Bid, 10, NormalizeDouble(UBBAND6, Digits), NormalizeDouble(LBBAND1, Digits), NULL, MagicNumber);
            if(OrderId < 0)
               Alert("The Order Could Not Be Sent, ErrorCode: " + GetLastError());
           }
      /*else
        {
         Alert("Hold Your Nerve");
        }*/
     }
   /*else // if an order has already been placed
     {
      if(OrderSelect(OrderId, SELECT_BY_TICKET)==true) // check if extracting data is possible
        {
         int orderType = OrderType(); // check the ordertype, 0 = long, 1 = short
         double UpdatedTakeProfit;
         if(orderType == 0)
           {
            UpdatedTakeProfit = NormalizeDouble(UBBAND1, Digits); // modify the take profit for long position
           }
         else
           {
            UpdatedTakeProfit = NormalizeDouble(LBBAND1, Digits); // modify the take profit for short position
           }
         double TP = OrderTakeProfit();
         double OpenPrice = OrderOpenPrice();
         double TPdistance = MathAbs(TP - UpdatedTakeProfit);
         if((orderType ==0 && TP!=UpdatedTakeProfit && UpdatedTakeProfit > OpenPrice && TPdistance >= .0001) || (orderType ==1 && TP!=UpdatedTakeProfit && UpdatedTakeProfit < OpenPrice && TPdistance >= .0001)) // if the currect take profit is not equal to the updated take profit by at least a pip
           {
            bool ModifySuccess = OrderModify(OrderId, OrderOpenPrice(), OrderStopLoss(), UpdatedTakeProfit, 0);
            if(ModifySuccess == true)
              {
               Print("Order modified: ",OrderId);
              }
            else
              {
               Print("Unable to modify order: ",OrderId);
              }
           }
        }
     }*/
  }
//+------------------------------------------------------------------+
