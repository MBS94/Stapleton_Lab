__title__ = 'qPCR Adjustment'
__author__ = 'Michael Byrd'

import numpy as np
import random, math

def qPCR_Adusjutment(xVec, yVec):
    return np.mean(np.subtract.outer(xVec, yVec))


def qPCR_Simulation(n):
    alpha = None
    beta = random.randint(-5, 5)


    # Create Vectors
    # arr = np.empty((0,2*n), int)
    x = np.empty([2*n, 1])
    y = np.empty([2*n, 1])

    # Populate Vectors
    for i in range(-n, n+1):
        print(math.pow(10, i))
        xVal = 1 + beta * math.pow(10, i) + np.random.normal(0, 1)
        yVal = 2 + beta * math.pow(10, i) + np.random.normal(0, 1)

        np.put(x, [i+n-1], [xVal])
        np.put(y, [i+n-1], [yVal])

    return qPCR_Adusjutment(x,y)

def Neill2018_Data_UnifromAdju(xInput, yInput):
    return qPCR_Adusjutment(xInput, yInput)

def Neill2018_Data_BlockAdju(xInput, yInput):
    for i in range(0, 5):
        temp_x = np.array([xInput[i], xInput[i + 1], xInput[i + 2]])
        temp_y = np.array([yInput[i], yInput[i + 1], yInput[i + 2]])
        print(math.pow(10,2-i) , "Adjustment:", qPCR_Adusjutment(temp_x, temp_y))

def Neill2018_Data():
    x = [18.73, 18.94, 18.88, 22.39, 22.43, 22.35, 25.44,
     25.52, 25.53, 28.34, 28.44, 28.32, 31.18, 31.18, 31.13]
    y = [17.74, 17.7, 17.72, 21.4, 21.57, 21.28, 24.86,
     24.85, 24.7, 28.08, 28.09, 28, 30.98, 30.95, 30.97]
    xA, xB, xC = [], [], []
    yA, yB, yC = [], [], []

    # amount_gblock+ire

    # all_productsCp1
    x = np.array([18.73, 18.94, 18.88,
     22.39, 22.43, 22.35, 25.44, 25.52,
      25.53, 28.34, 28.44, 28.32, 31.18, 31.18, 31.13])

    # test1_Cp1
    y = np.array([17.74, 17.7, 17.72, 21.4,
     21.57, 21.28, 24.86, 24.85, 24.7,
      28.08, 28.09, 28, 30.98, 30.95, 30.97])

    print(Neill2018_Data_UnifromAdju(x, y))

    Neill2018_Data_BlockAdju(x,y)

    # 50_50gblocks
    print('\n' + "50/50")
    # allproductsCp1_50_50
    x = np.array([17.9, 18.03, 17.93, 21.46, 21.51,
     21.6, 24.68, 24.66, 24.79, 27.62, 27.54, 27.62,
      30.14, 30.18, 30.13])

    # test1Cp150_50
    y = np.array([16.46, 16.42, 16.32, 19.95, 20.01,
     19.85, 23.46, 23.51, 23.42, 26.61, 26.65, 26.53,
      29.6, 29.61, 29.44])

    print(Neill2018_Data_UnifromAdju(x, y))

    Neill2018_Data_BlockAdju(x,y)


Neill2018_Data()
