//+------------------------------------------------------------------+
//|                                                       sizing.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


double GetPipValue(){
  
  if(Digits >= 4)
  {
   return 0.0001;
  }
  return 0.01;
}



double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss)
{
   int maxLossInPips = MathAbs((entryPrice - stopLoss)/GetPipValue());
   return OptimalLotSize(maxLossInPips, maxRiskPrc);
}







double StopLossRange(string tradeType, double sl_atr_mul){

  double atrRange = iATR(NULL, 0, 14, 0);
  
  int pipValue = sl_atr_mul * (atrRange / GetPipValue());
  
  double pipLoss = NormalizeDouble(pipValue * GetPipValue(), Digits);
  if(tradeType == "sell"){
      return NormalizeDouble(Ask + pipLoss, Digits);
  }else if(tradeType == "buy")
          {
            return NormalizeDouble(Bid - pipLoss, Digits);
          }
          return 0.0;
   
}

double StopLossRangeTest(string tradeType, double atrRange, double price){
  
  int pipValue = 1.5 * (atrRange / GetPipValue());
  
  double pipLoss = NormalizeDouble(pipValue * GetPipValue(), Digits);
  if(tradeType == "sell"){
      return NormalizeDouble(price + pipLoss, Digits);
  }else if(tradeType == "buy")
          {
            return NormalizeDouble(price - pipLoss, Digits);
          }
          return 0.0;
   
}

double AlertLossLevel(string tradeType, double prc_atr_sl_al_level){

   double atrRange = iATR(NULL, 0, 14, 0);
  
  int pipValue = prc_atr_sl_al_level * (atrRange / GetPipValue());
  
  double pipLoss = NormalizeDouble(pipValue * GetPipValue(), Digits);
  if(tradeType == "sell"){
      return NormalizeDouble(Ask + pipLoss, Digits);
  }else if(tradeType == "buy")
    {
      return NormalizeDouble(Bid - pipLoss, Digits);
    }
    return 0.0;
}

double AlertHalfProfitLevel(string tradeType, double prc_atr_tp_al_level){

   double atrRange = iATR(NULL, 0, 14, 0);
  
  int pipValue = prc_atr_tp_al_level * (atrRange / GetPipValue());
  
  double pipLoss = NormalizeDouble(pipValue * GetPipValue(), Digits);
  if(tradeType == "sell"){
      return NormalizeDouble(Ask - pipLoss, Digits);
  }else if(tradeType == "buy")
    {
      return NormalizeDouble(Bid + pipLoss, Digits);
    }
    return 0.0;
}


double takeProfitRange(string tradeType, double pf_mul_atr){

   double atrRange = iATR(NULL, 0, 14, 0);
  
  int pipValue = pf_mul_atr * (atrRange / GetPipValue());
  
  double pipProfit = NormalizeDouble(pipValue * GetPipValue(), Digits);
  
  if(tradeType == "sell"){
      return NormalizeDouble(Ask - pipProfit, Digits);
  }else if(tradeType == "buy")
          {
            return NormalizeDouble(Bid + pipProfit, Digits);
          }
          return 0.0;
}

double takeProfitRangeTest(string tradeType, double atrRange, double price){
  
  int pipValue = (atrRange / GetPipValue());
  
  double pipProfit = NormalizeDouble(pipValue * GetPipValue(), Digits);
  
  if(tradeType == "sell"){
      return NormalizeDouble(price - pipProfit, Digits);
  }else if(tradeType == "buy")
          {
            return NormalizeDouble(price + pipProfit, Digits);
          }
          return 0.0;
}

double OptimalLotSize(int stopLoss, double m_riskPrc){

  double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
  double minLot = MarketInfo(Symbol(), MODE_MINLOT);
  double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
  double tick = MarketInfo(Symbol(), MODE_TICKVALUE);
  
  double maxLossDollar = AccountEquity() * m_riskPrc;
  double maxLossInQuoteCurr = maxLossDollar / tick;
  
   //double lotSize = AccountBalance() * m_riskPrc/(stopLoss * tick);
  double lotSize = maxLossInQuoteCurr * m_riskPrc/(stopLoss * tick);
  
  return MathMin(maxLot, MathMax(minLot, NormalizeDouble(lotSize / lotStep, 0) * lotStep));
}