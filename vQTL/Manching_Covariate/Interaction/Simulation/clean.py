import csv

datafile = open('ManchingStressData_Covar.csv', 'r')
datareader = csv.reader(datafile, delimiter=';')
data = []
for row in datareader:
    data.append(row)


for i in range(2, 5): #len(data))
    print(data[i])
