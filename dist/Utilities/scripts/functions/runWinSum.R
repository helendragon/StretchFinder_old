#setSource<-"/mnt/lribas/users/arafels/irbPhd/4_NoAllData/codingSequences/"
#setData<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/"
#setFunc<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/functions/"
#setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/"

################################
#FUNCTION fsum3
################################
#this function sums the codons of interest depending in rowSet. If logical=TRUE ???
fsum3<-function(matri, rowSet, thr=NULL, cu=FALSE)
{
  if(!is.matrix(matri))
  {
    #print("error1")
    return(NULL)
  }
  if((dim(matri))[2]==0 | (dim(matri))[1]!=64)
  {
    #print("error2")
    return(NULL)
  }
  w<-sapply(c(1:((dim(matri))[2])),function(x){sum(matri[rowSet,x, drop=F])})
  if(cu){return(matri[,w>thr])}#return the CU for those windows with w>thr 
 # if(logical){return((w>thr))}#under construction (large vector of T and F)
  if(!cu){return(w)}#return the w for all the windows.
}################################

runWinSum<-function(rwMatrix, codonSet, cu=F, thr=NULL)
{
    if(cu==F){
        aux<-sapply(rwMatrix, fsum3, rowSet = codonSet, cu=FALSE)#creates again the suma of the data.
       return(aux)
    } 
    if(cu==T){
         aux<-sapply(rwMatrix, fsum3, rowSet = codonSet,thr, cu=TRUE)
       return(aux)  
     }
}
write('Created....runWinSum(rwMatrix, codonSet, cu, thr)\nOutput....rw?sum', file='')

#setwd(setFunc)
#source('codSets.R')
#setwd(setRes)
#load('rwMatrix55.Rdata')
#runWinSum(rwMatrix55, atCodons, T, 30)
#j<-runWinSum(rwMatrix55, atCodons, F)
#sum(j[[2]]>30)


