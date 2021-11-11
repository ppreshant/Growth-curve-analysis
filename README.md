# Growth-curve-analysis
This code is meant to analyse growth curve (OD vs time) of bacteria grown in 96 well plates on a shaking plate reader - Shamoo Lab. It models growth based on the Gompertz function.
Original author is from Friesen et. al. 2004) but was edited for ease of input by Prashant Kalvapalle

Brief description of it's function
1. Smoothing ODs
2. Calculating 1st,2nd and 3rd derivatives of each well (across the time series)
3. finding peaks in the derivatives (and valeys I guess?)
4. Infering the slopes of monoauxic, diauxic growth stages (might do more..)
5. Calculating growth rate (doubling time) and lag phase duration
4. Plotting cute graphs for each well on different facets in the same page in a PDF

**Source:** _Friesen, Maren L., et al. "Experimental evidence for sympatric ecological diversification due to frequency‐dependent competition in Escherichia coli." Evolution 58.2 (2004): 245-260._

# **Data analysis section of the paper**
_The following excerpt is copied over from the original paper describing the method used to make growth curves_

>To estimate growth curve parameters for each colony, the
parameters of growth curves from _each replicate well_ are
estimated and the _mean of the three or more replicates taken_.
Each growth curve is first normalized by subtracting the average of the control wells at each time point. The data are
`ln-transformed`, then a line of maximum slope is fit through
the first phase of growth. The maximum slope is defined to
be the maximum of the slopes of lines fit to a moving window
of `10 datapoints`. The first lag is the time between the start
of the run and the time at which the first line of exponential
growth has a value of `25.0`. This assumes that all wells are
inoculated with the same biomass and is done because the
BioScreen measurements are imprecise at low optical densities. This is in accordance with the common definition of
lag as the time period until exponential growth is detected
_(Dalgaard and Koutsoumanis 2001)_. Differences in initial
inoculum size could significantly affect estimates of lag time,
hence the lag measurements may be inaccurate and are treated
accordingly. The switching point is the point at which the
data is more than `0.1 units` away from the line of exponential
growth. This deviation corresponds to roughly `2.5%` of the
total growth curve and was chosen because the resulting
switching point corresponds visually to where switching occurs from the first phase to the second phase of growth. The
switching optical density is the optical density at the switching point. We believe that the switching point corresponds
to the point at which glucose is exhausted from the medium,
because E. coli are known to use glucose preferentially _(Saier
et al. 1996)_. The second maximum growth rate is estimated
in the same manner as the first, by taking the maximum of
the slopes after the switching point. The switching lag is the
length of time between the switching point and the point on
the second line of exponential growth where the optical density is equal to the switching optical density.
