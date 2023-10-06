# -*- coding: utf-8 -*-
"""
Created on Fri Oct  6 08:50:27 2023

@author: duckm
"""
#A python equivelant to the matlab climchg.m program
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

plt.rcParams['figure.dpi'] = 300

def climchg(vTemp, vTime, sIndex, *args):
    if sIndex == 'slope to target':
        # Extract the target date from the arguments
        dTarget = args[0]
        # Find the index of the target date in vTime
        iElNum = np.argmin(np.abs(vTime - dTarget))
        # Cut the data up to the target date
        vTiCut = vTime[:iElNum + 1]
        vTempCut = vTemp[:iElNum + 1]

        # Initialize arrays to store results
        vStartTime = np.zeros(len(vTiCut) - 4)
        vSlope = np.zeros(len(vTiCut) - 4)
        vUB = np.zeros(len(vTiCut) - 4)
        vLB = np.zeros(len(vTiCut) - 4)

        # Loop to calculate slope for each interval
        for i in range(len(vTiCut) - 4):
            xData = vTiCut[i:]
            yData = vTempCut[i:]
            
            # Define a linear function
            def linear_func(x, a, b):
                return a * x + b
            
            # Fit the data to the linear function
            popt, _ = curve_fit(linear_func, xData, yData)
            vStartTime[i] = vTiCut[i]
            vSlope[i] = popt[0] * 10
            vLB[i] = popt[0] * 10 - 1.96 * np.std(yData) / np.sqrt(len(yData))
            vUB[i] = popt[0] * 10 + 1.96 * np.std(yData) / np.sqrt(len(yData))

        # Plot the results
        plt.plot(vStartTime, vSlope, 'blue')
        plt.plot(vStartTime, vUB, 'red')
        plt.plot(vStartTime, vLB, 'red')
        plt.xlabel('Date', fontsize=10)
        sTitle = f'slope to target, {dTarget:.0f}'
        plt.title(sTitle)
        dIfVariable = vTime[1] - vTime[0]
        if dIfVariable == 1:
            sYLabel = f'Slope from date to {dTarget:.0f} (C° per decade)\n annual data'
        else:
            sYLabel = f'Slope from date to {dTarget:.0f} (C° per decade)\n monthly data'
        plt.ylabel(sYLabel, fontsize=10)
        
        # Return the results
        return vStartTime, vSlope, vUB, vLB

    elif sIndex == 'slope of interval':
        # Extract the interval size from the arguments
        dInterval = args[0]

        # Adjust interval based on data frequency (monthly or yearly)
        if vTime[1] - vTime[0] > 0.9:
            iWin = int(dInterval)
        else:
            iWin = int(dInterval * 12)

        # Initialize arrays to store results
        vSlope = np.zeros(len(vTime) - iWin + 1)
        vUB = np.zeros(len(vTime) - iWin + 1)
        vLB = np.zeros(len(vTime) - iWin + 1)
        vEndTime = np.zeros(len(vTime) - iWin + 1)
        vEndCell = np.zeros(len(vTime) - iWin + 1)

        # Loop to calculate slope for each interval
        for i in range(len(vTime) - iWin + 1):
            vTiCut = vTime[i:i + iWin]
            vTempCut = vTemp[i:i + iWin]

            # Define a linear function
            def linear_func(x, a, b):
                return a * x + b
            
            # Fit the data to the linear function
            popt, _ = curve_fit(linear_func, vTiCut, vTempCut)
            vSlope[i] = popt[0] * 10
            vLB[i] = popt[0] * 10 - 1.96 * np.std(vTempCut) / np.sqrt(len(vTempCut))
            vUB[i] = popt[0] * 10 + 1.96 * np.std(vTempCut) / np.sqrt(len(vTempCut))
            vEndCell[i] = iWin + i - 1
            vEndTime[i] = vTime[int(vEndCell[i])]

        # Plot the results
        plt.plot(vEndTime, vSlope, 'blue')
        plt.plot(vEndTime, vUB, 'red')
        plt.plot(vEndTime, vLB, 'red')
        plt.xlabel('Date', fontsize=10)
        sTitle = f'slope of interval size {dInterval:.0f}'
        plt.title(sTitle)
        dIfVariable = vTime[1] - vTime[0]
        if dIfVariable == 1:
            sYLabel = f'Slope of interval size {dInterval:.0f}, C° per decade\n (yearly data)'
        else:
            sYLabel = f'Slope of interval size {dInterval:.0f}, C° per decade\n (monthly data)'
        plt.ylabel(sYLabel, fontsize=10)

        # Return the results
        return vEndTime, vSlope, vUB, vLB

    elif sIndex == 'trend since 1970':
        # Find the index corresponding to 1970
        dElNum = np.argmin(np.abs(vTime - 1970))
        # Cut the data from 1970 to the end
        vTiCut = vTime[dElNum:]
        vTempCut = vTemp[dElNum:]

        # Define a linear function
        def linear_func(x, a, b):
            return a * x + b
        
        # Fit the data to the linear function
        popt, _ = curve_fit(linear_func, vTiCut, vTempCut)

        # Plot the data and fitted line
        plt.plot(vTiCut, vTempCut, 'b.')
        plt.plot(vTiCut, linear_func(vTiCut, *popt), 'r-')
        plt.xlabel('Date', fontsize=10)
        plt.title('Trend Since 1970')
        dIfVariable = vTime[1] - vTime[0]
        if dIfVariable == 1:
            sYLabel = 'Average Annual Temperature'
        else:
            sYLabel = 'Average Monthly Temperature'
        plt.ylabel(sYLabel, fontsize=10)

        # Extract the fitting parameters
        dSlope = popt[0] * 10
        dIntercept = popt[1]
        vUB = 1.96 * np.std(vTempCut) / np.sqrt(len(vTempCut))
        vLB = -vUB
        
        # Return the results
        return dIntercept, dSlope, vUB, vLB

    else:
        raise ValueError('Invalid sIndex value. Try one of the following: "slope to target", "slope of interval", "trend since 1970"')
