library(scales)
library(ggplot2)
library(dplyr)
library(plotly)
library(corrplot)

#carga de datos
getwd()
setwd("G:/BEDU/ProyectoR")

fallo <- read.csv("heart_failure_clinical_records_dataset.csv")
#confirmacion, exploracion inical
class(fallo)
head(fallo)
tail(fallo)
str(fallo)
attach(fallo)
summary(fallo)

#determinar columnas como factores
factores = c("anaemia", "diabetes", "high_blood_pressure", "sex", "smoking", "DEATH_EVENT")
fallo2 <- as.data.frame(fallo)
fallo <- fallo %>%
  mutate_at(factores, as.factor)

#graficos sencillos
#grafico 

grafico2 <- ggplot(fallo,aes( x=diabetes, y= platelets, fill=anaemia))+
  geom_boxplot()+
  scale_fill_discrete(name="Anemia") +
  ggtitle("Niveles de plaquetas de personas que son anemicas y diabeticas")+
  xlab("diabetes")+
  ylab("Plaquetas")+
  facet_wrap("DEATH_EVENT")

#eeee
ggplotly(grafico2)

#grafico 

grafica3 <- ggplot(fallo, aes(x = platelets, y = creatinine_phosphokinase , colour = DEATH_EVENT)) +
  geom_point() +
  labs(title = "Relacion de la creatinina y plaquetas en personas con hipertension" ) +
  facet_wrap("high_blood_pressure")
  

ggplotly(grafica3)

#grafica para ver la correlacion que hay 

corrplot(cor(fallo2),type= "lower", tl.col = "black", tl.srt = 45, addCoef.col = TRUE, sig.level = 0.05)

#regresion lineal

modelo1 <- lm(DEATH_EVENT ~ age + anaemia + high_blood_pressure + serum_creatinine + smoking + 
                diabetes + creatinine_phosphokinase + platelets + ejection_fraction + serum_sodium)
summary(modelo1)

cor(serum_creatinine, DEATH_EVENT)
cor(creatinine_phosphokinase, DEATH_EVENT)
#graficar los 2 mas relacionados ejection fraccion(% expulsado de sangre) 
#se ve la clara distincion entre los pacientes vivos y muertos

graficaSE <- ggplot(fallo, aes(x = serum_creatinine, y = ejection_fraction, colour = DEATH_EVENT)) +
    geom_point() +
    geom_abline(intercept=0, slope=15, colour="black", linetype="dashed") +
    labs(title = "Creatinina en suero con relación con el % de sangre explusado" ) +
    theme_minimal(base_size = 12)
 
ggplotly(graficaSE)

#grafica de
#Pequeña conclusion, podemos ver la relacion de algunos factores en los casos de fallos cardiacos
#conforme a lo que se hizo
#nos damos cuenta la creatinina en suero es de los factores mas importantes a considerar

