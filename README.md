# Corporate_Finance_Stock_Analysis
Data processing utilities for stock analysis for EHL Corporate Finance Course

### File Description:
- bid-ask.R: Calculate the bid-ask spread.
- eps.R: Extract the EPS data from the raw data and plot them.
- exctract_treasury_bonds.R: Extract the average interest rate from fiscaldata.treasury.gov data.
- pre_process.R: Data pre-processing (convert non-usd currency to usd | Missing data interpolation).
- price.R: Extract the price data from the raw data and plot them.
- shares.R: Process shares raw data (missing data interpolation).
- shares_price_combine.R: Combine the all shares data into one file and all price data into one file.
- market_cap_weighted_index.R: Calculate market-cap-weighted index for both the CBD and sin stocks.
- CITATION.cff: The [GitHub CITATION] file.

### Folder Description:
- datasets: All the data used during the analysis (excluding the shares data).
  - Raw: Raw data from Datastream | REFINITIV.
  - Pre_Processed: Data pre-processing and currency converstion (to USD).
  - Processed: Processed data.
  - Shares: Shares data (raw / processed) for calculating the market-cap-weighted indeices.

[Github CITATION]: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-citation-files

