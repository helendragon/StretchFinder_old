library(seqinr)
library(nnet)
setSource<-"/mnt/lribas/users/arafels/irbPhd/4_NoAllData/codingSequences/"
setData<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/"
setFunc<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/functions/"
#setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/win40/"
#setDel<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/deliveries/camille/win80/"
#setwd(setFunc)
#source("fsum3.R")
#source("codSets.R")
#source("stretch.R")

setwd(setSource)
genFasta<-read.fasta("ccdsHsapClean2IdLinux.fna", forceDNAtolower=F, as.string=F)#all the ccds human sequences

setwd(setData)
#load('sInfo80T67.R')
load('genHumanMatrix80.Rdata')
load('a80RW.Rdata')
load('d80RW.Rdata')
load('sInfo80T67.Rdata')
ls()

rwMatrix80<-genHumanMatrix80
rwASum80<-a80RW
rwDSum80<-d80RW

setwd(setData)
save(rwMatrix80, file='human/rwMatrix80.Rdata')
save(rwASum80, file='human/rwASum80.Rdata')
save(rwDSum80, file='human/rwDSum80.Rdata')
save(genFasta, file='human/genFasta.Rdata')


rwSInfo80T67<-strInfo(rwASum80, rwDSum80, rwMatrix80, genFasta, 67)
save('rwSInfo80T67', file='human/rwSInfo80T67.Rdata')
