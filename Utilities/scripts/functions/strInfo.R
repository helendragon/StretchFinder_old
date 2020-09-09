stretches<-function(agene,dgene,thr,winSize,matri,genSeq,ref,atCod,dtCod, path, Ethr)
{
 l<-(agene)>thr#this vector is 1(TRUE) is gene[i]>thr and 0(FALSE) is gene[i]<thr.
 
 l[1876:1999]
 agene>67
 
 if(sum(l)==0)#true if there is NOT any stretch
 {
   return(NULL)
 }
  l<-c(FALSE,l,FALSE)#extend l to find those stretches that ends in the tails of the gene
  l1<-l[1:length(l)-1]#vector l from 1 to n-1
  l2<-l[2:length(l)]#vector l from 2 to n
  l3<-l1+l2#when make the sum of both we obtain th stretches as [....000122222222...2222222100000...] 2's headed abd tailed by 1's. Thre stretch goes from the first '2' to the last '1'

  #l3[1950:2100]
 
  gr<-grep(1,l3)#return the position of each 1, therefore the vector have the begin and the end for each stretch.

 #length(gr)
 #gr
 
 gr1<-gr[seq(1,length(gr),2)]#the positions of all the beginings
 gr2<-(-1)+gr[seq(2,length(gr),2)]#the positions of all the endings

 #gr1
 #gr2

 if(length(gr1)==1){#només hi ha un stretch
      gr1Real<-gr1
      gr2Real<-gr2
  }
  if(length(gr1)>1){
      #strReal<-sapply(1:(length(gr1)-1), function(i){gr2[i]+thr-1 < gr2[i+1]}) OLD
      strReal<-sapply(1:(length(gr1)-1), function(i){gr2[i]+winSize-1 < gr1[i+1]})
      gr1Real<-gr1[c(TRUE,strReal)]
      gr2Real<-gr2[c(strReal,TRUE)]
  }
 

  #gr1Real
  #gr2Real
  #gr2Real-gr1Real
 
  #aStr<<-sapply(1:length(gr1Real), function(i){mean((agene)[gr1[i]:gr2[i]])})# a(l) for every stretch###################ojo comprovar que esta bé
   #dStr<<-sapply(1:length(gr1), function(i){mean((dgene)[gr1[i]:gr2[i]])})# d(l) for every stretch
#  l4<<-l3>0#vector of T&F 
#  l4[gr2+1]=0#vector of T&F
#  l5<<-l4[1:length(l4)-1]#vector of T&F ended
#  matri<<-matri
#  cu<<-sapply(1:length(gr1), function(i){codU(matri[,gr1[i]:gr2[i]])},simplify=T)
#  error<-sum(apply(mat,2,sum)-80)
#  seq<<-seq
   posini<-gr1Real
   posend<-gr2Real+winSize-1  

   #posini
   #posend
   #posend-posini
   #a1<-3*(gr1-1)+1
   #b1<-3*(gr2-1)+2+1+79*3
   #a1<<-3*(gr1Real-1)+1
   #b1<<-3*(gr2Real-1)+2+1+(thr-1)*3
   a1<-3*(posini-1)+1
   b1<-3*(posend-1)+3
   strs<-sapply(1:length(gr1Real), function(i){genSeq[a1[i]:b1[i]]} ,simplify=T)#
   #lapply(strs, write, "", append=TRUE, ncolumns=100)
   #write(strs[[1]], file='')
   ucoStr<<-sapply(1:length(gr1Real), function(i){uco(genSeq[a1[i]:b1[i]])} ,simplify=T)#
   ucoName<-paste('ucoStr', winSize, 'T', thr, '.txt', sep='')
   #t(ucoStr)
   #colSums(ucoStr[,1])
   #dim(ucoStr[,1]) 
   setwd(path)
   write.table(file=ucoName, x=t(ucoStr), append=T, row.names=F, col.names=F)
   #poli<-genSeq[a1[1]:b1[1]]
   #atCod<<-atCod
   #dtCod<<-dtCod
   aStr<-fsum3(ucoStr, atCod)
   dStr<-fsum3(ucoStr, dtCod)
   d_a <- dStr/aStr
   #paste(getTrans(seqStr[[1]]), collapse='')
   print( typeof(d_a))
   #cu<-sapply(1:length(gr1), function(i){ uco(genSeq[a1[i]:b1[i]])} ,simplify=F)
    if (d_a >= Ethr){
        re<-list(
      ref=ref
      #num=length(gr1),
      #posini=gr1,
      #posend=gr2,
      #sizes_w80=gr2-gr1+1,
     ,num=length(gr1Real)
     ,posini=posini
     ,posend=posend
     ,posiniN=a1
     ,posendN=b1
     ,strs=strs
     ,sizes=gr2Real+winSize-gr1Real
     ,aStr=aStr
     ,dStr=dStr
     ,d_a = d_a
   # ,seqStr=seqStr
    # ,cu=cu
      ) 
  return(re) 
    } 
#   cup<-seq[a[1]:b[1]]

}########################################

