# Cleaning script for NFL fourth down project
# Reads raw nflfastR play-by-play and writes a cleaned season-level summary

library(here)
library(dplyr)

# Read the raw play-by-play data
pbp_raw <- readRDS(
  here("pages", "project", "data", "nfl_pbp_raw.Rds")
)

fourth_down_clean <- pbp_raw |>
  # Keep only fourth down plays with a known play type
  filter(
    down == 4,
    !is.na(play_type),
    play_type %in% c("run", "pass", "punt", "field_goal")
  ) |>
  # Flag whether the offense went for the conversion
  mutate(
    went_for_it = play_type %in% c("run", "pass"),
    # Group distance to go into readable buckets
    distance_bucket = case_when(
      ydstogo <= 2 ~ "1-2 yards",
      ydstogo <= 5 ~ "3-5 yards",
      ydstogo <= 10 ~ "6-10 yards",
      TRUE ~ "11+ yards"
    )
  )

# Write the cleaned data for use in the data story
saveRDS(
  object = fourth_down_clean,
  file = here("pages", "project", "data", "cleaned", "nfl_fourth_down_cleaned.Rds")
)

