library("seqinr")
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretch_old/ccdsHsapNew2_stretch.txt", header=T)->dataBig#dataBig is the division of all the genes into halves several times until obtain small regions.
save(dataBig, file="Dropbox/TotDrop/IRB_pHd/databig.Rdata")
plot(dataBig$codons, dataBig$cod_adat, pch=".", xlim=c(0,3000), title(main='stretch with intersection'))#plots a(t) with respect c(t)

read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.800000_240.txt", header=T)->data80#data80 is the division of all the genes without intesection between the regions. Those regions are longer than 80 codons and more enriched in a(t) than 80% if possible (only 0.5% of the regions are >80% in a(t)). Files are generated with stretchMain project.
save(data80, file="Dropbox/TotDrop/IRB_pHd/data80.Rdata")
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.800000_150.txt", header=T)->data8s
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.800000_360.txt", header=T)->data8l
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.800000_240.txt", header=T)->data8m
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.600000_150.txt", header=T)->data6s
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.600000_360.txt", header=T)->data6l
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.600000_240.txt", header=T)->data6m
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.700000_240.txt", header=T)->data7m
read.table("/home/albert/IRBpHd/1_projects/1_stretch/stretchNew/hsapCodonId0.900000_240.txt", header=T)->data9m

#NOTE: charge package "seqinr". It seems to be a while old-fashioned.
read.fasta("IRBpHd//3_data/codingSequences/NOgeneCandidates", forceDNAtolower=F)->NoGenCand#just read fasta file and convert it into a useful list.
read.fasta("IRBpHd//3_data/codingSequences/geneCandidates", forceDNAtolower=F)->GenCand
read.fasta("IRBpHd//3_data/codingSequences/prova.fna", forceDNAtolower=F,)->GenProva
read.fasta("IRBpHd//3_data/codingSequences/ccdsHsapClean2IdLinux.fna", forceDNAtolower=F, as.string=T)->GenHumanS#all the ccds human sequences
read.fasta("IRBpHd/3_data/codingSequences/MUC4ccds.fna", forceDNAtolower=F, )->GenMUC4#all the ccds human sequences

read.fasta("IRBpHd//3_data/codingSequences/refMrna.fa.gz", forceDNAtolower=F, )->GenHumanUCSC#we want to find another human transcriptome database. This seems not to work.


plot(data80$size, data80$allADATper, pch=".", xlim=c(0,500), ylim=c(0,1), title(main='stretch w/o intersection'))#plot all the segments (method without intersection)
par(new=T)#the next plot is merged with the previous one.
stretch80=subset(data80, data80$size>80 & data80$allADATper>0.8)#select the best regions (stretches)
plot(stretch80$size, stretch80$allADATper, pch=1, col='red', xlim=c(0,500), ylim=c(0,1), title(main='stretch w/o intersection'))#plot the stretches also.





