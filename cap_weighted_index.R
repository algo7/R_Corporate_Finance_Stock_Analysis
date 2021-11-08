# Read the csv
data <- read.csv("./datasets/Pre_Processed/CBD_shares_cleaned.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data, stringAsFactor = F)