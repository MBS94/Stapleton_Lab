import random
import statistics as stat
import numpy as np
import time
import csv
# import simuPOP

data = []
heightData = []
gxeData = []

SNPHeights = {}
SNPStdD = {}

correct_SNP_Value = "\"A\""
# Reading in the Data
with open("ManchingScrubbed.csv", 'r') as f:
    for line in f:
        data.append(line.strip().split(','))

# Removing the first two rows of the spreadsheet
gxeData.append(data[0])
for i in range(3, len(data)):
    gxeData.append(data[i])

# Changing the height and effect values to ints
for i in range(3, len(data)):
    data[i][0] = int(data[i][0])
    data[i][1] = int(data[i][1])
    data[i][2] = int(data[i][2])
    data[i][3] = int(data[i][3])

# Creating a list of just the heights
# for calculations
for i in range(1, len(gxeData)):
    heightData.append(gxeData[i][0])

# Statistics on the original data
heightMean = stat.mean(heightData)
heightSD = np.std(heightData)

# A list of all the SNPs
SNP_List = data[0][4:]

# Populating the dictionaries with buffs of zero
for item in SNP_List:
    SNPHeights[item] = [0, 0, 0] # Low Water, Low Nitrogen, Pathogen
    SNPStdD[item] = [0, 0, 0] # # Low Water, Low Nitrogen, Pathogen

# Shuffle the SNPs to choose random SNPs
random.shuffle(SNP_List)
effect_SNP = SNP_List[:1000]  # Pick the first 1000 of a random shuffle

# Adding the buffs to the effected SNPs
for item in effect_SNP:
    # Low Water
    SNPHeights[item][0] = random.uniform(-.1, .3)
    SNPStdD[item][0] = random.uniform(-.01, .01)
    # Low Nitrogen
    SNPHeights[item][1] = random.uniform(-.1, .3)
    SNPStdD[item][1] = random.uniform(-.01, .01)
    # Pathogen
    SNPHeights[item][2] = random.uniform(-.1, .3)
    SNPStdD[item][2] = random.uniform(-.01, .01)

height = []
count = []
a = 1
b = len(gxeData)
bTime = time.time()
newData = []
for i in range(a, b):
    n = i - a
    height.append(0)
    totalMean = 0
    totalSD = 0
    meanBuff = [0, 0, 0]
    sdBuff = [0, 0, 0]
    for j in range(len(gxeData[0])):
        if gxeData[0][j] in effect_SNP:
            if gxeData[i][j] == "\"A\"":
                meanBuff[0] += SNPHeights[gxeData[0][j]][0]
                sdBuff[0] += SNPStdD[gxeData[0][j]][0]
                meanBuff[1] += SNPHeights[gxeData[0][j]][1]
                sdBuff[1] += SNPStdD[gxeData[0][j]][1]
                meanBuff[2] += SNPHeights[gxeData[0][j]][1]
                sdBuff[2] += SNPStdD[gxeData[0][j]][1]
    for k in range(1, 4):
        if gxeData[i][k] == 1:
            totalMean += meanBuff[k - 1]
            totalSD += sdBuff[k - 1]

    height[n] = np.random.normal(totalMean + heightMean, totalSD + heightSD)
    # print(height[i - 1], totalMean, totalSD)
    newData.append([height[n], totalMean, totalSD, meanBuff[0],
                    sdBuff[0], meanBuff[1], sdBuff[1], meanBuff[2],
                    sdBuff[2]])
    if i % 100 == 0:
        print(i)
etime = time.time()
print(etime - bTime)

with open("newData.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(newData)