#######################################
#this function analyzes whether the set of regions of dataBig of size "cut" are following a binomial distrubution.
chi <- function(cut, sup=0.1, t1=1, t2=cut+1)#"cur" are the length of the regions. "sup" are the superior bound for y axis (we have to adjust it manually). t1 and t2 are the region where the chi.squared test is fitting.
{
  subset(dataBig, dataBig$codons==cut)->points#regions with length = "cut"
#  rbinom(1000, size=cut, prob=0.526)->points #postive control
  
  hist(round(points$aa_adat*cut), breaks=seq(-0.5,cut+0.5,1), right=F)->>h#plots the histogram about the number of a(t) codons (points$aa_adat*cut). There can be from 0 to cut codons, therore there is one break more.
#NOTE: be carefull with teh breaks of the histogram. Some times it seems not to worrk properly. 

  length(points$codons)->>l#the number of samples. It can be measured also by sum(h$counts)
#  rbinom(l, cut, 0.526)->>r
#  hist(r, breaks=0:(cut+1), right=F)->>hr
  dbinom(x=0:(cut), size=cut, prob=0.526)->>d#the probability function
  plot(0:(cut), h$counts, type='h', ylim=c(0,max(d*l)))#plots the relative frequency 
#  lines(0:(cut), h$counts/l)#"lines" and "points" commands are helpful when when we want to merge another plot. "par(new=T)" ia not needed.
#  par(new=T)
#  plot(t1:t2, c, type='h', ylim=c(0,sup))#with the accumulation in the tails
#  plot(0:(cut), hr$counts/l, type='n', xlab="", ylab="", ylim=c(0,sup))
#  lines(0:(cut), hr$counts/l, col="green", ylim=c(0,sup)) 
#  par(new=T)

  lines(0:(cut), d*l, xlab="", ylab="", type='l',ylim=c(0,max(d*l)), col="green")#the probability function is merged to compare (by sight).
#  lines(t1:t2, d2*l, xlab="", ylab="", type='l',ylim=c(0,sup), col="green")#with the accumulations in the tails
#  lines(0:(cut), d, col="red")
#  par(new=T)

#  (h$counts-d*l)*(h$counts-d*l)/(d*l)->>chs#chs manually gets the values of the chi-squared test
#  plot(0:cut, chs,xlab="", ylab="",yaxt="n", col="green")#plot chs is useful to see how the error is distibuted all along the values. If the error is accumulated in the queues the region where the test is done ca be re-adjusted. 
#  axis(4)
#  mtext("y2",side=4,line=3)#create another y-axis in the right side.

#  chisq.test(h$counts, hr$counts/l)->>ch1

  d[t1:t2]->d2#make the chi-squared test acumulating the probability
  d2[1]<-sum(d[0:t1])#in the left tails and
  d2[length(d2)]<-sum(d[t2:length(d)])#in theright tail
  h$counts[t1:t2]->c#also accumulate the observations
  c[1]<-sum(h$counts[1:t1])#in the left tail and
  c[length(c)]<-sum(h$counts[t2:length(h$counts)])#in the right tail
  chisq.test(x=c, p=d2)->>test
  
  print(test)

#  ch1
#  print(ch2)#this give us quite information and the p-value.

#  sum(chs[t1:t2])->>X#sum off chs are the value X where the chi-sq probability function must be evaluated
#  print(X)
#  print(pchisq(q=X, df=t2-t1))
#  pval<- 1-(pchisq(q=X, df=t2-t1))#however it's clearer to directly write the p-value.
#  print(pval)

#  ok<-c(paste("red: dbinom(x, ",cut, " 0.526)"), paste("green: rbinom(", l, cut, "0.526)"), paste("black: c(t)=", cut, " numSamples=", l), paste("chisq.test (", t1-1,"," ,t2-1,"): pval=", round(ch2$p.value, 4)), paste("byHand: pval=", pval))#this is the text for the legend
  ok<-c(paste("Data for c(t)=",cut), paste("Samples=", l), paste("Binom(",cut, ",0.526)",sep=""), paste("Chisq.test p-val=", round(test$p.value, 4)))#this is the text for the legend
legend("topleft", ok, cex=1, xjust=1, lty=c(1,NA,1,NA), col=c("black",NA, "green", NA))#write the legend in the plot 
}##########################################chi



