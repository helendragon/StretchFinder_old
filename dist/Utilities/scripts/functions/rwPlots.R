rwPlotPolyP<-function(ucoStr, path){
    if(is.null(dim(ucoStr))){
        return(NULL)
    }
    setwd(path)
    pdf(file='sizePolyP.pdf', heigh=4, width=8)
    #dim(ucoStr)
    #ucoStr[,1]
    #colSums(ucoStr)
    #dim(ucoStr[,1]) 
    sizes<-rowSums(ucoStr)
    #sizes
    #ucoStr[,'ccg']/sizes
    plot(sizes, ucoStr[,'ccg']/sizes, xlab='stetch size (codons)', ylab='% CCG Pro') 
    cuts<-cut(sizes, breaks = (1:max(sizes)))
    box<-boxplot((ucoStr[,'ccg']/sizes)~cuts)
    dev.off()
    return(NULL)
}