codU<-function(mat)
{
    mat<-mat
    if(!is.matrix(mat)){return(mat)}
    m<-length(mat[1,])
    s1<-(mat[,2:m]-mat[,1:m-1])>0#+1 is allowed, -1 is avoided
    s<-cbind(c(0,0),s1)#to avoid s with only 1 column->apply error
    cu<-mat[,1]+apply(s,1,sum)
    return(cu)
}

strInfo<-function(rwAsum, rwDsum, rwMatrix, genFasta, thr, winSize, atCod, dtCod, path, Ethr)
{
    ucoName<-paste('ucoStr', winSize, 'T', thr, '.txt', sep='')
    setwd(path)
    write.table(file=ucoName, x=t(c("aaa", "aac", "aag", "aat", "aca", "acc", "acg", "act", "aga", "agc", "agg", "agt", "ata", "atc", "atg", "att", "caa", "cac", "cag", "cat", "cca", "ccc", "ccg", "cct", "cga", "cgc", "cgg", "cgt", "cta", "ctc", "ctg", "ctt", "gaa", "gac", "gag", "gat", "gca", "gcc", "gcg","gct", "gga", "ggc", "ggg", "ggt", "gta" ,"gtc", "gtg" ,"gtt" ,"taa" ,"tac" ,"tag", "tat", "tca", "tcc", "tcg", "tct", "tga", "tgc", "tgg", "tgt", "tta", "ttc", "ttg", "ttt")), append=F, row.names=F, col.names=F)
  rwSInfo<-mapply(function(x,y,z,v,w){stretches(x,y,thr,winSize,z,v,w,atCod,dtCod,path, Ethr)}, rwAsum, rwDsum, rwMatrix, genFasta, (1:length(genFasta)),SIMPLIFY=F)
  return(rwSInfo)
}

write('Created.... strInfo(rwAsum, rwDsum, rwMatrix, genFasta, thr)\nOutput....rwSInfo??T??', file='')
        