###########################################
#decide if a region follows or not a Bionomial distribution.OLD-FASHIONED
graphBinom <- function(error=0.05, ini, fin)
{
  #error <- 0.05#the region of allowed error, it'll be divided in the two tails.
  #ini<-1000#initial point, as Binomial is a discrete function, it follows the study point by point until...
  #fin<-1100#the final point
  results<<-dataBig[0,]#only the header of the data
  for(j in ini:fin)#NOTE: try to avoid "for" in R
  {
    sub<<-subset(dataBig, dataBig$codons==j)#subset of regions with length j (or j codons).
#    inf<-qbinom(error/2, j, 0.526)#lower threshold of a(t) (ADAT isoacceptors for each region)
#    sup<-qbinom(1-(error/2), j, 0.526)#upper threshold of a(t) (ADAT isoacceptors for each region)
    at<<-sub$aa_adat*sub$codons#number of a(t) (ADAT isoacceptors for each region)
#    subsub<-subset(sub, at < inf | at > sup)
    subsub<<-subset(sub, pbinom(at,j,0.526) < error/2 | pbinom(at,j,0.526) > 1-(error/2))
    outliers<<-rbind(results, subsub)#rbind concatenate data matrix horitzontally (if they've the same number of columns)
  }
  
  plot(dataBig$codons, dataBig$aa_adat, pch=".", col='black', xlim=c(ini,fin), ylim=c(0,1), title(main='All the regions with intersection'))
  par(new=T)
  plot(results$codons, results$aa_adat, pch=1, cex=0.5, col='red', xlim=c(ini,fin), ylim=c(0,1))
}########################################



#########################################
#FASTER print the points with extreme probabilites (p(x)>1-alpha/2 & p(x)<alpha/2) in the c(t)-a(t) graph.
graphBinom2 <- function(error=0.05, ini=0, fin=3000)#error i.e. level of significance.
{
  sub<-subset(dataBig, pbinom(dataBig$aa_adat*dataBig$codons, dataBig$codons, 0.526) < error/2 | pbinom(dataBig$aa_adat*dataBig$codons, dataBig$codons, 0.526) > (1-(error/2)))#select the outliers
  
  pvals<-pbinom(sub$aa_adat*sub$codons, sub$codons, 0.526)#record the pvalues (optional)
  pvalsC<-p.adjust(pvals, method="BH")#adjust the p-values....we'll do later
  subC<-subset(sub, pvalsC < error/2 | (1-(error/2)))
  
  ok<-c(paste("num outliers: ",length(sub$codons)), paste("num outliersC: ",length(subC$codons)), paste("error (two.sided): ", error))#create the legend
  
  plot(dataBig$codons, dataBig$aa_adat, pch=".", col='black', xlim=c(ini,fin),xlab="c(t) size in codons", ylim=c(0,1),ylab="a(t)/c(t)", title(main='All the regions with intersection'))#plot all the points
  par(new=T)
  plot(sub$codons, sub$aa_adat, pch=1, cex=0.5, col='red', xlim=c(ini,fin), ylim=c(0,1), xlab='', ylab='')#plot the outliers in red
  par(new=T)
  plot(subC$codons, subC$aa_adat, pch=1, cex=0.5, col='blue', xlim=c(ini,fin), ylim=c(0,1), xlab='', ylab='')#plot the outliers with corrected p-values in blue
  legend("topright", ok)#plot the legend
}####################################graphBinom

pvals<-pbinom(sub$aa_adat*sub$codons, sub$codons, 0.526)
  
#create a graph between variables a(t)-a(t)/c(t) via a boxplot graph
cut(results$aa_adat, 4)->cuts#divides the aa_adat data into 4 regions, cuts is a "grouping variable"
boxplot(results$aa_adat~cuts)# makes a boxplot analysis o variable aa_adat with respect to the cuts grouping variable
boxplot(results$codons~cuts)
cut(data80$allADATper, 20)->cuts



################################
#create a graph between variables a(t)-a(t)/c(t) via a boxplot graph
box<-function(Ncut=50)#makes the boxplot with the "Ncut" number of divisions
{
  cut(data9m$allADATper, Ncut)->cuts
  boxplot(data9m$cod.aaADAT~cuts)
  title(main=paste(Ncut," cuts", ">80cod >0.8"))
}################################

#rWindows<-list()#initialze a list (not used)
library("parallel")
library("seqinr")
library("Bioconductor")


