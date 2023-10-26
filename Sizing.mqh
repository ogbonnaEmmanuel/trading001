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



double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss, double MyMinLot=0.1)
{
   int maxLossInPips = MathAbs((entryPrice - stopLoss)/GetPipValue());
   return OptimalLotSize(maxLossInPips, maxRiskPrc, MyMinLot);
}


double StopRange(string tradeType, int stopPips){

  double pips = stopPips * GetPipValue();
  
  if(tradeType == "sell"){
      return NormalizeDouble(Ask + pips, Digits);
  }else if(tradeType == "buy")
          {
            return NormalizeDouble(Bid - pips, Digits);
          }
          return 0.0;
   
}

double StopRangeFrom(string tradeType, int stopPips, double top_or_low_valley){

  double pips = stopPips * GetPipValue();
  
  if(tradeType == "sell"){
      return NormalizeDouble(top_or_low_valley + pips, Digits);
  }else if(tradeType == "buy")
          {
            return NormalizeDouble(top_or_low_valley - pips, Digits);
          }
          return 0.0;
   
}

double CalculateATRTakeProfit(string tradeDirection)
{
    double atrValue = iATR(Symbol(), 0, 14, 0);
    double tp;

    if (tradeDirection == "buy")
    {
        tp = NormalizeDouble(Bid + (atrValue * 1.5), Digits);
    }
    else if (tradeDirection == "sell")
    {
        tp = NormalizeDouble(Ask - (atrValue * 1.5), Digits);
    }
    else
    {
        Print("Invalid trade direction. Use OP_BUY or OP_SELL.");
        tp = 0;
    }

    return(tp);
}

double CalculateATRStopLoss(string tradeDirection)
{
    double atrValue = iATR(Symbol(), 0, 14, 0);
    double stopLoss;

    if (tradeDirection == "buy")
    {
        stopLoss = NormalizeDouble(Bid - (atrValue * 2), Digits);
    }
    else if (tradeDirection == "sell")
    {
        stopLoss = NormalizeDouble(Ask + (atrValue * 2), Digits);
    }
    else
    {
        Print("Invalid trade direction. Use OP_BUY or OP_SELL.");
        stopLoss = 0;
    }

    return(stopLoss);
}



double ProfitRange(string tradeType, int numPips = 30){

double pips = numPips * GetPipValue();

if(tradeType == "buy"){
      return NormalizeDouble(Ask + pips, Digits);
  }else if(tradeType == "sell")
          {
            return NormalizeDouble(Bid - pips, Digits);
          }
          return 0.0;
}


double OptimalLotSize(int stopLoss, double m_riskPrc, double MyMinLot=0.1, bool notAtr=true){

  double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
  double minLot = MarketInfo(Symbol(), MODE_MINLOT);
  double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
  double tick = MarketInfo(Symbol(), MODE_TICKVALUE);
  
  double maxLossDollar = AccountEquity() * m_riskPrc;
  double maxLossInQuoteCurr = maxLossDollar / tick;
  
   //double lotSize = AccountBalance() * m_riskPrc/(stopLoss * tick);
  double lotSize = maxLossInQuoteCurr * m_riskPrc/(stopLoss * tick);
  
  double lot =  MathMin(maxLot, MathMax(minLot, NormalizeDouble(lotSize / lotStep, 0) * lotStep));
  if(lot < MyMinLot && notAtr)
    {
      return MyMinLot;
    }
    return lot;
}