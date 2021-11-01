# List of required pacakges
required_pkgs <- c(
    "data.table"
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


# Read the csv
data <- read.csv("./datasets/Casino.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data)

# Replace currency symbol
df[df == "U$"] <- "USD"

# Transpose the data frame
df <- as.data.frame(t(df), )

# Set the col names using the 1st row
colnames(df) <- df[1, ]

# Set row names equal to the 1st col
rownames(df) <- df[, 1]

# Remove the 1st row
df <- df[-1, ]

# Remove the currency column and the symbol column
df <- df[, -1:-2]

# Transpose the dataframe
df <- as.data.frame(t(df))

# Write to csv
write.csv(df, "./datasets/Casino_cleaned.csv")