#setSource<-"/mnt/lribas/users/arafels/irbPhd/4_NoAllData/codingSequences/"
#setData<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/"
#setFunc<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/functions/"
#setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/win40/"
#setDel<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/deliveries/camille/win80/"

rw<-function(path=NULL, winSize=NULL, thr=NULL, sourceFasta=NULL ,fasta=T, matrix=T, atCod=atCodons, dtCod=dtCodons, sum=T, info=T, robust=T, organism='not-specified', core=1, plots=NULL, order="S", absolute=FALSE, bigFasta=FALSE, Ethr=0.7)
{
    if(is.null(path)){
        write('rw(targetPath, winSize, thr, sourceFile,...,fasta=F, matrix=F, sum=F, info=F, robust=F, organism, core=8)', file='')
    }

    if(absolute==TRUE){
        dtCod <- NULL
        order <- "S"
        write ('...Doing an Absolute Abundance analysis...', file='')
    }
    genFasta<-NULL 
    if(fasta==T){
        setwd(path)
        genFasta<-readFasta(sourceFasta,T,F,path)
        save(genFasta, file='genFasta.Rdata')
        # genFasta_<<-genFasta
        genFastaClean<-checkmRNA(genFasta, path)
        save(genFastaClean, file='genFastaClean.Rdata')
    }
    if(fasta=='R' & is.null(sourceFasta)){ #no sourceFasta defined, read Rdata
        write('...Loading Fasta Object...', file='')
        setwd(path)
        #name<-paste(
        load('genFastaClean.Rdata')
    }

####################WORK WITH genFastaClean
    genFasta<-genFastaClean
    write(paste('...',length(genFasta), ' sequences will be analyzed...', sep=""), file='')
    rwMatrix<-NULL
    if(matrix==T){
        write('....createing rwMatrix....', file='')
####################CORE NUMBERS
        rwMatrix<-runWin(genFasta, winSize, cores=core, F, path)
        #save(runWin(genFasta, winSize, cores=8, F, path), file='trial.Rdata')
        # rwMatrix_<<-rwMatrix
        name<-paste('rwMatrix',winSize, sep='')
        fileName<-paste(name,'.Rdata', sep='')
        setwd(path)
        assign(name, rwMatrix)
        save(list=name, file=fileName)

        #return(list(rw=rwMatrix, ws=winSize))

        #pp <- rw(...)
        #eval(parse(text=paste("rwMatrix", pp$ws, " <- pp$rw", sep='')))
        
    }
    if(matrix=='R' & is.null(rwMatrix)){ #You want to load the rwMatrix
        write('...Loading Matrix...', file='')
        setwd(path)
        name<-paste('rwMatrix',winSize, sep='')
        fileName<-paste(name,'.Rdata', sep='')
        load(fileName)
        rwMatrix<-get(name)
    }
    rwAsum<-NULL
    if(sum==T){
        write('....creating rw?sum....', file='')
        nameA<-paste('rwAsum', winSize, sep='')
        nameD<-paste('rwDsum', winSize, sep='')
        fileNameA<-paste(nameA,'.Rdata', sep='')
        fileNameD<-paste(nameD, '.Rdata', sep='')
        rwAsum<-runWinSum(rwMatrix, atCod, cu=F)
        rwDsum<-runWinSum(rwMatrix, dtCod, cu=F)
        #rwAsum_<-rwAsum
        #rwDsum_<-rwDsum
        assign(nameA, rwAsum)
        assign(nameD, rwDsum)
        setwd(path)
        save(list=nameA, file=fileNameA)
        save(list=nameD, file=fileNameD)
    }
    if(sum=='R' & is.null(rwAsum)){
        write('...Loading Sums...', file='')
        setwd(path)
        nameA<-paste('rwAsum', winSize, sep='')
        nameD<-paste('rwDsum', winSize, sep='')
        fileNameA<-paste(nameA,'.Rdata', sep='')
        fileNameD<-paste(nameD, '.Rdata', sep='')
        load(fileNameA)
        load(fileNameD)
        rwAsum<-get(nameA)
        rwDsum<-get(nameD)
    }  
    rwSInfo<-NULL     
    if(info==T){
        name<-paste('rwSInfo',winSize,'T',thr, sep='')
        fileName<-paste(name,'.Rdata', sep='')
        rwSInfo<-strInfo(rwAsum, rwDsum, rwMatrix, genFasta, thr, winSize, atCod, dtCod, path, Ethr)
        #rwSInfo_<<-rwSInfo
        assign(name, rwSInfo)
        setwd(path)
        save(list=name, file=fileName)
        dir.create('runWinAnalisys')
        #print(order)
        rwSInfoOrder(rwAsum, rwDsum, rwMatrix, rwSInfo, genFasta, winSize ,thr, path, atCod, dtCod, order)
    }
    #I take out redundant proteins from my datset!
    if (bigFasta == TRUE){
    write('...Curating the Big Fasta file...', file='')
    rwSInfo <- BigFastaInfo(path, winSize, thr)
    name<-paste('rwSInfo',winSize,'T',thr, sep='')
    fileName<-paste(name,'.Rdata', sep='')
    assign(name, rwSInfo)
    setwd(path)
    save(list=name, file=fileName)
    }

    if(info=='R' & is.null(rwSInfo)){
        write('...Loading Information...', file='')
        setwd(path)
        name<-paste('rwSInfo',winSize,'T',thr, sep='')
        fileName<-paste(name,'.Rdata', sep='')
        load(fileName)
        rwSInfo<-get(name)
    }   

    

    if(robust==T){
        name<-paste('rwRobust', winSize,'T',thr, sep='')
        fileName<-paste(name,'.txt', sep='')
        rwRobust<-strRobust(rwSInfo, winSize, thr, path)
        #rwRobust_<<-rwRobust
        #assign(name, rwRobust)
        setwd(path)
        #write.csv(as.data.frame(rwRobust),file=fileName)
        names(organism)<-'organism   :'
        write.table(as.data.frame(organism), sep='\t' ,col.names=F ,file=fileName)
        write.table(as.data.frame(rwRobust),file=fileName, sep='\t', col.names=F ,append=T, dec='.')
        #print(rwRobust)
        #write(names(rwRobust), file=fileName)
        #write(rwRobust, file=fileName, append=T)
    }
    if(!is.null(plots)){

        winSize=3
        thr=2
        ucoName<<-paste('ucoStr', winSize, 'T', thr, '.txt', sep='')
        setwd(path)
        ucoStr<-read.table(ucoName, header=T)
        ucoStr
        rwPlotPolyP(ucoStr, path)
    }
    write('....Extracting list of stretches....', file='')
    stretcheslist(path, winSize, thr)
}            

