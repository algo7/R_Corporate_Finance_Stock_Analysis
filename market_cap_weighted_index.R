# Clean workspace
rm(list = ls())

# List of required pacakges
required_pkgs <- c(
    "ggplot2"
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
library("ggplot2")

# Read the csvs
shares <- read.csv(
    "./datasets/Pre_Processed/sin_stocks_merged_shares.csv",
    header = T
)
price <- read.csv(
    "./datasets/Pre_Processed/sin_stocks_merged_price.csv",
    header = T
)

# Read the csvs
shares_cbd <- read.csv(
    "./datasets/Pre_Processed/CBD_shares_cleaned.csv",
    header = T
)
price_cbd <- read.csv(
    "./datasets/Processed/Price/cbd_price.csv",
    header = T
)

# Convert them to a data frame
df_shares <- as.data.frame(shares, stringAsFactor = F)
df_price <- as.data.frame(price, stringAsFactor = F)

# Convert them to a data frame
df_shares_cbd <- as.data.frame(shares_cbd, stringAsFactor = F)
df_price_cbd <- as.data.frame(price_cbd, stringAsFactor = F)


# Set row names of the shares data using the date column
rownames(df_shares) <- df_shares[, 1]
rownames(df_shares_cbd) <- df_shares_cbd[, 1]

# Remove the date column from the shares data
df_shares <- df_shares[, -1]
df_shares_cbd <- df_shares_cbd[, -1]

# Function used to calculate the market caps
cal_market_cap <- function(price, shares) {
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
    market_cap$index <- market_cap$total_market_cap / market_cap$divisor

    # Calculate the divisor for each day later on
    # Source: https://www.spglobal.com/spdji/en/documents/methodologies/methodology-index-math.pdf
    for (i in seq_len(nrow(market_cap))) {
        # Don't calculate the divisor for the first day (already calculated)
        if (i != 1) {
            # If the number of stocks changes
            if (market_cap$number_of_stocks[i] !=
                market_cap$number_of_stocks[i - 1]) {
                # Recalculate the divisor (the divisor is now
                # base on the previous index)
                # index t == index t-1
                market_cap$divisor[i] <-
                    market_cap$total_market_cap[i] / market_cap$index[i - 1]

                # Recalculate the index
                market_cap$index[i] <-
                    market_cap$total_market_cap[i] / market_cap$divisor[i]
            } else {
                # Otherwise keep the previous divisor
                market_cap$divisor[i] <- market_cap$divisor[i - 1]
                market_cap$index[i] <-
                    market_cap$total_market_cap[i] / market_cap$divisor[i - 1]
            }
        }
    }

    return(market_cap)
}

market_cap <- cal_market_cap(df_price, df_shares)
market_cap_cbd <- cal_market_cap(df_price_cbd, df_shares_cbd)


# Format dates
date <- as.Date(gsub("/", "-", rownames(df_shares), ), "%m-%d-%y")


# PDF settings
pdf("./datasets/Processed/Index/combined.pdf",
    width = 12,
    height = 8,
    compress = T
)


# Create base chart
chart <- ggplot(market_cap, aes(x = date)) +
    ggtitle("Combined") +
    theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
    ) +
    xlab("Date") +
    ylab("Index Level") +
    ylim(0, max(market_cap$index) * 1.1) +
    geom_line(aes_(
        y = market_cap$index,
        group = "61 Sins",
        color = "61 Sins",
    )) +
    geom_line(aes_(
        y = market_cap_cbd$index,
        group = "Tripping 25",
        color = "Tripping 25",
    ))

# Change legend box title
chart$labels$colour <- "Index"

# Print the chart
print(chart)
dev.off()


write.csv(cbind(market_cap, market_cap_cbd), "./datasets/Processed/Index/combined.csv", row.names = F)