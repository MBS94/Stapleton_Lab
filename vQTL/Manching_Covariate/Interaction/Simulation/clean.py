import csv

data = list(csv.reader(open('simulated_data_10_highcoeff.csv')))

for i in range(3, len(data)):
    for j in range(4, len(data[0])):
        if data[i][j] == '0':
            data[i][j] = 'A'
        else:
            data[i][j] = 'B'

for i in range(50):
    print(data[i])

with open("simulated_cross_10_coeff.csv","w+") as my_csv:
    csvWriter = csv.writer(my_csv,delimiter=',')
    csvWriter.writerows(data)
