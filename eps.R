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
data <- read.csv("./datasets/Casino_cleaned.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data)

# Grep EPS
eps <- df[, grep("(EPS)", colnames(df))]

# Bind the data col with the eps data
eps <- cbind(df[, 1], eps)

# Set the col name for the data
colnames(eps)[1] <- "date"

# Remove NAs
# eps <- na.omit(eps)

# Replace NAs with 0
eps[is.na(eps)] <- 0

# Format dates
eps_date <- as.Date(gsub("/", "-", eps$date, ), "%m-%d-%y")

# Remove the date column
eps <- eps[, -1]

# Colors to use
# line_colors <- rainbow(ncol(eps))

# Create base chart
chart <- ggplot(eps, aes(x = eps_date)) +
    ggtitle("EPS Trend") +
    theme(plot.title = element_text(size = 20, face = "bold", hjust = 0.5)) +
    xlab("Date") +
    ylab("Dollars")


# Add the data of each stock to the based chart
for (i in seq_len(ncol(eps))) {
    chart <- chart +
        geom_line(aes_(
            y = eps[, i],
            group = colnames(eps)[i],
            color = colnames(eps)[i],
        ))
}

print(chart)


# Write to CSV
write.csv(eps, "./datasets/eps.csv", row.names = F)