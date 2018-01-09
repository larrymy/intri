setwd("C:/Users/jy/Desktop/intri/purge_intri/daily_exchange_data_20171110")

filenames <- dir(pattern = "*.csv")

replace <- function(df, replacewhat = "OPEN", replacewith = "CLOSE"){
      u1 <- is.na(df[,replacewhat]) || df[,replacewhat] == 0
      df[u1, replacewhat] <- df[u1, replacewith]
      return(df)
}

imputezero <- function(df, imputewhat = "VOLUME"){
      u1 <- is.na(df[,imputewhat])
      df[u1, imputewhat] <- 0
      return(df)
}

fill_ticker <- function(ticker){
      n <- nchar(ticker)
      if(n < 4){
            for(i in 1:(4-n)){
                  ticker <- paste0("0",ticker)
            }
            return(ticker)
      }else{
            return(as.character(ticker))
      }
}

a <- lapply(filenames, FUN = function(j){
      df <- read.csv(j, skip = 1)
            df <- replace(df, "OPEN", "CLOSE")
            df <- replace(df, "HIGH", "CLOSE")
            df <- replace(df, "LOW", "CLOSE")
            df <- replace(df, "ADJ_OPEN", "ADJ_CLOSE")
            df <- replace(df, "ADJ_HIGH", "ADJ_CLOSE")
            df <- replace(df, "ADJ_LOW", "ADJ_CLOSE")
            
            df <- imputezero(df, "VOLUME")
            df <- imputezero(df, "ADJ_VOLUME")
            
      return(df)
})


fdf <- do.call(rbind, a)

fdf[,"TICKER"] <- sapply((fdf[,"TICKER"]), FUN = fill_ticker)

save(fdf, file = "../20171110_fdf_intri.rda")
write.csv(fdf, file = "20171110_fdf.csv", row.names = F)
