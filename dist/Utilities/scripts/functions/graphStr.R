graphStr<-function(values,name ,thr=67)
{
    #setData<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/"
    #setFunc<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/functions/"
    #setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/"

    #setwd(setRes)
    colo<-rep('blue',length(values))
    if(sum(values>thr)>0){colo[values>thr]<-"red"}
    #colo
    #pdf(paste(name,'.pdf',sep=''), heigh=7, width=14)
    plot(values, pch=20, col=colo, ylim=c(0,80), xlab=name)
    #write(paste('***',name,'***'))
    abline(h=thr, lty=2)
    #dev.off()
}
   
