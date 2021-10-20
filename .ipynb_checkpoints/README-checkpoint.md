# incrementality-model

This repo contains the incrementality model used to measure the incremental impacts for new products / collections and measure the impacts from price changes.

* SQL: Contains the sql files used by the model to pull the number of rug sales, ad spend, and heap sessions
* functions.R: defines helper functions used by the incrementality model
* incremental_model_nb.ipynb: contains a jupyter notebook where you can run code blocks and measure incrementality manually
* incremental_model_app.R: holds the shiny code to create a self service tool
* run_app.R: run this to open the self service tool that measure incrementality using an easy to understand UI

## How to use this
#### If you are looking to simply measure incrementality... 
You can use either incremental_model_nb or incremental_model_app. The notebook is be more manual but gives more control for the user while the app will open a UI that is much more user-friendly but lacks more insight into the inner workings. See step-by-step manual before running.

#### If you are looking to make modifications and add new features to the model... 
Open up the incremental_model code (either app or notebook) and see the line that starts with ```fit <- df_train...```

The model currently uses ARIMA to forecast a baseline that we use as a pseudo-control. You can add or remove features in this section using standard R notation used for defining models.

## Step-by-step manual
* coming soon

## Examples for previous analysis using the incremental model
* [Product Launches](https://drive.google.com/drive/u/0/folders/1VhkLELAYES8JtqmBBcqAPO-2bMs05UYY)
* [Pricing](https://drive.google.com/drive/u/0/folders/1_keRRTP6zguTUk2UDMxmymVEP4OsP3pt)