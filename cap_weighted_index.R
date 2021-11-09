# Clean workspace
rm(list = ls())

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

# Empty list to hold the number of stocks everyday
number_of_stocks <- c()

# Calculate the number of stocks everyday
for (i in seq_len(nrow(market_cap))) {
    number_of_stocks <-
        c(
            number_of_stocks,
            sum(market_cap[i, seq_len(ncol(market_cap))] != 0)
        )
}

# Bind all the data together
market_cap <- cbind(market_cap,
    # Calculate the total market cap of all the companies each day
    total_market_cap = rowSums(market_cap),
    number_of_stocks = number_of_stocks
)


# Create the divisor and index column
market_cap <- cbind(
    market_cap,
    divisor = 0,
    index = 0
)

# Calculate the initial divisor
market_cap$divisor[1] <-
    market_cap$total_market_cap[1] / 10000

# Calculate the initial index
market_cap$index[1] <-
    market_cap$total_market_cap[1] / market_cap$divisor[1]

# Calculate the divisor for each day later on
for (i in seq_len(nrow(market_cap))) {
    # Don't calculate the divisor for the first day (already calculated)
    if (i != 1) {
        # If the number of stocks changes
        if (market_cap$number_of_stocks[i] !=
            market_cap$number_of_stocks[i - 1]) {
            # Recalculate the divisor
            market_cap$divisor[i] <- market_cap$total_market_cap[i] / 10000
        } else {
            # Otherwise keep the previous divisor
            market_cap$divisor[i] <- market_cap$divisor[i - 1]
        }
    }
}





write.csv(market_cap, "./datasets/mkt_cap.csv")