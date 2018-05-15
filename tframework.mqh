//+------------------------------------------------------------------+
//| MQL5 Framework (TFK Framework)
//|
//| This file contains all the predefined functions to
//| develop rapidly any type of trading algorithms for
//| prototyping and increase our ability to test and deploy
//| systems faster.
//|
//| To use this library, make sure this file: tframework.mqh
//| is in the include directory and declared
//| #include <tframework.mqh>
//|
//|           ******************************************
//|           SAVE THIS FILE AS tframework.mqh
//|           file should be placed in folder include
//|           ******************************************
//|
//+------------------------------------------------------------------+
/*
* Licensed under The MIT License
* Copyright 2018 Taatu Ltd. 27 Old Gloucester Street, London, WC1N 3AX, UK (http://taatu.co)
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software
* and associated documentation files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge, publish, distribute,
* sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
* is furnished to do so, subject to the following conditions:
* The above copyright notice and this permission notice shall be included in all copies
* or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
* FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
#property copyright "Copyright © 2018"
string framework_version="0.1";
string Company  =   "Taatu Ltd.";
string System   =   "TFK - Framework";
//+------------------------------------------------------------------+
//| LIBRARIES
//+------------------------------------------------------------------+
#include <trade\trade.mqh>
#include <Files\File.mqh>
#include <Files\FileTxt.mqh>
CTrade trade;
//+------------------------------------------------------------------+
//| TAATU FRAMEWORK
//+------------------------------------------------------------------+
/*
FRAMEWORK INITIALIZATION
------------------------
void tfk_run_taatu_framework()

TRADE EXECUTION AND MANAGEMENT
-------------------------------
void tfk_execute_trade()
void tfk_close_trade()
double tfk_lotSize()
int tfk_lotSize_multiplier()
double tfk_stopLoss_dollarAmount()
double tfk_target_dollarAmount()
double tfk_profit_loss()
int tfk_count_active_trades()
bool tfk_exists_trade()
double tfk_position_info()
void tfk_grid_trades()
void tfk_addup_trades()
void tfk_tunnel_trade_system()
void tfk_trailingStop() //Not yet completed TO FINALIZE DEVELOPMENT *********

INSTRUMENT INFORMATION
-----------------------
double tfk_symbol_info()
long tfk_magicID()
long tfk_magicID_max_range()

INDICATORS   //Indicators retrieve historical price (IN DEVELOPMENT) *********
-----------
double tfk_adx()
double tfk_alligator()
double tfk_adaptive_ma(()
double tfk_awesome_oscillator()
double tfk_atr()
double tfk_bollingerBands()
double tfk_bears_power()
double tfk_bulls_power()
double tfk_envelopes()
double tfk_macd()
double tfk_ma()
string tfk_ma_cross()
double tfk_psar()
double tfk_rsi()
double tfk_stdev()

PATTERN AND TIME SERIES
-----------------------
double tfk_candle_info()
double tfk_uptrend_percentage()
double tfk_fibonacci_level()

MATH AND STATISTICS
--------------------
int tfk_randomNumber()
double tfk_correlation()
double tfk_covariance()
double tfk_variance()
double tfk_mean()
double tfk_stdev()
double tfk_percentage_difference()

FILE AND FILE SYSTEM
---------------------
void  tfk_export_hist_Data_csv()
void tfk_export_deals_trades_to_csv()
*/

//+------------------------------------------------------------------+
//| CONSTANTS MQL4 MIGRATION
//+------------------------------------------------------------------+
#define OP_BUY 0; #define OP_SELL 1; #define OP_BUYLIMIT 2; #define OP_SELLLIMIT 3; #define OP_BUYSTOP 4; #define OP_SELLSTOP 5; #define MODE_OPEN 0;
#define MODE_CLOSE 3; #define MODE_VOLUME 4; #define MODE_REAL_VOLUME 5; #define MODE_TRADES 0; #define MODE_HISTORY 1; #define SELECT_BY_POS 0; #define SELECT_BY_TICKET 1;
#define DOUBLE_VALUE 0; #define FLOAT_VALUE 1; #define LONG_VALUE INT_VALUE; #define CHART_BAR 0; #define CHART_CANDLE 1; #define MODE_ASCEND 0; #define MODE_DESCEND 1; #define MODE_LOW 1;
#define MODE_HIGH 2; #define MODE_TIME 5; #define MODE_BID 9; #define MODE_ASK 10; #define MODE_POINT 11; #define MODE_DIGITS 12; #define MODE_SPREAD 13; #define MODE_STOPLEVEL 14;
#define MODE_LOTSIZE 15; #define MODE_TICKVALUE 16; #define MODE_TICKSIZE 17; #define MODE_SWAPLONG 18; #define MODE_SWAPSHORT 19; #define MODE_STARTING 20; #define MODE_EXPIRATION 21;
#define MODE_TRADEALLOWED 22; #define MODE_MINLOT 23; #define MODE_LOTSTEP 24; #define MODE_MAXLOT 25; #define MODE_SWAPTYPE 26; #define MODE_PROFITCALCMODE 27; #define MODE_MARGINCALCMODE 28;
#define MODE_MARGININIT 29; #define MODE_MARGINMAINTENANCE 30; #define MODE_MARGINHEDGED 31; #define MODE_MARGINREQUIRED 32; #define MODE_FREEZELEVEL 33; #define EMPTY -1;
//+------------------------------------------------------------------+
//| CONFIGURABLE VARIABLES
//+------------------------------------------------------------------+
input string     separator_01="";                       //_____________ GENERAL SETTINGS :::
input long       tfk_magicID_suffix=1;                        //Magic ID: from: 1 to 9.
input double     tfk_base_dollar_amount = 1000;         //Base Dollar Amount: Reference: Default: USD1000
input bool       tfk_debug_mode = false;                //Enable Debug Mode
input string     separator_02 = "";                     //.
input string     separator_03 = "";                     //_____________ TRADE ACTIVITY :::
input double     tfk_stopLoss_PCT = 0.01;               //Stop Loss in Percentage. 0.01 = 1% Approx: 100 pips
input double     tfk_takeProfit_PCT = 0.01;             //Take Profit in Percentage. 0.01 = 1% Approx: 100 pips
input string     separator_04 = "";                     //.
input string     separator_05 = "";                     //_____________ RISK MANAGEMENT :::
input double     tfk_trade_volume_lotSize =0.01;        //Trade volume lot size: 0.01 (if 0 then Dynamic Allocation)
input int        tfk_orderSlippage = 1000;              //Trade Order max allowed slippage.
//+------------------------------------------------------------------+
//| GENERIC VARIABLES
//+------------------------------------------------------------------+
long             tfk_magicID_base=tfk_magicID_suffix*100000000;
double           Ultimate_Long_SL=0,Ultimate_Short_SL=0,Ultimate_Long_TP=0,Ultimate_Short_TP=0;
double           grid_Reference_Price_1=0,grid_Reference_Price_2=0,grid_Reference_Price_3=0,grid_Reference_Price_4=0,grid_Reference_Price_5=0,grid_Reference_Price_6=0,grid_Reference_Price_7=0,grid_Reference_Price_8=0;
double           tunnel_upperRange_1=0,tunnel_lowerRange_1=0,tunnel_upperRange_2=0,tunnel_lowerRange_2=0,tunnel_upperRange_3=0,tunnel_lowerRange_3=0,tunnel_upperRange_4=0,tunnel_lowerRange_4=0,tunnel_upperRange_5=0,tunnel_lowerRange_5=0,tunnel_upperRange_6=0,tunnel_lowerRange_6=0;
int              tunnel_ID1_Level=0,tunnel_ID2_Level=0,tunnel_ID3_Level=0,tunnel_ID4_Level=0,tunnel_ID5_Level=0,tunnel_ID6_Level=0;
int              tunnel_ID1_Martingale=0,tunnel_ID2_Martingale=0,tunnel_ID3_Martingale=0,tunnel_ID4_Martingale=0,tunnel_ID5_Martingale=0,tunnel_ID6_Martingale=0;
int              tunnel_ID1_OrderType=-1,tunnel_ID2_OrderType=-1,tunnel_ID3_OrderType=-1,tunnel_ID4_OrderType=-1,tunnel_ID5_OrderType=-1,tunnel_ID6_OrderType=-1;
double           addup_Reference_Price_1=0,addup_Reference_Price_2=0,addup_Reference_Price_3=0,addup_Reference_Price_4=0,addup_Reference_Price_5=0,addup_Reference_Price_6=0;
int              addup_ID1_Level=0,addup_ID2_Level=0,addup_ID3_Level=0,addup_ID4_Level=0,addup_ID5_Level=0,addup_ID6_Level=0;
string           ma_cross_status_ID1="",ma_cross_status_ID2="",ma_cross_status_ID3="",ma_cross_status_ID4="",ma_cross_status_ID5="",ma_cross_status_ID6="";
//+------------------------------------------------------------------+
//| ENUM CUSTOMIZED TYPE
//+------------------------------------------------------------------+
enum ENUM_TFK_FUNCTION_MODE {TFK_RESET,TFK_CHECK};
//+------------------------------------------------------------------+
// Function:    Start() Start the system code name.
// Desc:        Start code name system
//+------------------------------------------------------------------+
void tfk_run_taatu_framework(string PalgoName,string PalgoVersion)
  {
   tfk_set_interface(PalgoName,Company,framework_version,PalgoVersion);
   tfk_add_instruments_watchlist();
  }
