import pandas as pd
import random

import simuPOP

data = pd.read_csv("ManchingScrubbed.csv")

# print(data.head())

numSNPS = 3235

colNumList = []

for i in range(1, numSNPS + 1):
    colNumList.append(i)

random.shuffle(colNumList)