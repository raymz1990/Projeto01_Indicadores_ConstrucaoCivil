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

# Definindo o maior valor para o eixo y dos graficos
ymaior_liq_geral <- max(as.matrix(liq_geral[, -c(1:3)]))
# Arredonda o valor para cima
ymaior_liq_geral <- ceiling(ymaior_liq_geral)
# Verifica se o valor é ímpar
if (ymaior_liq_geral %% 2 == 1) {
  # Se for ímpar, arredonda para cima novamente para obter o próximo número par
  ymaior_liq_geral <- ymaior_liq_geral + 1
}

# Liquidez Corrente
# Calcular a média da coluna VL_CONTA para cada combinação de EMPRESA, SEGMENTO, TRIMESTRE e CD_CONTA
liq_corrente <- aggregate(liq_corrente ~ SEGMENTO + TRIMESTRE + ANO, data = liquidez, FUN = mean)
liq_corrente <- liq_corrente %>%
  pivot_wider(names_from = SEGMENTO, values_from = liq_corrente)

liq_corrente_2022 <- subset(liq_corrente, ANO == 2022)
liq_corrente_2021 <- subset(liq_corrente, ANO == 2021)
liq_corrente_2020 <- subset(liq_corrente, ANO == 2020)
liq_corrente_2019 <- subset(liq_corrente, ANO == 2019)

# Liquidez Seca
# Calcular a média da coluna VL_CONTA para cada combinação de EMPRESA, SEGMENTO, TRIMESTRE e CD_CONTA
liq_seca <- aggregate(liq_seca ~ SEGMENTO + TRIMESTRE + ANO, data = liquidez, FUN = mean)
liq_seca <- liq_seca %>%
  pivot_wider(names_from = SEGMENTO, values_from = liq_seca)

liq_seca_2022 <- subset(liq_seca, ANO == 2022)
liq_seca_2021 <- subset(liq_seca, ANO == 2021)
liq_seca_2020 <- subset(liq_seca, ANO == 2020)
liq_seca_2019 <- subset(liq_seca, ANO == 2019)

# Liquidez Imediata
# Calcular a média da coluna VL_CONTA para cada combinação de EMPRESA, SEGMENTO, TRIMESTRE e CD_CONTA
liq_imediata <- aggregate(liq_imediata ~ SEGMENTO + TRIMESTRE + ANO, data = liquidez, FUN = mean)
liq_imediata <- liq_imediata %>%
  pivot_wider(names_from = SEGMENTO, values_from = liq_imediata)

liq_imediata_2022 <- subset(liq_imediata, ANO == 2022)
liq_imediata_2021 <- subset(liq_imediata, ANO == 2021)
liq_imediata_2020 <- subset(liq_imediata, ANO == 2020)
liq_imediata_2019 <- subset(liq_imediata, ANO == 2019)

