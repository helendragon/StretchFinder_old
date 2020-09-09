library(org.Hs.eg.db)
library(clusterProfiler)
library(Cairo)


Goterms <- function(csvfile, path, sep, ajuste="BH", qvalue=0.2, pvalue=0.05, anotacio="GOTERM_BP_FAT") {
  #setwd(path)
  adat<- read.table(csvfile, header = TRUE, stringsAsFactors = FALSE, sep = sep)
  #convertim de uniprot a entrez
  conversion <- bitr(adat$uniprot, fromType="UNIPROT", toType="ENTREZID", OrgDb="org.Hs.eg.db")  
  #treiem els duplicats
  non_duplicates <- which(duplicated(adat$uniprot) == FALSE)
  ids <- conversion[non_duplicates, ] 
  #Fem el analisi amb DAVID
  write("Doing the Analysis...", file='')
  david <- enrichDAVID(ids$ENTREZID, david.user = "helena.catena@irbbarcelona.org", annotation = anotacio, pvalueCutoff = pvalue, pAdjustMethod = ajuste, qvalueCutoff = qvalue)
  s<-(david@result)
  save(david, file="david.Rdata")
  
  #el fem readable
  edox <- setReadable(david, 'org.Hs.eg.db', keyType = 'ENTREZID')
  m<-edox@result
  write.csv2(m, "DavidAnalysis.csv", row.names = F)
  write("Analysis Finished ... Doing the plots...", file='')
  #cnet plot
  
  potat<-cnetplot(edox, circular=F)
  png(file = "cnetplot.png", type = c("cairo"), width=2500, height=2000, res=300)
  print(potat)
  dev.off()
  
  #barplot
  potat<- dotplot(david, x="count", showCategory=15, font.size=10)
  png(file = "barplot.png", type = c("cairo"), width=2900, height=2000, res=300)
  print(potat)
  dev.off()
}
