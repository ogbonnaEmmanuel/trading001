//+------------------------------------------------------------------+
//|                                            SavePriceData.mq4       |
//|                        Copyright 2023, Your Company Name        |
//|                                       http://www.yourcompany.com |
//+------------------------------------------------------------------+
#property strict

// Define the number of bars to save
input int numberOfBarsToSave = 100;

// Define a structure to represent a bar
struct BarData
{
   int Bar;
   double Open;
   double High;
   double Low;
   double Close;
};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Initialize an array to store price data as objects
   BarData priceData[];
   ArrayResize(priceData, numberOfBarsToSave);

   // Iterate through the bars and collect price data
   for (int i = 0; i < numberOfBarsToSave; i++)
   {
      priceData[i].Bar = i;
      priceData[i].Open = iOpen(Symbol(), Period(), i);
      priceData[i].High = iHigh(Symbol(), Period(), i);
      priceData[i].Low = iLow(Symbol(), Period(), i);
      priceData[i].Close = iClose(Symbol(), Period(), i);
   }

   // Convert the array of objects to a JSON string
   string jsonData = "[";
   for (int j = 0; j < ArraySize(priceData); j++)
   {
      jsonData += StringFormat("{\"Bar\":%d,\"Open\":%.5f,\"High\":%.5f,\"Low\":%.5f,\"Close\":%.5f}", priceData[j].Bar, priceData[j].Open, priceData[j].High, priceData[j].Low, priceData[j].Close);
      if (j < ArraySize(priceData) - 1)
         jsonData += ",";
   }
   jsonData += "]";

   // Save JSON data to a file
   string fileName = "PriceData.json";
   int fileHandle = FileOpen(fileName, FILE_WRITE | FILE_TXT);
   if (fileHandle != INVALID_HANDLE)
   {
      FileWriteString(fileHandle, jsonData);
      FileClose(fileHandle);
      Print("Price data saved to ", fileName);
   }
   else
   {
      Print("Error opening file ", fileName, " for writing!");
   }

   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Deinitialization code here, if necessary
}
//+------------------------------------------------------------------+
