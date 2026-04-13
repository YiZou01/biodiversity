
library(jsonlite)
library(httr2)
library(dplyr)
library(purrr)
library(readr)
library(curl)

api_key <- "XXXX"
input_dir <- "/Users/XXX"
input_files <- list.files(path = input_dir,
                          pattern = "\\.csv$",
                          full.names = TRUE)
length(input_files)
source("Prompt.R")

`%||%` <- function(a, b) if (!is.null(a)) a else b

classify_one_deepseek <- function(abstract, model = "deepseek-chat") {
  body <- list(
    model = model,
    messages = list(
      list(role = "system", content = system_prompt),
      list(role = "user", content = as.character(abstract))
    ),
    response_format = list(type = "json_object"),
    temperature = 0,
    stream = FALSE,
    max_tokens = 100
  )
  
  resp <- httr::POST(
    url = "https://api.deepseek.com/chat/completions",
    httr::add_headers(
      Authorization = paste("Bearer", api_key),
      `Content-Type` = "application/json"
    ),
    body = body,
    encode = "json"
  )
  
  httr::stop_for_status(resp)
  
  obj <- httr::content(resp, as = "parsed", type = "application/json", encoding = "UTF-8")
  txt <- obj$choices[[1]]$message$content
  
  if (is.null(txt) || !nzchar(trimws(txt))) {
    stop("Empty content returned by API")
  }
  
  parsed <- jsonlite::fromJSON(txt)
  
  tibble(
    fieldwork = parsed$fieldwork %||% NA_character_,
    primary_data = parsed$primary_data %||% NA_character_,
    raw_content = txt,
    error_msg = NA_character_
  )
}

output_dir <- "/Users/XXXX"
Jfile <- c(1:19)
for (j in Jfile)
{
  df.input <-read_csv(input_files[j])
  df <- df.input %>%
    mutate(
      X = as.character(X),
      paper_id = as.character(UT..Unique.ID.),
      abstract = as.character(Abstract)
    ) %>%
    filter(!is.na(abstract), abstract != "")%>%
    select(!c(Abstract,UT..Unique.ID.))
  out_file <- file.path(
    output_dir,
    paste0(tools::file_path_sans_ext(basename(input_files[j])), "_deepseek.csv")
  )

  if (file.exists(out_file)) {
    done_x <- as.character(read_csv(out_file, show_col_types = FALSE)$X)
  } else {
    done_x <- character(0)
  }
  
  df_to_do <- df[!(df$X %in% done_x), ]
  n <- nrow(df_to_do)
  
  if (n > 0 ) {
    for (i in  1:n) {
      
      cat(j,basename(input_files[j]),
          i, "/", n,
          df_to_do$paper_id[i], "\n")
      
      res <- tryCatch(
        classify_one_deepseek(df_to_do$abstract[i]),
        error = function(e) {
          tibble(
            fieldwork = NA_character_,
            primary_data = NA_character_,
            raw_content = NA_character_,
            error_msg = as.character(e$message)
          )
        }
      )
      
      row_out <- bind_cols(df_to_do[i, ], res)
      
      if (!file.exists(out_file)) {
        write_csv(row_out, out_file)
      } else {
        write_csv(row_out, out_file, append = TRUE)
      }
    }
  }
}

