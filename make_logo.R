 # program to make the logo

library(tidyverse)
library(convdistr)
library(hexSticker)

a<- new_LOGNORMAL(0.5,2)
b<- new_NORMAL(10,2) 
c <- a+b

sa <- rfunc(a,10000)
sb <- rfunc(b,10000)
sc <- rfunc(c,10000)

df <- tibble( A = sa, B = sb, `convolution A + B` = sc) |> 
  pivot_longer(everything(), names_to = "distribution", values_to = "value" )


gg <- ggplot(df) +
  aes(x = value,
      y = after_stat(density),
      fill = distribution) +
  geom_histogram(
    alpha = 0.4,
    bins = log10(n) * 7,
    color = "white",
    linewidth = 0.1
  )  +
  facet_wrap( ~ distribution, strip.position = "bottom") +
  scale_x_continuous("", limits = c(0, 20)) +
  scale_y_continuous("", limits = c(0, 0.25)) +
  scale_fill_manual(values = c("#F8766D", "#619CFF", "#AD89B6")) +
  theme_void() +
  theme_transparent() +
  theme(
    legend.position = "none",
    strip.text = element_text(
      size = 8,
      face = "bold",
      margin = margin(t = 0, b = 0, unit = "lines")
    ),
    # optional styling
  )
gg  

sticker(
  gg, s_x = 1, s_y = 1, s_width = 1.4, s_height = 1, 
  package = "convdistr", p_color = "black", p_size = 18, p_y = 1.5,
  h_color = "black", h_fill = "#F5f5f5",
  white_around_sticker = T
)  
