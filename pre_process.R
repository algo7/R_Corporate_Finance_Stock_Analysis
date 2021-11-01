# List of required pacakges
required_pkgs <- c(
    "data.table",
    "imputeTS"
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
library("imputeTS")


# Read the csv
data <- read.csv("./datasets/CBD.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data, stringAsFactor = F)

# Replace currency symbol
df[df == "U$"] <- "USD"
df[df == "A$"] <- "AUD"
df[df == "E"] <- "EUR"
df[df == "£"] <- "GBP"
df[df == "I£"] <- "ILS"
df[df == "TL"] <- "TRY"
df[df == "RI"] <- "IDR"
df[df == "K$"] <- "HKD"
df[df == "DK"] <- "DKK"
df[df == "CH"] <- "CHF"

# Exchange rate for the past 5 years (2016-2021)
# From https://www.ofx.com/en-au/forex-news/historical-exchange-rates/yearly-average-rates/
aud_to_usd <- 0.731572
eur_to_usd <- 1.153201
gbp_to_usd <- 1.313474
try_to_usd <- 0.185946
cad_to_usd <- 0.768548
idr_to_usd <- 0.000071
hkd_to_usd <- 0.128242
dkk_to_usd <- 0.154763
chf_to_usd <- 1.041509
ils_to_usd <- 0.287187

# Currency conversion function
currency_convert <- function(df) {


    # Extract stocks with non-USD currency
    aud_stocks <- which(df[1, ] == "AUD")
    eur_stocks <- which(df[1, ] == "EUR")
    gbp_stocks <- which(df[1, ] == "GBP")
    try_stocks <- which(df[1, ] == "TRY")
    cad_stocks <- which(df[1, ] == "CAD")
    idr_stocks <- which(df[1, ] == "IDR")
    hkd_stocks <- which(df[1, ] == "HKD")
    dkk_stocks <- which(df[1, ] == "DKK")
    chf_stocks <- which(df[1, ] == "CHF")
    ils_stocks <- which(df[1, ] == "ILS")

    # Remove the currency symbol
    df <- df[-1, ]

    # Convert the dataframe to numeric
    df <- sapply(df, as.numeric)

    # Convert AUD stocks
    converted_aud_stocks <- df[, aud_stocks] * aud_to_usd

    # Convert EUR stocks
    converted_eur_stocks <- df[, eur_stocks] * eur_to_usd

    # Convert GBP stocks (/1000 cuz stock prices are sterlings)
    converted_gbp_stocks <- df[, gbp_stocks] / 100 * gbp_to_usd

    # Convert TRY stocks
    converted_try_stocks <- df[, try_stocks] * try_to_usd

    # Convert CAD stocks
    converted_cad_stocks <- df[, cad_stocks] * cad_to_usd

    # Convert IDR stocks
    converted_idr_stocks <- df[, idr_stocks] * idr_to_usd

    # Convert HKD stocks
    converted_hkd_stocks <- df[, hkd_stocks] * hkd_to_usd

    # Convert HKD stocks
    converted_dkk_stocks <- df[, dkk_stocks] * dkk_to_usd

    # Convert CHF stocks
    converted_chf_stocks <- df[, chf_stocks] * chf_to_usd

    # Convert ILS stocks
    converted_ils_stocks <- df[, ils_stocks] * ils_to_usd



    df <- cbind(
        converted_aud_stocks, converted_eur_stocks, converted_gbp_stocks,
        converted_try_stocks, converted_cad_stocks, converted_idr_stocks,
        converted_hkd_stocks, converted_dkk_stocks, converted_chf_stocks,
        converted_ils_stocks
    )

    return(df)
}

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

# The dates
dates <- rownames(df)[-1]

# Non-usd stocks
non_usd_stocks <- which(df[1, ] != "USD")

if (length(non_usd_stocks) != 0) {
    # Convert currency
    converted_stocks <- currency_convert(df)

    # Remove non-usd stocks
    df <- df[, -non_usd_stocks]

    # Remove the currency column
    df <- df[-1, ]

    # Add converted stocks
    df <- cbind(converted_stocks, df)
} else {
    # Remove the currency column
    df <- df[-1, ]
}


# Convert the data frame to numeric
df <- sapply(df, as.numeric)

# Data interpolation using spline
df <- na_interpolation(df, option = "spline")

# Round numbers to 2 decimal places
df <- as.data.frame(round(df, 2), stringAsFactor = F)

# Add the dates
rownames(df) <- dates

# # Write to csv
write.csv(df, "./datasets/Processed/CBD_cleaned_converted.csv", row.names = T)