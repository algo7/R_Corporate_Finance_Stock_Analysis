# Clear workspace
rm(list = ls())

# Read the csvs of the shares
alcohol_shares <-
    read.csv("./datasets/Pre_Processed/Alcohol_shares_cleaned.csv", header = T)
casino_shares <-
    read.csv("./datasets/Pre_Processed/Casino_shares_cleaned.csv", header = T)
tabac_shares <-
    read.csv("./datasets/Pre_Processed/Tabac_shares_cleaned.csv", header = T)
arms_shares <-
    read.csv("./datasets/Pre_Processed/Arms_shares_cleaned.csv", header = T)

# Read the csvs for the prices
alcohol_price <-
    read.csv("./datasets/Processed/Price/alcohol_price.csv", header = T)
casino_prices <-
    read.csv("./datasets/Processed/Price/casino_price.csv", header = T)
tabac_prices <-
    read.csv("./datasets/Processed/Price/tabac_price.csv", header = T)
arms_prices <-
    read.csv("./datasets/Processed/Price/arms_price.csv", header = T)



# Convert csvs to a data frame
alcohol_shares <- as.data.frame(alcohol_shares, stringAsFactor = F)
casino_shares <- as.data.frame(casino_shares, stringAsFactor = F)
tabac_shares <- as.data.frame(tabac_shares, stringAsFactor = F)
arms_shares <- as.data.frame(arms_shares, stringAsFactor = F)

# Remove date columns for shares data except for the alcohol shares
# which will be used as the first data frame in cbind
casino_shares <- casino_shares[, -1]
tabac_shares <- tabac_shares[, -1]
arms_shares <- arms_shares[, -1]


# Convert csvs to a data frame
alcohol_price <- as.data.frame(alcohol_price, stringAsFactor = F)
casino_price <- as.data.frame(casino_prices, stringAsFactor = F)
tabac_price <- as.data.frame(tabac_prices, stringAsFactor = F)
arms_price <- as.data.frame(arms_prices, stringAsFactor = F)


# Merge all shares
merged_shares <- cbind(alcohol_shares, casino_shares, tabac_shares, arms_shares)

# Merge all prices
merged_price <- cbind(alcohol_price, casino_price, tabac_price, arms_price)

# Get the duplicate column name
id_dup_shares <- which(duplicated(names(merged_shares)))
id_dup_price <- which(duplicated(names(merged_price)))

merged_shares <- merged_shares[, -id_dup_shares]
merged_price <- merged_price[, -id_dup_price]


write.csv(merged_shares, "./datasets/Pre_Processed/sin_stocks_merged_shares.csv", row.names = F)
write.csv(merged_price, "./datasets/Pre_Processed/sin_stocks_merged_price.csv", row.names = F)