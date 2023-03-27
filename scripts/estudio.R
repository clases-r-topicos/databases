
library(DBI)
library(tidyverse)

conn <-  DBI::dbConnect(
  drv =  RMariaDB::MariaDB(),
  dbname = "ine",
  host =   "143.198.79.143" , #
  port =   1111, #
  password = "ine123", #  , # Sys.getenv("pass"),
  user = "root" #  Sys.getenv("userid")
)

conn <-  DBI::dbConnect(
  drv =  RMariaDB::MariaDB(),
  dbname = "censo",
  host =   "143.198.79.143" , #
  port =   1111, #
  password = "roscalata", #  , # Sys.getenv("pass"),
  user = "reader" #  Sys.getenv("userid")
)




#surveys <- tbl(mammals, "surveys")
ene <- readr::read_csv2("data/ene-2022-12-nde.csv")
ene2 <- ene %>%
  select(idrph, region, provincia, mes_central, id_identificacion, ano_encuesta, estrato, fact_cal, sexo, edad,
         cae_especifico, activ, region, categoria_ocupacion, habituales, efectivas ) %>%
  #slice(1:1000) %>%
  mutate_all(as.character) %>%
  mutate_all(~if_else(is.na(.), "", .))

write_csv(ene2, "data/ene_corregido.csv")

DBI::dbListTables(conn)
DBI::dbReadTable(conn, "viviendas")
DBI::dbRemoveTable(conn, "ene")
DBI::dbCreateTable(conn, "ene2", fields = ene2)


DBI::dbSendQuery(conn, )

LOAD DATA INFILE '/Microdato_Censo2017-Viviendas.csv'
INTO TABLE viviendas
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



####################
# Query using dplyr
####################

ene_table <- tbl(conn, "viviendas")
class(ene_table)

non_collected <-  ene_table %>%
  select(sexo, edad) %>%
  filter(edad >= 30)

dim(non_collected)


collected <-  ene_table %>%
  select(sexo, edad) %>%
  filter(edad >= 30) %>%
  collect()

dim(collected)
class(test1)


####################
# Query using SQL
####################

x <-  dbGetQuery(conn, "select sexo, edad from ene")

query <- dbSendQuery(conn, "select sexo, edad from ene")

output <- dbFetch(query)

output2 <- dbFetch(query, 10)
output3 <- dbFetch(query, 94022)
output4 <- dbFetch(query, 10)
DBI::dbHasCompleted(res = query)
dbGetRowCount(query)


sql_output <- dbGetQuery(conn, "select sexo, edad from ene where edad >= 30")

class(sql_output)
dim(sql_output)

####################
# Query using SQL
####################


ene_table %>%
  select(sexo, edad) %>%
  filter(edad >= 30) %>%
  show_query()

show_query(non_collected)


##############################
# cargar datos viviendas censo
###############################

viviendas_table <- tbl(conn, "viviendas")

collected <-  viviendas_table %>%
  group_by(REGION) %>%
  summarise(contar = n()) %>%
  collect()


viviendas <- read_csv2("data/csv-viviendas-censo-2017/microdato_censo2017-viviendas/Microdato_Censo2017-Viviendas.csv")
DBI::dbCreateTable(conn, "viviendas", fields = viviendas)
DBI::dbListFields(conn, "viviendas")


DBI::dbDisconnect(conn)




###############3
# GUION CLASE #
###############

# ¿Por qué es relevante aprender bases de datos?
# Breve comentario sobre las bases de datos (relacionales)
# Conectarse desde R a una base de datos
# Hacer consultas a una base de datos
# Crear nuestra propia base de datos
# Consultar nuestra propia base de datos
