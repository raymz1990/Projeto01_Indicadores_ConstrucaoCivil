####################### INSTRUÇÕES #######################
## Neste arquivo serão somente feito os tratamentos dos dados

atalho <- "C:/Users/Raymundo/Documentos/R/Projeto01_Indicadores_ConstrucaoCivil/"

source(paste(atalho, "R/0_DemonstracoesFinanceiras.R", sep = ""))

#### INDICADORES DE LIQUIDEZ ############
# Tabela de liquidez. 
liquidez <- merge(BP1, empresas2[c("CD_CVM", "SEGMENTO", "EMPRESA")], by = "CD_CVM", all = TRUE)

liquidez <- liquidez[c("EMPRESA", "SEGMENTO", "TRIMESTRE", "ANO",
                       "1.01 - Ativo Circulante",
                       "1.01.01 - Caixa e Equivalentes de Caixa",
                       "1.01.02 - Aplicações Financeiras",
                       "1.01.04 - Estoques",
                       "1.02.01 - Ativo Realizável a Longo Prazo",
                       "2.01 - Passivo Circulante",
                       "2.02 - Passivo Não Circulante")]

# Calcular as colunas de liquidez
liquidez$liq_geral <- round((liquidez$`1.01 - Ativo Circulante` + liquidez$`1.02.01 - Ativo Realizável a Longo Prazo`) / (liquidez$`2.01 - Passivo Circulante` + liquidez$`2.02 - Passivo Não Circulante`), 2)
liquidez$liq_corrente <- round(liquidez$`1.01 - Ativo Circulante` / liquidez$`2.01 - Passivo Circulante`, 2)
liquidez$liq_seca <- round((liquidez$`1.01 - Ativo Circulante` - liquidez$`1.01.04 - Estoques`) / liquidez$`2.01 - Passivo Circulante`, 2)
liquidez$liq_imediata <- round((liquidez$`1.01.01 - Caixa e Equivalentes de Caixa` + liquidez$`1.01.02 - Aplicações Financeiras`) / liquidez$`2.01 - Passivo Circulante`, 2)

# Filtrar os resultados apenas por ano
liquidez_2022 <- subset(liquidez, ANO == 2022)
liquidez_2021 <- subset(liquidez, ANO == 2021)
liquidez_2020 <- subset(liquidez, ANO == 2020)
liquidez_2019 <- subset(liquidez, ANO == 2019)

# Liquidez Geral
# Calcular a média da coluna VL_CONTA para cada combinação de EMPRESA, SEGMENTO, TRIMESTRE e CD_CONTA
liq_geral <- aggregate(liq_geral ~ SEGMENTO + TRIMESTRE + ANO, data = liquidez, FUN = mean)
liq_geral <- liq_geral %>%
  pivot_wider(names_from = SEGMENTO, values_from = liq_geral)
liq_geral_2022 <- subset(liq_geral, ANO == 2022)
liq_geral_2021 <- subset(liq_geral, ANO == 2021)
liq_geral_2020 <- subset(liq_geral, ANO == 2020)
liq_geral_2019 <- subset(liq_geral, ANO == 2019)


