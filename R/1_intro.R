####################### INSTRUÇÕES #######################
## NNeste arquivo serão somente feito os tratamentos dos dados

atalho <- "C:/Users/raymu/OneDrive/Documentos/R/ProjetoA_Indicadores_ConstrucaoCivil/"

source(paste(atalho, "R/0_DemonstracoesFinanceiras.R", sep = ""))

# Tabela 1 - Empresas por Segmento e Estado
intro_tb_empresas <- select(empresas, EMPRESA, SEGMENTO, UF)

# Tabela 2 - Grafico de barras por segmento
intro_graph_segmento <- select(empresas, SEGMENTO) %>%
  group_by(SEGMENTO) %>%
  summarise(Freq = n(), .groups = "drop") %>%
  arrange(desc(Freq), SEGMENTO)


# Tabela 3 - Treemap das empresas por segmento

d1 <- empresas2 %>%
  select(CD_CVM, EMPRESA, SEGMENTO)

DRE_2022 <- DRE %>%
  select(CD_CVM, DENOM_CIA, PERIODO, CD_CONTA, VL_CONTA) %>%
  filter(PERIODO == '2022' & CD_CONTA == '3.01')
DRE_2022$VL_CONTA <- abs(DRE_2022$VL_CONTA)

d1 <- merge(d1, DRE_2022[, c("CD_CVM", "VL_CONTA")], by = "CD_CVM", all.x = TRUE) %>%
  filter(!is.na(VL_CONTA))

d1 <- d1 %>%
  left_join(paleta_cores, by = "SEGMENTO")

d1 <- d1[, c("SEGMENTO", "EMPRESA", "VL_CONTA", "Cor")]

d2 <- d1 %>% 
  group_by(SEGMENTO, Cor) %>% 
  summarise(VL_CONTA = sum(VL_CONTA), .groups = "drop") %>% 
  rename(EMPRESA = SEGMENTO) %>%             # change columns
  mutate(SEGMENTO = "") %>%                # create blank column replacement
  select(names(d1))                     # put columns back in order

d3 <- rbind(d2, d1) %>% as.data.frame() # combine with original data




#empresas2 <- select(empresas, CD_CVM, EMPRESA, SEGMENTO, MUN, UF)
# Filtrar as linhas em que PERIODO é igual a '2022' no dataframe DRE
#DRE_2022 <- filter(DRE, PERIODO == '2022' & DS_CONTA == 'Receita de Venda de Bens e/ou Serviços')
# Realizar o merge dos dataframes empresas e DRE_2022 com base na coluna CD_CVM
#intro_graph_local <- merge(empresas2, DRE_2022[, c("CD_CVM", "VL_CONTA")], by = "CD_CVM", all.x = TRUE)
#intro_graph_local <- int %>% filter(DT_REG != "NA")