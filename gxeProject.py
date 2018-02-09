import random
import statistics as stat
import numpy as np

# import simuPOP

data = []
heightData = []
gxeData = []

SNPHeights = {}
SNPStdD = {}

correct_SNP_Value = "\"A\""

with open("ManchingScrubbed.csv", 'r') as f:
    for line in f:
        data.append(line.strip().split(','))

gxeData.append(data[0])
for i in range(3, len(data)):
    gxeData.append(data[i])

for i in range(3, len(data)):
    data[i][0] = int(data[i][0])

for i in range(1, len(gxeData)):
    heightData.append(gxeData[i][0])

heightMean = stat.mean(heightData)
heightSD = np.std(heightData)

SNP_List = data[0][4:]

# for item in SNP_List:
#     SNPHeights[item] = heightMean
#     SNPStdD[item] = heightSD

random.shuffle(SNP_List)
effect_SNP = SNP_List[:1000]



for item in effect_SNP:
    SNPHeights[item] = random.uniform(-.3, .3)
    SNPStdD[item] = random.uniform(-.01, .01)

height = []
count = []
for i in range(1, 200):
    height.append(0)
    count.append(0)
    for j in range(len(gxeData[0])):
        if gxeData[0][j] in effect_SNP:
            if gxeData[i][j] == "\"A\"":
                height[i - 1] += SNPHeights[gxeData[0][j]]
                count[i - 1] += 1

for item in height:
    print(item)

# A = gxeData[1]
# B = gxeData[11]
#
# for i in range(len(A)):
#     if A[i] != B[i]:
#         print(i, "Not Eq")