rwSInfoHtml<-function(ref, rwSInfo, path, rwAsum, rwDsum, thr, winSize, genFasta, name, atCod, dtCod){
#triar els gens amb stretch
#ordenarlos de millor a pitjors
#crear un fitxer html colorejant els stretches al gen (green a(t), green d(t))
    
    #setTarget<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/miniTrial"
    #setwd(setTarget)
    #load("rwSInfo80T50.Rdata")
    #load("rwAsum80.Rdata")
    #rwSInfo<-rwSInfo80T50
    #winSize=80
    #thr=50
    #photoName='trial.jpg'
    #rwA<<-rwAsum
    #plot(unlist(rwA[1]))
    
    #rwSInfo80T50[[1]]$num
    #write(file=name, '<html><body>', append=T)
    write(file=name, paste('gene name:', names(rwSInfo)[ref], '<br>'), append=T)
    write(file=name, paste('gene ref:', rwSInfo[[ref]]$ref, '<br>'), append=T)
    write(file=name, paste('num of stretches:', rwSInfo[[ref]]$num, '<br>'), append=T)
    write(file=name, 'initial poitions (codons):', append=T)
    write(file=name, rwSInfo[[ref]]$posini, append=T)
    write(file=name, '<br>', append=T)
    write(file=name, 'final poitions (codons):', append=T)
    write(file=name, rwSInfo[[ref]]$posend, append=T)
    write(file=name, '<br>', append=T)

    #write(file=name, 'initial poitions (nuc):', append=T)
    #write(file=name, rwSInfo[[ref]]$posiniN, append=T)
    #write(file=name, '<br>', append=T)
    #write(file=name, 'final poitions (nuc):', append=T)
    #write(file=name, rwSInfo[[ref]]$posendN, append=T)
    #write(file=name, '<br>', append=T)
    #write(file=name, 'stretches:<br>', append=T)
    #lapply(strs, function(str){paste(write(str,file='',append=TRUE,ncolumns=100),'<br>')})
    #aux1<-lapply(rwSInfo[[ref]]$strs, paste, collapse='')
    #aux2<-lapply(aux1, write, file=name, append=T, sep='<br>')
    #write(file=name, rwSInfo[[ref]]$strs, append=T)
    #write(file=name, '<br>', append=T)

    write(file=name, 'stretch sizes (codons):', append=T)
    write(file=name, rwSInfo[[ref]]$sizes, append=T)
    write(file=name, '<br>', append=T)
    write(file=name, 'a(t):', append=T)
    ######################
    #####On Repair!#######
    ######################
    #SOLVED: in order to create rwSInfo as a list with each stretch recorded, it needs at least gen without stretches (I don't understant why). So to my source fasta I added the first gene >trial and the sequence ATGGTA.
    print('rwSInfo (must not be NULL):')
    print(rwSInfo[[ref]]$aStr)
    #ls()
    #load('/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/evolution/analysis/2_stretchAnalysis/results/trial2019/trial06Good/rwAsum80.Rdata')
#load('/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/evolution/analysis/2_stretchAnalysis/results/trial2019/trial06Good/rwSInfo80T67.Rdata')
#    rwAsum80#any of them are null!
#    rwSInfo80T67#BAD, more than one stretch.
#    length(rwSInfo80T67)
#    rwSInfo80T67[1]
        
    write(file=name, round(rwSInfo[[ref]]$aStr,1), append=T)
    write(file=name, ' (', append=T)
    write(file=name, round(100*rwSInfo[[ref]]$aStr/rwSInfo[[ref]]$sizes,1), append=T)
    write(file=name, ')a/c%', append=T)
    write(file=name, '<br>', append=T)
    write(file=name, 'd(t):', append=T)
    write(file=name, round(rwSInfo[[ref]]$dStr,1), append=T)
    write(file=name, ' (', append=T)
    write(file=name, round(100*rwSInfo[[ref]]$dStr/rwSInfo[[ref]]$aStr,1), append=T)
    write(file=name, ')d/a%', append=T)
    write(file=name, '<br>', append=T)
    photoName<-rwPlot(rwAsum[ref], rwDsum[ref], ref, path, thr, winSize)
    #write(file=name, paste('<img src="',photoName,'",style="width:1000px;height:300px">'), append=T)
    #write(file=name, paste('<iframe src="',photoName,'" width="300" height="300">', sep=''), append=T)#iframe is more complex
    write(file=name, paste('<embed src="runWinAnalisys/',photoName,'" width="800" height="400">', sep=''), append=T)
    #write(file=name, '</html></body>', append=T)
    write(file=name, '<br>', append=T)
    #write(file=name, '<p class="test">', append=T)
    #write(file=name, paste(getTrans(genFasta[[ref]]), collapse=''), append=T)
    #write(file=name, '</p>', append=T)
    write(file=name, '<p class="test">', append=T)
    write(file=name, paste(htmlColor(genFasta[[ref]], atCod, dtCod, rwSInfo[[ref]]$posini, rwSInfo[[ref]]$posend), collapse=''), append=T)
    write(file=name, '</p>', append=T)
   
    write(file=name, '<br><br>', append=T)

    
    
    #j<-names(rwSInfo)[1]
    #rwAsum80[[1]]       
    #rwSInfo80T50[[1]]
    return(NULL)
}

