# Read the csv
data <- read.csv("./datasets/Raw/AVG_INT_RATE_US.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data)

# Grep treasury bonds
treasury_bonds <- df[which(df$Security.Description == "Treasury Bonds"), ]

# Extract the interest rate and the data
treasury_bonds <- treasury_bonds[, c(
    "Record.Date",
    "Average.Interest.Rate.Amount"
)]

# Write to CSV
write.csv(treasury_bonds, "./datasets/Processed/us_treasury_bond.csv", row.names = F)

# Data source
# https://fiscaldata.treasury.gov/datasets/average-interest-rates-treasury-securities/average-interest-rates-on-u-s-treasury-securities