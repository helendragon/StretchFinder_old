################################
#LIBRARIES
################################
library("seqinr")#contains the function uco that calculates the codon usage
#install.packages("Downloads/seqinr_3.0-7.tar.gz")
library("parallel")
#library("Biostrings", lib.loc="~/R/x86_64-suse-linux-gnu-library/3.1")

#setData<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/"
#setFunc<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/functions/"
#setRun<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/runningWindows/"
#setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/"
#setSource<-"/mnt/lribas/users/arafels/irbPhd/4_NoAllData/codingSequences/"

#setwd(setFunc)
#source('readFasta.R')#!!!!ojo
#setwd(setSource)
#readFasta("EcoliK-12_cds.fasta", path=setRes)


readFasta<-function(fastaFile2, checkNames=T, save=T, path)
{
    fastaFile<-read.fasta(fastaFile2, forceDNAtolower=F, as.string=F)#all the ccds human sequences
    fileName<-'genFastaClean.txt'
    setwd(path)
    write(paste('Source File:             ', fastaFile2), file=fileName, append=F)
    if(checkNames==T)
    {
        n<-getAnnot(fastaFile)
        names<-make.names(n)#get valid names for a list
        #easyNames<-gsub("^.*?coli.", "", namesColi)#remove '>.....coli.' from the name 
        l<-attributes(fastaFile)#a lsit with the names
        l$names<-names#substitute for our names of interest
        attributes(fastaFile)<-l#reload the attributes to GenColi
    }
    if(save==T){
        setwd(path)
        save(fastaFile, file='genFasta.Rdata')
        write(paste('fastaFile saved in ', path))
        return(NULL)
    }
    else{
        return(fastaFile)
    }
}

write('Created....readFasta(fastaFile, checkNames, save, path)\nOutput....genFasta', file='')

#setwd(setFunc)
#source('readFasta.R')
#path<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/Klebsiella/"


checkmRNA<-function(fastaFile, path){
    setwd(path)
    n<-length(fastaFile)
    fileName<-'genFastaClean.txt'
    write(paste('Number of genes:         ', n), file=fileName, append=T)
    ################CHECK THE FUNCTION
    #setSource<-"/mnt/lribas/users/arafels/irbPhd/4_NoAllData/ncbiData/nucleotide"
    #path<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/Klebsiella"
    #setwd(path)
    #load('genFasta.Rdata')
    #fastaFile<-genFasta
    #ex<-sample(fastaFile, 1000)
    #n<-100
    #e<-sapply(ex, check2, logic)
    #t<-table(e)
    #sum(e==5)
    #write.table(t, file='')
    ################
    e<-sapply(fastaFile, check2)
    write(paste('Number of correct genes: ', sum(e==0),' (',round ( (sum(e==0)*100)/n , 4), '%)'), file=fileName, append=TRUE)
    write(paste('NOT multiple of 3:       ', sum(e==3),' (',round ( (sum(e==3)*100)/n , 4), '%)'), file=fileName, append=TRUE)
    write(paste('NOT with ATG:            ', sum(e==1),' (',round ( (sum(e==1)*100)/n , 4), '%)'), file=fileName, append=TRUE)
    write(paste('NOT with stop codon:     ', sum(e==2),' (',round ( (sum(e==2)*100)/n , 4), '%)'), file=fileName, append=TRUE)
    genFastaClean<-fastaFile[e==0]
    return(genFastaClean)
    #save(genFastaClean, file='genFastaClean.Rdata')
    #load('geFastaClean.Rdata')
}

check2<-function(sequence){
    #print(sequence)
    #print(sequence[1:3])
    #print(length(sequence))
    l<-length(sequence)
    #print(l)
    #print(sequence[(l-2):l])
    if(l%%3 != 0){
        return(3)
    }
    atg<-toString(paste(sequence[1:3],collapse=''))#convertir a string
    #print(atg)
    #print( atg =='ATG' )#comparar amb ATG
    if(atg != 'ATG'){
        return(1)
    }
    stp<<-toString(paste(sequence[(l-2):l],collapse=''))#convertir a string
    #print(stp)
    #print((stp!='TAG')&(stp!='TAA')&(stp!='TGA'))
    if((stp!='TAG')&(stp!='TAA')&(stp!='TGA')){
        return(2)
    }
    else{
        return(0)
    }
}


