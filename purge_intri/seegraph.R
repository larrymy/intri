# plot_df <- final_full_df

library(ggplot2)
library(dplyr)

code1 <- unique(plot_df[,"code"])

for(c in code1){
      subdf <- plot_df %>% filter(code == c)
      stock1 <- subdf[nrow(subdf),"stock"]
      
      # a <- paste0("http://www.malaysiastock.biz/Stock-Chart.aspx?securitycode=", c,"&mode=D")
      # browseURL(a)

      # g <- plot_df %>% filter(code == c) %>% ggplot(aes(x = date, y = close)) + geom_line() + ggtitle(paste(c, stock1))
      # print(g)
      View(subdf)
      readline("next................")
           
}


u1 <- grep(pattern = "^0{1}$", x = plot_df$close)
plot_df[u1 ,c("open", "high", "low", "close")]  <- plot_df[u1-1,"close"]
View( plot_df %>% filter(code == "8885"))

