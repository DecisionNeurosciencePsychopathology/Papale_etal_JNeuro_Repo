# 2022-12-23 AndyP
# Explore_MEDuSA combine by id/run
# m_dir full path of directory for MEDuSA interpolated files
# /Users/andypapale/vmPFC/Explore_MEDuSA/interpolated/rt_aligned
# w_dir write directory to output concatenated data
# /Volumes/Users/Andrew/MEDuSA_data_Explore
# name_to_save - name of file to save
# 'fb-vmPFC'

load_MEDuSA_data_Explore <- function(m_dir,w_dir,name_to_save){
  
  
  library(tidyverse)
  
  # list files in the input directory that start with 'sub'
  mf <- list.files(path=m_dir,pattern='^sub',full.names=TRUE)
  # count how many files were found
  nF <- length(mf)
  # initialize an empty object to accumulate data
  md <- NULL
  # loop over each file to read and annotate with id/run
  for (iF in 1:nF){
    # current file path
    m0 <- mf[iF]
    # remove the prefix up to 'run' to extract the run number
    m1 <- sub("*.*run","",m0)
    # parse the run number from filename
    m2 <- as.integer(sub("_interpolated.csv.gz","",m1))
    # split path to get the filename components
    m3 <- str_split(m0,'/sub')
    m4 <- str_split(m3[[1]][2],'_')
    # first component of filename is the subject id
    id <- m4[[1]][1]
    # print progress message
    message(paste('file ', iF, 'out of', nF))
    # read the current csv file
    currF <- read_csv(mf[iF])
    # add run and id columns to the data frame
    currF <- currF %>% mutate(run=m2,id=id)
    # append the current data to the accumulator
    md <- rbind(md,currF)
  }
  
  # save the combined data object to an Rdata file in the output directory
  save(md,file=paste0(w_dir,'/',name_to_save,'.Rdata'))
}