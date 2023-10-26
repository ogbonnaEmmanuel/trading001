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
string sel_tradeType = "buy";
double price = Bid;
input int NumPipstopLoss = 30;
input int NumPipProfit = 100;
input double m_top_or_low_valley = 1.84849;

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
     double takeProfit =  ProfitRange(sel_tradeType, NumPipProfit);
     double stopLoss = StopRangeFrom(sel_tradeType, NumPipstopLoss, m_top_or_low_valley);
    double lotSize = OptimalLotSize(rsk_prc, price, stopLoss);

       if(executeTrade(sel_tradeType, lotSize, stopLoss, takeProfit))
      {
        Alert("Success");
      }else
         {
           Alert("Error unable to enter trade");
         }
   }     
//+------------------------------------------------------------------+