mclapply(GenHuman, runningWindow, winSize=20, type="d",mc.cores=8, mc.preschedule=F)->crWinHuman20#similar to sapply but uses all the cores of the computer, then is 8 fold faster. (for GeneHuman 28000 genes -> 4h aprox)
load("Dropbox/TotDrop/IRB_pHd/RWinHuman.Rdata")
unlist(rWinHuman)->>l
dnorm(x=0:80, mean=mean(l), sd=sd(l))*length(l)->>E
hist(l, xlim=c(-0.5,80.5), breaks=seq(-0.5,80.5,1), ylim=c(0,10e+5))->>hist2#plot the general distribution of th windows
hist$counts->>O
lines(0:80, dnorm(x=0:80, mean=mean(l), sd=sd(l))*length(l), col="red")
ks.test(x=O, pnorm, mean(l), sd(l))->ks#checks normality
leg<-c(paste("ks.test pvalue: ",ks$p.value))
legend("topright", leg)

load("Dropbox/TotDrop/IRB_pHd/RWinHuman20.Rdata")
unlist(rWinHuman20)->>l
dnorm(x=0:20, mean=mean(l), sd=sd(l))*length(l)->>E
hist(l, xlim=c(-0.5,20.5), breaks=seq(-0.5,20.5,1), ylim=c(0,3e+6))->>hist2#plot the general distribution of th windows
par(mfrow=c(1,1))
hist$counts->>O
lines(0:20, dnorm(x=0:20, mean=mean(l), sd=sd(l))*length(l), col="red")
ks.test(x=O, pnorm, mean(l), sd(l))->ks#checks normality
leg<-c(paste("ks.test pvalue: ",ks$p.value))
legend("topright", leg)

round(qnorm(c(0.9999, 0.999, 0.99, 0.95, 0.90, 0.80, 0.70, 0.60),mean=mean(l), sd=sd(l)))->thrs#supposing normality of data, thrs is a vector of the thresholds to select the stretches supossing an error of 1-(taken vector of pobabilities in qnorm)  



################################
#runing window: for a "gene" a region of "winSize" amio acids is selected at the begining and it slides out to the end aa by aa. Returns the a(t) for each step and a plot of a(t)
runningWindow <- function(gene, winSize=80, type="a")
{
  gene<<-gene
  numCod<-length(gene)/3#because the winSize is in codons
  steps<-numCod-winSize#the number of steps we will do.
  if(steps < 0)#stops if the winSize is larger than the gene
  {
    print(c("winSize is too long"))
#    break  
  }
  if(steps>0)
  {
#  win<<-list()
#  remove(at)  
  at<<-vector(length=steps+1)

#  sapply(c(0:steps),fcount, gene, winSize)->at
  sapply(c(0:steps),function(x){fcount(i=x, gene, winSize, type)})->>at

  #rbind(rWindows, )
#  length(rWindows)=length(rWindows)+1
#  rWindows[[length(rWindows)]]<<-at
  }
  return(at)
}
##############################

##############################
fcount<-function(i, gene, winSize, type)
{
  ini<<-(i*3)+1#initial position for step i
  fin<<-((i*3)+(winSize*3))#final position for step i
#  print(ini)
  
  if(i==0)
  {
    win<<-gene[ini:fin]
##    win<<-DNAString(paste(gene[ini:fin],collapse=""))# the section of gene to analyze 
#   print(win)
    count <- uco(win)
##    count <- trinucleotideFrequency(DNAString(paste(gene[ini:fin],collapse="")), step=3)#OJO cannot be extensive "<<-". uco gives the codon usage of win (for every codon) 
    w1<-fcount2(count, type)
#    print(c("i:",i," w1:",w1))
    aux<<-w1#we need the previous value ot the next iteration
    return(w1)
  }
  if(i>0)
  {
##    co1<<-uco(gene[(ini-3):(ini-1)])
##    co1<<-DNAString(paste(gene[(ini-3):(ini-1)],collapse=""))#the codon on the left we just discarded in this window iteration
##    coEnd<<-uco(gene[(fin-2):fin])
##    coEnd<<-DNAString(paste(gene[(fin-2):fin],collapse=""))#the codon on the right we just added in this windiw iteration
      c1<<-fcount2(uco(gene[(ini-3):(ini-1)]), type)
##    c1<<-fcount2(trinucleotideFrequency(DNAString(paste(gene[(ini-3):(ini-1)],collapse="")),step=3), type)
      c2<<-fcount2(uco(gene[(fin-2):fin]), type)
##    c2<<-fcount2(trinucleotideFrequency(DNAString(paste(gene[(fin-2):fin],collapse="")),step=3), type)
    aux<<-aux-c1+c2
#    print(c("i:",i,"co1",co1,"co2",coEnd,"c1",c1,"c2",c2))
    return(aux) 
  }
}####################################

