####################### INSTRUÇÕES #######################
## NNeste arquivo serão somente feito os tratamentos dos dados

atalho <- "C:/Users/raymu/OneDrive/Documentos/R/ProjetoA_Indicadores_ConstrucaoCivil/Relatorio/"

source(paste(atalho, "R/1_BaseDados.R", sep = ""))


# alterando o formato da coluna CD_CVM
empresas$CD_CVM <- as.character(empresas$CD_CVM)
BP$CD_CVM <- as.character(BP$CD_CVM)
#BP$VL_CONTA <- as.integer((BP$VL_CONTA))
DFC_MD$CD_CVM <- as.character(DFC_MD$CD_CVM)
DFC_MI$CD_CVM <- as.character(DFC_MI$CD_CVM)
#DRA$CD_CVM <- as.character(DRA$CD_CVM)
DRE$CD_CVM <- as.character(DRE$CD_CVM)
DVA$CD_CVM <- as.character(DVA$CD_CVM)

CD_CVM_unique <- unique(empresas$CD_CVM)

unique(BP$ORDEM_EXERC)

# filtrar as linhas que contém as empresas desejadas na coluna "DENOM_CIA"

BP <- subset(BP, CD_CVM %in% CD_CVM_unique & ORDEM_EXERC == "ÚLTIMO")
DFC_MD <- subset(DFC_MD, CD_CVM %in% CD_CVM_unique & ORDEM_EXERC == "ÚLTIMO")
DFC_MI <- subset(DFC_MI, CD_CVM %in% CD_CVM_unique & ORDEM_EXERC == "ÚLTIMO")
#DRA <- subset(DRA, CD_CVM %in% CD_CVM_unique & ORDEM_EXERC == "ÚLTIMO")
DRE <- subset(DRE, CD_CVM %in% CD_CVM_unique & ORDEM_EXERC == "ÚLTIMO")
DVA <- subset(DVA, CD_CVM %in% CD_CVM_unique & ORDEM_EXERC == "ÚLTIMO")

#unique(BP$DT_REFER)

# Duplicar a coluna DT_REF
BP$TRIMESTRE <- BP$DT_REF
DFC_MD$TRIMESTRE <- DFC_MD$DT_REF
DFC_MI$TRIMESTRE <- DFC_MI$DT_REF
#DRA$TRIMESTRE <- DRA$DT_REF
DRE$TRIMESTRE <- DRE$DT_REF
DVA$TRIMESTRE <- DVA$DT_REF

# Converter para formato de data
BP$TRIMESTRE <- as.Date(BP$TRIMESTRE)
DFC_MD$TRIMESTRE <- as.Date(DFC_MD$DT_REF)
DFC_MI$TRIMESTRE <- as.Date(DFC_MI$DT_REF)
#DRA$TRIMESTRE <- as.Date(DRA$DT_REF)
DRE$TRIMESTRE <- as.Date(DRE$DT_REF)
DVA$TRIMESTRE <- as.Date(DVA$DT_REF)

# Criando colunas Trimestre e Ano
## BP
trimestre <- as.integer(format(BP$TRIMESTRE, "%m")) / 3 # Extrair o trimestre e os dois últimos digitos do ano
ano <- format(BP$TRIMESTRE, "%y")
BP$TRIMESTRE <- paste0(trimestre, "T", ano) # Criar a coluna formatada
BP$ANO <- format(as.Date(BP$DT_REFER), "%Y")
## DFC_MD
trimestre <- as.integer(format(DFC_MD$TRIMESTRE, "%m")) / 3 # Extrair o trimestre e os dois últimos digitos do ano
ano <- format(DFC_MD$TRIMESTRE, "%y")
DFC_MD$TRIMESTRE <- paste0(trimestre, "T", ano) # Criar a coluna formatada
DFC_MD$ANO <- format(as.Date(DFC_MD$DT_REFER), "%Y")
## DFC_MI
trimestre <- as.integer(format(DFC_MI$TRIMESTRE, "%m")) / 3 # Extrair o trimestre e os dois últimos digitos do ano
ano <- format(DFC_MI$TRIMESTRE, "%y")
DFC_MI$TRIMESTRE <- paste0(trimestre, "T", ano) # Criar a coluna formatada
DFC_MI$ANO <- format(as.Date(DFC_MI$DT_REFER), "%Y")
## DRA
#trimestre <- as.integer(format(DRA$TRIMESTRE, "%m")) / 3 # Extrair o trimestre e os dois últimos digitos do ano
#ano <- format(DRA$TRIMESTRE, "%y")
#DRA$TRIMESTRE <- paste0(trimestre, "T", ano) # Criar a coluna formatada
#DRA$ANO <- format(as.Date(DRA$DT_REFER), "%Y")
## DRE
trimestre <- as.integer(format(DRE$TRIMESTRE, "%m")) / 3 # Extrair o trimestre e os dois últimos digitos do ano
ano <- format(DRE$TRIMESTRE, "%y")
DRE$TRIMESTRE <- paste0(trimestre, "T", ano) # Criar a coluna formatada
DRE$ANO <- format(as.Date(DRE$DT_REFER), "%Y")


DRE <- subset(DRE, !(substr(DRE$DT_INI_EXERC, nchar(DRE$DT_INI_EXERC) - 4, nchar(DRE$DT_INI_EXERC)) == "03-01"))

