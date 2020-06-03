//+------------------------------------------------------------------+
//|                                               openordercheck.mqh |
//|                                       Copyright 2020, khantanvir |
//|                                      https://github.com/tanvird3 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, khantanvir"
#property link      "https://github.com/tanvird3"
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
// This function checks if there is any open order already by the same expert advisor by checking the magic nuber

bool CheckOpenOrder (int MyMagicNumber)
{
   int OpenOrder = OrdersTotal(); // checks total number of openorder 
   
   for (int i = 0; i < OpenOrder; i++) // loop through all the open order, picks data with OrderSelect and checks the magic nubmber of the order
   {
      if (OrderSelect(i, SELECT_BY_POS) == true) // if it succeeds to pull the data of ther order
      {
         if (OrderMagicNumber() == MyMagicNumber) // check the orders magic number
         {
            return true; // if the OrderMagicNumber of any order matches MyMagicNumber that means there is alreay an open order sent through this EA
         }
      }
   } 
   return false; // otherwise false and allow the EA to send new order
}

bool CheckMarketOpen ()
{
   if(IsTradeAllowed()) 
   {
      return true; 
   }
   else
   {
      return false; 
   }
   
}