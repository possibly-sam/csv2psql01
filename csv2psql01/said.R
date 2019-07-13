
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





# this will give you the sql statements needed to make
# the database table corresponding to a given column name (with associated type) 
# and a given table name.

ppsql <- function(the_table_name) {
  result <- new.env(emptyenv())
  
  kill <- function(it, s, target='') gsub(s,target, it, fixed=TRUE)
  
  bad_characters <- c(' ', '(', ')', '$', '.', ',', '%')
  
  get_safe_name <- function(it) {
    for (k in bad_characters) it <- it %>% kill(k, '_')
    it
  }
  
  enquote <- function(it) paste0('"', it, '"')
  result$make_column <- function(the_column_name, the_type='character varying') {
    the_column_name <- the_column_name %>% get_safe_name()
    paste('ALTER TABLE', paste0('public.', the_table_name %>% enquote()), 'ADD COLUMN', the_column_name %>% enquote(), the_type , ';')
  }
  
  result
}




#p01 <- ppsql('R02')
# 'asdf' %>% p01$make_column() %>% writeLines()

# ALTER TABLE public."Risks01" ADD COLUMN "Description" character varying;








# XL --> PSQL

# Suppose for the sake of argument that we are given a table.  We want to create the corresponding table in postgresql.  

# * Read in the table
# * for each column, get the class
# * use the class to make a decent assumption about what the column can be in psql






pmeta <- function(the_table) {
  the_names <- the_table %>% colnames()
  the_class <- the_names
  for (k in seq_along(the_names)) {
    # cat(k)
    the_class[k] <- the_table[[k]] %>% class()
  }
  data.frame(the_name=the_names , the_class=the_class, stringsAsFactors = FALSE)
  
}

psql_map <- list()
psql_map[["integer"]] <- "bigint"
psql_map[["numeric"]] <- "real"
psql_map[["Date"]]    <- "date"

psql_meta <- function(the_table, the_table_name) {
  result <- new.env(emptyenv())
  
  result$ppsql <- ppsql(the_table_name)
  result$meta  <- pmeta(the_table)
  
  get_class <- function(the_class) {
    result <- psql_map[[the_class]]
    if (is.null(result)) result <- "varchar"
    result
  }
  
  
  # return (result)
  
  x0 <- result$meta$the_class
  for (k in seq_along(x0)) {
    c0 <- get_class(result$meta$the_class[k]) 
    x0[k] <- result$ppsql$make_column( result$meta$the_name[k], c0) 
  }
  
  # for (k in seq_along(x0)) x0[k] <- result$meta$the_name[k]
  
  result$meta %>% cbind(x0, stringsAsFactors=FALSE)
  
}

# examples
# x0 <- psql_meta(a18, "ACTVZ18")
# x0 <- psql_meta(q0$my_tables$Activities[[16]], "Activities16")
# x0$x0 %>% writeLines()




# pre-convert .csv files
#e.g. blanks in integer columns become zeros


psql_sanitize <- function(the_table) {
  
  for (k in seq_along(the_table)) {
    the_class <- the_table[[k]] %>% class()
    if (the_class == "integer" || the_class == "numeric") {
      the_empty <- (the_table[[k]] == "") | (the_table[[k]] %>% is.na())
      the_table[the_empty,k] <- 0
    }
    
  }
  
  the_table
  
}

# a16 <- q0$my_tables$Activities[[16]] 
# a16h <- a16#  %>% head()
# a16hb <- a16h %>% psql_sanitize()
# a16hb %>% write.csv("a16.csv", row.names=FALSE)






