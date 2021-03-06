library(httr)
library(ymd)
#daily all stocks
# https://api.intrinio.com/prices/exchange.csv?identifier=^XKLS&price_date=2017-09-21

# https://api.intrinio.com/prices.csv?ticker=$SPX
# https://api.intrinio.com/prices.csv?ticker=$SPX
# https://api.intrinio.com/prices.csv?identifier=WLW:MK
# https://d82a8b255816b922a436ab6ffb177ec3:92ad8da92b80534003d9f134ec1f82a5@api.intrinio.com/prices.csv?identifier=WLW:MK

# download.file("https://d82a8b255816b922a436ab6ffb177ec3:92ad8da92b80534003d9f134ec1f82a5@api.intrinio.com/prices.csv?identifier=WLW:MK", destfile = "test.csv")

#https://api.intrinio.com/securities?exch_symbol=
url_csv <- function(){
      price_base_1 <- "https://" 
      price_base_2 <- "@api.intrinio.com/securities.csv?exch_symbol=^XKLS"
      username <- "d82a8b255816b922a436ab6ffb177ec3"
      password <- "92ad8da92b80534003d9f134ec1f82a5"
      
      price <- paste(price_base_1, username, ":", password, price_base_2,sep="")
      
      date_char <- gsub(pattern = "-", replacement = "", x = Sys.Date())
      if(!dir.exists("xkls_list_of_securities")){
        dir.create("xkls_list_of_securities")
      }
      fname <- paste0("./xkls_list_of_securities/", date_char, "_xkls.csv")
      download.file(url = price, destfile = fname)
      
      return(fname)
}

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

prices_csv <- function(ticker, name){
      price_base_1 <- "https://" 
      price_base_2 <- "@api.intrinio.com/prices.csv?identifier="
      username <- "d82a8b255816b922a436ab6ffb177ec3"
      password <- "92ad8da92b80534003d9f134ec1f82a5"
      
      price <- paste(price_base_1, username, ":", password, price_base_2, ticker,sep="")
      
      fname <- paste0(name, "_", strsplit(ticker, ":")[[1]][1], ".csv")
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
setwd("C:/Users/jy/Desktop/intri")

#get all securities
filename <- url_csv() #export list of xkls securities, and return the <filename.csv>
all_securities <- read.csv(file=filename, stringsAsFactors = F, skip = 1)
# all_securities <- read.csv("securities_xkls.csv", stringsAsFactors = F, skip = 1)
u1 <- all_securities[, "SECURITY_TYPE"] == "Common Stock"
all_figi_ticker <- all_securities[u1, "FIGI_TICKER"]
all_ticker <- all_securities[u1, "TICKER"]

if(!dir.exists("data")){dir.create("data")}
setwd("C:/Users/jy/Desktop/intri/data")
date_char <- gsub(pattern = "-", replacement = "", x = Sys.Date())
dir.create(date_char)
setwd(paste0("C:/Users/jy/Desktop/intri/data/", date_char))

N <- length(all_ticker); print(N);
for(i in 1:N){
      prices_csv(all_figi_ticker[i], all_ticker[i])
}

print("Done")


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