#####################################
fcount2<-function(count, codSet)#this function sums the codons of interest in each case.
{
  if(codSet=="a")
  {
    w<-count[[40]]+count[[38]]+count[[37]]+count[[39]]+count[[24]]+count[[22]]+count[[21]]+count[[23]]+count[[8]]+count[[6]]+count[[5]]+count[[7]]+count[[48]]+count[[46]]+count[[45]]+count[[47]]+count[[56]]+count[[54]]+count[[53]]+count[[55]]+count[[12]]+count[[10]]+count[[28]]+count[[26]]+count[[25]]+count[[27]]+count[[11]]+count[[9]]+count[[32]]+count[[30]]+count[[29]]+count[[31]]+count[[63]]+count[[61]]+count[[16]]+count[[14]]+count[[13]]#the ADAT A codons are collected from "count" a(t)
    return(w)
  }
  if(codSet=="d")
  {
    w<-count[[40]]+count[[38]]+count[[37]]+count[[24]]+count[[22]]+count[[21]]+count[[8]]+count[[6]]+count[[5]]+count[[48]]+count[[46]]+count[[56]]+count[[54]]+count[[53]]+count[[55]]+count[[28]]+count[[26]]+count[[25]]+count[[32]]+count[[30]]+count[[29]]+count[[16]]+count[[14]]+count[[13]]#the ADAT D codons are collected from "count" d(t)
    return(w)
  }
}###################################



##################################

#TO DO: ENHANCE of 'at': save the information for each codons instead of sum them. Therefore we can make all the analysis needed.






####################################
#creates a histogram from the set of points of length c(t)=cut. 
histoCut<-function(cut)
{
  subset(dataBig, dataBig$codons == cut)->>bin100#creates the set of points
  c(paste("var=",round(var(bin100$aa_adat), digits=4)),paste("min=", round(min(bin100$aa_adat), digits=4)), paste("Q1=", round(quantile(bin100$aa_adat, 0.25), digits=4)),paste("mean=", round(mean(bin100$aa_adat), digits=4)), paste("median=", round(median(bin100$aa_adat), digits=4)), paste("Q3=", round(quantile(bin100$aa_adat, 0.75), digits=4)), paste("max=", round(max(bin100$aa_adat), digits=4)), paste("num poits: ", length(bin100$aa_adat))) -> ok#creates the legend with statistic information
  hist(bin100$aa_adat, main=NULL)#plot the histogram
  legend("topright", ok)#plot the legend in the histogram
  title(paste("Histogam of dataBig at c(t)=", cut, " codons"))#plot the title in the histogram
}#####################################

par(new=F)
#jpeg("runs.jpeg", heigh=297, width=210, units='mm', res=300)#define the name of the jpg and the resolution. The path of the jpg is /home/runs.jpeg
sapply(rWin, prw)#merge all the runung window plots to check the general beahaviour 



>#################
#dev.off()

library("reshape2")#to use function melt
melt(rWinHuman)->s2#library(reshape2) symilar to unlist but it doesn't change the name of the genes.

