# Growth-curve-analysis
This code is meant to analyse growth curve (OD vs time) of bacteria grown in 96 well plates on a shaking plate reader - Shamoo Lab. It models growth based on the Gompertz function.
Original author is Dr. Anisha Perez) but was edited for ease of input by Prashant Kalvapalle

Brief description of it's function
1. Smoothing ODs
2. Calculating 1st,2nd and 3rd derivatives of each well (across the time series)
3. finding peaks in the derivatives (and valeys I guess?)
4. Infering the slopes of monoauxic, diauxic growth stages (might do more..)
5. Calculating growth rate and doubling time
4. Plotting cute graphs for each well in a PDF
