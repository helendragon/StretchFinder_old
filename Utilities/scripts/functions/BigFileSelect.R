#source('/home/helena/Documentos/Master/IRB/BigFileSelect.R')
BigFastaInfo <- function(path, windowSize, thr) {
  
  setwd(path)
  #load rwInfo
  name <- paste('rwSInfo', windowSize, 'T', thr, sep='')
  SInfo<-paste(name,'.Rdata', sep='')
  x=load(SInfo)
  rwSInfo=get(x)
  rm(x)
  
  #load rwAsum
  name<-paste('rwAsum',windowSize, sep='')
  Asum<-paste(name,'.Rdata', sep='')
  x=load(Asum)
  rwAsum=get(x)
  rm(x)
  
  s<-sapply(rwSInfo, is.null) #false si te stretches
  stretch <- rwSInfo[!s] #agafa gens que tenen stretches
  si<-sapply(rwAsum[!s],function(x) length(x)+(windowSize-1), simplify=T)#size dels gens 
  
  if (length(stretch) != 0){ 
  
    n <- length(stretch[[1]])
    DF <- structure(stretch, row.names = c(NA, -n), class = "data.frame")
    
    names <-colnames(DF)
    for (i in names){
      for (c in names){
        if (c != i){
          uniprot1 <- sub(".*\\..*\\..*\\..*\\..*\\.(.*?)\\..*", "\\1", i)
          uniprot2 <- sub(".*\\..*\\..*\\..*\\..*\\.(.*?)\\..*", "\\1", c)
          if (uniprot1 == uniprot2){
            num <- stretch[i]
            size1<-num[[1]]$sizes
            en1<-num[[1]]$d_a
            num <- stretch[c]
            size2<-num[[1]]$sizes
            en2<-num[[1]]$d_a
            
            if (size1 > size2){ #mirem stretches
              rwSInfo[c]<- NULL
            } else if (size1 < size2) {
              rwSInfo[i] <- NULL
            } else if (size1== size2){
              if (en1 > en2){
                rwSInfo[c]<- NULL
              } else if ( en1 < en2){
                rwSInfo[i] <- NULL
              } else if (en1 == en2){
                if (si[i] > si[c]){
                 rwSInfo[c]<- NULL
                } else if (si[i] < si[c]){
                  rwSInfo[i] <- NULL
                } else {
                  print("no hem tret re")
                  rwSInfo[c]<- NULL
                }
              } #elseififen
            } #elseif size
          } #ifuniprot 
        } #ifci
      } #forc
    }#for i
    return(rwSInfo)
  } #iflengthstretch
}#function

    