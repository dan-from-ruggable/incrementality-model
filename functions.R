# reads sql
getSQL <- function (filepath) {
  con = file(filepath, "r")
  sql.string <- ""
  while (TRUE){
    line <- readLines(con, n = 1)
    if ( length(line) == 0 ){
      break
    }
    line <- gsub("\\t", " ", line)
    if(grepl("--",line) == TRUE){
      line <- paste(sub("--","/*",line),"*/")
    }
    sql.string <- paste(sql.string, line)
  }
  close(con)
  return(sql.string)
}

# group data
groupData <- function (data, group_by_cols) {
  grouped_data <- data %>% 
    group_by(.dots = group_by_cols) %>% 
    summarize(quantity = sum(quantity), .groups = 'drop')
  return(grouped_data)
}

# find market matches
getControls <- function (data, id_var=grouping_parameter, start_date, end_date, target_var) {
    mm <- MarketMatching::best_matches(data,
                                       id_variable=id_var,
                                       date_variable="date",
                                       matching_variable="quantity",
                                       parallel=FALSE,
                                       warping_limit=1, # warping limit=1
                                       dtw_emphasis=1, # rely only on dtw for pre-screening
                                       matches=10, # request 5 matches
                                       start_match_period=start_date,
                                       end_match_period=end_date)
    return(mm$BestMatches %>% filter(group_by_col==target_var) %>% as_tibble())
}