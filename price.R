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
data <- read.csv("./datasets/Casino_cleaned.csv", header = T)

# Convert it to a data frame
df <- as.data.frame(data)

# Grep EPS
eps <- df[, grep("(EPS)", colnames(df))]

# Bind the data col with the eps data
eps <- cbind(df[, 1], eps)

# Set the col name for the data
colnames(eps)[1] <- "Date"

# Remove NAs
eps <- na.omit(eps)

# Write to CSV
write.csv(eps, "./datasets/eps.csv")