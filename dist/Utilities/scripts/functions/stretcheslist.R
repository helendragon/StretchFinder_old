get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}


stretcheslist<- function(path, windowSize, thr)
{
  setwd(path)
  ######################
  ### Load the data ####
  ######################
  #load rwAsum
  name<-paste('rwAsum',windowSize, sep='')
  Asum<-paste(name,'.Rdata', sep='')
  x=load(Asum)
  rwAsum=get(x)
  rm(x)
  #load rwDsum
  name<-paste('rwDsum',windowSize, sep='')
  Dsum<-paste(name,'.Rdata', sep='')
  load(Dsum)
  x=load(Dsum)
  rwDsum=get(x)
  rm(x)
  #load rwSinfo
  name <- paste('rwSInfo', windowSize, 'T', thr, sep='')
  SInfo<-paste(name,'.Rdata', sep='')
  load(SInfo)
  x=load(SInfo)
  rwSInfo=get(x)
  rm(x)
  
  #############################
  ### Genes with stretches ####
  #############################
  
  s<-sapply(rwSInfo, is.null) #false si no te stretches
  stretch <- rwSInfo[!s] #agafa gens que tenen stretches

  if (length(stretch) != 0){ 

    re<-sapply(stretch,function(x) x$num) #per tots els gens agafes el numero de streches
    name<-rep(names(stretch),re)
    name <- sub("X\\.(.*)",'\\1',name) #remove X 
    ccdsId<-sub("X\\.(.*)\\.Hs.*", "\\1", name) #extract CCDSid
    

    
    
    #cada ccdsId buscarlo a la taula (id) i afegir el nom ($gene) en una nova columna (quan creem t2).
    size<-unlist(sapply(stretch, function(x) x$size), use.names=F) #agafa la size dels streches
    a<-unlist(sapply(stretch, function(x) x$aStr), use.names=F) 
    d<-unlist(sapply(stretch, function(x) x$dStr), use.names=F)
    d_a<-d/a
    si<-sapply(rwAsum[!s],function(x) length(x)+(windowSize-1), simplify=T) #agafo la size del gen
    sizeGen<-rep(si,re) #taula amb la size del gen
    StretchSize <- size/sizeGen
    t1 <- data.frame(name,size,a,d,d_a,sizeGen, StretchSize) #create data frame
    colnames(t1)<- c("name","size", "a", "d", "d_a", "sizeGen", "Stretch/Size")
    o<-order(t1$size,t1$d_a, decreasing=T)
    write.csv(t1[o,], 'GenesWithStretches.csv', row.names=F) #write csv
    x<-0
  } else {
    write('Warning: I did not find any stretches!', file='')
    x<-1
  }

  
  ################################
  ### Genes with no stretches ####
  ################################
  
  s1<-sapply(rwSInfo, is.null)
  sum(!s1)

  if (length(s1) !=0){ #hi ha gens amb stretches
    na1<-names(rwSInfo[s1]) #gens SENSE streches
    na2<-names(rwSInfo[!s1]) #gens AMB streches
    max1<-sapply(rwAsum[na1], max, simplify=T)#ens quedem amb la regio amb l'a(t) més gran.
    
  
    #Gens sense stretch que nomes surten un cop.
    s2<-table(na1)==1
    t2<-table(na1)[s2]
    na3<-names(t2)
    s3<-sapply(rwAsum[na3],function(x) is.numeric(x))
    nainf<-names(rwAsum[na3][!s3])#aquets son els que donen Na o INF
    na4<-na3[!(na3 %in% nainf)] #gens sense stretches que no donen inf
    #print(length(na4))
    if (length(na4)!=0){
      si<-sapply(rwAsum[na4],function(x) length(x)+(windowSize-1), simplify=T)#get sizes of the genes
      a<-sapply(rwAsum[na4],function(x) max(x)) 
      d<-sapply(rwDsum[na4],function(x) max(x))
      ta1<-cbind(si[na4], a[na4], d[na4])
      colnames(ta1)<-c('size','a','d')
      taHIGH<-ta1[ta1[,'a']>thr,] ##miro quins estan per sobre del threshold
      naHIGH<-rownames(taHIGH)
      naHIGH
      #na4 %in% na2
      naHIGH %in% na2 #they are in the stretch table too, so we can remove from here.
      s3<-na4 %in% na2 #miro si els gens sense stretches que estiguessin a la llista amb stretches
      na5<-na4[!s3]
      nas<-sub('X.','',na5) #teiem la X
      StretchSize <- windowSize/si[na5]
      ta2<-cbind(nas,windowSize, a[na5], d[na5], d[na5]/a[na5],si[na5], StretchSize)
      colnames(ta2)<-c('name','size','a','d','d_a', 'sizeGen', "Stretch/Size")
      o <- order(as.numeric(ta2[,'d_a']), decreasing=T)
      if (nrow(ta2) == 1){ #si hi ha nomes 1 dona problemes amb el order
        write.table(ta2, 'GenesWithNoStretches.csv', row.names=F)
      }else{
        write.table(ta2[o,], 'GenesWithNoStretches.csv', row.names=F)
      }
      y<-0
    }else {
      write('Warning: There are genes without stretches, but I have no count info! I cannot  make the file', file='')
      y<-1
    }
  } else {
    write('Warning: I did not find genes without stretches!', file='')
    y<-1
  }
  
  
  
  ###################### 
  #######All PARTS######
  ######################
  
  if (y !=1){ #hi ha sense stretches
    p1<-read.table('GenesWithNoStretches.csv', header=T)
    Nas <- rep(NA, length(p1))
  }
  
  if(x!=1){ #hi ha streches
    p2<-read.csv('GenesWithStretches.csv', header=T)
    Nas <- rep(NA, length(p2))
  }
  
  tot <- x + y
  if (tot == 0){ #tinc els 2 fitxers

    max(p1$a)#below the threshold to be an stretch
    min(p2$a)#above the threshold to be an stretch
    sum(duplicated(p2$name))#some genes have several stretches
    sum(duplicated(p1$name))#p1 only have one 'stretch' per gene
    sum(p1$name %in% p2$name)#no shared names.
    
    #NOTE: a=ADAT codons/length. d=ADAT-sensitive codons/ ADAT codons.
    #order by size then d/a
    #order p1
    p1os <- order(as.numeric(p1[,'size']),as.numeric(p1[,'d_a']), decreasing=T)
    p1<- p1[p1os,]
    #order p2
    p2os <- order(as.numeric(p2[,'size']),as.numeric(p2[,'d_a']), decreasing=T)
    p2 <- p2[p2os,]
    ptot<- rbind(p2,Nas,p1)
    ############## NECESITEM AIXO?????
    write.table(ptot, 'allStr.csv', row.names=F)
    pto<-read.table('allStr.csv', header=T)
    
    s<-duplicated(pto[,'name']) #mirem quins estan repetits
    pun<-cbind(pto,!s) #afegim clumn T/F de si estan repetits
    pun2<-pto[!s,]#eliminate all repeated str except the 1st one (the longest).
    table(table(pun2[,'name']))
    
    write.table(pun2, 'UniqueStretchforGene.csv', row.names=F)
    
    #write name info in different columns
    aux<-pun$name
    #aux
    gname <- sub(".*\\..*\\..*\\..*\\..*\\.(.*?)", "\\1", aux)#extract...
    gname
    id <- sub(".*(CCDS.*)\\.Hs.*", "\\1", aux)#extract...
    id
    hs <- sub(".*\\.(Hs.*)\\.chr.*", "\\1", aux)#extract...
    hs
    chr <- sub(".*\\.(chr.*)\\..*\\..*", "\\1", aux)#extract...
    chr
    uniprot <- sub(".*\\..*\\..*\\..*\\.(.*?)\\..*", "\\1", aux)
    uniprot
    df <- data.frame(id, gname,uniprot, chr, pun[,2:7])
    colnames(df) <- c("CCDS id", "Gene Name", "uniprot","Chromosome", "Size Stretch", "A codons", "D codons", "Enrichment (D/A", "Size of gene (AA)", "Stretch/GeneSize")
    write.table(df, 'AllGenes.csv', row.names=F)
  }else {
    write("Warning: I could not make the ALL file, some files were missing!", file='')
  }

  ###### Making the tables more pretty
  p1<-read.table('GenesWithNoStretches.csv', header=T)
  aux <- p1$name
  id <- sub(".*(CCDS.*)\\.Hs.*", "\\1", aux)#extract...
  gname <- sub(".*\\..*\\..*\\..*\\..*\\.(.*?)", "\\1", aux)#extract...
  chr <- sub(".*\\.(chr.*)\\..*\\..*", "\\1", aux)
  uni<- sub(".*\\..*\\..*\\..*\\.(.*?)\\..*", "\\1", aux)
  df <- data.frame(id, gname,uni, chr, p1[,2:7])
  colnames(df) <- c("CCDS id", "Gene Name", "uniprot","Chromosome", "Size Stretch", "A codons", "D codons", "Enrichment (D/A", "Size of gene (AA)", "Stretch/GeneSize")
  write.table(df, 'GenesWithNoStretches.csv', row.names=F)
  ####
  
  p2<-read.table('GenesWithStretches.csv', header=T, sep=",")
  aux <- p2$name
  id <- sub(".*(CCDS.*)\\.Hs.*", "\\1", aux)#extract...
  gname <- sub(".*\\..*\\..*\\..*\\..*\\.(.*?)", "\\1", aux)#extract...
  chr <- sub(".*\\.(chr.*)\\..*\\..*", "\\1", aux)
  uni<- sub(".*\\..*\\..*\\..*\\.(.*?)\\..*", "\\1", aux)
  df <- data.frame(id, gname,uni, chr, p2[,2:7])
  colnames(df) <- c("CCDS id", "Gene Name","uniprot", "Chromosome", "Size Stretch", "A codons", "D codons", "Enrichment (D/A", "Size of gene (AA)", "Stretch/GeneSize")
  write.table(df, 'GenesWithStretches.csv', row.names=F)
  
  }
