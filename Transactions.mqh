//+------------------------------------------------------------------+
//|                                                 Transactions.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <Sizing.mqh>







bool executeTrade(string m_tradeType, double lot, double stopLoss, double m_take_profit){

int ticket;

if(m_tradeType == "buy"){

ticket=OrderSend(Symbol(),OP_BUY,lot,Ask,3,stopLoss,m_take_profit,"My order",16384,0,clrGreen);


}else if(m_tradeType == "sell")
        {
          
          ticket=OrderSend(Symbol(),OP_SELL,lot,Bid,3,stopLoss,m_take_profit,"My order",16384,0,clrGreen);
        }
   if(ticket<0)
     {
      Print("OrderSend failed with error #",GetLastError());
      return false;
     }
   Print("OrderSend placed successfully");
   return true;
}


bool closeTrade(){

  string m_symbol = Symbol();
  
 int slippage = 3;
    
    if(Digits ==3 || Digits ==5)
      {
        slippage = slippage * 10;
      }
      
     for(int i=OrdersTotal() - 1; i>=0; i--)
       {
          if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
               double ClosePrice;
               RefreshRates();
               if(OrderType() == OP_BUY) ClosePrice = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID), Digits);
               if(OrderType() == OP_SELL) ClosePrice = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), Digits);
               
               if(OrderClose(OrderTicket(), OrderLots(), ClosePrice, slippage, clrBlue))
                     {
                        Print("successfully closed");
                        return true;
                     }else
                     {
                        Print("unable to close order");
                        return false;
                    }
       
            }
       }
       return false;
}