DRE$PERIODO <- 
  ifelse(
    substr(DRE$TRIMESTRE, 1, 2) == "2T" &
      substr(DRE$DT_INI_EXERC, 6, 10) == "01-01", 
    paste0("6M", ano),
    ifelse(
      substr(DRE$TRIMESTRE, 1, 2) == "3T" & 
        substr(DRE$DT_INI_EXERC, nchar(DRE$DT_INI_EXERC) - 4, 
               nchar(DRE$DT_INI_EXERC)) == "01-01", 
      paste0("9M", ano),
      ifelse(
        substr(DRE$TRIMESTRE, 1, 2) == "4T", DRE$ANO,
        DRE$TRIMESTRE)))

## DVA
trimestre <- as.integer(format(DVA$TRIMESTRE, "%m")) / 3 # Extrair o trimestre e os dois últimos digitos do ano
ano <- format(DVA$TRIMESTRE, "%y")
DVA$TRIMESTRE <- paste0(trimestre, "T", ano) # Criar a coluna formatada
DVA$ANO <- format(as.Date(DVA$DT_REFER), "%Y")

### BP
# Verificado que as empresas possuem nomenclaturas diferentes em seus planos de contas, buscou-se reduzir a base dados,
# e agrupar algumas informações para padronizar todas as DF.

#unique(BP$DS_CONTA)
contas_bp <- BP[, c('CD_CONTA', 'DS_CONTA')]
contas_bp <- unique(contas_bp)


# Criando uma nova tabela BP
BP$NIVEL <- nchar(BP$CD_CONTA)
BP$CLASSE <- ifelse(BP$NIVEL == 1, as.character(BP$NIVEL), substr(BP$CD_CONTA, 1, 4))
contas_bp <- BP[, c('NIVEL', 'CLASSE', 'CD_CONTA', 'DS_CONTA', 'ST_CONTA_FIXA')]
contas_bp <- unique(contas_bp)

BP <- subset(BP, (CLASSE == 1.02 & NIVEL <= 10) | (CLASSE != 1.02 & NIVEL <= 7))

BP$CONTA <- paste(BP$CD_CONTA, "-", BP$DS_CONTA)

#unique(BP$CONTA)

# Renomear os valores da coluna "CONTA" com base nas regras
BP <- BP %>%
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

BP <- BP %>% filter(CONTA != "NA")
BP <- BP %>%select(CNPJ_CIA,
                   CD_CVM,
                   DENOM_CIA,
                   CD_CONTA,
                   DS_CONTA,
                   TRIMESTRE,
                   ANO,
                   CONTA,
                   VL_CONTA)

# Agrupar os dados e calcular a soma de VL_CONTA para cada grupo
BP <- BP %>%
  group_by(CD_CVM, DENOM_CIA, TRIMESTRE, ANO, CONTA) %>%
  mutate(VL_CONTA = sum(VL_CONTA)) %>%
  distinct(CD_CVM, DENOM_CIA, TRIMESTRE, ANO, CONTA, .keep_all = TRUE)


### DRE
# Mesma situação da BP

# unique(DRE$DS_CONTA)
contas_DRE <- DRE[, c('CD_CONTA', 'DS_CONTA')]
contas_DRE <- unique(contas_DRE)


# Criando uma nova tabela BP
DRE$NIVEL <- nchar(DRE$CD_CONTA)
DRE$CLASSE <- ifelse(DRE$NIVEL == 1, as.character(DRE$NIVEL), substr(DRE$CD_CONTA, 1, 4))
contas_DRE <- DRE[, c('NIVEL', 'CLASSE', 'CD_CONTA', 'DS_CONTA', 'ST_CONTA_FIXA')]
contas_DRE <- unique(contas_DRE)

DRE <- subset(DRE, (CLASSE == 1.02 & NIVEL <= 10) | (CLASSE != 1.02 & NIVEL <= 7))

DRE$CONTA <- paste(DRE$CD_CONTA, "-", DRE$DS_CONTA)


DRE1 <- DRE %>%
  select(DENOM_CIA, CD_CONTA, DS_CONTA, NIVEL, CLASSE, CONTA, VL_CONTA, PERIODO) %>%
  pivot_wider(names_from = DENOM_CIA, values_from = VL_CONTA)




sum(DRE1$`GAFISA S.A.`)


# Primeiro, agrupe os dados para identificar as combinações com valores duplicados
duplications <- DRE %>%
  group_by(CD_CONTA, DS_CONTA, NIVEL, CLASSE, CONTA, PERIODO, DENOM_CIA) %>%
  summarise(n = n()) %>%
  filter(n > 1L) 

# Em seguida, você pode verificar as combinações específicas que estão causando duplicações
print(duplications)


#unique(BP$CONTA)

# Renomear os valores da coluna "CONTA" com base nas regras
BP <- BP %>%
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

BP <- BP %>% filter(CONTA != "NA")
BP <- BP %>%select(CNPJ_CIA,
                   CD_CVM,
                   DENOM_CIA,
                   CD_CONTA,
                   DS_CONTA,
                   TRIMESTRE,
                   ANO,
                   CONTA,
                   VL_CONTA)

# Agrupar os dados e calcular a soma de VL_CONTA para cada grupo
BP <- BP %>%
  group_by(CD_CVM, DENOM_CIA, TRIMESTRE, ANO, CONTA) %>%
  mutate(VL_CONTA = sum(VL_CONTA)) %>%
  distinct(CD_CVM, DENOM_CIA, TRIMESTRE, ANO, CONTA, .keep_all = TRUE)






































BP1 <- BP1 %>%
  select(CD_CVM, DENOM_CIA, CONTA, VL_CONTA, TRIMESTRE, ANO) %>%
  pivot_wider(names_from = CONTA, values_from = VL_CONTA)

       