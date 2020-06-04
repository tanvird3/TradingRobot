# Trading Bot SuperMao

SuperMao is a trading bot named after my imaginary cat. It trades on Meta Trader trading platform. It takes into account
the following things before taking any position-

1. If the Ask price is within lower bands of 1 and 2 standard deviation Bollinger Bands and the MACD line is above the MACD signal line,
it goes long. The Stop Loss is set at the lower band of 4 standard deviation Bollinger Band. Take Profit is set at the
middle band.

2. If the Bid price is within upper bands of 1 and 2 standard deviation Bollinger Bands and the MACD line is below the MACD
Signal Line it goes short. The Stop Loss is set at the upper band of 4 standard deviation Bollinger Bands. Take Profit is set 
at the middle band. 

3. A currency pair can have only one active positon on a specific timeframe, SuperMao stops you from losing everything too quickly.  

### Disclaimer

SuperMao is not perfect, don't set it free. It can blow your capital as quickly as 1 week. Unlike many others, the creator of SuperMao takes
of SuperMao takes full liability. He is working procrastinatingly to make the cat a better hunter. 