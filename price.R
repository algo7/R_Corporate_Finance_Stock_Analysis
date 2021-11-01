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
data <- read.csv("./datasets/Pre_Processed/Tabac_cleaned_converted.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data)

# Grep price
price <- df[, grep("(P)", colnames(df))]

# Bind the data col with the price data
price <- cbind(df[, 1], price)

# Set the col name for the data
colnames(price)[1] <- "date"

# Format dates
price_date <- as.Date(gsub("/", "-", price$date, ), "%m-%d-%y")

# Remove the date column
price <- price[, -1]

# Colors to use
# line_colors <- rainbow(ncol(price))

# PDF settings
pdf("./datasets/Processed/tabac_price.pdf", width = 12, height = 8, compress = T)


# Create base chart
chart <- ggplot(price, aes(x = price_date)) +
    ggtitle("Price Trend") +
    theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
    ) +
    xlab("Date") +
    ylab("Dollars") +
    ylim(0, max(price) * 1.1)



# Add the data of each stock to the based chart
for (i in seq_len(ncol(price))) {
    chart <- chart +
        geom_line(aes_(
            y = price[, i],
            group = colnames(price)[i],
            color = colnames(price)[i],
        ))
}

# Change legend box title
chart$labels$colour <- "Stocks"

# Print the chart
print(chart)
dev.off()


# Write to CSV
write.csv(price, "./datasets/Processed/tabac_price.csv", row.names = F)