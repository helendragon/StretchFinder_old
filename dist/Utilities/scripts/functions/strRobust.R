#input: sInfo67T80, object of stretches
#output:  a table with stretches properties

#setSource<-"/mnt/lribas/users/arafels/irbPhd/4_NoAllData/codingSequences/"
#setData<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/"
#setData<-'/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/evolution/analysis/2_stretchAnalysis/results/eukarya/OLD/HsapCcds/'
#setFunc<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/functions/"
#setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/win40/"
#setDel<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/deliveries/camille/win80/"
#setwd(setFunc)
#source("fsum3.R")
#source("codSets.R")
#source("stretch.R")

#setwd(setData)
#load('rwSInfo80T67.Rdata')
#ls()



strRobust<-function(sInfo, winSize, thr, path)
{
    
    ####check data
    #path<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/Klebsiella/"
    #winSize=80
    #thr=67
    #setwd(path)
    #load('rwSInfo80T57.Rdata')
    #sInfo<-rwSInfo80T67
    #<###   
    t<-sapply(sInfo, is.null)
    nGen<-length(t)
    #nGen
    if(nGen==0){
        print('nGen=0, there are no genes to analyze!!!!!!!!')
        return(NULL)
    }
    nGenStr<-sum(!t)
    #nGenStr
    fileName=paste('rwMatrix',winSize,'.txt', sep='')
    #fileName
    #ls()
    #infoRw
    #ta<-read.table(fileName)#llegim directament del fitxer rwMatrix...txt TOO DANGEROUS!!!
    fileName=paste('rwMatrix',winSize,'txt.Rdata', sep='')
    load(fileName)#creates the object infoRw
    nWinTot<-infoRw[3]
    nGenShort<-infoRw[2]
    #nGenShort
    if(nGenStr==0){
        #info<-c(winSize, thr, nGen, nGenStr ,0, 0, 0, 0, 0, 0, 0, 0, 0)
        info<-c(winSize, thr, nGen, nGenShort, (nGenShort*100)/nGen, nGenStr, (nGenStr*100)/nGen, 0, nWinTot, 0, 0, 0, 0)
        names(info)<-c('winSize    :', 'thr        :' ,'nGen(clean):', paste('nGen <',winSize, ' :'), paste('%nGen <', winSize, ':') , 'nGenStr    :', '%nGenStr   :', 'nStr       :' ,'nWinTot    :', 'nWinStr    :','%WinStr    :', 'strSizeMean:', 'strNumMean :')
        info<-round(info,5)######OJO: round all the values at 5 digits
        #info
        return(info)
    }

    #sInfo<-rwSInfo80T67
    #sInfo

    sInfo<-sInfo[!t]
    v<-unlist(sapply(sInfo, '[[', 'sizes'))
    strSizeMean<-mean(v+79)
    nWinStr<-sum(v)

    #v
    #nWinStr

    v<-sapply(sInfo, '[[', 'num') 
    nStr<-sum(v)
    strNumMean<-mean(v) 
    info<-c(winSize, thr, nGen, nGenShort, (nGenShort*100)/nGen,nGenStr, (nGenStr*100)/nGen, nStr, nWinTot, nWinStr, (nWinStr*100)/nWinTot, strSizeMean, strNumMean)
    names(info)<-c('winSize    :', 'thr        :' ,'nGen(clean):', paste('nGen <',winSize, ' :'), paste('%nGen <', winSize, ':') , 'nGenStr    :', '%nGenStr   :', 'nStr       :' ,'nWinTot    :', 'nWinStr    :','%WinStr    :', 'strSizeMean:', 'strNumMean :')
    info<-round(info,5)######OJO: round all the values at 5 digits
    return(info)

}
write('Created....strRobust(rwSInfo67T80)', file='')
    
