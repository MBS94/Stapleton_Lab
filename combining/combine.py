import numpy as np

import csv
results = []
with open('plant_height.csv') as csvfile:
    reader = csv.reader(csvfile) # change contents to floats
    for row in reader: # each row is a list
        results.append(row)

data = []
for item in results:
    data.append([item[1], item[2]])
del data[0]

snp = []
with open('IBM94markerset08seq.csv') as csvfile:
    reader = csv.reader(csvfile) # change contents to floats
    for row in reader: # each row is a list
        snp.append(row)

snp = np.array(snp).T.tolist()
# snp = [*zip(*snp)]
del snp[1]
del snp[1]
del snp[1]
del snp[1]

for item in data:
    MO = item[0]
    MO_num = MO[-3:]
    snpList = []
    for i in range(len(snp)):
         if MO_num == snp[i][0][-3:]:
             # item.append(snp[i])
             for j in range(len(snp[i])):
                 item.append(snp[i][j])

data.insert(0, [])
# print(data[0])
data[0].append("Marker Number")
data[0].append("Height")
data[0].append("Marker Number")

# print(snp[0])
for i in range(1, len(snp[0])):
    data[0].append(snp[0][i])

# print(data[0])

import csv

with open("output.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerows(data)
