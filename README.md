# Trading Bot SuperMao

SuperMao is a trading bot named after my imaginary cat. It trades on Meta Trader trading platform. It takes into account
the following things before taking any position-

1. If the Ask price is within lower band of 2 standard deviation and upper band 1 standard deviation Bollinger Bands and the MACD line is above the MACD signal line,
it goes long. The Stop Loss is set at the lower band of 6 standard deviation Bollinger Band. Take Profit is set at the
upper band of the 1 standard deviation Bollinger Bands.

2. If the Bid price is within upper bands of 2 standard deviation and lower band 1 standard deviation Bollinger Bands and the MACD line is below the MACD
Signal Line it goes short. The Stop Loss is set at the upper band of 6 standard deviation Bollinger Bands. Take Profit is set 
at the lowr band of the 1 standard deviation Bollinger Bands. 

3. A currency pair can have only one active positon on a specific timeframe, SuperMao stops you from losing everything too quickly.  

### Disclaimer

SuperMao is not perfect, don't set it free. It can blow your capital as quickly as 1 week. Don't blame the cat, blame the creator. However, he is working procrastinatingly to make the cat a better hunter. 

According to the back-test run on the previous 6-month data, SuperMao has a success rate of over 90%. 