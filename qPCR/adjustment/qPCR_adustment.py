__title__ = 'qPCR Adjustment'
__author__ = 'Michael Byrd'

import numpy as np
import random, math
import pandas as pd

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

    data = np.genfromtxt("Neill2018calibrations.csv", dtype=float, delimiter=',', names=True)


    # amount_gblock+ire
    x = []
    y = []
    for i in range(len(data)):
        x.append(data[i][5])
        y.append(data[i][3])

    # all_productsCp1
    x = np.array(x)

    # test1_Cp1
    y = np.array(y)

    print(Neill2018_Data_UnifromAdju(x, y))

    Neill2018_Data_BlockAdju(x,y)

    # 50_50gblocks
    print('\n' + "50/50")

    x = []
    y = []
    for i in range(len(data)):
        x.append(data[i][15])
        y.append(data[i][14])

    # allproductsCp1_50_50
    x = np.array(x)

    # test1Cp150_50
    y = np.array(y)

    print(Neill2018_Data_UnifromAdju(x, y))

    Neill2018_Data_BlockAdju(x,y)


# Neill2018_Data()

def RNA_6_8_18():
    # data = np.genfromtxt("Stapleton_RNA_6.8.18_labels_cpValues.csv", dtype=float, delimiter=',', names=True)

    df = pd.read_csv("Stapleton_RNA_6.8.18_labels_cpValues.csv", sep=',')

    print(df.head())

    test_data_Dict = dict()
    allP_data_Dict = dict()

    for index, row in df.iterrows():
        label = row['Sample']
        s_quantity = row['Starting Quantity for Std']
        cpD1 = row['cpD1']

        # if label in data_Dict:
        #     data_Dict[label].append(cpD1)
        # else:
        #     data_Dict[label] = [cpD1]


        if row['reaction_type'] == "Test1":
            if label in test_data_Dict:
                if s_quantity in test_data_Dict[label]:
                    test_data_Dict[label][s_quantity].append(cpD1)
                else:
                    test_data_Dict[label][s_quantity] = [cpD1]
            else:
                test_data_Dict[label] = {s_quantity : [cpD1]}
        elif row['reaction_type'] == "all_products":
            if label in allP_data_Dict:
                if s_quantity in allP_data_Dict[label]:
                    allP_data_Dict[label][s_quantity].append(cpD1)
                else:
                    allP_data_Dict[label][s_quantity] = [cpD1]
            else:
                allP_data_Dict[label] = {s_quantity : [cpD1]}

    print(allP_data_Dict['gblock+IRE_plus18IRE'])
    print(test_data_Dict['gblock+IRE_plus18IRE'])


        # print(row['Sample'])



RNA_6_8_18()
