
library(tidyverse)

# this is the way to read in all the files


said <- function(the_directory="") {
  result <- new.env(emptyenv())
  
  result$my_tables <- list()
  
  fn <- function(the_name, the_year) {
    read_csv( paste0(the_directory, "/20", the_year, "/", the_name, ".csv"))
  }
  
  fn_all <- function(the_name, the_years=13:18) {
    
    result$my_tables[[the_name]] <- list()
    for (year in the_years)
      result$my_tables[[the_name]][[year]] <- fn(the_name, year)
    
  }
  
  
  # result$my_tables[["Projects"]] <- list()
  # result$my_tables[["Projects"]][[18]] <- result$fn("Projects", 18)
  
  fn_all("Projects")
  fn_all("Activities")
  fn_all("BusinessCase", 16:18)
  result
  
  # where you were:  read in for each of the available files.  
  # merge where possible:  expand to NA
  # do the joins
  
}

# Projects18 <- read_csv("2018/Projects.csv")

# Projects18 %>% colnames()


#q0 <- said()

# q0 %>% ls.str()
