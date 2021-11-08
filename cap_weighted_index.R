# Read the csvs
shares <- read.csv(
    "./datasets/Pre_Processed/CBD_shares_cleaned.csv",
    header = T
)
price <- read.csv("./datasets/Processed/Price/cbd_price.csv", header = T)

# Convert them to a data frame
shares <- as.data.frame(shares, stringAsFactor = F)
price <- as.data.frame(price, stringAsFactor = F)

# Set row names of the shares data using the date column
rownames(shares) <- shares[, 1]

# Remove the date column from the shares data
shares <- shares[, -1]

# Calculate market cap for each company of each day
market_cap <- price * shares

# Calculate the total market cap of all the companies each day
market_cap <- cbind(market_cap, totalMarketCap = rowSums(market_cap))

# Calculate the number of companies at each day
number_of_stocks <- sum(market_cap[1, seq_len(ncol(market_cap)) - 1] != 0)


write.csv(market_cap, "./datasets/mkt_cap.csv")