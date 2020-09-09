#setSource<-"/mnt/lribas/users/arafels/irbPhd/4_NoAllData/codingSequences/"
#setData<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/data/"
#setFunc<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/scripts/functions/"
#setRes<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/computational/r/results/win40/"
#setDel<-"/mnt/lribas/users/arafels/irbPhd/1_projects/1_stretch/deliveries/camille/win80/"
#setwd(setFunc)
#source("fsum3.R")
#source("codSets.R")
#source("stretch.R")
#setFunc<- '/home/hcatena/Escritorio/scripts/functions'
#setFunc <- "/mnt/lribas/shared/ADAT3mutantProject/STEP2/scripts/functions/"
#setwd(setData)
#load('sInfo80T67.R')

get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}



library(seqinr)
library(nnet)


source('readFasta.R')
source('runWin.R')
source('runWinSum.R')
source('strInfo.R')
source('strRobust.R')
source('codSets.R')
source('rw.R')
source('rwEvol.R')
source('rwPlots.R')
source('stretcheslist.R')
source('BigFileSelect.R')
#setwd(setFunc)
#eval(source('strLibrary.R'))
