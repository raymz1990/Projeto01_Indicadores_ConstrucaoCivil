# definir os diretórios onde estão os arquivos CSV
dir_BP <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/Empresas Bolsa/DF_EmpresasBolsa/BP"
dir_DFC_MD <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/Empresas Bolsa/DF_EmpresasBolsa/DFC_MD"
dir_DFC_MI <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/Empresas Bolsa/DF_EmpresasBolsa/DFC_MI"
dir_DMPL <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/Empresas Bolsa/DF_EmpresasBolsa/DMPL"
dir_DRA <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/Empresas Bolsa/DF_EmpresasBolsa/DRA"
dir_DRE <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/Empresas Bolsa/DF_EmpresasBolsa/DRE"
dir_DVA <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/Empresas Bolsa/DF_EmpresasBolsa/DVA"

# obter a lista de nomes de arquivos em cada diretório
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

# loop através dos arquivos em cada diretório e ler cada um com read.csv
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

# combinar todos os data frames em um único data frame
BP <- do.call(rbind, lista_BP)
DFC_MD <- do.call(rbind, lista_DFC_MD)
DFC_MI <- do.call(rbind, lista_DFC_MI)
DRA <- do.call(rbind, lista_DRA)
DRE <- do.call(rbind, lista_DRE)
DVA <- do.call(rbind, lista_DVA)

# definir vetor de nomes de empresas a serem filtrados
empresas <- c("ALPHAVILLE S.A.", "CONSTRUTORA ADOLPHO LINDENBERG S.A.", "CONSTRUTORA TENDA S.A.",
              "CURY CONSTRUTORA E INCORPORADORA S.A.", "CYRELA BRAZIL REALTY S.A.EMPREEND E PART",
              "DIRECIONAL ENGENHARIA S.A.", "EVEN CONSTRUTORA E INCORPORADORA S.A.",
              "EZ TEC EMPREEND. E PARTICIPACOES S.A.", "FICA EMPREENDIMENTOS IMOBILIÁRIOS S.A",
              "GAFISA S.A.", "HELBOR EMPREENDIMENTOS S.A.", "INTER CONSTRUTORA E INCORPORADORA S.A.",
              "JHSF PARTICIPACOES S.A.", "JOAO FORTES ENGENHARIA S.A.",
              "KALLAS INCORPORACOES E CONSTRUCOES S.A.", "LAVVI EMPREENDIMENTOS IMOBILIÁRIOS S.A.",
              "MELNICK DESENVOLVIMENTO IMOBILIÁRIO S.A.", "MITRE REALTY EMPREENDIMENTOS E PARTICIPAÇÕES S.A.",
              "MOURA DUBEUX ENGENHARIA S/A", "MRV ENGENHARIA E PARTICIPACOES S.A.",
              "PDG REALTY S.A. EMPREEND E PARTICIPACOES", "PLANO & PLANO DESENVOLVIMENTO IMOBILIÁRIO S.A.",
              "RNI NEGÓCIOS IMOBILIÁRIOS S.A.", "ROSSI RESIDENCIAL S.A.", "TECNISA S.A.",
              "TEGRA INCORPORADORA S.A.", "TRISUL S.A.", "VIVER INCORPORADORA E CONSTRUTORA S.A.")

# filtrar as linhas que contêm as empresas desejadas na coluna "DENOM_CIA"
BP <- subset(BP, DENOM_CIA %in% empresas)
DFC_MD <- subset(DFC_MD, DENOM_CIA %in% empresas)
DFC_MI <- subset(DFC_MI, DENOM_CIA %in% empresas)
DRA <- subset(DRA, DENOM_CIA %in% empresas)
DRE <- subset(DRE, DENOM_CIA %in% empresas)
DVA <- subset(DVA, DENOM_CIA %in% empresas)
