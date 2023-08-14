####################### INSTRUÇÕES #######################

atalho <- "C:/Users/Raymundo/Documentos/R/Projeto01_Indicadores_ConstrucaoCivil/"

source(paste(atalho, "R/0_Library.R", sep = ""))


## Definindo os períodos de estudo
ano1 <- 2022
ano2 <- 2021
ano3 <- 2020
ano4 <- 2019


################## PARTE II - EMPRESAS ##################
# Carregando um dataset de empresas lista na CVM. Depois de filtrado os segmentos 
# e escolhido qual será utilizado para trabalhado, ocorrendo a exportação do arquivo 'export_cia_segmento.csv', para 
# que seja feito uma nova classificação, seguindo modelo adotado pela BOVESPA.
# Será carregado o novo arquivo 'cia_construcao.xlsx' para ser utilizado como ferramenta nos próximos tratamentos

#carregar arquivos de cadastro das empresas
dir_cadastro <- file.path(atalho, "Dados_CVM/Empresas/cad_cia_aberta.csv")
cadastro <- read.csv(dir_cadastro, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
colunas_excluir <- c("DT_CANCEL", " MOTIVO_CANCEL", "DT_INI_CATEG", "DT_INI_SIT_EMISSOR", "TP_ENDER", 
                     "LOGRADOURO", "COMPL", "BAIRRO", "CEP", "DDD_TEL", "TEL", "DDD_FAX", 
                     "FAX", "EMAIL", "TP_RESP", "RESP", "DT_INI_RESP", "LOGRADOURO_RESP", 
                     "COMPL_RESP", "BAIRRO_RESP", "MUN_RESP", "UF_RESP", "PAIS_RESP", 
                     "CEP_RESP", "DDD_TEL_RESP", "TEL_RESP", "DDD_FAX_RESP", "FAX_RESP", 
                     "EMAIL_RESP", "CNPJ_AUDITOR")
colunas_manter <- setdiff(colnames(cadastro), colunas_excluir)
cadastro <- cadastro[, colunas_manter]
cadastro$ANO_SIT <- substr(cadastro$DT_INI_SIT, 1, 4)
#head(cadastro,2)
unique(cadastro$SETOR_ATIV) # conhecer os setores do dataset
condicao_setor <- cadastro$SETOR_ATIV %in% c("Construção Civil, Mat. Constr. e Decoração", 
                                             "Emp. Adm. Part. - Const. Civil, Mat. Const. e Decoração")
# filtragens para reduzir o numero de empresas: SIT = ATIVO, TP_MERC não é BALCÃO ORGANIZADO E SIT_EMISSOR não é FASE PRÉ-OPERACIONAL
condicao_sit <- cadastro$SIT == "ATIVO"
condicao_tp_merc <- cadastro$TP_MERC != "BALCÃO ORGANIZADO"
condicao_sit_emissor <- cadastro$SIT_EMISSOR != "FASE PRÉ-OPERACIONAL"
cadastro_filtrados <- subset(cadastro, condicao_setor & condicao_sit & condicao_tp_merc & condicao_sit_emissor)


# salvando em arquivo para posteriormente incluir os segmentos
dados_exportar <- cadastro_filtrados[, c('CD_CVM', 'CNPJ_CIA', "DENOM_SOCIAL")]
nome_arquivo <- "export_cia_segmento.csv"
caminho_saida <- file.path(atalho, "Dados_CVM/TratamentoManual/", nome_arquivo)
write.csv(dados_exportar, caminho_saida, row.names = FALSE, fileEncoding = "UTF-8")

# Carregamento do novo arquivo
dir_empresa <- file.path(atalho, "Dados_CVM/TratamentoManual/cia_construcao.xlsx")
empresas <- read.xlsx(dir_empresa)
# Colunas para puxar da tabela dados_exportar
colunas_puxar <- c("DT_REG", "DT_CONST", "TP_MERC", "SIT_EMISSOR", "CONTROLE_ACIONARIO", "MUN", "UF", "PAIS", "AUDITOR")
# Realizar o merge das tabelas
empresas <- merge(empresas, cadastro_filtrados[, c("CD_CVM", "DT_REG", "DT_CONST", "TP_MERC", "SIT_EMISSOR", "CONTROLE_ACIONARIO", "MUN", "UF", "PAIS", "AUDITOR")], by = "CD_CVM", all.x = TRUE)
empresas <- empresas[order(empresas$EMPRESA), ]
empresas <- empresas %>% filter(DT_REG != "NA")
# identificar empresas que não tem Município cadastrado
print(empresas$EMPRESA[empresas$MUN == ""])
empresas$MUN <- ifelse(empresas$EMPRESA == "Pacaembu Construtora", "SÃO PAULO", empresas$MUN)
#print(empresas$EMPRESA)

# Criação de novo objeto reduzindo a quantidade de segmentos
empresas2 <- empresas %>%
  mutate(SEGMENTO = case_when(
    SEGMENTO %in% c("Construção Pesada",
                    "Madeira e Papel", 
                    "Engenharia Consultiva", 
                    "Utilidades Domésticas", 
                    "Serviços Diversos", 
                    "Loteamento") ~ "Outros",
    TRUE ~ SEGMENTO
  ))

# Paleta de Cores
# Criando o dataset com os segmentos e suas cores associadas
paleta_cores <- data.frame(
  SEGMENTO = c(
    'Construção Pesada',        # 1
    'Engenharia Consultiva',    # 2
    'Exploração de Imóveis',    # 3
    'Incorporações',            # 4
    'Loteamento',               # 5
    'Madeira e Papel',          # 6    
    'Produtos para Construção', # 7
    'Serviços Diversos',        # 8
    'Utilidades Domésticas',    # 9
    'Outros'                    # 10
    ),
  Cor = c(
    "black",   # 1
    "yellow",   # 2
    "#F2294E",   # 3
    "#334075",   # 4
    "brown",   # 5
    "purple",   # 6
    "#05C7F2",   # 7
    "pink",   # 8
    "grey",   # 9
    "#FFB700"    # 10 
  )
) #

# definição de cor para cada Segmento
cor_constpesada <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Construção Pesada"]
cor_engcons <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Engenharia Consultiva"]
cor_expimoveis <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Exploração de Imóveis"]
cor_incorp <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Incorporações"]
cor_lotes <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Loteamento"]
cor_madeira <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Madeira e Papel"]
cor_prodconst <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Produtos para Construção"]
cor_servicos <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Serviços Diversos"]
cor_utilidades <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Utilidades Domésticas"]
cor_outros <- paleta_cores$Cor[paleta_cores$SEGMENTO == "Outros"]


################## DEMONSTRACOES FINANCEIRAS #########
# definir os diretC3rios onde estC#o os arquivos CSV

dir_BP <- file.path(atalho,"Dados_CVM/DemonstracoesFinanceiras/BP")
dir_DFC_MD <- file.path(atalho,"Dados_CVM/DemonstracoesFinanceiras/DFC_MD")
dir_DFC_MI <- file.path(atalho,"Dados_CVM/DemonstracoesFinanceiras/DFC_MI")
dir_DMPL <- file.path(atalho,"Dados_CVM/DemonstracoesFinanceiras/DMPL")
#dir_DRA <- file.path(atalho,"Dados_CVM/DemonstracoesFinanceiras/DRA")
dir_DRE <- file.path(atalho,"Dados_CVM/DemonstracoesFinanceiras/DRE")
dir_DVA <- file.path(atalho,"Dados_CVM/DemonstracoesFinanceiras/DVA")

# obter a lista de nomes de arquivos em cada diretC3rio
arquivos_BP <- list.files(dir_BP, pattern = "\\.csv$")
arquivos_DFC_MD <- list.files(dir_DFC_MD, pattern = "\\.csv$")
arquivos_DFC_MI <- list.files(dir_DFC_MI, pattern = "\\.csv$")
arquivos_DMPL <- list.files(dir_DMPL, pattern = "\\.csv$")
#arquivos_DRA <- list.files(dir_DRA, pattern = "\\.csv$")
arquivos_DRE <- list.files(dir_DRE, pattern = "\\.csv$")
arquivos_DVA <- list.files(dir_DVA, pattern = "\\.csv$")

# inicializar listas para armazenar os data frames
lista_BP <- list()
lista_DFC_MD <- list()
lista_DFC_MI <- list()
lista_DMPL <- list()
#lista_DRA <- list()
lista_DRE <- list()
lista_DVA <- list()

# loop atravC)s dos arquivos em cada diretC3rio e ler cada um com read.csv
for (arquivo in arquivos_BP) {
  caminho_arquivo <- file.path(dir_BP, arquivo)
  df <- read.csv(caminho_arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
  lista_BP[[arquivo]] <- df
}
for (arquivo in arquivos_DFC_MD) {
  caminho_arquivo <- file.path(dir_DFC_MD, arquivo)
  df <- read.csv(caminho_arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
  lista_DFC_MD[[arquivo]] <- df
}
for (arquivo in arquivos_DFC_MI) {
  caminho_arquivo <- file.path(dir_DFC_MI, arquivo)
  df <- read.csv(caminho_arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
  lista_DFC_MI[[arquivo]] <- df
}
for (arquivo in arquivos_DMPL) {
  caminho_arquivo <- file.path(dir_DMPL, arquivo)
  df <- read.csv(caminho_arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
  lista_DMPL[[arquivo]] <- df
}
#for (arquivo in arquivos_DRA) {
#  caminho_arquivo <- file.path(dir_DRA, arquivo)
#  df <- read.csv(caminho_arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
#  lista_DRA[[arquivo]] <- df
#}
for (arquivo in arquivos_DRE) {
  caminho_arquivo <- file.path(dir_DRE, arquivo)
  df <- read.csv(caminho_arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
  lista_DRE[[arquivo]] <- df
}
for (arquivo in arquivos_DVA) {
  caminho_arquivo <- file.path(dir_DVA, arquivo)
  df <- read.csv(caminho_arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
  lista_DVA[[arquivo]] <- df
}

# combinar todos os data frames em um C:nico data frame
BP <- do.call(rbind, lista_BP)
DFC_MD <- do.call(rbind, lista_DFC_MD)
DFC_MI <- do.call(rbind, lista_DFC_MI)
#DRA <- do.call(rbind, lista_DRA)
DRE <- do.call(rbind, lista_DRE)
DVA <- do.call(rbind, lista_DVA)

       