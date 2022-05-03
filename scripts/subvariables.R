library(dplyr)

df <- read.table("eovs.tsv", sep = "\t", header = TRUE) %>%
  mutate_all(stringr::str_trim) %>%
  rowwise() %>%
  mutate(
    broader = paste0("https://goosocean.org/eov/", paste0(head(strsplit(about, "/")[[1]], -1), collapse = "/")),
    about = paste0("https://goosocean.org/eov/", about)
  )

concepts <- glue::glue("  <skos:Concept rdf:about=\"{df$about}\"><skos:prefLabel xml:lang=\"en\">{df$label}</skos:prefLabel><skos:altLabel>{df$label}</skos:altLabel></skos:Concept>") %>%
  paste0(collapse = "\n")

xml <- glue::glue("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:skos=\"http://www.w3.org/2004/02/skos/core#\">
  <skos:ConceptScheme xmlns:skos=\"http://www.w3.org/2004/02/skos/core#\" rdf:about=\"https://goosocean.org/eov\">
    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">GOOS Essential Ocean Variable (EOV) subvariables</dc:title>
    <dcterms:issued xmlns:dcterms=\"http://purl.org/dc/terms/\">2021-12-10T12:00:00</dcterms:issued>
    <dcterms:modified xmlns:dcterms=\"http://purl.org/dc/terms/\">2021-12-10T12:00:00</dcterms:modified>
  </skos:ConceptScheme>
{concepts}
</rdf:RDF>")

writeLines(xml, "subvariables.rdf")
