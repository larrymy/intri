library(httr)
#daily all stocks
# https://api.intrinio.com/prices/exchange.csv?identifier=^XKLS&price_date=2017-09-21

# https://api.intrinio.com/prices.csv?ticker=$SPX
# https://api.intrinio.com/prices.csv?ticker=$SPX
# https://api.intrinio.com/prices.csv?identifier=WLW:MK
# https://d82a8b255816b922a436ab6ffb177ec3:92ad8da92b80534003d9f134ec1f82a5@api.intrinio.com/prices.csv?identifier=WLW:MK

# download.file("https://d82a8b255816b922a436ab6ffb177ec3:92ad8da92b80534003d9f134ec1f82a5@api.intrinio.com/prices.csv?identifier=WLW:MK", destfile = "test.csv")

prices <- function(ticker){
      price_base <- "https://api.intrinio.com/prices?identifier="
      username <- "d82a8b255816b922a436ab6ffb177ec3"
      password <- "92ad8da92b80534003d9f134ec1f82a5"
      
      price <- paste(price_base,ticker,sep="")
      tp <- GET(price, authenticate(username, password, type = "basic"))
      z <- unlist(content(tp,"parsed"))
      
      n=length(z)
      b=as.data.frame(matrix(z[1:(n-5)],(n-5)/13, byrow = T))
      names(b)=names(z)[1:13]
      
      return(b)
}

prices_csv <- function(ticker){
      price_base_1 <- "https://" 
      price_base_2 <- "@api.intrinio.com/prices.csv?identifier="
      username <- "d82a8b255816b922a436ab6ffb177ec3"
      password <- "92ad8da92b80534003d9f134ec1f82a5"
      
      price <- paste(price_base_1, username, ":", password, price_base_2, ticker,sep="")
      
      fname <- paste0(strsplit(ticker, ":")[[1]][1], ".csv")
      download.file(url = price, destfile = fname)
      # b <- read.csv(price, stringsAsFactors = F)
      # tp <- GET(price, authenticate(username, password, type = "basic"))
      # z <- unlist(content(tp,"parsed"))
      
      # n=length(z)
      # b=as.data.frame(matrix(z[1:(n-5)],(n-5)/13, byrow = T))
      # names(b)=names(z)[1:13]
      
      # return(z)
}

# 1 stock
# setwd("C:/Users/jy/Desktop/")
# prices_csv("PENT:MK")

# mass import
setwd("C:/Users/jy/Desktop/intrinio")
all_securities <- read.csv("securities_xkls.csv", stringsAsFactors = F, skip = 1)
u1 <- all_securities[, "SECURITY_TYPE"] == "Common Stock"
all_ticker <- all_securities[u1, "FIGI_TICKER"]

setwd("C:/Users/jy/Desktop/all_stock")
N <- length(all_ticker)
for(i in all_ticker){
      prices_csv(i)
}



# a <- grep(z, pattern = "OPEN")
# b <- grep(z, pattern = "DATE")
#      N <- a-b-1
# 
#      k = 11
#      b=as.data.frame(matrix(z[1:(k*(N+1))],nrow = N+1, ncol = k, byrow = F)) 
#        b   
# RCurl::getURL(
# ticker <- "MTI:MK"
# df <- prices("WLW:MK")
# df2 <- prices_csv("MTI:MK")
# str(df2)
# nrow(df)

# z <- unlist(content(df2,"parsed"))

# base <- "https://api.intrinio.com/"
# endpoint <- "data_point"
# stock <- "AAPL"
# item1 <- "close_price"
# item2 <- "pricetoearnings"
# call1 <- paste(base,endpoint,"?","ticker","=", stock, "&","item","=",item1, sep="")
# call2 <- paste(base,endpoint,"?","ticker","=", stock, "&","item","=",item2, sep="")
# 
# apple_price <- GET(call1, authenticate(username,password, type = "basic"))
# apple_pricetoearnings <- GET(call2, authenticate(username,password, type = "basic"))
# 
# 	
# test1 <- unlist(content(apple_price,"parsed"))
# test2 <- unlist(content(apple_pricetoearnings,"parsed"))
# 
# df <- data.frame(test1,test2)


