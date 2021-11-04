# Clean the workspace
rm(list = ls())

# List of required pacakges
required_pkgs <- c(
    "data.table", "ggplot2"
)

# Empty list to hold dependencies that are not isntalled
not_met_dependencies <- c()

# Check if required packages are installed
for (pkg in required_pkgs) {
    if (!(pkg %in% rownames(installed.packages()))) {
        not_met_dependencies <- c(not_met_dependencies, pkg)
    }
}

# Install missing packages
if (length(not_met_dependencies) != 0) {
    install.packages(not_met_dependencies)
}

# Load libraries
library("data.table")
library("ggplot2")

# Read the csv
data <- read.csv("./datasets/Pre_Processed/Alcohol_cleaned_converted.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data)

# Grep Ask Price
pa <- df[, grep("PA.$", colnames(df))]

# Grep Bid Price
pb <- df[, grep("PB.$", colnames(df))]

# Bind the date col with the pa,pb data
pa <- cbind(df[, 1], pa)
pb <- cbind(df[, 1], pb)

# Set the col name for the pa,pb data
colnames(pa)[1] <- "date"
colnames(pb)[1] <- "date"


# Format dates
pa_date <- as.Date(gsub("/", "-", pa$date, ), "%m-%d-%y")
pb_date <- as.Date(gsub("/", "-", pb$date, ), "%m-%d-%y")

# Remove the date column
pa <- pa[, -1]
pb <- pb[, -1]

# Calculate spread
spread <- (pa - pb) / ((pa + pb) / 2)

# Change the col name
colnames(spread) <- gsub("PA", "Spread", colnames(spread))

# Replace NAs (happen when bid and ask are 0) with 0
spread[is.na(spread)] <- 0

# Calculate the average spread
spread <- rbind(spread, colMeans(spread))

# Write to CSV
write.csv(pa, "./datasets/Processed/Bid_Ask/alcohol_pa.csv", row.names = F)
write.csv(pb, "./datasets/Processed/Bid_Ask/alcohol_pb.csv", row.names = F)
write.csv(spread, "./datasets/Processed/Bid_Ask/alcohol_spread.csv", row.names = F)