#########################################
#this function read a rWin gene (concentration for each window) and return a vector with the lengths of each stretch.
stretches<-function(gene, thr=62)
{
  gene>thr->>l#this vector is 1(TRUE) is gene[i]>thr and 0(FALSE) is gene[i]<thr.
  if(sum(l)<3)#true if there is NOT any stretch
  {
    return(NULL)
  }
  l[1:length(l)-1]->>l1#vector l from 1 to n-1
  l[2:length(l)]->>l2#vector l from 2 to n
  l1+l2->>l3#when make the sum of both we obtain th stretches as [....000122222222...2222222100000...] 2's headed abd tailed by 1's.
  if(l3[1]==2)#if the vector starts with a stretch...
  {
    l3[1]=1#let's put a 1 to the first position
  }
  if(l3[length(l3)]==2)#if the there is a stretch at the end...
  {
    l3[length(l3)]=1#let's put a 1 to the last position
  }
  grep(1,l3)->>gr#return the position of each 1, therefore the vector have the begin and the end for each stretch.
  gr1<<-gr[seq(1,length(gr),2)]#the positions of all the beginings
  gr2<<-gr[seq(2,length(gr),2)]#the positions of all the endings
  return(gr2-gr1)#vector of sizes.
}########################################thr 

##########################################
#this function plot the histogram with the distribution of stretches depending on the threshold (thr)
hists<-function(thr,xend=NULL, yend=NULL,x2end=NULL, y2end=NULL,rWinFile,strVec)
{
  #some data of interest
  sapply(rWinFile, is.null,simplify=T)->nu#check if the member of the list is NULL, returs TRUE/FALSE
  (length(nu)-sum(nu))/length(nu)->>freStr#sum(nu)=total of NULLS, thus this is the stretched genes frequence. 
  sapply(rWinFile, length,simplify=T)->>num#return the number of stretches for each gene.
  mean(num[num>0])->>numStr#the mean of above when there are 1 stretch at least
  mean(strVec)->>lenStr#the mean of the stretches length (when != 0)
  ok<<-c(paste("strechd gene freq:", round(freStr,4)),paste("num stretch per gene:", round(numStr,4)),paste("mean length stretch:", round(lenStr,4)))
  pdf("/mnt/lribas/users/arafels/IRB_pHd/1_projects/1_stretch/withR/Results/hist.pdf",width = 20,height = 10)
  #par(mfrow=c(2,1))
  hist(strVec,breaks=seq(1,max(strVec),1), main=paste("Stretch Length ( thr=",thr, ")"))->h
  legend("topright",cex=0.7, ok)
  hist(num[num>0],breaks=seq(1,max(num),1), main=paste("Stretch Frequency ( thr=",thr, ")"))->h2
  
  if(!is.null(xend) & !is.null(yend))
  {
    hist(strVec, xlim=c(0,xend), ylim=c(0,yend),breaks=seq(1,max(strVec),1), main=paste("Stretch Length ( thr=",thr, ")"))->h
    legend("topright",cex=0.7, ok)
    hist(num[num>0],xlim=c(0,x2end), ylim=c(0,y2end), breaks=seq(1,max(num),1), main=paste("Stretch Frequency ( thr=",thr, ")"))->h2
    
  }
  dev.off()
  #hist(strVec,breaks=200)->h
  #hist(strVec, xlim=c(0,500), ylim=c(0,500),breaks=100)->h
  return()
}############################################