########################################
#this function returs a list of gene candidates when a threshold is fixed
lista<-function(thr=75)
{
  subset(s2, s2$value>thr)->ss2#the subset highly enriched with a(t).The name of the gene candidates are repeated as times as >75 points they have.
#  length(ss2$L1)
  unique(ss2$L1)->>candi#this function remove all the repeated names and returns the list of gene candidates.
#  lenght(candi)
  print(paste("Number of candidates: ", length(candi)))
  print("List in 'candi' obsject created")
}######################################

########################################
#Volem calcular per cada gen l'area per sobre del threshold i el numero de windows per sobre del threshold. 
load(file="/Users/federica/Dropbox/TotDrop/IRB_pHd/RWinHuman.Rdata")#load Rdata in windows
sapply(rWinHuman, rank, 62,     simplify=F)->rankHuman62#retorna com una llista
sapply(rWinHuman, rank, 62,     simplify=T)->rankHuman62#retorna com una matriu pk en aquest cas el resultat ?s senzill
rankHuman62[,order(rankHuman62[2,],decreasing=T)]->r62len#return the values ordered by length (2nd column)
rankHuman62[,order(rankHuman62[1,],decreasing=T)]->r62sum#return the values ordered by area (1st column)
plot(t(rankHuman62))#plot length vs area to check the correlation

ranks<-function(gene, thr=62)#for each gene it retuns the area and the length c(area,length) of the stretch (based on the threshold thr)
{
  gene[gene>thr]->>area#vector with only the values > thr.
  return(c(sum(area), length(area)))#sum(area) gives us an idea of how powerfull is the stretch and length how long.
}########################################

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
}########################################

##########################################
#this function plot the histogram with the distribution of stretches depending on the threshold (thr)
hists<-function(thr,xend=NULL, yend=NULL,x2end=NULL, y2end=NULL)
{
  sapply(rWinHuman,stretches,thr=thr)->rWinFile#apply the function stretches in each of the elements of rWinHuman
  unlist(rWinFile)->strVec#converts rWinFile from a file to a vector avioding NULL's (genes w/o stretches)
  
  #some data of interest
  sapply(rWinFile, is.null,simplify=T)->nu#check if the member of the list is NULL, returs TRUE/FALSE
  (length(nu)-sum(nu))/length(nu)->>freStr#sum(nu)=total of NULLS, thus this is the stretched genes frequence. 
  sapply(rWinFile, length,simplify=T)->>num#return the number of stretches for each gene.
  mean(num[num>0])->>numStr#the mean of above when there are 1 stretch at least
  mean(strVec)->>lenStr#the mean of the stretches length (when != 0)
  ok<<-c(paste("strechd gene freq:", round(freStr,4)),paste("num stretch per gene:", round(numStr,4)),paste("mean length stretch:", round(lenStr,4)))
  
  par(mfrow=c(2,1))
  hist(strVec,breaks=seq(1,max(strVec),1), main=paste("Stretch Length ( thr=",thr, ")"))->h
  legend("topright",cex=0.7, ok)
  hist(num[num>0],breaks=seq(1,max(num),1), main=paste("Stretch Frequency ( thr=",thr, ")"))->h2
  
  if(!is.null(xend) & !is.null(yend))
  {
    hist(strVec, xlim=c(0,xend), ylim=c(0,yend),breaks=seq(1,max(strVec),1), main=paste("Stretch Length ( thr=",thr, ")"))->h
    legend("topright",cex=0.7, ok)
    hist(num[num>0],xlim=c(0,x2end), ylim=c(0,y2end), breaks=seq(1,max(num),1), main=paste("Stretch Frequency ( thr=",thr, ")"))->h2

  }
  #hist(strVec,breaks=200)->h
  #hist(strVec, xlim=c(0,500), ylim=c(0,500),breaks=100)->h
  return()
}############################################

