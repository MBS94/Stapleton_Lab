import random
import statistics as stat
import numpy as np
import time
import csv
# import simuPOP

Mean = 68.7463
Average_Error = 11.36

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
# heightMean = stat.mean(heightData)
heightMean = 68.7463
heightSD = np.std(heightData)

print(heightMean)

# A list of all the SNPs
SNP_List = data[0][4:]

print(len(SNP_List))

# Treatment effects
# Low_Water = 4.5267
# Lower_Nitrogen = -15.1621
# Pathogen = -.2905

Treatment_Effects = [4.5267, -15.1621, -.2905]

# Populating the dictionaries with buffs of zero
for item in SNP_List:
    SNPHeights[item] = [0, 0, 0]  # Low Water, Low Nitrogen, Pathogen
    SNPStdD[item] = [0, 0, 0]     # Low Water, Low Nitrogen, Pathogen

# Shuffle the SNPs to choose random SNPs
random.shuffle(SNP_List)
effect_SNP = SNP_List[:1000]  # Pick the first 1000 of a random shuffle

print(len(effect_SNP))

# Adding the buffs to the effected SNPs
for item in effect_SNP:
    # Low Water
    SNPHeights[item][0] = random.uniform(-.2, .2)
    SNPStdD[item][0] = random.uniform(-.001, .001)
    # Low Nitrogen
    SNPHeights[item][1] = random.uniform(-.2, .2)
    SNPStdD[item][1] = random.uniform(-.001, .001)
    # Pathogen
    SNPHeights[item][2] = random.uniform(-.2, .2)
    SNPStdD[item][2] = random.uniform(-.001, .001)

height = []
count = []
a = 1
b = 2  # len(gxeData)
# print((gxeData[0]))
bTime = time.time()
newData = [["Height", "Total Mean Var", "Total SD Var",
            "Total Low Water Mean", "Total Low Water SD",
            "Total Low Nitrogen Mean", "Total Low Nitrogen Mean SD",
            "Total Pathogen Mean", "Total Pathogen SD"]]
for i in range(a, b):
    n = i - a
    height.append(0)
    totalMean_Var = 0
    totalSD_Var = 0
    meanBuff = [0, 0, 0]
    sdBuff = [0, 0, 0]
    for j in range(len(gxeData[0])):
        if gxeData[0][j] in effect_SNP:
            if gxeData[i][j] == "A":
                meanBuff[0] += SNPHeights[gxeData[0][j]][0]
                sdBuff[0] += SNPStdD[gxeData[0][j]][0]
                meanBuff[1] += SNPHeights[gxeData[0][j]][1]
                sdBuff[1] += SNPStdD[gxeData[0][j]][1]
                meanBuff[2] += SNPHeights[gxeData[0][j]][2]
                sdBuff[2] += SNPStdD[gxeData[0][j]][2]
    for k in range(1, 4):
        if gxeData[i][k] == 1:
            totalMean_Var += meanBuff[k - 1]
            totalMean_Var += Treatment_Effects[k-1]
            totalSD_Var += sdBuff[k - 1]
    SD_New = ((Average_Error / heightMean) + totalSD_Var) \
                             * (totalMean_Var + heightMean)
    if SD_New <= 0:
        print("HELP", SD_New)

    height[n] = np.random.normal(totalMean_Var + heightMean, SD_New)
    newData.append([height[n], totalMean_Var, totalSD_Var, meanBuff[0],
                    sdBuff[0], meanBuff[1], sdBuff[1], meanBuff[2],
                    sdBuff[2]])
    if i % 100 == 0:
        print(i)
etime = time.time()
print(etime - bTime)

with open("newData.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(newData)

SNP_Data = []

for item in effect_SNP:
    x = [item, SNPHeights[item][0], SNPStdD[item][0],
         SNPHeights[item][1], SNPStdD[item][1],
         SNPHeights[item][2], SNPStdD[item][2]]
    SNP_Data.append(x)

with open("SNPData.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(SNP_Data)

print(heightMean, heightSD)