rwSInfoOrder<-function(rwAsum, rwDsum, rwMatrix, sInfo, genFasta, winSize ,thr, path, atCod, dtCod, order){
##########################copied from 
    #sInfo<-rwSInfo80T50
    #sInfo
    #library(nnet)#for which.is.max()
    #ls()
    t<-sapply(sInfo, is.null)
    #t
    if(sum(t)==length(t)){return(NULL)}
    #length(sInfo)
    #sInfo<-sInfo[!t]don't change the reference of sInfo
    #length(sInfo)
    #sapply(sInfo, '[[', 'sizes_w80')
    if (order =="S"){
        ma<<-sapply(sInfo[!t], function(x){c(which.is.max(x$sizes),max(x$sizes), x$ref)})
        rownames(ma)=c('strMaxSize', 'strSize', 'refNum')
        ma2<-ma[,order(-ma[2,])]#reorder ma in function of stretch size, descending order
    } 
    if (order =="E"){
        ma<<-sapply(sInfo[!t], function(x){c(which.is.max(x$d_a),max(x$d_a), x$ref)})
        rownames(ma)=c('strMaxEnrichment', 'Enrichment', 'refNum')
        ma2<-ma[,order(-ma[2,])]#reorder ma in function of stretch size, descending order
    }
    
    #ma2<-ma[,order(ma[2,])]#reorder ma in function of stretch size, ascending order
    #ma2['refNum',1]
    #rwAsum80[ma2['refNum',1]]
    name<-paste('rwSInfo',winSize,'T',thr, '.html', sep='')
    write(file=name, '<!DOCTYPE html><html><head><style>p.test {word-wrap: break-word;}</style></head><body>')
    if(!is.null(ncol(ma2))){
    if(ncol(ma2)>50 ){
        ma2<-ma2[,1:50]
        write(file=name, '<font color=red>Too many genes with stretches, here we show only 100</font><br>', append=T)
    }}
    write(file=name, paste('path:', path, '<br>', 'winSize:', winSize, '<br>', 'thr:', thr, '<br>'), append=T)
    write(file=name, '<br>', append=T)
    if(is.null(ncol(ma2))){
        sapply(ma2['refNum'], rwSInfoHtml,  sInfo, path, rwAsum, rwDsum, thr, winSize, genFasta, name, atCod, dtCod)
    
    }
    if(!is.null(ncol(ma2))){
        sapply(ma2['refNum', ], rwSInfoHtml,  sInfo, path, rwAsum, rwDsum, thr, winSize, genFasta, name, atCod, dtCod)
    }
    write(file=name, '</body></html>', append=T)
    #ma2['refNum', 1]
    #a<-attributes(ma)$dimnames[[2]]
    #a
    #siz<-sapply(sInfo, function(x){x$sizes_w80})
    #siz2<-unlist(siz)
    #length(siz2)
###############################
return(NULL)
}



rwPlot<-function(Asum, Dsum, ref, path, thr, winSize){
    #fileName=paste('geneCand', ref, '.jpeg', sep='')
    fileName=paste('geneCand', ref,'_',winSize,'T',thr, '.pdf', sep='')
    setwd(path)
    #jpeg(file=fileName, width=800, height=400)
    pdf(file=paste('runWinAnalisys/',fileName, sep=''), width=8, height=4)
    colo<-unlist(Asum)>thr
    plot(unlist(Asum), ylim=c(0,winSize) ,pch=16, col='orange', cex=.7, type='l', xlab='position (codons)', ylab='number of codons', main='Running Windows Analysis')
    lines(unlist(Dsum), col='red', cex=.7)
    abline(h=thr, lty=2)
    legend('topright', legend=c('a(t)', 'd(t)'), fill=c('orange', 'red')) 
    dev.off()
    return(fileName)
}

htmlColor<-function(gen, atCod, dtCod, posini, posend){
    #gene
    #gene<<-gen
    codons<-length(gen)/3
    #codons
    aa<-getTrans(gen)
    #aa
    codNum<-sapply(1:codons, function(i){match(1,uco(gen[((i-1)*3+1):(i*3)]))})
    #codNum[1]
    codCol<-sapply(1:codons, function(i) colorSelect(codNum[i], atCod, dtCod) )
    htmlCol<-sapply(1:codons, function(i) paste('<font color=', codCol[i], '>', aa[i], '</font>', sep=''))
    htmlStr<-htmlCol
    posini<-posini
    posend<-posend
    sapply(1:length(posini), function(i){ htmlStr[posini[i]]<<-paste('<u>', htmlStr[posini[i]],sep='') })
    sapply(1:length(posini), function(i){ htmlStr[posend[i]]<<-paste(htmlStr[posend[i]], '</u>', sep='') })
    #htmlStr<<-htmlStr
    #posend[1]
    #htmlStr[84]
    #match(1,cod[,1])
    return(htmlStr)
}

colorSelect<-function(codNum, atCod, dtCod){
     if(codNum%in%dtCod){return('red')}
     if(codNum%in%(setdiff(atCod, dtCod))){return('orange')}
     if(codNum%in%(setdiff((1:64), atCod))){return('black')}
     return(NULL)
     #setdiff((1:64), atCodons)
     #atCodons
 }


