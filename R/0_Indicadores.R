####################### INSTRUÇÕES #######################
## NNeste arquivo serão somente feito os tratamentos dos dados

atalho <- "C:/Users/Raymundo/Documentos/R/Projeto01_Indicadores_ConstrucaoCivil/"

source(paste("./R/0_DemonstracoesFinanceiras.R", sep = ""))

BP1 <- BP1 %>%
  select(CD_CVM, DENOM_CIA, CONTA, VL_CONTA, TRIMESTRE, ANO) %>%
  pivot_wider(names_from = CONTA, values_from = VL_CONTA)