//+------------------------------------------------------------------+
// Function:    Add all the instrument to the watchlist
// Desc:        Add all symbols/Instruments in the watchlist of terminal
//+------------------------------------------------------------------+
void tfk_add_instruments_watchlist()
{
   int TotalNumberSymbols=SymbolsTotal(false);
   int CurrentNumberSymbols=SymbolsTotal(true);
   if (TotalNumberSymbols>CurrentNumberSymbols) {
      for(int i=0;i<TotalNumberSymbols;i++)
        {
         SymbolName(i,false);
         SymbolSelect(SymbolName(i,false),true);
        }
   }
}
//+------------------------------------------------------------------+
// Function:    Get information specific to an instrument
// Return:      Return specific information according to parameters.
// Parameters:  Psymbol as the instrument to extract.
//              PwhatInfo = "price", "contractSize", "dollarAmount"
//+------------------------------------------------------------------+
double tfk_symbol_info(string Psymbol,string PwhatInfo)
  {
   double returned_Value=0;
   MqlTick latest_price;
   double cPrice,cContractSize,cMinLotSize;
   cPrice=SymbolInfoDouble(Psymbol,SYMBOL_ASK);
   cContractSize=SymbolInfoDouble(Psymbol,SYMBOL_TRADE_CONTRACT_SIZE);
   cMinLotSize=SymbolInfoDouble(Psymbol,SYMBOL_VOLUME_MIN);
   if(PwhatInfo == "minLotSize") returned_Value = cMinLotSize;
   if(PwhatInfo == "price") returned_Value = cPrice;
   if(PwhatInfo == "contractSize") returned_Value = cContractSize;
   if(PwhatInfo == "dollarAmount") returned_Value = cPrice * cContractSize * cMinLotSize;
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Get information specific to an active position
// Return:      Return specific information according to parameters.
// Parameters:  PmagicID = magic ID of the instrument to get info.
//              PwhatInfo = "open_price", "profit_loss"
//+------------------------------------------------------------------+
double tfk_position_info(long PmagicID,string PwhatInfo)
  {
   double returned_Value=0;
   long selected_Magic=-1;
   double selected_Open_Price=0,selected_Profit_Loss=0;
   int selected_Order_Type=-1;
   for(int i=0; i<=PositionsTotal();i++)
     {
      PositionGetTicket(i);
      selected_Magic=PositionGetInteger(POSITION_MAGIC);
      selected_Profit_Loss= PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
      selected_Open_Price = PositionGetDouble(POSITION_PRICE_OPEN);
      selected_Order_Type = (int)PositionGetInteger(POSITION_TYPE);
      if(selected_Magic==PmagicID)
        {
         if(PwhatInfo=="open_price") returned_Value = selected_Open_Price;
         if(PwhatInfo=="profit_loss") returned_Value = selected_Profit_Loss;
         if(PwhatInfo=="order_type") returned_Value = selected_Order_Type;
        }
     }
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Compute the lot size multiplier.
// Return:      Return lot size multiplier.
//+------------------------------------------------------------------+
int tfk_lotSize_multiplier()
  {
   int TotalPos=PositionsTotal();
   int returned_value=1;
   double Account_Equity=AccountInfoDouble(ACCOUNT_EQUITY);
   if(tfk_trade_volume_lotSize==0) returned_value=(int)(Account_Equity/(tfk_base_dollar_amount*2));
   if(tfk_trade_volume_lotSize!=0) returned_value=1;
   if(returned_value<1) returned_value=1;
   return(returned_value);
  }
//+------------------------------------------------------------------+
// Function:    Compute the lot size multiplier.
// Return:      Return lot size multiplier.
//              if yes, then it will return the multiplier else return 1.
// Parameters:  Psymbol = instrument to check the minimum lot size.
//+------------------------------------------------------------------+
double tfk_lotSize(string Psymbol)
  {
   double returned_value=0;
   if(tfk_trade_volume_lotSize!=0) returned_value=tfk_trade_volume_lotSize*tfk_lotSize_multiplier();
   if(tfk_trade_volume_lotSize==0) returned_value=tfk_symbol_info(Psymbol,"minLotSize")*tfk_lotSize_multiplier();
   return( returned_value );
  }
//+------------------------------------------------------------------+
// Function:    Compute the stop loss price based on multiplier
// Return:      Return the stop loss dollar amount
// Parameters:  PlotVolume = is the volume of lot size from the selected trade.
//              if yes, then it will return the multiplier else return 1.
// Desc:        This function compute the stop loss price in dollar
//              amount.
//+------------------------------------------------------------------+
double tfk_stopLoss_dollarAmount(string Psymbol,double PlotVolume,int PorderType)
  {
   MqlTick latest_price;
   SymbolInfoTick(Psymbol,latest_price);
   double Stop_Loss_PCT=tfk_stopLoss_PCT;
   double SymbolContractSize=SymbolInfoDouble(Psymbol,SYMBOL_TRADE_CONTRACT_SIZE);
   double returned_Value=latest_price.ask*Stop_Loss_PCT*SymbolContractSize*PlotVolume;
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Compute the dynamic target price based on multiplier
// Return:      Return the target amount
// Parameters:  PlotVolume = is the volume of lot size from the selected trade.
//              Psymbol = Instrument to query.
// Desc:        This function compute the dynamic target price in dollar
//              amount.
//+------------------------------------------------------------------+
double tfk_target_dollarAmount(string Psymbol,double PlotVolume)
  {
   MqlTick latest_price;
   SymbolInfoTick(Psymbol,latest_price);
   double SymbolContractSize=SymbolInfoDouble(Psymbol,SYMBOL_TRADE_CONTRACT_SIZE);
   double returned_Value=latest_price.ask*tfk_takeProfit_PCT*SymbolContractSize*PlotVolume;
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Get Magic number of individual trade
// Return:      Return magic number
// Parameters:  PmagicSuffix = 1,2,3,4,5,6,7,8,9 from 1 to 19;
//+------------------------------------------------------------------+
long tfk_magicID(int PmagicSuffix)
{
   return(tfk_magicID_base*PmagicSuffix);
}
//+------------------------------------------------------------------+
// Function:    Get Max MagicID to retrieve max range
// Return:      Return magic number of the max range.
// Parameters:  Pmagic = for particular range 1 to 19.
//+------------------------------------------------------------------+
long tfk_magicID_max_range(long PmagicID)
{
   return(PmagicID+990000);
}
//+------------------------------------------------------------------+
// Function:    Compute technical indicators by updating global variables
// Return:      Return value of the selected indicator based Pindicator.
// Parameters:  PSymbol = Symbol of the instrument to extract information.
//              Pindicator = if = iRSIm iMA return respective indicator.
//              Pindex = Default one is 0. Set the value index to return.
//              Index example for the higher band or lower band of Bollinger.
//              Pcustom_int_1, Pcustom_int_2, Pcustom_int_3 = integer custom field.
//              Pcustom_double_1, Pcustom_double_2, Pcustom_double_3 = double custom field.
// Desc:        This function compute indicators based on provided
//              parameters.
//+------------------------------------------------------------------+
double tfk_get_indicator(string Psymbol,string Pindicator,ENUM_TIMEFRAMES Ptimeframe,int Pperiod,int Pindex,
                         int Pcustom_int_1,int Pcustom_int_2,int Pcustom_int_3,double Pcustom_double_1,
                         double Pcustom_double_2,double Pcustom_double_3)
  {
   int indicator_Handle=-1;
   double indicator_Value[];

   if(Pindicator=="iRSI") indicator_Handle=iRSI(Psymbol,Ptimeframe,Pperiod,PRICE_CLOSE);
   if(Pindicator=="iMA") indicator_Handle=iMA(Psymbol,Ptimeframe,Pperiod,0,MODE_EMA,PRICE_CLOSE);
   if(Pindicator=="iStdDev") indicator_Handle=iStdDev(Psymbol,Ptimeframe,Pperiod,0,MODE_EMA,PRICE_CLOSE);
   if(Pindicator=="iBands") indicator_Handle=iBands(Psymbol,Ptimeframe,Pperiod,0,0,PRICE_CLOSE);
   if(Pindicator=="iSAR") indicator_Handle=iSAR(Psymbol,Ptimeframe,Pcustom_double_1,Pcustom_double_2);
   if(Pindicator=="iEnvelopes") indicator_Handle=iEnvelopes(Psymbol,Ptimeframe,Pperiod,0,MODE_EMA,PRICE_CLOSE,Pcustom_double_1);
   if(Pindicator=="iMACD") indicator_Handle=iMACD(Psymbol,Ptimeframe,Pcustom_int_1,Pcustom_int_2,Pcustom_int_3,PRICE_CLOSE);
   if(Pindicator=="iADX") indicator_Handle=iADX(Psymbol,Ptimeframe,Pperiod);
//if(Pindicator=="iAlligator") indicator_Handle=iAlligator(Psymbol,Ptimeframe,Pcustom_int_1,Pcustom_int_2,Pcustom_int_3,(int)(Pcustom_double_1),(int)(Pcustom_double_2),(int)(Pcustom_double_3),MODE_EMA,PRICE_CLOSE);
   if(Pindicator=="iAlligator") indicator_Handle=iAlligator(Psymbol,Ptimeframe,13,8,5,5,5,3,MODE_EMA,PRICE_CLOSE);

   if(Pindicator=="iAMA") indicator_Handle=iAMA(Psymbol,Ptimeframe,Pperiod,Pcustom_int_1,Pcustom_int_2,Pcustom_int_3,PRICE_CLOSE);
   if(Pindicator=="iAO") indicator_Handle=iAO(Psymbol,Ptimeframe);
   if(Pindicator=="iATR") indicator_Handle=iATR(Psymbol,Ptimeframe,Pperiod);
   if(Pindicator=="iBearsPower") indicator_Handle=iBearsPower(Psymbol,Ptimeframe,Pperiod);
   if(Pindicator=="iBullsPower") indicator_Handle=iBullsPower(Psymbol,Ptimeframe,Pperiod);

   CopyBuffer(indicator_Handle,Pindex,0,3,indicator_Value);
   if(tfk_debug_mode) Print(Pindicator+"="+(string)(indicator_Value[0]));
   return(indicator_Value[0]);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Bulls Power Indicator
// Return:      Return Indicator value.
// Parameters:  Psymbol = Instrument to query.
//              Ptimeframe = Period to analyze.
//              Pma_period = Averaging period.
//+------------------------------------------------------------------+
double tfk_bulls_power(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int Pma_period)
  {
   int ma_period=13;
   if(Pma_period!=0) ma_period=Pma_period;
   double returned_value=tfk_get_indicator(Psymbol,"iBullsPower",Ptimeframe,ma_period,0,0,0,0,0,0,0);
   return(returned_value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Bears Power Indicator
// Return:      Return Indicator value.
// Parameters:  Psymbol = Instrument to query.
//              Ptimeframe = Period to analyze.
//              Pma_period = Averaging period.
//+------------------------------------------------------------------+
double tfk_bears_power(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int Pma_period)
  {
   int ma_period=13;
   if(Pma_period!=0) ma_period=Pma_period;
   double returned_value=tfk_get_indicator(Psymbol,"iBearsPower",Ptimeframe,ma_period,0,0,0,0,0,0,0);
   return(returned_value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Average True Range
// Return:      Return Indicator value.
// Parameters:  Psymbol = Instrument to query..
//              Ptimeframe = Period to analyze.
//              Pma_period = Averaging period.
//+------------------------------------------------------------------+
double tfk_atr(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int Pma_period)
  {
   int ma_period = 14;
   if(Pma_period!=0) ma_period=Pma_period;
   double returned_value=tfk_get_indicator(Psymbol,"iATR",Ptimeframe,ma_period,0,0,0,0,0,0,0);
   return(returned_value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Awesome Oscillator
// Return:      Return Indicator value.
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Period to analyze.
//+------------------------------------------------------------------+
double tfk_awesome_oscillator(string Psymbol,ENUM_TIMEFRAMES Ptimeframe)
  {
   double returned_value=tfk_get_indicator(Psymbol,"iAO",Ptimeframe,0,0,0,0,0,0,0,0);
   return(returned_value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Kaufman's Adaptive MA
// Return:      Return AMA value as double = price.
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Period to analyze.
//+------------------------------------------------------------------+
double tfk_adaptive_ma(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int Pperiod,int Pfast_EMA,int Pslow_EMA,int Pshift)
  {
   int period=9;
   int fast_EMA = 2;
   int slow_EMA = 30;
   int shift=0;
   if(Pfast_EMA!=0) fast_EMA=Pfast_EMA;
   if(Pslow_EMA!=0) slow_EMA=Pslow_EMA;
   if(Pshift!=0) shift=Pshift;
   double returned_value=tfk_get_indicator(Psymbol,"iAMA",Ptimeframe,Pperiod,0,fast_EMA,slow_EMA,shift,0,0,0);
   return(returned_value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Bill Williams Alligator
// Return:      Return Alligator lines according to parameters.
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Period to analyze.
//              Pindic_period = Number of period to analyse.
//              PwhichLine = Which line information to query.
//              If PwhichLine =
//              The buffer numbers are the following:
//              0 - GATORJAW_LINE, 1 - GATORTEETH_LINE, 2 - GATORLIPS_LINE.
//
//              PwhichLine = "jaw_line"(blue=0), "teeth_line"(red=1), "lips_line" (green=2)
//
//              if 0 provided as value for:
//              pjaw_period, Pjaw_shift, Pteeth_period, Pteeth_shift,
//              Plips_period, Plips_period.
//              then the function will use the default parameters.
//+------------------------------------------------------------------+
double tfk_alligator(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int Pjaw_period,int Pjaw_shift,
                     int Pteeth_period,int Pteeth_shift,int Plips_period,int Plips_shift,string PwhichLine)
  {
   int jaw_period=13;
   int jaw_shift=8;
   int teeth_period=8;
   int teeth_shift=5;
   int lips_period=5;
   int lips_shift=3;
   int index=-1;
   if(Pjaw_period!=0) jaw_period=Pjaw_period;
   if(Pjaw_shift!=0) jaw_shift=Pjaw_shift;
   if(Pteeth_period!=0) teeth_period=Pteeth_period;
   if(Pteeth_shift!=0) teeth_shift=Pteeth_shift;
   if(Plips_period!=0) lips_period=Plips_period;
   if(Plips_shift!=0) lips_shift=Plips_shift;
   if(PwhichLine=="jaw_line") index=0;
   if(PwhichLine=="teeth_line") index=1;
   if(PwhichLine=="lips_line") index=2;
   double returned_value=tfk_get_indicator(Psymbol,"iAlligator",Ptimeframe,0,index,jaw_period,jaw_shift,teeth_period,(double)(teeth_shift),(double)(lips_period),(double)(lips_shift));
   return(0);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: ADX, return ADX lines.
// Return:      Return ADX value according to parameters.
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Period to analyze.
//              Pindic_period = Number of period to analyse.
//              PwhichLine = Which line information to query.
//              If PwhichLine = "main" return main line
//                              "+DI" return +DI line
//                              "-DI" return -DI line
//              0 = "main", 1 = +DI line, 2 = -DI line.
//+------------------------------------------------------------------+
double tfk_adx(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int Pindic_period,string PwhichLine)
  {
   int index=-1;
   double returned_value=-1;
   if(PwhichLine=="main") index = 0;
   if(PwhichLine=="+DI") index = 1;
   if(PwhichLine=="-DI") index = 2;
   returned_value=tfk_get_indicator(Psymbol,"iADX",Ptimeframe,Pindic_period,index,0,0,0,0,0,0);
   return(0);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: MACD
//              return the MACD Main line or Signal line.
// Return:      Return value of the main line or signal line.
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Time frame to analyse.
//              PfastPeriod = Number of fast period in the time series.
//              PslowPeriod = Number of slow period in the time series.
//              Psignal = Number of period for the signal line.
//              PwhichLine = 0 = "main", 1 = "signal"
// Desc:        This function will return MACD main or signal line
//              as per the parameters.
//+------------------------------------------------------------------+
double tfk_macd(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int PfastPeriod,int PslowPeriod,int Psignal,string PwhichLine)
  {
   int fastPeriod = 12;
   int slowPeriod = 26;
   int signal     = 9;
   double returned_Value=-1;
   if(PfastPeriod!=0) fastPeriod=PfastPeriod; if(PslowPeriod!=0) slowPeriod=PslowPeriod; if(Psignal!=0) signal=Psignal;
   if(PwhichLine=="main") returned_Value=tfk_get_indicator(Psymbol,"iMACD",Ptimeframe,0,0,fastPeriod,slowPeriod,signal,0,0,0);
   if(PwhichLine=="signal") returned_Value=tfk_get_indicator(Psymbol,"iMACD",Ptimeframe,0,1,fastPeriod,slowPeriod,signal,0,0,0);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: MA cross check.
// Return:      Return signal as string: if "no_signal" no signal,
//                                       if "above", MA1 cross above MA2
//                                       if "below", MA2 cross below MA2
// Parameters:  Pmode = TFK_RESET or TFK_CHECK;
//              Init is to initialize the function to listen to chart.
//              Check is to return the current status of the MAs cross.
//              Psymbol = Instrument to query.
//              Ptimeframe = timeframe, Period of MA1 and MA2
//              Pindic_period_MA_1 = Period of MA1
//              Pindic_period_MA_2 = Period of MA2
//              Pma_cross_check_Direction = "above", "below".
//              Pma_cross_check_ID = from 1 to 6. Support up to 6 configuration
//+------------------------------------------------------------------+
string tfk_ma_cross(ENUM_TFK_FUNCTION_MODE Pmode,string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int Pindic_period_MA_1,int Pindic_period_MA_2,string Pma_cross_check_Direction,int Pma_cross_check_ID)
  {
   double MA_1 = tfk_ma(Psymbol,Ptimeframe,Pindic_period_MA_1);
   double MA_2 = tfk_ma(Psymbol,Ptimeframe,Pindic_period_MA_2);
   string ma_cross_status="";
   string returned_value ="";

   if(Pmode==TFK_RESET)
     {
      switch(Pma_cross_check_ID)
        {
         case 1:{ ma_cross_status_ID1=""; break;}
         case 2:{ ma_cross_status_ID2=""; break;}
         case 3:{ ma_cross_status_ID3=""; break;}
         case 4:{ ma_cross_status_ID4=""; break;}
         case 5:{ ma_cross_status_ID5=""; break;}
         case 6:{ ma_cross_status_ID6=""; break;}
        }
     }
   else
     {
      switch(Pma_cross_check_ID)
        {
         case 1: {ma_cross_status=ma_cross_status_ID1; break; }
         case 2: {ma_cross_status=ma_cross_status_ID2; break; }
         case 3: {ma_cross_status=ma_cross_status_ID3; break; }
         case 4: {ma_cross_status=ma_cross_status_ID4; break; }
         case 5: {ma_cross_status=ma_cross_status_ID5; break; }
         case 6: {ma_cross_status=ma_cross_status_ID6; break; }
        }
      if(Pma_cross_check_Direction=="above")
        {
         if(MA_1<MA_2) ma_cross_status="below";
         if(ma_cross_status!="" && (MA_1>MA_2)) ma_cross_status="above";
        }
      if(Pma_cross_check_Direction=="below")
        {
         if(MA_1>MA_2) ma_cross_status="above";
         if(ma_cross_status!="" && (MA_1<MA_2)) ma_cross_status="below";
        }
      switch(Pma_cross_check_ID)
        {
         case 1: {ma_cross_status_ID1=ma_cross_status; break; }
         case 2: {ma_cross_status_ID2=ma_cross_status; break; }
         case 3: {ma_cross_status_ID3=ma_cross_status; break; }
         case 4: {ma_cross_status_ID4=ma_cross_status; break; }
         case 5: {ma_cross_status_ID5=ma_cross_status; break; }
         case 6: {ma_cross_status_ID6=ma_cross_status; break; }
        }
      returned_value=ma_cross_status;
     }
   return(returned_value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Envelopes
//              return the Envelopes upper or lower line.
// Return:      Return price of lower or upper envelopes line
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Time frame to analyse.
//              PIndic_Period = Number of period in the time series.
//              Pdeviation = Deviation from center lin, default = 0.01
//              PwhichLine = 0 = "upper_line", 1 = "lower_line"
// Desc:        This function will return Parabolic SAR value according to
//              specified parameters.
//+------------------------------------------------------------------+
double tfk_envelopes(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int PIndic_Period,double Pdeviation,string PwhichLine)
  {
   double deviation=0.01;
   int index=0;
   if(Pdeviation!=0) deviation=Pdeviation;
   if(PwhichLine=="upper_line") index = 0;
   if(PwhichLine=="lower_line") index = 1;
   double returned_Value=tfk_get_indicator(Psymbol,"iEnvelopes",Ptimeframe,PIndic_Period,index,0,0,0,deviation,0,0);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Parabolic Stop & Reverse
//              return the PSAR value (price)
// Return:      Return price as per parameters
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Time frame to analyse.
//              Pstep = step of price increment default is 0.02
//              Pmaximum = maximum steps, default is 0.2
// Desc:        This function will return Parabolic SAR value according to
//              specified parameters.
//+------------------------------------------------------------------+
double tfk_psar(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,double Pstep,double Pmaximum)
  {
   double step=0.02;
   double maximum=0.2;
   if(Pstep!=0) step=Pstep;
   if(Pmaximum!=0) maximum=Pmaximum;
   double returned_Value=tfk_get_indicator(Psymbol,"iSAR",Ptimeframe,0,0,0,0,0,step,maximum,0);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Bollinger Bands
//              return the Bollinger Bands value (price)
// Return:      Return Lower, Base or Upper band according to parameters
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Time frame to analyse.
//              PIndic_Period = Number of period to analyse.
//              Pwhich_Band = 0 = "base_band", 1 = "upper_band", 2 = "lower_band"
// Desc:        This function will return Bollinger Band value according to
//              specified parameters.
//+------------------------------------------------------------------+
double tfk_bollingerBands(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int PIndic_Period,string Pwhich_Band)
  {
   double returned_Value=-1;
   if(Pwhich_Band=="base_band") returned_Value=tfk_get_indicator(Psymbol,"iBands",Ptimeframe,PIndic_Period,0,0,0,0,0,0,0);
   if(Pwhich_Band=="upper_band") returned_Value=tfk_get_indicator(Psymbol,"iBands",Ptimeframe,PIndic_Period,1,0,0,0,0,0,0);
   if(Pwhich_Band=="lower_band") returned_Value=tfk_get_indicator(Psymbol,"iBands",Ptimeframe,PIndic_Period,2,0,0,0,0,0,0);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Standard Deviation (Exponential)
// Return:      Return Standard Deviation value or percentage of an instrument.
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Time frame to analyse.
//              PIndic_Period = Number of period to analyse.
// Desc:        This function will return Standard Deviation value according to
//              specified parameters in price points / pct. using Exponential Moving Avg.
//+------------------------------------------------------------------+
double tfk_stdev(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int PIndic_Period,bool PinPCT)
  {
   double returned_Value=0;
   double stdev_Value=tfk_get_indicator(Psymbol,"iStdDev",Ptimeframe,PIndic_Period,0,0,0,0,0,0,0);
   returned_Value=stdev_Value;
   if(PinPCT)
     {
      double current_Price=tfk_symbol_info(Psymbol,"price");
      returned_Value=(stdev_Value/current_Price);
     }
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: Moving Average (Exponential)
//              return the MA value (price)
// Return:      Return MA value
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Time frame to analyse.
//              PIndic_Period = Number of period to analyse.
// Desc:        This function will return MA value according to
//              specified parameters.
//+------------------------------------------------------------------+
double tfk_ma(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int PIndic_Period)
  {
   double returned_Value=tfk_get_indicator(Psymbol,"iMA",Ptimeframe,PIndic_Period,0,0,0,0,0,0,0);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Technical indicator function: RSI, return the RSI value
// Return:      Return RSI value
// Parameters:  Psymbol = Instrument to locate.
//              Ptimeframe = Time frame to analyse.
//              PIndic_Period = Number of period to analyse.
// Desc:        This function will return RSI value according to
//              specified parameters.
//+------------------------------------------------------------------+
double tfk_rsi(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int PIndic_Period)
  {
   double returned_Value=tfk_get_indicator(Psymbol,"iRSI",Ptimeframe,PIndic_Period,0,0,0,0,0,0,0);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Check if a position is currently active based on
//              instrument Symbol and Magic ID.
// Return:      Return true if position exists.
// Parameters:  PmagicID_startRange = Magic ID of the position to check.from.
//              PmagicID_endRange = Magic ID of the position to check. to.
// Desc:        This function will check into the active trades and
//              attempt to locate trade with the specified conditions.
//+------------------------------------------------------------------+
bool tfk_exists_trade(long PmagicID_startRange,long PmagicID_endRange)
  {
   int totalPos=PositionsTotal();
   long selected_Magic = 0;
   bool returned_Value =false;
   for(int i=0; i<=totalPos; i++)
     {
      PositionGetTicket(i);
      selected_Magic=PositionGetInteger(POSITION_MAGIC);
      if(selected_Magic>=PmagicID_startRange && selected_Magic<=PmagicID_endRange)
        {
         returned_Value=true;
         break;
        }
     }
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Build a tunnel trapping system of trades with limited
//              risk according to maximum of level systematic exit.
// Return:      No value returned.
// Parameters:  PmagicID = MagicID of the reference trade.
//              PupperRange = UpperRange most likely based on resistance
//              PlowerRange = LowerRange most likely based on support level
//              PmaxLevel = maximum level before systematic closing of trades.
//              Ptarget_dollarAmount = Amount in dollar as a target.
//              Set to 0 to ignore and calculate dynamically.
//              PtunnelID = 1 to 6. ID of the tunnel. Note that the system can
//              manage up to 6 tunnels simultaneously.
//
//              *******************************************
//              MagicID range from 1000 to 19'000
//              *******************************************
//+------------------------------------------------------------------+
void tfk_tunnel_trade_system(long PmagicID,string Psymbol,double PupperRange,double PlowerRange,int PmaxLevel,double Ptarget_dollarAmount,int PtunnelID)
  {

   long magicID_StartRange=PmagicID,magicID_EndRange=PmagicID+PmaxLevel+19000;
   int order_Type=(int)tfk_position_info(PmagicID,"order_type");
   int previous_order_type=-1;
   double open_price = tfk_position_info(PmagicID,"open_price");
   double upperRange = -1, lowerRange = -1;
   int current_Level = 0;
   int martingale=0;
   double current_price=tfk_symbol_info(Psymbol,"price");
   switch(PtunnelID)
     {
      case 1: {current_Level = tunnel_ID1_Level; martingale = tunnel_ID1_Martingale; previous_order_type= tunnel_ID1_OrderType; lowerRange = tunnel_lowerRange_1; upperRange = tunnel_upperRange_1; break; }
      case 2: {current_Level = tunnel_ID2_Level; martingale = tunnel_ID2_Martingale; previous_order_type= tunnel_ID2_OrderType; lowerRange = tunnel_lowerRange_2; upperRange = tunnel_upperRange_2; break; }
      case 3: {current_Level = tunnel_ID3_Level; martingale = tunnel_ID3_Martingale; previous_order_type= tunnel_ID3_OrderType; lowerRange = tunnel_lowerRange_3; upperRange = tunnel_upperRange_3; break; }
      case 4: {current_Level = tunnel_ID4_Level; martingale = tunnel_ID4_Martingale; previous_order_type= tunnel_ID4_OrderType; lowerRange = tunnel_lowerRange_4; upperRange = tunnel_upperRange_4; break; }
      case 5: {current_Level = tunnel_ID5_Level; martingale = tunnel_ID5_Martingale; previous_order_type= tunnel_ID5_OrderType; lowerRange = tunnel_lowerRange_5; upperRange = tunnel_upperRange_5; break; }
      case 6: {current_Level = tunnel_ID6_Level; martingale = tunnel_ID6_Martingale; previous_order_type= tunnel_ID6_OrderType; lowerRange = tunnel_lowerRange_6; upperRange = tunnel_upperRange_6; break; }
     }
   if(tfk_exists_trade(PmagicID,PmagicID))
     {
      if(previous_order_type==-1) previous_order_type=order_Type;
      if(current_Level==0)
        {
         if(order_Type==0)
           {
            upperRange=open_price;
            if(PupperRange!=0 && PlowerRange!=0)
              {
               if(PlowerRange<open_price) lowerRange=PlowerRange;
               else lowerRange=open_price-(open_price*tfk_candle_info(Psymbol,PERIOD_D1,5,"PCT_LH",0,"previous"));
              }
            else
              {
               lowerRange=tfk_candle_info(Psymbol,PERIOD_D1,5,"LOW",0,"previous");
               if(lowerRange>open_price) lowerRange=tfk_candle_info(Psymbol,PERIOD_D1,5,"LOW",0,"previous")-(tfk_candle_info(Psymbol,PERIOD_D1,5,"LOW",0,"previous")*tfk_candle_info(Psymbol,PERIOD_D1,5,"PCT_LH",0,"previous"));
              }
           }
         if(order_Type==1)
           {
            lowerRange=open_price;
            if(PupperRange!=0 && PlowerRange!=0)
              {
               if(PupperRange>open_price) upperRange=PupperRange;
               else upperRange=open_price+(open_price*tfk_candle_info(Psymbol,PERIOD_D1,5,"PCT_LH",0,"previous"));
              }
            else
              {
               upperRange=tfk_candle_info(Psymbol,PERIOD_D1,5,"HIGH",0,"previous");
               if(upperRange<open_price) upperRange=tfk_candle_info(Psymbol,PERIOD_D1,5,"HIGH",0,"previous")+(tfk_candle_info(Psymbol,PERIOD_D1,5,"HIGH",0,"previous")*tfk_candle_info(Psymbol,PERIOD_D1,5,"PCT_LH",0,"previous"));
              }
           }
        }
      if(current_price<lowerRange && previous_order_type==0)
        {
         current_Level++;
         if(current_Level==1) martingale=current_Level*2; else martingale=martingale*2;
         previous_order_type=1;
         for(int i=1; i<=(martingale);i++)
           {
            tfk_execute_trade(Psymbol,1,(string)(PmagicID+current_Level*1000+i),(PmagicID+current_Level*1000+i),tfk_lotSize(Psymbol));
           }
        }
      if(current_price>upperRange && previous_order_type==1)
        {
         current_Level++;
         if(current_Level==1) martingale=current_Level*2; else martingale=martingale*2;
         previous_order_type=0;
         for(int i=1; i<=(martingale);i++)
           {
            tfk_execute_trade(Psymbol,0,(string)(PmagicID+current_Level*1000+i),(PmagicID+current_Level*1000+i),tfk_lotSize(Psymbol));
           }
        }
     }
   double collected_profit=tfk_profit_loss(PmagicID,magicID_EndRange);
   double target_profit=tfk_target_dollarAmount(Psymbol,tfk_lotSize(Psymbol));
   if(Ptarget_dollarAmount!=0) target_profit=Ptarget_dollarAmount;
   if(collected_profit>target_profit || current_Level>PmaxLevel)
     {
      do
        {
         tfk_close_trade(magicID_StartRange,magicID_EndRange);
         current_Level=0;
         martingale=0;
         previous_order_type=-1;
        }
      while(tfk_exists_trade(magicID_StartRange,magicID_EndRange));
     }
   switch(PtunnelID)
     {
      case 1:{tunnel_ID1_Level = current_Level; tunnel_ID1_Martingale = martingale; tunnel_ID1_OrderType = previous_order_type; tunnel_lowerRange_1 = lowerRange; tunnel_upperRange_1 = upperRange; break; }
      case 2:{tunnel_ID2_Level = current_Level; tunnel_ID2_Martingale = martingale; tunnel_ID2_OrderType = previous_order_type; tunnel_lowerRange_2 = lowerRange; tunnel_upperRange_2 = upperRange; break; }
      case 3:{tunnel_ID3_Level = current_Level; tunnel_ID3_Martingale = martingale; tunnel_ID3_OrderType = previous_order_type; tunnel_lowerRange_3 = lowerRange; tunnel_upperRange_3 = upperRange; break; }
      case 4:{tunnel_ID4_Level = current_Level; tunnel_ID4_Martingale = martingale; tunnel_ID4_OrderType = previous_order_type; tunnel_lowerRange_4 = lowerRange; tunnel_upperRange_4 = upperRange; break; }
      case 5:{tunnel_ID5_Level = current_Level; tunnel_ID5_Martingale = martingale; tunnel_ID5_OrderType = previous_order_type; tunnel_lowerRange_5 = lowerRange; tunnel_upperRange_5 = upperRange; break; }
      case 6:{tunnel_ID6_Level = current_Level; tunnel_ID6_Martingale = martingale; tunnel_ID6_OrderType = previous_order_type; tunnel_lowerRange_6 = lowerRange; tunnel_upperRange_6 = upperRange; break; }
     }
  }
//+------------------------------------------------------------------+
// Function:    Add up to winning trades based on a distance in pct.
// Return:      No value returned.
// Parameters:  PmagicID = Magic ID of the initial reference trade
//              Ppct_gap = Gap in percentage where 0.1 = 10%
//              Psymbol = Instrument to query.
//              PaddupID = Add Up trade reference from 1 to 6.
//
//              *******************************************
//              MagicID range from 29'000 to 50'000
//              *******************************************
//+------------------------------------------------------------------+
void tfk_addup_trades(long PmagicID,double Ppct_gap,string Psymbol,int PaddupID)
  {
   long magicID_startRange=PmagicID+20000,magicID_endRange=PmagicID+50000;
   double addup_Reference_Price=-1;
   int level=1;
   int count_trade=tfk_count_active_trades(magicID_startRange,magicID_endRange)+tfk_count_active_trades(PmagicID,PmagicID);
   switch(PaddupID)
     {
      case 1: {addup_Reference_Price = addup_Reference_Price_1; level = addup_ID1_Level; break; }
      case 2: {addup_Reference_Price = addup_Reference_Price_2; level = addup_ID2_Level; break; }
      case 3: {addup_Reference_Price = addup_Reference_Price_3; level = addup_ID3_Level; break; }
      case 4: {addup_Reference_Price = addup_Reference_Price_4; level = addup_ID4_Level; break; }
      case 5: {addup_Reference_Price = addup_Reference_Price_5; level = addup_ID5_Level; break; }
      case 6: {addup_Reference_Price = addup_Reference_Price_6; level = addup_ID6_Level; break; }
     }
   if(count_trade==1)
     {
      addup_Reference_Price=tfk_position_info(PmagicID,"open_price");
      level=0;
     }
   double current_price=tfk_symbol_info(Psymbol,"price");
   int order_type=(int)tfk_position_info(PmagicID,"order_type");
   double current_gap=tfk_percentage_difference(current_price,addup_Reference_Price,false);
   if(count_trade>=1)
     {
      if(order_type==0 && current_gap>Ppct_gap)
        {
         level++;
         tfk_execute_trade(Psymbol,0,"tfk_add_up: "+(string)(magicID_startRange+count_trade*100)+": "+(string)PaddupID,magicID_startRange+level*100,tfk_lotSize(Psymbol));
         addup_Reference_Price=current_price;
        }
      if(order_type==1 && current_gap<Ppct_gap*(-1))
        {
         level++;
         tfk_execute_trade(Psymbol,1,"tfk_add_up: "+(string)(magicID_startRange+count_trade*100)+": "+(string)PaddupID,magicID_startRange+level*100,tfk_lotSize(Psymbol));
         addup_Reference_Price=current_price;
        }
     }

   switch(PaddupID)
     {
      case 1: {addup_Reference_Price_1 = addup_Reference_Price; addup_ID1_Level = level; break; }
      case 2: {addup_Reference_Price_2 = addup_Reference_Price; addup_ID2_Level = level; break; }
      case 3: {addup_Reference_Price_3 = addup_Reference_Price; addup_ID3_Level = level; break; }
      case 4: {addup_Reference_Price_4 = addup_Reference_Price; addup_ID4_Level = level; break; }
      case 5: {addup_Reference_Price_5 = addup_Reference_Price; addup_ID5_Level = level; break; }
      case 6: {addup_Reference_Price_6 = addup_Reference_Price; addup_ID6_Level = level; break; }
     }
  }
//+------------------------------------------------------------------+
// Function:    Build a grid of trades
// Return:      No value returned.
// Parameters:  PmagicID = Reference Magic ID of the trade to build
//              grid upon on it.
//              Ppct_gap = Provide percentage gap between trades.
//              where 0.01 = 1% distance.
//              Ptarget_DollarAmount = Target amount for closing
//              if target amount = 0 then dynamically computed.
//              all the grid positions including the reference trade.
//              Psymbol = symbol of the trade to open
//              Pmultiplier = if true, then implement martingale.
//              PgridID = ID of the grid from 1 to 6. The system
//              manage up to 8 grids simultaneously.
//
//              *******************************************
//              MagicID range from 100'000 to 900'000
//              *******************************************
//+------------------------------------------------------------------+
void tfk_grid_trades(long PmagicID,double Ppct_gap,double Ptarget_DollarAmount,string Psymbol,bool Pmultiplier,int PgridID)
  {
   long magicID_startRange=PmagicID+100000,magicID_endRange=PmagicID+900000;
   double grid_Reference_Price=1;
   switch(PgridID)
     {
      case 1: {grid_Reference_Price = grid_Reference_Price_1; break; }
      case 2: {grid_Reference_Price = grid_Reference_Price_2; break; }
      case 3: {grid_Reference_Price = grid_Reference_Price_3; break; }
      case 4: {grid_Reference_Price = grid_Reference_Price_4; break; }
      case 5: {grid_Reference_Price = grid_Reference_Price_5; break; }
      case 6: {grid_Reference_Price = grid_Reference_Price_6; break; }
      case 7: {grid_Reference_Price = grid_Reference_Price_7; break; }
      case 8: {grid_Reference_Price = grid_Reference_Price_8; break; }
     }
   if(tfk_count_active_trades(PmagicID,PmagicID)>0)
     {
      int    level=tfk_count_active_trades(magicID_startRange,magicID_endRange)+1;
      double current_price=tfk_symbol_info(Psymbol,"price");
      if(level==1) grid_Reference_Price=tfk_position_info(PmagicID,"open_price");
      if(tfk_debug_mode) Print(Psymbol+"="+(string)(level)+" :: Ref_price="+(string)(grid_Reference_Price));
      ENUM_ORDER_TYPE  order_type=(ENUM_ORDER_TYPE)tfk_position_info(PmagicID,"order_type");
      double multiplier=1;
      if(Pmultiplier) multiplier=level*2;
      if((order_type==ORDER_TYPE_BUY && tfk_percentage_difference(current_price,grid_Reference_Price,false)<(Ppct_gap*(-1))) || (order_type==ORDER_TYPE_SELL && tfk_percentage_difference(current_price,grid_Reference_Price,false)>(Ppct_gap)))
        {
         tfk_execute_trade(Psymbol,order_type,"tfk_grid: "+(string)(magicID_startRange+level),magicID_startRange+level,tfk_lotSize(Psymbol)*multiplier);
         grid_Reference_Price=current_price;
        }
     }
   double collected_profit=tfk_profit_loss(magicID_startRange,magicID_endRange)+tfk_profit_loss(PmagicID,PmagicID);
   double target_profit=0;
   if(Ptarget_DollarAmount==0)
      target_profit=tfk_target_dollarAmount(Psymbol,tfk_lotSize(Psymbol)); else target_profit=Ptarget_DollarAmount;
   if(collected_profit>target_profit)
     {
      tfk_close_trade(magicID_startRange,magicID_endRange);
      tfk_close_trade(PmagicID,PmagicID);
     }
   switch(PgridID)
     {
      case 1: {grid_Reference_Price_1 = grid_Reference_Price; break; }
      case 2: {grid_Reference_Price_2 = grid_Reference_Price; break; }
      case 3: {grid_Reference_Price_3 = grid_Reference_Price; break; }
      case 4: {grid_Reference_Price_4 = grid_Reference_Price; break; }
      case 5: {grid_Reference_Price_5 = grid_Reference_Price; break; }
      case 6: {grid_Reference_Price_6 = grid_Reference_Price; break; }
      case 7: {grid_Reference_Price_7 = grid_Reference_Price; break; }
      case 8: {grid_Reference_Price_8 = grid_Reference_Price; break; }
     }
  }
//+------------------------------------------------------------------+
// Function:    Return Random integer within specific range
// Return:      Return a random integer
// Parameters:  PminValue = the min. of the range and PmaxValue the max.
// Desc:        The function returns the value of an integer randomly.
//+------------------------------------------------------------------+
int tfk_randomNumber(int PminValue,int PmaxValue)
  {
   return((int)(PminValue + MathRound((PmaxValue-PminValue)*(MathRand()/32767.0))));
  }
//+------------------------------------------------------------------+
// Function:    return the coefficient of correlation, covariance or
//              mean and variance from specified number of period
//              in the time series of a particular instrument.
// Return:      Return a coefficient as per specified by parameters
// Parameters:  Pwhat = "correlation", "variance", "covariance", "mean",
//                      "standard_dev".
//              Psymbol_1 = Symbol of the instrument to analyse.
//              Psymbol_2 = Symbol of the instrument to compare to.
//              Ptimeframe = PERIOD_H1, PERIOD_M15
//              PnumberPeriod = number of period in the time series.
//              max recommendation is 400.
//              This function will return value as per specification
//              in the Pwhat parameter. Note that it is recommended
//              to extract more than 400 periods due to certain limitation.
//+------------------------------------------------------------------+
double tfk_get_statistical_coeficient(string Pwhat,string Psymbol_x,string Psymbol_y,ENUM_TIMEFRAMES Ptimeframe,int PnumberPeriod)
  {
   double   returned_Value=0;
   double   mx_Inst = 0, dx_Inst = 0;
   double   my_Inst = 0, dy_Inst = 0;
   double   cov=0,corr=0;
   MqlRates Data_x_Array[];
   double   Data_x_Array_D[];
   MqlRates Data_y_Array[];
   double   Data_y_Array_D[];
   int      inst_x=CopyRates(Psymbol_x,Ptimeframe,0,PnumberPeriod,Data_x_Array);
   int      inst_y=CopyRates(Psymbol_y,Ptimeframe,0,PnumberPeriod,Data_y_Array);
   ArrayResize(Data_x_Array_D,inst_x,inst_x);
   ArrayResize(Data_y_Array_D,inst_y,inst_y);
   for(int i = 0; i <= inst_x-1; i++) Data_x_Array_D[i] = Data_x_Array[i].close;
   for(int i = 0; i <= inst_y-1; i++) Data_y_Array_D[i] = Data_y_Array[i].close;
   mx_Inst=Average(Data_x_Array_D);
   dx_Inst=Variance(Data_x_Array_D,mx_Inst);
   my_Inst=Average(Data_y_Array_D);
   dy_Inst=Variance(Data_y_Array_D,my_Inst);
   cov=Cov(Data_x_Array_D,Data_y_Array_D,mx_Inst,my_Inst);
   corr=Corr(cov,dx_Inst,dy_Inst);
   if(Pwhat=="correlation") returned_Value = corr;
   if(Pwhat=="covariance") returned_Value = cov;
   if(Pwhat=="variance") returned_Value = dx_Inst;
   if(Pwhat=="mean") returned_Value = mx_Inst;
   if(Pwhat=="standard_dev") returned_Value = tfk_stdev(Psymbol_x,Ptimeframe,PnumberPeriod,true);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Return the mean of a particular instrument
// Return:      mean is returned.
// Parameters:  Psymbol_1 is the instrument to query
//              Ptimeframe = PERIOD_D1, PERIOD_H1, PERIOD_M15
//              PnumberPeriod = 100, 200, 50, maximum recomm. 400.
//+------------------------------------------------------------------+
double tfk_mean(string Psymbol_1,ENUM_TIMEFRAMES Ptimeframe,int PnumberPeriod)
  {
   double returned_Value=tfk_get_statistical_coeficient("mean",Psymbol_1,Psymbol_1,Ptimeframe,PnumberPeriod);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Return the variance of a particular instrument
// Return:      variance is returned.
// Parameters:  Psymbol_1 is the instrument to query
//              Ptimeframe = PERIOD_D1, PERIOD_H1, PERIOD_M15
//              PnumberPeriod = 100, 200, 50, maximum recomm. 400.
//+------------------------------------------------------------------+
double tfk_variance(string Psymbol_1,ENUM_TIMEFRAMES Ptimeframe,int PnumberPeriod)
  {
   double returned_Value=tfk_get_statistical_coeficient("variance",Psymbol_1,Psymbol_1,Ptimeframe,PnumberPeriod);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Return the covariance between 2 instruments
// Return:      Covariance is returned.
// Parameters:  Psymbol_1, Psymbol_2 are 2 of the instrument to compare
//              Ptimeframe = PERIOD_D1, PERIOD_H1, PERIOD_M15
//              PnumberPeriod = 100, 200, 50, maximum recomm. 400.
//+------------------------------------------------------------------+
double tfk_covariance(string Psymbol_1,string Psymbol_2,ENUM_TIMEFRAMES Ptimeframe,int PnumberPeriod)
  {
   double returned_Value=tfk_get_statistical_coeficient("covariance",Psymbol_1,Psymbol_2,Ptimeframe,PnumberPeriod);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Return the correlation between 2 instruments
// Return:      Correlation coefficient is returned.
// Parameters:  Psymbol_1, Psymbol_2 are 2 of the instrument to compare
//              Ptimeframe = PERIOD_D1, PERIOD_H1, PERIOD_M15
//              PnumberPeriod = 100, 200, 50, maximum recomm. 400.
//+------------------------------------------------------------------+
double tfk_correlation(string Psymbol_1,string Psymbol_2,ENUM_TIMEFRAMES Ptimeframe,int PnumberPeriod)
  {
   double returned_Value=tfk_get_statistical_coeficient("correlation",Psymbol_1,Psymbol_2,Ptimeframe,PnumberPeriod);
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Exit trade according to specific parameters
// Return:      No value returned.
// Parameters:  Pmagic_ID_StartRange = Magic ID start range
//              Pmagic_ID_EndRange = Magic ID end range
//              This function will locate the position in the active
//              trade list and will close the position according to
//              the specification.
//+------------------------------------------------------------------+
void tfk_close_trade(long Pmagic_ID_StartRange,long Pmagic_ID_EndRange)
  {
   int totalPos=PositionsTotal();
   string selected_Symbol="";
   long selected_Magic=0;
   long selected_Ticket=0;
   do {
   for(int i=0; i<=totalPos; i++)
     {
      PositionGetTicket(i);
      selected_Ticket= PositionGetInteger(POSITION_TICKET);
      selected_Magic = PositionGetInteger(POSITION_MAGIC);
      selected_Symbol= PositionGetString(POSITION_SYMBOL);
      if(selected_Magic>=Pmagic_ID_StartRange && selected_Magic<=Pmagic_ID_EndRange)
        {
         trade.PositionClose(selected_Ticket);
         if(tfk_debug_mode) Print("*** CloseTrade (Ticket="+(string)selected_Ticket+")");
        }
     }
   } while (tfk_exists_trade(Pmagic_ID_StartRange,Pmagic_ID_EndRange));
  }
//+------------------------------------------------------------------+
// Function:    Execute trade if not existing position is in progress
// Return:      No value returned.
// Parameters:  Pdirection=0 for long, Pdirection=1 for short.
//              alternatively use ORDER_TYPE_BUY, ORDER_TYPE_SELL
//              Pppdistance=2, 4, 6, 8, 10.
//              PcommentCode="2PP-Pos" etc...
//              if set to 0, ignore for executeTrade that are not pending,
//              which is at the market price.
//+------------------------------------------------------------------+
void tfk_execute_trade(string Psymbol,ENUM_ORDER_TYPE Pdirection,string PcommentCode,long Pmagic_ID_Model,double Plot_Size)
  {
   bool posExist=false;
   int total=PositionsTotal();
   bool OS;
   long OrderMagic;
   MqlTradeRequest mrequest;
   MqlTradeResult mresult;
   MqlTick latest_price;

   for(int cnt=0; cnt<total; cnt++)
     {
      OS=PositionGetTicket(cnt);
      OrderMagic=PositionGetInteger(POSITION_MAGIC);
      if(OrderMagic==Pmagic_ID_Model)
        {
         posExist=true;
        }
     }
   if(!posExist)
     {
      ZeroMemory(mrequest);
      mrequest.action= TRADE_ACTION_DEAL; mrequest.symbol = Psymbol; mrequest.volume = Plot_Size;
      mrequest.magic = Pmagic_ID_Model; mrequest.type_filling = ORDER_FILLING_IOC; mrequest.deviation=tfk_orderSlippage;
      mrequest.comment=PcommentCode; SymbolInfoTick(Psymbol,latest_price);

      if(Pdirection==0)
        {
         mrequest.price= latest_price.ask; mrequest.sl = Ultimate_Long_SL; mrequest.tp = Ultimate_Long_TP;
         mrequest.type = ORDER_TYPE_BUY; OS = OrderSend(mrequest,mresult);
         if(tfk_debug_mode) Print("*** ExecuteTrade (long)");
        }

      if(Pdirection==1)
        {
         mrequest.price= latest_price.bid; mrequest.sl = Ultimate_Short_SL; mrequest.tp = Ultimate_Short_TP;
         mrequest.type = ORDER_TYPE_SELL; OS = OrderSend(mrequest,mresult);
         if(tfk_debug_mode) Print("*** ExecuteTrade (short)");
        }
     }
  }
//+------------------------------------------------------------------+
// Function:    The function returned absolute percentage low high
// Return:      Return percentage move between low and high
// Parameters:  Psymbol,
//              Ptimeframe = "PERIOD_D1"
//              PnumberPeriod = 200 (200 previous candles)
//              Pwhat = "PCT_LH" = High Low, "PCT_OC" = Open Close
//              Pwhat = "TYPE" = Type of candle, 1 for green, 0 for red, 2 unchanged.
//              Pwhat = "LOW" = Low value from specific candle.
//              Pwhat = "HIGH" = High value from specific candle.
//              Pwhat = "OPEN" = Open value from specific candle.
//              Pwhat = "CLOSE" = Close value from specific candle.
//              Pindex = which candle to return calculation.
//              PwhichCandle = "current", "previous", "previous-1", "previous-2",
//                             "previous-3", "previous-4", "previous-5", "previous-6", leave blank to ignore settings.
// Desc:        This function check last day candle high and low price
//              return the percentage move between low and high.
//+------------------------------------------------------------------+
double tfk_candle_info(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int PnumberPeriod,string Pwhat,int Pindex,string PwhichCandle)
  {
   MqlRates Value_Array[];
   double v1_Value=0,v2_Value=0;
   double pct_change=0;
   double CandleType= 9;
   double returned_Value=9;
   int index=Pindex;

   if(PwhichCandle =="current") index = PnumberPeriod-1;
   if(PwhichCandle =="previous") index = PnumberPeriod-2;
   if(PwhichCandle =="previous-1") index = PnumberPeriod-3;
   if(PwhichCandle =="previous-2") index = PnumberPeriod-4;
   if(PwhichCandle =="previous-3") index = PnumberPeriod-5;
   if(PwhichCandle =="previous-4") index = PnumberPeriod-6;
   if(PwhichCandle =="previous-5") index = PnumberPeriod-7;
   if(PwhichCandle =="previous-6") index = PnumberPeriod-8;

   int Count_Value=CopyRates(Psymbol,Ptimeframe,0,PnumberPeriod,Value_Array);

   if(Pwhat=="PCT_LH")
     {
      v1_Value = Value_Array[index].low;
      v2_Value = Value_Array[index].high;
     }
   if(Pwhat=="PCT_OC")
     {
      v1_Value = Value_Array[index].open;
      v2_Value = Value_Array[index].close;
     }
   if(Pwhat=="PCT_LH" || Pwhat=="PCT_OC")
     {
      if(v2_Value>v1_Value) pct_change=MathAbs((v1_Value/v2_Value)-1); else pct_change=MathAbs((v2_Value/v1_Value)-1);
      returned_Value=pct_change;
     }
   if(Pwhat=="LOW") returned_Value = Value_Array[index].low;
   if(Pwhat=="HIGH") returned_Value = Value_Array[index].high;
   if(Pwhat=="OPEN") returned_Value = Value_Array[index].open;
   if(Pwhat=="CLOSE") returned_Value = Value_Array[index].close;
   if(Pwhat=="TYPE")
     {
      if(Value_Array[index].open<Value_Array[Pindex].close) CandleType = 1;
      if(Value_Array[index].open>Value_Array[Pindex].close) CandleType = 0;
      if(Value_Array[index].open==Value_Array[Pindex].close) CandleType=2;
      returned_Value=CandleType;
     }

   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Get Last period price pattern as per specific parameters.
// Return:      Return uptrend estimated percentage.
// Parameters:  Psymbol = Symbol to return info. PnumberPeriod = Number to analyze.
//              PTimeframe = "PERIOD_D1", "PERIOD_M15".
// Desc:        This function check last period performance close, open, high and low
//              price. Return percentage. 0.01 = 1%, 0.6 = 60% bullish.
//+------------------------------------------------------------------+
double tfk_uptrend_percentage(string Psymbol,ENUM_TIMEFRAMES Ptimeframe,int PnumberPeriod)
  {
   MqlRates Rates[];
   ENUM_TIMEFRAMES TimeFrame=Ptimeframe;
   int score=0;
   int NumberPeriod=PnumberPeriod;
   double returned_Value=9;
   int N=CopyRates(Psymbol,TimeFrame,0,NumberPeriod,Rates);
   double countBull= 0,countBear = 0;
   double bull_Pct = 0;
   double GreenCandle_Size=0,RedCandle_Size=0;
   double GreenCandle_Avg_Pct=0,RedCandle_Avg_Pct=0;
   double countOpenUp=0,countCloseUp=0,countHighUp=0,countLowUp=0;
   double openUp_Avg_Pct=0,closeUp_Avg_Pct=0,highUp_Avg_Pct=0,lowUp_Avg_Pct=0;

   for(int i=1; i<N; i++)
     {
      if(Rates[i].open<Rates[i].close)
        {
         countBull++;
         GreenCandle_Size=tfk_candle_info(Psymbol,Ptimeframe,PnumberPeriod,"PCT_OC",i,"");
        }
      if(Rates[i].open>Rates[i].close)
        {
         countBear++;
         RedCandle_Size=tfk_candle_info(Psymbol,Ptimeframe,PnumberPeriod,"PCT_OC",i,"");
        }
      if(i<(N-1))
        {
         if(Rates[i].open > Rates[1].open) countOpenUp++;
         if(Rates[i].close > Rates[1].close) countCloseUp++;
         if(Rates[i].high > Rates[1].high) countHighUp++;
         if(Rates[i].low > Rates[1].low) countLowUp++;
        }
     }

   GreenCandle_Avg_Pct=GreenCandle_Size/countBull;
   RedCandle_Avg_Pct=RedCandle_Size/countBear;

   openUp_Avg_Pct=countOpenUp/N; //1
   closeUp_Avg_Pct=countCloseUp/N; //2
   highUp_Avg_Pct=countHighUp/N; //3
   lowUp_Avg_Pct=countLowUp/N; //4
   bull_Pct=countBull/(countBear+countBull); //5
   returned_Value=(openUp_Avg_Pct+closeUp_Avg_Pct+highUp_Avg_Pct+lowUp_Avg_Pct+bull_Pct)/5;
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Return percentage difference between Value_A and Value_B
// Return:      Return double which represent percentage difference.
//              0.1 means 10%, 0.45 means 45%...
// Parameters:  PvalueA = Value A as a double, PvalueB = Value B as a double.
//              if PabsoluteValue = true, then return absolute value.
//+------------------------------------------------------------------+
double tfk_percentage_difference(double PvalueA,double PvalueB,bool PabsoluteValue)
  {
   double percentageChange=0;
   if(PvalueB>0)
      percentageChange=(PvalueA/PvalueB)-1;
   if(PabsoluteValue) MathAbs(percentageChange);
   return(percentageChange);
  }
//+------------------------------------------------------------------+
// Function:    Count active trades
// Return:      Return active trades as per specific Magic ID
// Parameters:  Pmagic_ID_StartRange = Magic ID from to Pmagic_ID_EndRange
//+------------------------------------------------------------------+
int tfk_count_active_trades(long Pmagic_ID_StartRange,long Pmagic_ID_EndRange)
  {
   int countTrade=0;
   long selected_Magic=-1;
   for(int i=0; i<=PositionsTotal(); i++)
     {
      PositionGetTicket(i);
      selected_Magic=PositionGetInteger(POSITION_MAGIC);
      if(selected_Magic>=Pmagic_ID_StartRange && selected_Magic<=Pmagic_ID_EndRange) countTrade++;
     }
   return(countTrade);
  }
//+------------------------------------------------------------------+
// Function:    Return total active profit / loss for specific trades
// Return:      Return dollar amount of profit/loss including swap
// Parameters:  PmagicID = Magic ID of trades to query.
//+------------------------------------------------------------------+
double tfk_profit_loss(long Pmagic_ID_StartRange,long Pmagic_ID_EndRange)
  {
   double TotalPnL=0;
   long selected_Magic=-1;
   double selected_Profit=0,collected_Profit_Swap=0;
   for(int i=0; i<=PositionsTotal(); i++)
     {
      PositionGetTicket(i);
      selected_Magic=PositionGetInteger(POSITION_MAGIC);
      selected_Profit=PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
      if(selected_Magic>=Pmagic_ID_StartRange && selected_Magic<=Pmagic_ID_EndRange) collected_Profit_Swap=collected_Profit_Swap+selected_Profit;
     }
   return(collected_Profit_Swap);
  }
//+------------------------------------------------------------------+
// Function:    Trailing Stop at half of position from target.
// Return:      No value returned.
// Parameters:  PmagicID_startRange = Start range of MagicID
//              PmagicID_endRange = End range of MagicID
//              MagicID of positions to trail stops.
//              Pstart_trail_pct_reached = pct reach (1% = 0.01 or avg. 10 pips)
//                                           before half position profit
//                                           is locked.
//+------------------------------------------------------------------+
void tfk_trailingStop(long PmagicID_startRange,long PmagicID_endRange,double Pstart_trail_pct_reached)
  {
   double start_trail_pct=Pstart_trail_pct_reached;
   double pct_SL_Pos=start_trail_pct/2;
   long selected_magic=0;
   string selected_symbol="";
   double selected_open_price=0;
   double computed_SL=0;

   for(int i=0; i<=PositionsTotal(); i++)
     {
      ///XXX
     }

  }
//+------------------------------------------------------------------+
// Function:    Export to CSV active deals and trades.
// Return:      No value returned.
// Parameters:  PnumHistoryToExport = 100;
// Description: Export to csv file: TRADES.csv
//+------------------------------------------------------------------+
void tfk_export_deals_trades_to_csv(int PnumHistoryToExport)
  {
   ulong selected_Ticket, selected_Magic, selection;
   string selected_Symbol, selected_Order_Type, selected_Status;
   datetime selected_datetime;
   int selected_type;
   double selected_volume, selected_contract_size,
          selected_price_open, selected_price_current, selected_value,
          selected_SL, selected_TP, selected_numShare_Lots, selected_profit;

   //Initialize history deals
   datetime end=TimeCurrent();                 // current server time
   datetime start=end-31536000;// decrease 1 day
   //--- request of trade history needed into the cache of MQL5 program

   //Export properties
   CFileTxt     File;
   int Number_Of_Line_To_Export = PnumHistoryToExport;
   string ExtFileName="TRADES";
   StringConcatenate(ExtFileName,ExtFileName,".CSV");
   string sOut;
   // open file
   File.Open(ExtFileName,FILE_WRITE,9);
   sOut="Ticket,Magic,Symbol,Datetime,OrderType,PriceOpen,PriceCurrent,Contract,Value,SL,TP,PnL,Status";
   sOut=sOut+"\n";
   File.WriteString(sOut);
   for(int i=0; i<=PositionsTotal(); i++)
     {
      PositionGetTicket(i);
      selected_Ticket = PositionGetInteger(POSITION_TICKET);
      selected_Magic = PositionGetInteger(POSITION_MAGIC);
      selected_Symbol = PositionGetString(POSITION_SYMBOL);
      selected_datetime = (int)PositionGetInteger(POSITION_TIME);
      selected_type = (int)PositionGetInteger(POSITION_TYPE);
      if (selected_type == 0) selected_Order_Type = "Buy";
      if (selected_type == 1) selected_Order_Type = "Sell";

      selected_volume = PositionGetDouble(POSITION_VOLUME);
      selected_contract_size = tfk_symbol_info(selected_Symbol,"contractSize");
      selected_price_open = PositionGetDouble(POSITION_PRICE_OPEN);
      selected_price_current = PositionGetDouble(POSITION_PRICE_CURRENT);
      selected_value = selected_volume * selected_contract_size * selected_price_current;
      selected_numShare_Lots = selected_volume * selected_contract_size;
      selected_SL = PositionGetDouble(POSITION_SL);
      selected_TP = PositionGetDouble(POSITION_TP);
      selected_profit = PositionGetDouble(POSITION_PROFIT);
      selected_Status = "Active";

      if (selected_Ticket!=0) {
         sOut=(string)selected_Ticket+","+(string)selected_Magic+","+(string)selected_Symbol+","+(string)selected_datetime+","+
         (string)selected_Order_Type+","+(string)selected_price_open+","+(string)selected_price_current+","+(string)selected_numShare_Lots+","+(string)selected_value+","+
         (string)selected_SL+","+(string)selected_TP+","+(string)selected_profit+","+selected_Status;
         sOut=sOut+"\n";
         File.WriteString(sOut);
      }
     }

   HistorySelect(start,end);
   for(int i=Number_Of_Line_To_Export; i>=0; i--)
     {
      selection = HistoryDealGetTicket(i);
      selected_Ticket = HistoryDealGetInteger(selection,DEAL_TICKET);
      selected_Magic = HistoryDealGetInteger(selection, DEAL_MAGIC);
      selected_Symbol = HistoryDealGetString(selection,DEAL_SYMBOL);
      selected_datetime = (int)HistoryDealGetInteger(selection,DEAL_TIME);
      selected_type = (int)HistoryDealGetInteger(selection,DEAL_TYPE);
      if (selected_type == 0) selected_Order_Type = "Buy";
      if (selected_type == 1) selected_Order_Type = "Sell";

      selected_volume = HistoryDealGetDouble(selection,DEAL_VOLUME);
      selected_contract_size = tfk_symbol_info(selected_Symbol,"contractSize");
      selected_price_current = HistoryDealGetDouble(selection,DEAL_PRICE);
      selected_value = selected_volume * selected_contract_size * selected_price_current;
      selected_numShare_Lots = selected_volume * selected_contract_size;
      selected_profit = HistoryDealGetDouble(selection,DEAL_PROFIT);
      selected_Status = "Expired";

      sOut=(string)selected_Ticket+","+(string)selected_Magic+","+(string)selected_Symbol+","+(string)selected_datetime+","+
      (string)selected_Order_Type+","+"-"+","+"-"+","+(string)selected_numShare_Lots+","+(string)selected_value+","+
      "-"+","+"-"+","+(string)selected_profit+","+selected_Status;
      sOut=sOut+"\n";
      File.WriteString(sOut);
     }

   //Close file
   File.Close();

  }
//+------------------------------------------------------------------+
// Function:    Build a fibonacci grid from Value_A and Value_B
//              Typically on an uptrend, provice the Value_A with the lowest point
//              and Value_B with the highest point to get fibonacci
//              retracement level.
// Return:      Return price of the level specified in parameter.
//              1=23.6%, 2=38.2%, 3=50%, 4=61.8%, 5=76.4%, 6=100%, 7=138.2
//              3.7 means 3.7%
// Parameters:  PwhatLevel means , 1, 2, 3, 4, 5, 6... Which level to compute.
//              PretracementLength= deviation in percentage: 3.5 = 3.5%
//+------------------------------------------------------------------+
double tfk_fibonacci_level(int PwhatLevel,double PvalueA,double PvalueB)
  {
   double FibLevelValue=0;
   double retracementLength=MathAbs(PvalueA-PvalueB);
   double returned_Value=-1;
   if(PwhatLevel == 1) FibLevelValue = ((retracementLength) / 100) * 23.6;
   if(PwhatLevel == 2) FibLevelValue = ((retracementLength) / 100) * 38.2;
   if(PwhatLevel == 3) FibLevelValue = ((retracementLength) / 100) * 50.0;
   if(PwhatLevel == 4) FibLevelValue = ((retracementLength) / 100) * 61.8;
   if(PwhatLevel == 5) FibLevelValue = ((retracementLength) / 100) * 76.4;
   if(PwhatLevel == 6) FibLevelValue = ((retracementLength) / 100) * 100;
   if(PwhatLevel == 7) FibLevelValue = ((retracementLength) / 100) * 138.2;
   if(PvalueA > PvalueB) returned_Value = PvalueB + FibLevelValue;
   if(PvalueA < PvalueB) returned_Value = PvalueB - FibLevelValue;
   return(returned_Value);
  }
//+------------------------------------------------------------------+
// Function:    Export the specified symbol historical data for a
//              specific timeframe and specific number of records.
// Return:      No value returned.
// Parameters:  Pexportfilename = Filename of the exported file.
//              Psymbol = Instrument
//              Ptimeframe = PERIOD_D1, PERIOD_M1 etc...
//              PnumberRecords = 1 (if 9999 then return max records)
//+------------------------------------------------------------------+
void  tfk_export_hist_Data_csv(string Pexportfilename, string Psymbol, ENUM_TIMEFRAMES Ptimeframe, int PnumberRecords)
  {
   string    ExtFileName;
   CFileTxt     File;
   MqlRates  rates_array[];
   string sSymbol=Psymbol;
   string  sPeriod;
   tfk_periodToStr(Ptimeframe,sPeriod);
   int Number_Of_Line_To_Export = 9999;
   int iMaxBar=TerminalInfoInteger(TERMINAL_MAXBARS);
   if (PnumberRecords==9999) Number_Of_Line_To_Export = iMaxBar; else Number_Of_Line_To_Export = PnumberRecords;
   // prepare file name, for example, EURUSD1
   ExtFileName=Pexportfilename;
   StringConcatenate(ExtFileName,Pexportfilename,"_",sPeriod,".CSV");
   ArraySetAsSeries(rates_array,true);
   string format="%G,%G,%G,%G,%d";
   int iCod=CopyRates(sSymbol,Ptimeframe,0,Number_Of_Line_To_Export,rates_array);
   if(iCod>1)
     {
      // open file
      File.Open(ExtFileName,FILE_WRITE,9);
      for(int i=iCod-1; i>0; i--)
        {
         // prepare a string:
         // 2009.01.05,12:49,1.36770,1.36780,1.36760,1.36760,8
         string sOut=StringFormat("%s",TimeToString(rates_array[i].time,TIME_DATE));
         sOut=sOut+","+TimeToString(rates_array[i].time,TIME_MINUTES);
         sOut=sOut+","+StringFormat(format,
                                    rates_array[i].open,
                                    rates_array[i].high,
                                    rates_array[i].low,
                                    rates_array[i].close,
                                    rates_array[i].tick_volume);
         sOut=sOut+"\n";
         File.WriteString(sOut);
        }
      File.Close();
     }
  }
//+------------------------------------------------------------------+
// Function:    Converting Period type data into string.
// Return:      No string of the provided period type.
// Parameters:  Pperiod = PERIOD_D1, PERIOD_M1 etc...
//+------------------------------------------------------------------+
bool tfk_periodToStr(ENUM_TIMEFRAMES Pperiod,string &strper)
  {
   bool res=true;
   switch(Pperiod)
     {
      case PERIOD_MN1 : strper="MN1"; break;
      case PERIOD_W1 :  strper="W1";  break;
      case PERIOD_D1 :  strper="D1";  break;
      case PERIOD_H1 :  strper="H1";  break;
      case PERIOD_H2 :  strper="H2";  break;
      case PERIOD_H3 :  strper="H3";  break;
      case PERIOD_H4 :  strper="H4";  break;
      case PERIOD_H6 :  strper="H6";  break;
      case PERIOD_H8 :  strper="H8";  break;
      case PERIOD_H12 : strper="H12"; break;
      case PERIOD_M1 :  strper="M1";  break;
      case PERIOD_M2 :  strper="M2";  break;
      case PERIOD_M3 :  strper="M3";  break;
      case PERIOD_M4 :  strper="M4";  break;
      case PERIOD_M5 :  strper="M5";  break;
      case PERIOD_M6 :  strper="M6";  break;
      case PERIOD_M10 : strper="M10"; break;
      case PERIOD_M12 : strper="M12"; break;
      case PERIOD_M15 : strper="M15"; break;
      case PERIOD_M20 : strper="M20"; break;
      case PERIOD_M30 : strper="M30"; break;
      default : res=false;
     }
   return(res);
  }
//+------------------------------------------------------------------+
// Function:    Interface display
//Parameters:   PalgoName = Name of the Algorithm.
//              PcompanyName = Name of the company.
//              Pversion = Version of the Algorithm.
// Return:      No returned parameter.
//+------------------------------------------------------------------+
void tfk_set_interface(string PalgoName,string PcompanyName,string Pframework_Version,string Psys_Version)
  {
   tfk_objectCreate("ObjAlgoName",OBJ_LABEL,0,0,0);
   tfk_objectSetText("ObjAlgoName",PalgoName,15,"Verdana",White);
   tfk_objectSet("ObjAlgoName",OBJPROP_CORNER,0);
   tfk_objectSet("ObjAlgoName",OBJPROP_XDISTANCE,15);
   tfk_objectSet("ObjAlgoName",OBJPROP_YDISTANCE,50);

   tfk_objectCreate("ObjCompanyName",OBJ_LABEL,0,0,0);
   tfk_objectSetText("ObjCompanyName",PcompanyName,10,"Verdana",White);
   tfk_objectSet("ObjCompanyName",OBJPROP_CORNER,0);
   tfk_objectSet("ObjCompanyName",OBJPROP_XDISTANCE,15);
   tfk_objectSet("ObjCompanyName",OBJPROP_YDISTANCE,70);

   tfk_objectCreate("ObjVersion",OBJ_LABEL,0,0,0);
   tfk_objectSetText("ObjVersion","Framework Ver: "+Pframework_Version+"  System Ver: "+Psys_Version,10,"Verdana",White);
   tfk_objectSet("ObjVersion",OBJPROP_CORNER,0);
   tfk_objectSet("ObjVersion",OBJPROP_XDISTANCE,15);
   tfk_objectSet("ObjVersion",OBJPROP_YDISTANCE,100);

   tfk_objectCreate("ObjServerTime",OBJ_LABEL,0,0,0);
   tfk_objectSetText("ObjServerTime","Server Time: "+IntegerToString(tfk_Hour())+":"+IntegerToString(tfk_Minute())+":"+IntegerToString(tfk_Seconds()),10,"Verdana",White);
   tfk_objectSet("ObjServerTime",OBJPROP_CORNER,0);
   tfk_objectSet("ObjServerTime",OBJPROP_XDISTANCE,15);
   tfk_objectSet("ObjServerTime",OBJPROP_YDISTANCE,120);

   tfk_objectCreate("ObjMagicIDMaster",OBJ_LABEL,0,0,0);
   tfk_objectSetText("ObjMagicIDMaster","Reserved MagicID: "+IntegerToString(tfk_magicID(1))+" to "+IntegerToString((tfk_magicID(2))),10,"Verdana",White);
   tfk_objectSet("ObjMagicIDMaster",OBJPROP_CORNER,0);
   tfk_objectSet("ObjMagicIDMaster",OBJPROP_XDISTANCE,15);
   tfk_objectSet("ObjMagicIDMaster",OBJPROP_YDISTANCE,140);

   ChartSetInteger(0,CHART_COLOR_GRID,DarkBlue);
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,DarkBlue);
  }
//+------------------------------------------------------------------+
//| Median                                                           |
//+------------------------------------------------------------------+
double Mediana(double &arr[])
  {
   double res=0.0;
   int    size=ArraySize(arr);
//--- check
   if(size<=0)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   if(size%2==0) res=(arr[size/2-1]+arr[size/2])/2;
   else           res=arr[(size+1)/2-1];
//--- returning the result
   return(res);
  }
//+------------------------------------------------------------------+
//| The middle of the 50% interquantile range (bends center)         |
//+------------------------------------------------------------------+
double Mediana50(double &arr[])
  {
   int size=ArraySize(arr);
//--- check
   if(size<=0)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   int m=size/4;
//---
   return((arr[m]+arr[size-m-1])/2);
  }
//+------------------------------------------------------------------+
//| Arithmetical mean of entire sampling                             |
//+------------------------------------------------------------------+
double Average(double &arr[])
  {
   int size=ArraySize(arr);
//--- check
   if(size<=0)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   for(int i=0;i<size;i++)
      sum+=arr[i];
//--- returning the result
   return(sum/size);
  }
//+------------------------------------------------------------------+
//| Arithmetical mean of the 50% interquantile range                 |
//+------------------------------------------------------------------+
double Average50(double &arr[])
  {
   int size=ArraySize(arr);
//--- check
   if(size<=0)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   int    m=size/4;
   int    n=size-m;
//---
   for(int i=m;i<n;i++)
      sum+=arr[i];
//--- returning the result
   return(sum/(size-2*m));
  }
//+------------------------------------------------------------------+
//| Sweep center                                                     |
//+------------------------------------------------------------------+
double SweepCenter(double &arr[])
  {
   int size=ArraySize(arr);
//--- check
   if(size<=0)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   return((arr[0]+arr[size-1])/2);
  }
//+------------------------------------------------------------------+
//| The average value of upper five evaluations                      |
//+------------------------------------------------------------------+
double AverageOfEvaluations(double &arr[])
  {
   double res;
   double array[5];
//--- calculation of five evaluations
   array[0]=Mediana(arr);
   array[1]=Mediana50(arr);
   array[2]=Average(arr);
   array[3]=Average50(arr);
   array[4]=SweepCenter(arr);
//--- check
   if(ArraySort(array))
      res=array[2];
   else
     {
      Print(__FUNCTION__+": array sort error");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return res;
  }
//+------------------------------------------------------------------+
//| Variance                                                         |
//+------------------------------------------------------------------+
double Variance(double &arr[],double mx)
  {
   int size=ArraySize(arr);
//--- check
   if(size<=1)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   for(int i=0;i<size;i++)
      sum+=MathPow(arr[i]-mx,2);
//---
   return(sum/(size-1));
  }
//+------------------------------------------------------------------+
//| 3rd central moment                                               |
//+------------------------------------------------------------------+
double ThirdCentralMoment(double &arr[],double mx)
  {
   int size=ArraySize(arr);
//--- check
   if(size<=2)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   for(int i=0;i<size;i++)
      sum+=MathPow(arr[i]-mx,3);
//--- returning the result
   return(sum*size/(size-1)/(size-2));
  }
//+------------------------------------------------------------------+
//| 4th central moment                                               |
//+------------------------------------------------------------------+
double FourthCentralMoment(double &arr[],double mx)
  {
   int size=ArraySize(arr);
//--- check
   if(size<=3)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum2=0.0;
   double sum4=0.0;
   for(int i=0;i<size;i++)
     {
      sum2+=MathPow(arr[i]-mx,2);
      sum4+=MathPow(arr[i]-mx,4);
     }
//--- returning the result
   return(((MathPow(size,2)-2*size+3)*sum4-
          (6*size-9)/size*MathPow(sum2,2))/
          (size-1)*(size-2)*(size-3));
  }
//+------------------------------------------------------------------+
//| Custom asymmetry                                                 |
//+------------------------------------------------------------------+
double Asymmetry(double &arr[],double mx,double dx)
  {
//--- check
   if(dx==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//---
   double size=ArraySize(arr);
//--- check
   if(size<=2)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   for(int i=0;i<size;i++)
      sum+=MathPow(arr[i]-mx,3);
//--- returning the result
   return(size/(size-1)/(size-2)/MathPow(dx,1.5)*sum);
  }
//+------------------------------------------------------------------+
//| Excess (another calculation method)                              |
//+------------------------------------------------------------------+
double Excess2(double &arr[],double mx,double dx)
  {
//--- check
   if(dx==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//---
   double size=ArraySize(arr);
//--- check
   if(size<=3)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum2=0.0;
   double sum4=0.0;
   for(int i=0; i<size; i++)
     {
      sum2+=MathPow(arr[i]-mx,2);
      sum4+=MathPow(arr[i]-mx,4);
     }
//--- returning the result
   return((size*(size+1)*sum4-3*sum2*sum2*(size-1))/
          (size-1)/(size-2)/(size-3)/dx/dx);
  }
//+------------------------------------------------------------------+
//| Excess                                                           |
//+------------------------------------------------------------------+
double Excess(double &arr[],double mx,double dx)
  {
//--- check
   if(dx==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//---
   double size=ArraySize(arr);
//--- check
   if(size<4)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   for(int i=0; i<size; i++)
      sum+=MathPow(arr[i]-mx,4);
//--- returning the result
   return(((size *(size+1)*sum/(size-1)/dx/dx)-3*MathPow(size-1,2))/
          (size-2)/(size-3));
  }
//+------------------------------------------------------------------+
//| Euler's gamma function for x>0                                   |
//+------------------------------------------------------------------+
double Gamma(double x)
  {
//--- check
   if(x==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- initialization of variables
   double p=0.0;
   double pp=0.0;
   double qq=0.0;
   double z=1.0;
   double sgngam=1.0;
   int    i=0;
//--- check
   if(x>33.0)
      return(sgngam*GammaStirling(x));
//---
   while(x>=3)
     {
      x--;
      z=z*x;
     }
//---
   while(x<2)
     {
      if(x<0.000000001)
         return(z/((1+0.5772156649015329*x)*x));
      z/=x;
      x++;
     }
//---
   if(x==2)
      return(z);
//---
   x-=2.0;
   pp = 0.000160119522476751861407;
   pp = 0.00119135147006586384913+x*pp;
   pp = 0.0104213797561761569935+x*pp;
   pp = 0.0476367800457137231464+x*pp;
   pp = 0.207448227648435975150+x*pp;
   pp = 0.494214826801497100753+x*pp;
   pp = 0.999999999999999996796+x*pp;
   qq = -0.0000231581873324120129819;
   qq = 0.000539605580493303397842+x*qq;
   qq = -0.00445641913851797240494+x*qq;
   qq = 0.0118139785222060435552+x*qq;
   qq = 0.0358236398605498653373+x*qq;
   qq = -0.234591795718243348568+x*qq;
   qq = 0.0714304917030273074085+x*qq;
   qq = 1.00000000000000000320+x*qq;
//--- check
   if(qq==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(z*pp/qq);
  }
//+--------------------------------------------------------------------+
//| Stirling's approximation for the Euler's gamma function calculation|
//| for x>33                                                           |
//+--------------------------------------------------------------------+
double GammaStirling(double x)
  {
//--- check
   if(x==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- initialization of variables
   double y=0.0;
   double w=0.0;
   double v=0.0;
   double stir=0.0;
//---
   w=1.0/x;
   stir = 0.000787311395793093628397;
   stir = -0.000229549961613378126380+w*stir;
   stir = -0.00268132617805781232825+w*stir;
   stir = 0.00347222221605458667310+w*stir;
   stir = 0.0833333333333482257126+w*stir;
   w=1+w*stir;
//---
   y=MathExp(x);
   if(x>143.01608)
     {
      v = MathPow(x, 0.5*x-0.25);
      y = v*(v/y);
     }
   else
      y=MathPow(x,x-0.5)/y;
//--- returning the result
   return(2.50662827463100050242*y*w);
  }
//+------------------------------------------------------------------+
//| The variance of the sample variance                              |
//+------------------------------------------------------------------+
double VarianceOfSampleVariance(double &arr[],double m4,double dx)
  {
   double size=ArraySize(arr);
//--- check
   if(size<=0)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return((m4-MathPow(dx,2))/size);
  }
//+------------------------------------------------------------------+
//| Variation of the sample standard deviation                       |
//+------------------------------------------------------------------+
double VarianceOfStandartDeviation(double &arr[],double m4,double dx)
  {
//--- check
   if(dx==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(VarianceOfSampleVariance(arr,m4,dx)/dx/4);
  }
//+------------------------------------------------------------------+
//| Sample asymmetry variation                                       |
//+------------------------------------------------------------------+
double VarianceOfAsymmetry(double size)
  {
//--- check
   if(size==-1 || size==-3)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return((6*size-6)/(size+1)/(size+3));
  }
//+------------------------------------------------------------------+
//| Sample excess variation                                          |
//+------------------------------------------------------------------+
double VarianceOfExcess(double size)
  {
//--- check
   if(size==1 || size==-3 || size==-5)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(24*size*(size-2)*(size-3)/MathPow(size-1,2)/(size+3)/(size+5));
  }
//+------------------------------------------------------------------+
//| Variation of a sample mean                                       |
//+------------------------------------------------------------------+
double VarianceOfAverage(double dx,int size)
  {
//--- check
   if(size==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(dx/size);
  }
//+------------------------------------------------------------------+
//| Logarithm õ by base à                                            |
//+------------------------------------------------------------------+
double Log(double x,double a)
  {
//--- check
   if(x<=0 || a<=0 || a==1)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(MathLog(x)/MathLog(a));
  }
//+------------------------------------------------------------------+
//| Censoring ratio                                                  |
//+------------------------------------------------------------------+
double CensorCoeff(int size,double e)
  {
//--- check
   if(e<1)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(1.55+0.8*Log(1.0*size/10,10)*MathSqrt(e-1));
  }
//+------------------------------------------------------------------+
//| The optimal number of the distribution density histogram columns |
//+------------------------------------------------------------------+
int HistogramLength(double e,int size)
  {
//--- length calculation
   int n=(int)((e/6+0.25)*MathPow(size,0.4));
   if(n%2==0)
      n--;
//--- returning the result
   return(n);
  }
//+------------------------------------------------------------------+
//| Exclusion of misses from the sample                              |
//+------------------------------------------------------------------+
int Resize(double &arr[],double g,double dx,double center)
  {
//--- check
   if(dx<0)
     {
      Print(__FUNCTION__+": the error variable");
      return(-1);
     }
//---
   int size=ArraySize(arr);
//--- check
   if(size==0)
     {
      Print(__FUNCTION__+": array size error");
      return(-1);
     }
//--- initialization of variables
   int    mini=-1;
   int    maxi=-1;
   int    m=0;
   double sig=MathSqrt(dx);
   double gsig=g*sig;
   double min=center-gsig;
   double max=center+gsig;
//--- calculation
   for(int i=size-1;maxi<0;i--)
      if(arr[i]<=max)
         maxi=size-1-i;
   for(int i=0;mini<0;i++)
      if(arr[i]>=min)
         mini=i;
//--- changing the array structure
   m=size-mini-maxi;
   for(int i=0; i<m; i++)
      arr[i]=arr[i+mini];
//--- returning the result
   return(ArrayResize(arr,m));
  }
//+------------------------------------------------------------------+
//| Creating the distribution histogram to *.csv file                |
//| (for viewing in Excel)                                           |
//+------------------------------------------------------------------+
bool Histogram(double &arr[])
  {
   int size=ArraySize(arr);
//--- check
   if(size<=0)
     {
      Print(__FUNCTION__+": array size error");
      return(false);
     }
//--- initialization of variables
   double center=0.0;
   double mx=0.0;
   double xmin=0.0;
   double xmax=0.0;
   double delta=0.0;
   double max=0.0;
   double d=0.0;      // histogram column width
   double dx=0.0;
   double a=0.0;
   double e=0.0;
   double g=0.0;
   double s=0.0;      // unnormalized histogram area (=d*size)
   double histog[];
   int    l=0;        // number of the histogram columns (odd)
   int    num=0;
   int    handle=0;
//---
   ArraySort(arr);
   center=AverageOfEvaluations(arr); // getting the average from the evaluations
   dx=Variance(arr,center);          // variance calculation
   e=Excess2(arr,center,dx);         // excess calculation
   g=CensorCoeff(size,e);            // censoring ratio calculation
   size=Resize(arr,g,dx,center);     // determining the array new size
   mx=Average(arr);                  // average
   dx=Variance(arr,mx);              // variance new value
   a=Asymmetry(arr,mx,dx);           // asymmetry value
   e=Excess2(arr,mx,dx);             // excess new value
   l=HistogramLength(e,size);        // determining the histogram new length
//--- creating a histogram
   max=MathMax(MathAbs(arr[0]-mx),MathAbs(arr[size-1]-mx));
   xmin=mx-max;
   xmax=mx+max;
   d=2*max/l;
   delta=xmax-xmin;
   ArrayResize(histog,l);
   ArrayInitialize(histog,0.0);
   for(int i=0;i<size;i++)
     {
      num=(int)((arr[i]-xmin)/delta*l);
      if(num==l) num--;
      histog[num]++;
     }
//---
   s=d*size;
   for(int i=0;i<l;i++)
      histog[i]/=s;
//---
   if(MathAbs(a)/MathSqrt(VarianceOfAsymmetry(size))<3)
      for(int i=0;i<l/2;i++)
        {
         histog[i]=(histog[i]+histog[l-1-i])/2;
         histog[l-1-i]=histog[i];
        }
//--- writing to file
   handle=FileOpen("histogram.csv",FILE_CSV|FILE_WRITE);
//--- check
   if(handle!=INVALID_HANDLE)
     {
      for(int i=0;i<l;i++)
         FileWrite(handle,histog[i]);
      FileClose(handle);
     }
//--- file open error
   else
     {
      Print(__FUNCTION__+": file open error");
      return(false);
     }
//---
   return true;
  }
//+------------------------------------------------------------------+
//| Custom covariation                                               |
//+------------------------------------------------------------------+
double Cov(double &arrX[],double &arrY[],double mx,double my)
  {
   int sizeX=ArraySize(arrX);
//--- check
   if(sizeX<=1)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//---
   int sizeY=ArraySize(arrY);
//--- check
   if(sizeX!=sizeY)
     {
      Print(__FUNCTION__+" dimensional arrays are not equal");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   for(int i=0;i<sizeX;i++)
      sum+=(arrX[i]-mx)*(arrY[i]-my);
//--- returning the result
   return(sum/(sizeX-1));
  }
//+------------------------------------------------------------------+
//| Custom correlation ratio                                         |
//+------------------------------------------------------------------+
double Corr(double cov,double dx,double dy)
  {
//--- check
   if(dx==0 || dy==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(cov/MathSqrt(dx)/MathSqrt(dy));
  }
//+------------------------------------------------------------------+
//| Custom correlation variance                                      |
//+------------------------------------------------------------------+
double VarianceOfCorr(double p,int size)
  {
//--- check
   if(size==1)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(MathPow(1.0-MathPow(p,2),2)/(size-1));
  }
//+------------------------------------------------------------------+
//| por sequence autocorrelation                                     |
//+------------------------------------------------------------------+
double AutoCorr(double &arr[],double mx,int por)
  {
//--- check
   if(por<0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- initializing
   int    size=ArraySize(arr)-por;
   double sum1=0.0;
   double sum2=0.0;
   double sum3=0.0;
//--- calculation
   for(int i=0; i<size; i++)
     {
      sum1+=(arr[i]-mx)*(arr[i+por]-mx);
      sum2+=MathPow(arr[i]-mx,2);
      sum3+=MathPow(arr[i+por]-mx,2);
     }
//--- check
   if(!sum2 || !sum3)
     {
      Print(__FUNCTION__+": incorrect summ value");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(sum1/MathSqrt(sum2)/MathSqrt(sum3));
  }
//+------------------------------------------------------------------+
//| Autocorrelation function (ACF)                                   |
//+------------------------------------------------------------------+
bool AutoCorrFunc(double &arr[],double mx,int count,double &res[])
  {
   int size=ArraySize(arr);
   count++;
//--- check
   if(count>size)
     {
      Print(__FUNCTION__+": the error variable");
      return(false);
     }
//--- calculation
   double sum1=0.0;
   double sum2=0.0;
   ArrayResize(res,count);
   res[0]=1.0;
   for(int i=1; i<count; i++)
      res[i]=AutoCorr(arr,mx,i);
//---
   return true;
  }
//+------------------------------------------------------------------+
//| a ratio in the y=a*x+b linear regression equation                |
//+------------------------------------------------------------------+
double aCoeff(double p,double sigX,double sigY)
  {
//--- check
   if(sigX==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(p*sigY/sigX);
  }
//+------------------------------------------------------------------+
//| b ratio in the y=a*x+b linear regression equation                |
//+------------------------------------------------------------------+
double bCoeff(double mx,double my,double a)
  {
   return(my-a*mx);
  }
//+------------------------------------------------------------------+
//| Writes the linear regression errors into e[] array               |
//+------------------------------------------------------------------+
bool LineRegresErrors(double &arrX[],double &arrY[],double a,double b,double &e[])
  {
   int sizeX=ArraySize(arrX);
   int sizeY=ArraySize(arrY);
//--- check
   if(sizeX!=sizeY)
     {
      Print(__FUNCTION__+" dimensional arrays are not equal");
      return(false);
     }
//--- record
   ArrayResize(e,sizeX);
   for(int i=0;i<sizeX;i++)
      e[i]=arrY[i]-a*arrX[i]-b;
//---
   return true;
  }
//+------------------------------------------------------------------+
//| Variance of the errors of å-deviations from the regression line  |
//| (it is accepted that Me=0)                                       |
//+------------------------------------------------------------------+
double eVariance(double &e[])
  {
   int size=ArraySize(e);
//--- check
   if(size==2)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   for(int i=0;i<size;i++)
      sum+=MathPow(e[i],2);
//--- returning the result
   return(sum/(size-2));
  }
//+------------------------------------------------------------------+
//| à parameter variance in the y=a*x+b linear regression equation   |
//+------------------------------------------------------------------+
double aVariance(int size,double dx,double de)
  {
//--- check
   if(dx==0 || size==1)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(de/dx/(size-1));
  }
//+------------------------------------------------------------------+
//| b parameter variance in the y=a*x+b linear regression equation   |
//+------------------------------------------------------------------+
double bVariance(double &arr[],double dx,double de)
  {
//--- check
   if(dx==0)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//---
   int size=ArraySize(arr);
//--- check
   if(size<=0)
     {
      Print(__FUNCTION__+": array size error");
      return(EMPTY_VALUE);
     }
//--- calculation
   double sum=0.0;
   for(int i=0;i<size;i++)
      sum+=MathPow(arr[i],2);
//--- returning the result
   return(de*(size-1)*sum/dx/size);
  }
//+------------------------------------------------------------------+
//| Determination ratio                                              |
//+------------------------------------------------------------------+
double DeterminationCoeff(int size,double dy,double de)
  {
//--- check
   if(dy==0 || size==1)
     {
      Print(__FUNCTION__+": the error variable");
      return(EMPTY_VALUE);
     }
//--- returning the result
   return(1.0-de*(size-2)/dy/(size-1));
  }
//+------------------------------------------------------------------+
//| Splits an array of arr[n][2] type in two arrays                  |
//+------------------------------------------------------------------+
void ArraySeparate(double &arr[][2],double &arrX[],double &arrY[])
  {
   int size=ArraySize(arr)/2;
//---
   ArrayResize(arrX,size);
   ArrayResize(arrY,size);
//---
   for(int i=0;i<size;i++)
     {
      arrX[i]=arr[i][0];
      arrY[i]=arr[i][1];
     }
  }
//+------------------------------------------------------------------+
//| Joins two arrays into one of arr[n][2] type                      |
//+------------------------------------------------------------------+
void ArrayUnion(double &arrX[],double &arrY[],double &arr[][2])
  {
   int size=ArraySize(arrX);
//---
   ArrayResize(arr,size*2);
   for(int i=0;i<size;i++)
     {
      arr[i][0]=arrX[i];
      arr[i][1]=arrY[i];
     }
  }
//+------------------------------------------------------------------+
//| Writes one-dimensional array to *.csv file                       |
//+------------------------------------------------------------------+
bool WriteArray(double &arr[],string name="")
  {
//--- check
   if(name=="")
      name=TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS);
//--- opening the file
   int handle=FileOpen(name+".csv",FILE_CSV|FILE_WRITE);
//--- check
   if(handle!=INVALID_HANDLE)
     {
      int size=ArraySize(arr);
      for(int i=0;i<size;i++)
         FileWrite(handle,DoubleToString(arr[i],8));
      FileClose(handle);
     }
//--- file open error
   else
     {
      Print(__FUNCTION__+": file open error");
      return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Writes two-dimensional array of arr[n][2] type to *.csv file     |
//+------------------------------------------------------------------+
bool WriteArray2(double &arr[][2],string name="")
  {
//--- check
   if(name=="")
      name=TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS);
//--- opening the file
   int handle=FileOpen(name+".csv",FILE_CSV|FILE_WRITE);
//--- check
   if(handle!=INVALID_HANDLE)
     {
      int size=ArraySize(arr)/2;
      for(int i=0;i<size;i++)
         FileWrite(handle,DoubleToString(arr[i][0],8),DoubleToString(arr[i][1],8));
      FileClose(handle);
     }
//--- file open error
   else
     {
      Print(__FUNCTION__+": file open error");
      return(false);
     }
//---
   return(true);
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MQL4 MIGRATION FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int tfk_dayOfWeek() { MqlDateTime tm; TimeCurrent(tm); return(tm.day_of_week);}
int tfk_Hour() { MqlDateTime tm; TimeCurrent(tm); return(tm.hour);}
int tfk_Minute() { MqlDateTime tm; TimeCurrent(tm); return(tm.min);}
int tfk_Seconds(){ MqlDateTime tm; TimeCurrent(tm); return(tm.sec);}
//+------------------------------------------------------------------+
//| Set Object on chart
//+------------------------------------------------------------------+
bool tfk_objectSet(string name,
                   int index,
                   double value)
  {
   switch(index)
     {
      case OBJPROP_PRICE: ObjectSetDouble(0,name,OBJPROP_PRICE,1,value);return(true);
      case OBJPROP_TIME: ObjectSetInteger(0,name,OBJPROP_TIME,2,(int)value);return(true);
      case OBJPROP_COLOR: ObjectSetInteger(0,name,OBJPROP_COLOR,(int)value);return(true);
      case OBJPROP_STYLE: ObjectSetInteger(0,name,OBJPROP_STYLE,(int)value);return(true);
      case OBJPROP_WIDTH: ObjectSetInteger(0,name,OBJPROP_WIDTH,(int)value);return(true);
      case OBJPROP_BACK: ObjectSetInteger(0,name,OBJPROP_BACK,(int)value);return(true);
      case OBJPROP_RAY: ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,(int)value);return(true);
      case OBJPROP_ELLIPSE: ObjectSetInteger(0,name,OBJPROP_ELLIPSE,(int)value);return(true);
      case OBJPROP_SCALE: ObjectSetDouble(0,name,OBJPROP_SCALE,value);return(true);
      case OBJPROP_ANGLE: ObjectSetDouble(0,name,OBJPROP_ANGLE,value);return(true);
      case OBJPROP_ARROWCODE: ObjectSetInteger(0,name,OBJPROP_ARROWCODE,(int)value);return(true);
      case OBJPROP_TIMEFRAMES: ObjectSetInteger(0,name,OBJPROP_TIMEFRAMES,(int)value);return(true);
      case OBJPROP_DEVIATION: ObjectSetDouble(0,name,OBJPROP_DEVIATION,value);return(true);
      case OBJPROP_FONTSIZE: ObjectSetInteger(0,name,OBJPROP_FONTSIZE,(int)value);return(true);
      case OBJPROP_CORNER: ObjectSetInteger(0,name,OBJPROP_CORNER,(int)value);return(true);
      case OBJPROP_XDISTANCE: ObjectSetInteger(0,name,OBJPROP_XDISTANCE,(int)value);return(true);
      case OBJPROP_YDISTANCE: ObjectSetInteger(0,name,OBJPROP_YDISTANCE,(int)value);return(true);
      case OBJPROP_LEVELCOLOR: ObjectSetInteger(0,name,OBJPROP_LEVELCOLOR,(int)value);return(true);
      case OBJPROP_LEVELSTYLE: ObjectSetInteger(0,name,OBJPROP_LEVELSTYLE,(int)value);return(true);
      case OBJPROP_LEVELWIDTH: ObjectSetInteger(0,name,OBJPROP_LEVELWIDTH,(int)value);return(true);
      default: return(false);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Set text object on chart
//+------------------------------------------------------------------+
bool tfk_objectSetText(string name,
                       string text,
                       int font_size,
                       string font="",
                       color text_color=CLR_NONE)
  {
   int tmpObjType=(int)ObjectGetInteger(0,name,OBJPROP_TYPE);
   if(tmpObjType!=OBJ_LABEL && tmpObjType!=OBJ_TEXT) return(false);
   if(StringLen(text)>0 && font_size>0)
     {
      if(ObjectSetString(0,name,OBJPROP_TEXT,text) && ObjectSetInteger(0,name,OBJPROP_FONTSIZE,font_size))
        {
         if((StringLen(font)>0) && !ObjectSetString(0,name,OBJPROP_FONT,font)) return(false);
         if( (text_color>0) && !ObjectSetInteger(0,name,OBJPROP_COLOR,text_color)) return(false);
         return(true);
        }
      return(false);
     }
   return(false);
  }
bool tfk_objectCreate(string name,ENUM_OBJECT type,int window,datetime time1,double price1,datetime time2=0,double price2=0,
                      datetime time3=0,double price3=0){ return(ObjectCreate(0,name,type,window,time1,price1,time2,price2,time3,price3));}
                      //+------------------------------------------------------------------+
