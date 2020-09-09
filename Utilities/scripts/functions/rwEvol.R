rwEvol <- function(fileName, names, values, hline=NULL, vline=NULL, colPat=NULL, ylab=NULL){

    setData<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/"
    setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/evol/"
    if(is.null(values)){
        setwd(setData)
        t<-read.table(paste(fileName,'.txt',sep=''))
        names<-t$V1
        #names
        values<-t$V2
        pattern<-c(7,9,15,5,11,12,6,13,29,10,14,21,22,1,2,3,24,20,28,30,4,16,8,23,26,27,18,19,25)
        colPat<-c(1,1,2,2,2,2,2,3,3,4,4,5,5,5,5,6,6,6,6,8,8,8,8,8,8,8,8,8,8)
        names<-names[pattern]
        values<-values[pattern]
    }
        
    #length(colPat)
    #length(pattern)
    setwd(setRes)
    pdf(paste(fileName,'.pdf', sep=''),height = 7 ,width = 17)
    par(oma=c(0,0,0,0))
    par(mar=c(20,6,3,1))
    b<-barplot(values,col=colPat,cex.axis=1, cex.lab=1.3, cex.names=1.3, main="", names.arg=names, ylab=ylab, las=3, srt=45)
    #lines(0:80, p*length(ua), col="red")
    abline(lty=2, lwd=1, v=vline, col='black')
    #ma<-which.is.max(hist$counts)
    abline(lty=2, h=hline, lwd=1, col='black')
    #lines(0:80, dbinom(0:80, 81, 0.527)*length(ua),col="green")
    dev.off()
    return(NULL)
}
