# Author Dr. Anisha Perez (?)(Shamoo Lab at Rice University)
# edited by Prashant (Shamoo Lab at Rice University)
# (version 1.3g-120411) <- obsolete number

library(lattice)
library(reshape2)
library(readxl)


get_seconds<- function(time){ # convert time data from hh:mm:ss to seconds
  sec <- as.numeric(format(time, "%H")) * 3600 + as.numeric(format(time, "%M"))*60 + as.numeric(format(time, "%S"))
}

# get_seconds <- function(x) { # requires library(lubridate) ; replaced above
#   second(x) + minute(x)*60 + hour(x)*3600
# }

minutesAndSeconds <- function(seconds) {
  return(c(seconds%/%60, seconds%%60))
}

avgSmooth <- function(opticalDensities, windowSize, log=T) {
  if (length(opticalDensities) <= 1) {
    return(0)
  }
  
  if (log) {
    opticalDensities = log(opticalDensities)
  }
  offset = (windowSize-1)/2
  expandedODs = c(rep(opticalDensities[1], offset), opticalDensities, rep(opticalDensities[length(opticalDensities)], offset))
  
  rates = NULL
  for (t in (1:length(opticalDensities))+offset) {
    mean = mean(expandedODs[(t-offset):(t+offset)])
    rates = c(rates, mean)
    # message(coef(m)[2])
  }
  
  return(rates)
}

# calculate derivative of parameter 'opticalDensities' using symmetrical window around data points
ratesInterval <- function(opticalDensities, times, windowSize, log=T) {
  if (length(opticalDensities) <= 1) {
    return(0)
  }
  
  if (log) {
    opticalDensities = log(opticalDensities)
  }
  offset = (windowSize-1)/2
  expandedODs = c(rep(opticalDensities[1], offset), opticalDensities, rep(opticalDensities[length(opticalDensities)], offset))
  
  deltaTime = times[2]-times[1]
  expandedTimes = c(seq(times[1]-deltaTime, times[1]-offset*deltaTime, -deltaTime), times, seq(times[length(times)]+deltaTime, times[length(times)]+offset*deltaTime, deltaTime))
  
  rates = NULL
  for (t in (1:length(opticalDensities))+offset) {
    m = lm(expandedODs[(t-offset):(t+offset)] ~ expandedTimes[(t-offset):(t+offset)])
    rates = c(rates, coef(m)[2])
    # message(coef(m)[2])
  }
  
  return(rates)
}

# calculate derivative of parameter 'opticalDensities' using 'windowLeft' and 'windowRight' points around data points
ratesOffsets <- function(opticalDensities, times, windowLeft, windowRight, log=T) {
  if (length(opticalDensities) <= 1) {
    return(0)
  }
  
  if (log) {
    opticalDensities = log(opticalDensities)
  }
  # message(offset)
  expandedODs = c(rep(opticalDensities[1],windowLeft), opticalDensities, rep(opticalDensities[length(opticalDensities)],windowRight))
  # print(expandedODs)
  
  deltaTime = times[2]-times[1]
  expandedTimes = c(seq(times[1]-deltaTime,times[1]-windowLeft*deltaTime,-deltaTime), times, seq(times[length(times)]+deltaTime,times[length(times)]+windowRight*deltaTime,deltaTime))
  
  slopes = NULL
  for (i in (1:length(opticalDensities))+windowLeft) {
    # message(i)
    m = lm(expandedODs[(i-windowLeft):(i+windowRight)] ~ expandedTimes[(i-windowLeft):(i+windowRight)])
    slopes = c(slopes, coef(m)[2])
  }
  
  return(slopes)
}


normalize <- function(x) {
  return((x-min(x))/(max(x)-min(x)) + (min(x)/(max(x)-min(x))))
}


isTwoResourceWell <- function(oneResourceWells, twoResourceWells, well) {
  if (twoResourceWells[1] == "ALL") {
    return(TRUE)
  }
  
  if (well %in% twoResourceWells) {
    return(TRUE)
  }
  
  rowCol = substring(well,1:2,c(1,3))
  if (rowCol[1] %in% twoResourceWells) {
    return(TRUE)
  }
  if (rowCol[2] %in% twoResourceWells) {
    return(TRUE)
  }
  
  if (length(oneResourceWells) != 0) {
    if (well %in% oneResourceWells) {
      return(FALSE)
    }
    
    rowCol = substring(well,1:2,c(1,3))
    if (rowCol[1] %in% oneResourceWells) {
      return(FALSE)
    }
    if (rowCol[2] %in% oneResourceWells) {
      return(FALSE)
    }
    
    return(TRUE)
  }
  
  return(FALSE)
}

rankPeaks <- function(od, rate, rate1, rate2) {
  return(1.5*od + (8*rate)^3 + 32*(1-abs(rate1)) - 4*rate2)
}


rankValley <- function(time, od, rate, rate1, rate2) {
  weightTime = 2
  weightRate = 2
  weightRate1 = 10
  weightRate2 = 7
  
  od1 = min(od) + (max(od) - min(od)) * 0.15
  od2 = min(od) + (max(od) - min(od)) * 0.75
  time1Index = which(od>od1)[1]
  time4Index = which(od>od2)[1]
  time1 = time[time1Index]
  time4 = time[time4Index]
  time2 = time1+(time4-time1)*0.2
  time3 = time1+(time4-time1)*0.5
  
  return(weightTime*sapply(time, rankValleyTime, time1, time2, time3, time4, max(time)) + weightRate*sapply(rate, rankValleyRate) + weightRate1*(1-abs(rate1)) + weightRate2*rate2)
}

rankValleyTime <- function(t, time1, time2, time3, time4, maxT) {
  if (t < time1 || t >= time4) {
    return(-0.4 - 1.2*t/maxT)
  }
  if (t < time2) {
    return((t-time1)/(time2-time1)-0.4 - 1.2*t/maxT)
  }
  if (t < time3) {
    return(0.6 - 1.2*t/maxT)
  }
  if (t < time4) {
    return(0.6-(t-time3)/(time4-time3) - 1.2*t/maxT)
  }
}

rankValleyRate <- function(x) {
  if (x >= 0) {
    return(1-(abs(x))^2)
  } else {
    return(1-6*(abs(x))^2)
  }
}





####### following 2 functions specific for transforming "08202009-2.txt" data set from Selwyn #######

# threeCharWell <- function(wellName) {
#   if (nchar(wellName) == 2) {
#     return(paste(substr(wellName,1,1), substr(wellName,2,2), sep="0"))
#   } else {
#     return(wellName)
#   }
# }
# createMissingWell <- function(well, times, od) {
#   tmp = NULL
#   for (t in times) {
#     tmp = rbind(tmp, data.frame(Time=t, OD=od, Well=well))
#   }
#   return(tmp)
# }





