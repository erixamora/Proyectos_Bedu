#Creacion Base de datos
Create database if not exists proyecto_bedu;
use proyecto_bedu;
#Creacion de la tabla
create table if not exists heart_failure (id int auto_increment Primary key,age smallint,
anaemia boolean,creatinine_phosphokinase int, diabetes boolean,ejection_fraction smallint, high_blood_pressure boolean,
platelets double, serum_creatinine double, serum_sodium int, sex smallint, smoking boolean, `time` smallint, 
death_event boolean);
# Anaemia= decremento de hemoglobina o globulos rojos, Ejection_fraction= porcentaje de la sangre que deja el corazon con cada contracccion
# Creatinine_phosphokinase= nivel de la enzyma CPK en la sangre mcg/L,sexo 0-mujer 1-hombre,
# platelets= plaquetas en sangre kiloplatelets/mL, serum_creatinine= nivel de creatinina en sangre mg/dL
# serum_sodium= niveles de sodio en sangre mEq/L, time= tiempo de observacion
# valores normales de CPk 10-120mcg/L, niveles de plaquetas normales en sangre 150,000 a 400,000 por microlitro (mcL)

select * from heart_failure;

#Promedio de edad de las personas que fallecen general
Select avg(age) as edad_prom_fallecidos from heart_failure where death_event = true;
#Promedio de edad de las personas que fallecen  de hombres y mujeres
Select avg(age) as Hombres_edad_prom from heart_failure where death_event = true and sex=1;
Select avg(age) as Mujeres_edad_prom from heart_failure where death_event = true and sex=0;
#death_event y edad de los pacientes que tienen diabetes, anemia, hipertension y fuman
select death_event, age from heart_failure where diabetes= true and anaemia =true and high_blood_pressure =true and smoking =true;

#Mayor numero de microgramos por litro de la CPK y su death_event
select creatinine_phosphokinase, death_event from heart_failure order by creatinine_phosphokinase desc limit 1;

#pacientes cuyas plaquetas son mayores a lo normal y su death event sea fallecido
select * from heart_failure where platelets>=400000 and death_event=true;

#creacion de views
create view paciente_cuadro_basico as (select id, age, sex, anaemia, diabetes, high_blood_pressure, smoking, death_event, `time` from heart_failure );
create view analisis_sanguineo as (select id, creatinine_phosphokinase, ejection_fraction, platelets, serum_creatinine, serum_sodium from heart_failure);

#confirmacion de views
select * from paciente_cuadro_basico;
select * from analisis_sanguineo;

#Joins ejemplo
select * from paciente_cuadro_basico 
join analisis_sanguineo on paciente_cuadro_basico.id = analisis_sanguineo.id;

#Otros ejemplos
#edad,sexo death_event, diabetes, niveles de la enzima CPK en sangre y conteo de plaquetas de gente mayor a 60 años
select age, sex, diabetes, creatinine_phosphokinase, platelets,death_event 
from paciente_cuadro_basico 
join analisis_sanguineo 
on paciente_cuadro_basico.id = analisis_sanguineo.id
where age>60 order by age desc;

#Edad,sexo, death_event, diabetes, hipertension, plaquetas, smoking de pacientes que tengan la enzima CPK por arriba de los niveles normales
select age,sex,diabetes, creatinine_phosphokinase ,high_blood_pressure,platelets, smoking, death_event
from paciente_cuadro_basico
join analisis_sanguineo
on paciente_cuadro_basico.id=analisis_sanguineo.id
where creatinine_phosphokinase> 120 order by creatinine_phosphokinase desc;

#pacientes cuyas plaquetas se encuentran fuera de los niveles normales y hayan fallecido
select age , sex, platelets, death_event
from paciente_cuadro_basico as cb
join analisis_sanguineo as ans
on cb.id=ans.id
where death_event=true and (platelets >= 400000 or platelets <= 150000) order by platelets desc;

#saber id, edad minimo de sodio y creatinina de personas de personas que fuman, tienen hipertension y han fallecido
select cb.id , age, min(serum_sodium), min(serum_creatinine)
from paciente_cuadro_basico as cb join analisis_sanguineo as ans
on cb.id= ans.id where high_blood_pressure=true and smoking=true and death_event=true;
