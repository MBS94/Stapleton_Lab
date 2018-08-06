<!--- pandoc qPCR_adj.md -f markdown -t html -s -o qPCR_adj.html --->


# qPCR Adjustment Analysis on Neill Data

</br>

###Original Data Sets
Training: Neill2018calibrations.xlsx  
Expieremental: corrected17June_Neill Thesis RNA samples.xlsx


## Process

- The data is separated into two output columns, test_1 and all_products. We want to adjust the values of the test_1 output to make it comparable to the all_product output.

- The calibrated (training) data is grouped into sets of three with varying inputs in powers of 10.

- We will preform U-Statistics on these groups for the test_1 and all_prod columns. This process will give us the difference in expectation values, this will be served as our adjustment value.

- We then create a linear model that will map test_1 values to an adjustment value that we can then add to test_1 to make it comparable to all_products

- To increase the linear models accuracy, we will map the ratio of all_products over test_1 to the square of the adjustment values

- We then use this linear model as a 'look-up table' to find the correct adjustment values for test_1 in the expieremental data set with unknown inputs. This unknown input is what prevents any grouping thus requiring the linear model.

The R script for this process can be found on Github at the following [link](https://github.com/michael-byrd/Stapleton_Lab/blob/development/qPCR/adjustment/Neill_qPCR_Adjustment.R).
