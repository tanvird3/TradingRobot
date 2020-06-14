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
input ENUM_APPLIED_PRICE MyPrice = PRICE_CLOSE; // what price do we want to consider
input double LotSize = 0.10; // the lot size we wish to trade
input int TenKanSen = 9;
input int KijunSen = 26;
input int SenKouSpanB = 52;
input int TakeProfit = 5;
input int StopLoss = .2;

input string ContUpdate = "Yes"; // Should TP & SL Keep Updating Continuously

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MagicNumber = 5000+Period()+StringGetChar(MySymbol, 0)+StringGetChar(MySymbol, 3); //set the unique number for each comb of currency pair and timeframe
int OrderId;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Alert("You Have Just Awakened SuperMaoIchiMoku");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Alert("SuperMaoIchiMoku Is Going Into Hybernation");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

// Set the Ichimoku Properties
   double tenkan_sen = iIchimoku(NULL,0,TenKanSen,KijunSen,SenKouSpanB,MODE_TENKANSEN,0);
   double kinjun_sen = iIchimoku(NULL,0,TenKanSen,KijunSen,SenKouSpanB,MODE_KIJUNSEN,0);
   double senkou_spanA = iIchimoku(NULL,0,TenKanSen,KijunSen,SenKouSpanB,MODE_SENKOUSPANA,0);
   double senkou_spanB = iIchimoku(NULL,0,TenKanSen,KijunSen,SenKouSpanB,MODE_SENKOUSPANB,0);

// if there is no order only then a new order would be sent
   if(!CheckOpenOrder(MagicNumber))
     {
      if(tenkan_sen > kinjun_sen && Close[0] > MathMin(senkou_spanA, senkou_spanB)) //if tenken_sen is above kinjun_sen and Close is within or above the cloud go long
        {
         Alert("Buy Now at "+ NormalizeDouble(Ask, Digits));
         Alert("Take Proft at "+ NormalizeDouble(Ask+ Ask * TakeProfit/100, Digits)); // primary take profit is set at the designated level
         //Alert("Stop Loss at "+ NormalizeDouble(MathMin(senkou_spanA, senkou_spanB), Digits));
         Alert("Stop Loss at "+ NormalizeDouble(Ask - Ask * TakeProfit/100, Digits)); // stop loss is set at the designated level
         OrderId = OrderSend(MySymbol, OP_BUYLIMIT, LotSize, Ask, 10, NormalizeDouble(Ask - Ask * TakeProfit/100, Digits), NormalizeDouble(Ask+ Ask * TakeProfit/100, Digits), NULL, MagicNumber);
         if(OrderId < 0)
            Alert("The Order Could Not Be Sent, ErrorCode: " + GetLastError());
        }
      else
         if(tenkan_sen < kinjun_sen && Close[0] < MathMax(senkou_spanA, senkou_spanB)) //if tenken_sen is below kinjun_sen and Close is within or below the cloud go short
           {
            Alert("Sell Now at "+ NormalizeDouble(Bid, Digits));
            Alert("Take Proft at "+ NormalizeDouble(Bid-Bid * TakeProfit/100, Digits));
            //Alert("Stop Loss at "+ NormalizeDouble(MathMax(senkou_spanA, senkou_spanB),Digits));
            Alert("Stop Loss at "+ NormalizeDouble(Bid+Bid * TakeProfit/100, Digits));
            OrderId = OrderSend(MySymbol, OP_SELLLIMIT, LotSize, Bid, 10, NormalizeDouble(Bid+Bid * TakeProfit/100, Digits), NormalizeDouble(Bid-Bid * TakeProfit/100, Digits), NULL, MagicNumber);
            if(OrderId < 0)
               Alert("The Order Could Not Be Sent, ErrorCode: " + GetLastError());
           }
      /*else
        {
         Alert("Hold Your Nerve");
        }*/
     }
   else // if an order has already been placed
     {
      if(ContUpdate=="Yes")
        {
         if(OrderSelect(OrderId, SELECT_BY_TICKET)==true) // check if extracting data is possible
           {
            int orderType = OrderType(); // check the ordertype, 0 = long, 1 = short
            double UpdatedTakeProfit;
            if(orderType == 0)
              {
               if(tenkan_sen < kinjun_sen) // if the tenken_sen has come below kinjun_sen sell 
                 {
                  UpdatedTakeProfit = NormalizeDouble(Bid, Digits); // modify the take profit for long position i.e. sell at current bid
                 }
              }
            else
              {
               if(tenkan_sen > kinjun_sen) // if the tenken_sen has gone above kinjun_sen
                 {
                  UpdatedTakeProfit = NormalizeDouble(Ask, Digits); // modify the take profit for short position ie buy at current ask
                 }
              }
            double TP = OrderTakeProfit();
            double OpenPrice = OrderOpenPrice();
            double TPdistance = MathAbs(TP - UpdatedTakeProfit);
            if((orderType==0 && TP!=UpdatedTakeProfit && UpdatedTakeProfit > OpenPrice && TPdistance >= .0001) || (orderType==1 && TP!=UpdatedTakeProfit && UpdatedTakeProfit < OpenPrice && TPdistance >= .0001)) // if the currect take profit is not equal to the updated take profit by at least a pip
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
        }
     }
  }
//+------------------------------------------------------------------+
