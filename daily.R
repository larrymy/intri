daily_csv <- function(today_date = "2017-10-23"){
  
  #https://api.intrinio.com/prices/exchange.csv?identifier=^XKLS&price_date=2017-10-23
  price_base_1 <- "https://" 
  price_base_2 <- "@api.intrinio.com/prices/exchange.csv?identifier=^XKLS&price_date="
  # today_date <- "2017-10-24"
  username <- "d82a8b255816b922a436ab6ffb177ec3"
  password <- "92ad8da92b80534003d9f134ec1f82a5"
  
  price <- paste(price_base_1, username, ":", password, price_base_2, today_date, sep="")
  
  datepart <- gsub(pattern = "-", replacement = "", x = as.character(Sys.Date()))
  dirname <- paste0("daily_exchange_data_", datepart)
  if(!dir.exists(  dirname  )){
    dir.create(dirname)
  }
  date_char <- gsub(pattern = "-", replacement = "", x = today_date)
  fname <- paste0("./", dirname, "/", date_char, "_daily_xkls.csv")
  download.file(url = price, destfile = fname)
  
  df_temp <- read.csv(fname, skip = 1, header = T)
  print(nrow(df_temp))
  if(nrow(df_temp) == 0){
    file.remove(fname)
    return(NA)
  }else{
    return(fname)
  }
  
  
}


loop_daily_csv <- function(start_date = Sys.Date(), loop = 10){
  loop_date <- sapply(1:loop, FUN = function(x){
    return(as.character(start_date - x + 1))
  })
  
  fname_v <- sapply(loop_date, FUN = function(datee){
    daily_csv(datee);
  })
  return(fname_v)
}


setwd("C:/Users/jy/Desktop/intri")

loop_daily_csv(loop = 5000)

# daily_csv("2017-10-23")