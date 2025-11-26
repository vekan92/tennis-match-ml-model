# tennis-match-ml-model
A machine-learning project that scrapes live tennis match data, trains a neural network to estimate win probabilities from score states, and evaluates expected value based on live betting odds.


# Tennis Set Win Probability (MATLAB)

This is a  project where I model the probability of a player winning a tennis set based on the current game score pattern. The core idea is:

- Scrape historical point-by-point match data for a given player.
- Encode how each game in a set was won or lost (serve holds, breaks, etc.).
- Train a classification model on past sets for a player and their opponents.
- Use that model during a live match to estimate who is more likely to win the set.
- Use the prediction as a basis to check whether a bet could be favourable.

I wrote this mainly to combine maths, programming and some basic machine learning in a concrete setting.

---

## Project overview

The project is split into three main parts:

1. **Data collection (JavaScript + Puppeteer)**  
   A Node.js script (`scraper/tennis_scraper.js`) uses Puppeteer to open a player’s page on livesport.com, click through past matches, and collect point-by-point or game-level data for each set.  
   The result is written to a text file as an encoded matrix (each row is a set, columns are game outcomes, `-1` marks the end of a set). This file is then used in MATLAB to build the `dataMatrix`.

2. **Data preparation and training per player (MATLAB)**  
   Historical sets for a player are stored in a `dataMatrix` (one row per set). Each row contains encoded game outcomes plus a final column indicating whether the set was won (1) or lost (0).  
   A MATLAB classification network (`fitcnet`) is trained on this data to predict `"win"` / `"loss"` from the game pattern.

3. **Live use during a match (MATLAB)**  
   During a live match, the code:
   - Scrapes the current score from a match page.
   - Encodes the sequence of games so far in the same format as the training data.
   - Loads the training data for the player and the opponent.
   - Trains two models (one per side) and compares their predictions for the current score state.
   - If the models disagree (one predicts win, the other loss), the script flags that as a potential betting opportunity and alerts the user.

This is not a production system, just an experiment to explore modelling and decision rules.

---

## Scripts and what they do

### Web scraping (JavaScript)

- **`scraper/tennis_scraper.js`**  
  Node.js + Puppeteer script used to gather the raw data for the project.
  - Opens a player page on livesport.com.
  - Clicks “more” to load a large number of past matches.
  - For each match, opens the point-by-point view.
  - Loops over sets and games, extracts the game scores and encodes them as digits.
  - Handles cases where the player appears on the left or right side of the scoreboard.
  - Writes the resulting `dataMatrix` to a text file such as `Tennis_Djokovic_N_Data_1.txt`.

This text file is later converted into the MATLAB `dataMatrix` format used for training.

---

### Core modelling scripts (MATLAB)

- **`betScript.m`**  
  Early script to build a `dataMatrix` from an encoded string and train a neural network on the full dataset.  
  - Parses a character string into game-level features.
  - Builds a `dataMatrix` with 19 game columns plus a `resultNumeric` column.
  - Converts the matrix into a table, creates a `"win"` / `"loss"` label, and trains a `fitcnet` classifier.
  - Includes an example of predicting the outcome for a hand-coded `currentGames` vector.

- **`games_8_prediction.m`**  
  Script to work with a specific match situation where 8 games have been played in the set.  
  - Loads historical `dataMatrix` for a given player and opponent from separate `.mat` files (`Tennis_<playerName>/<playerName>.mat` etc.).
  - Builds a table for each, converts the first 8 game columns to categorical features, and `result` to a categorical target.
  - Trains a `fitcnet` model for the player and one for the opponent.
  - Given `currentGames_player` (length 8), predicts `"win"` / `"loss"` for each side.
  - Computes the empirical win percentage for the exact pattern in the historical data.
  - Contains commented code for turning these probabilities into a value calculation for a bet.

- **`getPredictedResultGame8.m`**  
  Function version of the logic in `games_8_prediction.m`.  
  Signature:
  ```matlab
  [predictedResult_player, predictedResult_opponent] = getPredictedResultGame8(playerName, opponentName, currentGames_player)
