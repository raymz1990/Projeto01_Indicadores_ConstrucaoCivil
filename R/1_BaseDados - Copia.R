####################### INSTRUÇÕES #######################
## Será feito em X partes, com o escopo de ja trabalhar todas as tabelas neste arquivo, já que será trabalhado com o mesmo indicador em páginas diferentes, evitando, assim de refazer códigos.


############### PARTE I - PARAMETRIZAÇÕES ###############
# Estarão sendo definidos os atalhos principais como pasta para carregar os arquivos, parametrizações de data e bibliotecas 

## Definição de atalhos de pasta
# definindo caminho das pastas
# caminho pasta note
dir_1 <- "C:/Users/raymu/OneDrive/Documentos/R/"
# caminho pasta trabalho
dir_2 <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/"
# definindo o diretório que esta sendo trabalhado
atalho <- dir_1 # importante #

## Carregando bibliotecas
library(WriteXLS)
library(openxlsx)
library(tidyverse)
library(dplyr)
library(plyr)
library(pander)
library(ggpubr)
library(splitstackshape, quietly = TRUE)
library(lubridate)
library(GGally)
library(ggmosaic)
library(stringr)
library(knitr)
library(DT)
library(RColorBrewer)
library(ggplot2)
library(shiny)
library(plotly)
library(tidyr)
library(gridExtra)

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
dir_cadastro <- file.path(atalho, "Empresas Bolsa/DF_EmpresasBolsa/cad_cia_aberta.csv")
cadastro <- read.csv(dir_cadastro, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
colunas_excluir <- c("DT_CANCEL", " MOTIVO_CANCEL", "DT_INI_CATEG", "DT_INI_SIT_EMISSOR", "TP_ENDER", 
                     "LOGRADOURO", "COMPL", "BAIRRO", "CEP", "DDD_TEL", "TEL", "DDD_FAX", 
                     "FAX", "EMAIL", "TP_RESP", "RESP", "DT_INI_RESP", "LOGRADOURO_RESP", 
                     "COMPL_RESP", "BAIRRO_RESP", "MUN_RESP", "UF_RESP", "PAIS_RESP", 
                     "CEP_RESP", "DDD_TEL_RESP", "TEL_RESP", "DDD_FAX_RESP", "FAX_RESP", 
                     "EMAIL_RESP", "CNPJ_AUDITOR")
colunas_manter <- setdiff(colnames(cadastro), colunas_excluir)
cadastro <- cadastro[, colunas_manter]
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
dados_exportar <- cadastro_filtrados[, c("CD_CVM", "CNPJ_CIA", "DENOM_SOCIAL")]
nome_arquivo <- "export_cia_segmento.csv"
caminho_saida <- file.path(atalho, "Empresas Bolsa", "DF_EmpresasBolsa-auxiliar", nome_arquivo)
write.csv(dados_exportar, caminho_saida, row.names = FALSE, fileEncoding = "UTF-8")

# Carregamento do novo arquivo
dir_empresa <- file.path(atalho, "Empresas Bolsa/DF_EmpresasBolsa/cia_construcao.xlsx")
empresas <- read.xlsx(dir_empresa)
# Colunas para puxar da tabela dados_exportar
colunas_puxar <- c("DT_REG", "DT_CONST", "TP_MERC", "SIT_EMISSOR", "CONTROLE_ACIONARIO", "MUN", "UF", "PAIS", "AUDITOR")
# Realizar o merge das tabelas
empresas <- merge(empresas, cadastro_filtrados[, c("CD_CVM", "DT_REG", "DT_CONST", "TP_MERC", "SIT_EMISSOR", "CONTROLE_ACIONARIO", "MUN", "UF", "PAIS", "AUDITOR")], by = "CD_CVM", all.x = TRUE)
empresas <- empresas[order(empresas$EMPRESA), ]
#print(empresas$EMPRESA)

# Reduzindo as informações 



################## DEMONSTRACOES FINANCEIRAS #########
# definir os diretC3rios onde estC#o os arquivos CSV

dir_BP <- file.path(atalho,"Empresas Bolsa/DF_EmpresasBolsa/BP")
dir_DFC_MD <- file.path(atalho,"Empresas Bolsa/DF_EmpresasBolsa/DFC_MD")
dir_DFC_MI <- file.path(atalho,"Empresas Bolsa/DF_EmpresasBolsa/DFC_MI")
dir_DMPL <- file.path(atalho,"Empresas Bolsa/DF_EmpresasBolsa/DMPL")
dir_DRA <- file.path(atalho,"Empresas Bolsa/DF_EmpresasBolsa/DRA")
dir_DRE <- file.path(atalho,"Empresas Bolsa/DF_EmpresasBolsa/DRE")
dir_DVA <- file.path(atalho,"Empresas Bolsa/DF_EmpresasBolsa/DVA")

# obter a lista de nomes de arquivos em cada diretC3rio
arquivos_BP <- list.files(dir_BP, pattern = "\\.csv$")
arquivos_DFC_MD <- list.files(dir_DFC_MD, pattern = "\\.csv$")
arquivos_DFC_MI <- list.files(dir_DFC_MI, pattern = "\\.csv$")
arquivos_DMPL <- list.files(dir_DMPL, pattern = "\\.csv$")
arquivos_DRA <- list.files(dir_DRA, pattern = "\\.csv$")
arquivos_DRE <- list.files(dir_DRE, pattern = "\\.csv$")
arquivos_DVA <- list.files(dir_DVA, pattern = "\\.csv$")

# inicializar listas para armazenar os data frames
lista_BP <- list()
lista_DFC_MD <- list()
lista_DFC_MI <- list()
lista_DMPL <- list()
lista_DRA <- list()
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
for (arquivo in arquivos_DRA) {
  caminho_arquivo <- file.path(dir_DRA, arquivo)
  df <- read.csv(caminho_arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
  lista_DRA[[arquivo]] <- df
}
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
DRA <- do.call(rbind, lista_DRA)
DRE <- do.call(rbind, lista_DRE)
DVA <- do.call(rbind, lista_DVA)

# alterando o formato da coluna CD_CVM
empresas$CD_CVM <- as.character(empresas$CD_CVM)
BP$CD_CVM <- as.character(BP$CD_CVM)
#BP$VL_CONTA <- as.integer((BP$VL_CONTA))
DFC_MD$CD_CVM <- as.character(DFC_MD$CD_CVM)
DFC_MI$CD_CVM <- as.character(DFC_MI$CD_CVM)
DRA$CD_CVM <- as.character(DRA$CD_CVM)
DRE$CD_CVM <- as.character(DRE$CD_CVM)
DVA$CD_CVM <- as.character(DVA$CD_CVM)

CD_CVM_unique <- unique(empresas$CD_CVM)

unique(BP$ORDEM_EXERC)

# filtrar as linhas que contém as empresas desejadas na coluna "DENOM_CIA"

BP <- subset(BP, CD_CVM %in% CD_CVM_unique & ORDEM_EXERC == "ÚLTIMO")


DFC_MD <- subset(DFC_MD, CD_CVM %in% CD_CVM_unique)
DFC_MI <- subset(DFC_MI, CD_CVM %in% CD_CVM_unique)
DRA <- subset(DRA, CD_CVM %in% CD_CVM_unique)
DRE <- subset(DRE, CD_CVM %in% CD_CVM_unique)
DVA <- subset(DVA, CD_CVM %in% CD_CVM_unique)

#unique(BP$DT_REFER)

# Duplicar a coluna DT_REF
BP$TRIMESTRE <- BP$DT_REF

# Converter para formato de data
BP$TRIMESTRE <- as.Date(BP$TRIMESTRE)

# Extrair o trimestre e os dois últimos d?gitos do ano
trimestre <- as.integer(format(BP$TRIMESTRE, "%m")) / 3
ano <- format(BP$TRIMESTRE, "%y")

# Criar a coluna formatada
BP$TRIMESTRE <- paste0(trimestre, "T", ano)

BP$ANO <- format(as.Date(BP$DT_REFER), "%Y")

#unique(BP$DS_CONTA)

contas_bp <- BP[, c('CD_CONTA', 'DS_CONTA')]
contas_bp <- unique(contas_bp)


# Criando uma nova tabela BP


# Foi pensado que a melhor solu??o para trabalhar com os indicadores, seria convertendo o 'CD_CONTA' em colunas. 
# Por?m, verificou-se que algumas empresas usam descrimina??es diferentes para o mesmo c?digo. Desta forma, 
# ser? dividido em 2 novos objetos:
# BP1, com a 'CD_CONTA' convertida em coluna, por?m restrigindo-se ao 'NIVEL" <= 10.
# BP2, com a 'DS_CONTA" convertida em coluna, com 'NIVEL' <= 10 e fazendo identifica??o LP para contas do longo prazo
# BP1
BP1 <- BP

BP1$NIVEL <- nchar(BP1$CD_CONTA)
BP1$CLASSE <- ifelse(BP1$NIVEL == 1, as.character(BP1$NIVEL), substr(BP1$CD_CONTA, 1, 4))
contas_bp <- BP1[, c('NIVEL', 'CLASSE', 'CD_CONTA', 'DS_CONTA', 'ST_CONTA_FIXA')]
contas_bp <- unique(contas_bp)

BP1 <- subset(BP1, (CLASSE == 1.02 & NIVEL <= 10) | (CLASSE != 1.02 & NIVEL <= 7))

BP1$CONTA <- paste(BP1$CD_CONTA, "-", BP1$DS_CONTA)

#unique(BP1$CONTA)

library(dplyr)
# Renomear os valores da coluna "CONTA" com base nas regras
BP1 <- BP1 %>%
  mutate(CONTA = case_when(
    CONTA %in% c("1.01.05 - Ativos Biológicos", 
                 "1.01.06 - Tributos a Recuperar", 
                 "1.01.07 - Despesas Antecipadas", 
                 "1.01.08 - Outros Ativos Circulantes") 
    ~ "1.01.05 - Outros Ativos Circulantes",
    CONTA %in% c("1.02.01.01 - Aplicações Financeiras Avaliadas a Valor Justo através do Resultado", 
                 "1.02.01.02 - Aplicações Financeiras Avaliadas a Valor Justo através de Outros Resultados Abrangentes", 
                 "1.02.01.03 - Aplicações Financeiras Avaliadas ao Custo Amortizado", 
                 "1.02.01.01 - Aplicações Financeiras Avaliadas a Valor Justo", 
                 "1.02.01.02 - Aplicações Financeiras Avaliadas ao Custo Amortizado") 
    ~ "1.02.01.01 - Aplicações Financeiras",
    CONTA %in% c("1.02.01.04 - Contas a Receber", 
                 "1.02.01.03 - Contas a Receber") 
    ~ "1.02.01.02 - Contas a Receber",
    CONTA %in% c("1.02.01.05 - Estoques", 
                 "1.02.01.04 - Estoques") 
    ~ "1.02.01.03 - Estoques",
    CONTA %in% c("1.02.01.06 - Ativos Biológicos", 
                 "1.02.01.07 - Tributos Diferidos", 
                 "1.02.01.08 - Despesas Antecipadas", 
                 "1.02.01.10 - Outros Ativos Não Circulantes", 
                 "1.02.01.05 - Ativos Biológicos", 
                 "1.02.01.06 - Tributos Diferidos", 
                 "1.02.01.07 - Despesas Antecipadas", 
                 "1.02.01.09 - Outros Ativos Não Circulantes") 
    ~ "1.02.01.05 - Outros Ativos Não Circulantes",
    CONTA %in% c("1.02.01.09 - Créditos com Partes Relacionadas", 
                 "1.02.01.08 - Créditos com Partes Relacionadas") 
    ~ "1.02.01.04 - Créditos com Partes Relacionadas",
    CONTA == "1.02.02 - Investimentos" 
    ~ "1.02.02 - Investimentos",
    CONTA == "1.02.03 - Imobilizado" 
    ~ "1.02.03 - Imobilizado",
    CONTA == "1.02.04 - Intangível" 
    ~ "1.02.04 - Intangível",
    CONTA %in% c("1.02.02.01 - Participações Societárias", 
                 "1.02.02.02 - Propriedades para Investimento", 
                 "1.02.03.01 - Imobilizado em Operação", 
                 "1.02.03.02 - Direito de Uso em Arrendamento", 
                 "1.02.03.03 - Imobilizado em Andamento", 
                 "1.02.04.01 - Intangíveis", 
                 "1.02.04.02 - Goodwill", 
                 "1.02.03.02 - Imobilizado Arrendado", 
                 "1.02.02.01 - Participações Societárias") 
    ~ "NA",
    CONTA %in% c("2.01.06 - Provisões", "2.01.07 - Passivos sobre Ativos Não-Correntes a Venda e Descontinuados") 
    ~ "2.01.05 - Outras Obrigações",
    CONTA %in% c("2.02.03 - Tributos Diferidos", 
                 "2.02.04 - Provisões", 
                 "2.02.05 - Passivos sobre Ativos Não-Correntes a Venda e Descontinuados", 
                 "2.02.06 - Lucros e Receitas a Apropriar") 
    ~ "2.02.02 - Outras Obrigações",
    CONTA == "2.03 - Patrimônio Líquido Consolidado" 
    ~ "2.03 - Patrimônio Líquido",
    TRUE ~ CONTA
  ))

BP1 <- BP1 %>% filter(CONTA != "NA")
BP1 <- BP1 %>%select(CD_CVM, DENOM_CIA, TRIMESTRE, ANO, CONTA, VL_CONTA)



library(dplyr)

# Agrupar os dados e calcular a soma de VL_CONTA para cada grupo
BP1 <- BP1 %>%
  group_by(CD_CVM, DENOM_CIA, TRIMESTRE, ANO, CONTA) %>%
  mutate(VL_CONTA = sum(VL_CONTA)) %>%
  distinct(CD_CVM, DENOM_CIA, TRIMESTRE, ANO, CONTA, .keep_all = TRUE)

library(tidyverse)

BP1 <- BP1 %>%
  select(CD_CVM, DENOM_CIA, CONTA, VL_CONTA, TRIMESTRE, ANO) %>%
  pivot_wider(names_from = CONTA, values_from = VL_CONTA)

       