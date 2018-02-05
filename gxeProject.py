import random

# import simuPOP

data = []

with open("ManchingScrubbed.csv", 'r') as f:
    for line in f:
        data.append(line.strip().split(','))

for i in range(3, len(data)):
    data[i][0] = int(data[i][0])

SNP_List = data[0][4:]

random.shuffle(SNP_List)
effect_SNP = SNP_List[:1000]

correct_SNP_Value = "\"A\""

i = 1

for i in range(len(data)):
    for j in range(len(data[0])):
        # print(data[i][j])
        if data[i][j] == correct_SNP_Value:# and data[0][j] in effect_SNP:
            print("Yes")

# for i in range(10):
#     print(data[i])
