#setFunc<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/functions/"
#setRun<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/runningWindows/"
#setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/"
#setSource<-"/mnt/lribas/users/arafels/irbPhd/4_NoAllData/codingSequences/"

################################
#LIBRARIES
################################
library("seqinr")#contains the function uco that calculates the codon usage
library("parallel")#define mclapply

################################
#FUNCTION runninWindow
################################
#rm(list=ls())#erases all the working space 

#runing window: for a "gene" a region of "winSize" amio acids is selected at the begining and it slides out to the end aa by aa. Returns the a(t) for each step and a plot of a(t)
runWinGen <- function(gene, winSize=80)
{
  gene<<-gene
  numCod<<-length(gene)/3#because the winSize is in codons
  steps<<-numCod-winSize#the number of steps we will do.
  if(steps < 0)#stops if the winSize is larger than the gene
  {
    print(paste(err, "winSize is too long"))
    err<<-err+1
#   break 
    return(NULL)
  }
  if(steps>0)
  {
    #  win<<-list()
    #  remove(at)  
    at<<-vector(length=steps+1)
    #  sapply(c(0:steps),fcount, gene, winSize)->at
    sapply(c(0:steps),function(x){fcount(i=x, gene, winSize)}, simplify=T)->>at
    #rbind(rWindows, )
    #  length(rWindows)=length(rWindows)+1
    #  rWindows[[length(rWindows)]]<<-at
  }
  return(at)
}################################

################################
#FUNCTION fcountUCOenh
################################
#find the initial and the final point of each window depending on th iteration i and returns the sum of the codons of interest (there are different ways to achieve that)
fcount<-function(i, gene, winSize)
{
  ini<<-(i*3)+1#initial position for step i
  fin<<-((i*3)+(winSize*3))#final position for step i
  if(i==0)
  {
    win<<-gene[ini:fin]
#   print(win)
    count <- uco(win)#OJO cannot be extensive "<<-". uco gives the codon usage of win (for every codon)
#   w1<-fsum(count, type)
#   print(c("i:",i," w1:",w1))
    aux<<-count#we need the previous value ot the next iteration
#   print(aux)
#   aux<<-w1#we need the previous value ot the next iteration
#   return(w1)
    return(count)
  }
  if(i>0)
  {
   
    co1<-uco(gene[(ini-3):(ini-1)])
    #c1<<-fsum(uco(gene[(ini-3):(ini-1)]), type)
    co2<-uco(gene[(fin-2):fin])
    aux<<-aux-co1+co2
    #c2<<-fsum(uco(gene[(fin-2):fin]), type)
    #aux<<-aux-c1+c2
    #print(co1[[1]]+co2[[1]])
    #print(i)
    #print(co1)
    #print(co2)
    #print(aux)
    return(aux) 
  }
}################################

runWin<-function(genFasta, winSize, cores, save=T, path=NULL)
{
    ##############################check the function
    #path<- "/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/miniTrial2/"
    #setwd(path)
    #load('genFastaClean.Rdata')
    #genFasta<-genFastaClean
    #winSize=80
    cores=1
    #load('rwMatrix80txt.Rdata')
    ##############################
    name<-paste('rwMatrix',winSize, sep='')
    fileName<-paste(name,'.Rdata', sep='')
    fileName2<-paste(name,'.txt', sep='')
    fileName3<-paste(name,'txt.Rdata', sep='')
    tim<-system.time(aux<-mclapply(genFasta, runWinGen, winSize, mc.cores=cores, mc.preschedule=F))
    write(paste('Taken time ', round(tim[3],3), 'seconds.'),file='')
    #write(paste('"Taken time (s):    "', round(tim[3],3)), file=fileName2, append=F)#######DOESN'T WORK
    #write('hello mf!', file=fileName2)
    win<-sapply(aux, ncol, simplify=T)
    #length(win)
    s<-sapply(win, is.null)
    #print(sum(s))
    #write(paste('"Num total  genes   :"', length(win)), file=fileName2, append=T)#num genes not long enough
    #write(paste('"genes < ', winSize, ' codons:"', sum(s)), file=fileName2, append=T)#num genes not long enough
    names(win)<-NULL
    u<-unlist(win[!s])
    #write(paste('"Num total windows  :"', sum(u)), file=fileName2, append=T)#num total windows
    infoRw<-c(length(win), sum(s), sum(u),  round(tim[3],3))
    names(infoRw)<-c('numTotalGenes', paste('genes<',winSize,sep=''), 'numTotalWin', 'takenTime(s)')
    setwd(path)
    save(infoRw, file=fileName3)
    write.table(infoRw, file=fileName2)
    if(save==T){
        assign(name,aux)#assign the object aux to the 'name' in name
        setwd(path)
        save(list=name, file=fileName)# takes a lsit of strings that are the names of the objects to save.
        write(paste('Saved....', path, fileName, sep=''), file='')
    }
    else{
       #return(eval(as.name(name)))
        return(aux)
    }      
}

write('Created.....runWin(fastaFile, winSize, cores, save, path)\nOutput....rwMatrix', file='')

#setwd(setFunc)
#source('runWin.R')#NOTE!!! do not source a function in the same function file
#setwd(setData)
#load('human/genFasta.Rdata')
#ex<-sample(genFasta,2)
#genFasta<-ex
#winSize=40
#cores=80
#setwd(setRes)
#load('rwMatrix50.Rdata')

#runWin(ex,55, 8, T, setRes)
#setwd(setRes)
#load('rwMatrix55.Rdata')


