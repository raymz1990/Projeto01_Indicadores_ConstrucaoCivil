library(readr)
library(stringr)
library(httr)

# Definir o caminho do diretório
diretorio <- "C:/Users/Convidado/ownCloud/Documentos/RAYMUNDO/Empresas Bolsa/DF_EmpresasBolsa/dados_empresas"


# Listar todos os arquivos CSV no diretório
arquivos <- list.files(diretorio, pattern = "\\.csv$", full.names = TRUE)

# Loop através dos arquivos
for (arquivo in arquivos) {
  # Ler o arquivo CSV
  dados <- read.csv(arquivo, sep = ";", fileEncoding = "ISO-8859-1", stringsAsFactors = FALSE)
  
  # Verificar se a coluna "LINK_DOC" existe no arquivo
  if ("LINK_DOC" %in% colnames(dados)) {
    # Obter os links da coluna "LINK_DOC"
    links <- dados$LINK_DOC
    
    # Loop através dos links
    for (link in links) {
      # Verificar se o link é válido
      if (!is.na(link) && !str_detect(link, "^\\s*$")) {
        # Abrir o link no navegador padrão
        browseURL(link)
      }
    }
  }
}

# Exibir as mensagens de aviso
warnings()

