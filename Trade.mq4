//+------------------------------------------------------------------+
//|                                                        Trade.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <sizing.mqh>
#include <Transactions.mqh>
#property script_show_inputs
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
enum m_sel_tradeType {
   buy = 1,
   sell = 0,
};

input m_sel_tradeType usr_trade = buy;
input double rsk_prc = 0.02;
input double MyDesiredLotSize = 0.2;
input int FirstNumProfit = 20;
input int StopLossPip = 10;
string sel_tradeType = "buy";
double price = Bid;
input double MaximumSpread = 3.0;

void OnStart()
  {
//---
   if(usr_trade == 1)
     {
       sel_tradeType = "buy";
     }else if(usr_trade == 0)
             {
               sel_tradeType = "sell";
               price = Ask;
             }
     double stopLossValue = StopRange(sel_tradeType, StopLossPip);
     double takeProfit =  ProfitRange(sel_tradeType, FirstNumProfit);
    double lotSize = OptimalLotSize(rsk_prc, price, stopLossValue, MyDesiredLotSize);
    double spread = (Ask - Bid)/ GetPipValue();
    if(spread < MaximumSpread)
      {
          if(executeTrade(sel_tradeType, lotSize, stopLossValue, takeProfit))
         {
           Alert("Success");
         }else
            {
              Alert("Error unable to enter trade");
            }
      }else
         {
           Alert("Spread is too high");
         }      
  }
//+------------------------------------------------------------------+
