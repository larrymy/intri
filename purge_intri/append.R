#append fdf
library(dplyr)
library(lubridate)

#Load data
setwd("C:/Users/jy/Desktop/intri/purge_intri/")
load("3_20171110_fdf_intri.rda")
setwd("C:/Users/jy/Desktop/tempmplus/rda")
load("plot_df.rda")

#last date
lastdate <- max(df[,"DATE"])

df1 <- plot_df %>% 
      filter(date == lastdate) %>% 
      select(code, open, high, low, close) %>%
      mutate(type = "mplus") #next time add volume
      
df2 <- df %>%
      filter(DATE == lastdate) %>% 
      select(code = TICKER, open = ADJ_OPEN, high = ADJ_HIGH, low = ADJ_LOW, close = ADJ_CLOSE) %>%
      mutate(type = "intri")

mergedf <- merge(df1,df2, by = "code", all = T)
scaledf <- mergedf %>% mutate(scale = close.y/close.x) %>% mutate(scale = ifelse(is.na(scale), 1, scale))



newdf <- (merge(plot_df, scaledf %>% select(code, scale), by = "code")) 

plot_df_before <- newdf %>% 
                  filter(date < lastdate) %>% select(-scale)
plot_df_after <- newdf %>% 
                  filter(date >= lastdate) %>% 
                  mutate(open = open*scale, 
                              high = high*scale,
                              low = low*scale,
                              close = close*scale) %>% 
                  select(code, stock, date, open, high, low, close, vol)

intri_df_before <- df %>%
                        filter(DATE < lastdate) %>% 
                        select(code = TICKER, stock = FIGI_TICKER, date = DATE, open = ADJ_OPEN, high = ADJ_HIGH, low = ADJ_LOW, close = ADJ_CLOSE, vol = VOLUME)
                                                                                                
intri_missing_df <- plot_df_before %>% filter(!code %in% intri_df_before$code)
intri_df_before <- intri_df_before %>% mutate(stock = as.character(stock))

final_full_df <- rbind(intri_missing_df, intri_df_before, plot_df_after) %>% arrange(code, date)

u1 <- grep(pattern = "^0{1}$", x = final_full_df$close)
final_full_df[u1 ,c("open", "high", "low", "close")]  <- final_full_df[u1-1,"close"]

fdf_klse <- final_full_df

save(fdf_klse, file = "fdf_klse.rda")
write.csv(fdf_klse, file = "fdf_klse.csv", row.names = F)
