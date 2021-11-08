# Read the csv
data <- read.csv("./datasets/Separated/Alcohol_Shares.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data, stringAsFactor = F)

# Transpose the data frame
df <- as.data.frame(t(df))

# Set the col names using the 1st row
colnames(df) <- df[1, ]

# Set row names equal to the 1st col
rownames(df) <- df[, 1]

# Remove the 1st row
df <- df[-1, ]

# Remove the stock symbol column
df <- df[, -1]

# Transpose the data frame
df <- as.data.frame(t(df))

# Replace NAs with 0
df[is.na(df)] <- 0


# Write to csv
write.csv(df, "./datasets/Pre_Processed/Alcohol_shares_cleaned.csv", row.names = T)