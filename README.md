# mastermind
AxiomZen challenge on Vanhackathon

The challenge consists on creating an API that allows creation of mastermind games, waits for players to join and check their guesses.

# Requirements for local execution
* Ruby 2.3.0
* Rails 4.2.6
* Postgresql

# Executing on local machine
1. `gem install bundler`
2. `bundle install`
3. `foreman start`

# Requirements for docker execution
* Docker v1.11.1 or higher
* Docker Compose v1.7.1 or higher

# Executing on docker
1. Enter the directory of the project
2. Build the docker image with `docker build -t mastermind-api:v1 .`
3. Start the service with `docker-compose up` or connect to the docker container with `docker-compose run --rm --service-ports api bash`

# API
This project consists of the following APIs:


## POST /games
* Creates a game;
* Headers:
    - Accept: application/json
    - Content-Type: application/json
* Input: 
    - player: Name of the player creating the game;
    - number_of_players: Number of people that will play the game. Defaults to `1`;
    - allow_repetition: Indicates if the code generated will have duplicated colors or not. Defaults to `false`;
    - max_turns: The max number of guesses each player will have. Defaults to `10`;
    - Example: `{ "player": "Player1", "number_of_players": 2, "allow_repetition": true, "max_turns": 10 }`
* Output: check schema Game


## GET /games/:game_key
* Gets a game by game_key
* Headers:
    - Accept: application/json
* Input: 
    - game_key: Identifier of the game;
    - Example: `/games/jHSZDdLHb3QpbRajXv9bzvCX`
* Output: check schema Game
    - There are no guesses in this response, except when the game is over;
    - Example:
```
{"game_key":"NApe9saManED9vcqUsCSmf1u","status":"playing","number_of_players":2,"max_turns":10,"allow_repetition":true,"code_length":8,"colors":["R","B","G","Y","O","P","C","M"],"current_turn":1,"players":["GameMaster","John Doe"]}
```
    - Example of finished game:
```
{"game_key":"NApe9saManED9vcqUsCSmf1u","status":"finished","number_of_players":2,"max_turns":10,"allow_repetition":true,"code_length":8,"colors":["R","B","G","Y","O","P","C","M"],"current_turn":11,"players":["GameMaster","John Doe"],"winner":null,"guesses":{"GameMaster":[{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"BBBBBBBB","exact":1,"near":0},{"code":"BBBBBBBB","exact":1,"near":0},{"code":"BBBBBBBB","exact":1,"near":0},{"code":"BBBBBBBB","exact":1,"near":0},{"code":"BBBBBBBB","exact":1,"near":0}],"John Doe":[{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0}]}}
```


## GET /games/availables
* Gets all available games a player can enter
* Headers:
    - Accept: application/json
* Output: An array of available games. Check schema Game
    - free_slots: present only in this API, shows how many more players can enter a game;
    - Example:
```
[{"game_key":"g3sqc3e22BARHDA45rj7Ad2T","status":"waiting_for_players_to_join","number_of_players":2,"max_turns":10,"allow_repetition":true,"code_length":8,"colors":["R","B","G","Y","O","P","C","M"],"players":["GameMaster"],"free_slots":1}]
```


## POST /games/:game_key/players
* Joins a game;
* Headers:
    - Accept: application/json
    - Content-Type: application/json
* Input: 
    - game_key: Identifier of the game;
    - player: Name of the player joining the game;
    - Example: `{ "player": "John Doe" }`
* Output: check schema Game
    - Example:
```
{"game_key":"NApe9saManED9vcqUsCSmf1u","status":"playing","number_of_players":2,"max_turns":10,"allow_repetition":true,"code_length":8,"colors":["R","B","G","Y","O","P","C","M"],"current_turn":1,"players":["GameMaster","John Doe"],"player_key":"sGXdaw2pPhG91NT7TincTtVZ","my_guesses":[]}
```


## POST /players/:player_key/guesses
* Makes a guess in a game with a given user;
* Headers:
    - Accept: application/json
    - Content-Type: application/json
* Input: 
    - player_key: Identifier of the game;
    - code: Guess made by the player
    - Example: `{ "code": "RBGRBGRB" }`
* Output: check schema Game
    - Example: 
```
{"game_key":"NApe9saManED9vcqUsCSmf1u","status":"playing","number_of_players":2,"max_turns":10,"allow_repetition":true,"code_length":8,"colors":["R","B","G","Y","O","P","C","M"],"current_turn":3,"players":["GameMaster","John Doe"],"player_key":"nbRkoTYHdVyP6TyRb5jvmvCP","my_guesses":[{"code":"RRRRRRRR","exact":3,"near":0},{"code":"RRRRRRRR","exact":3,"near":0}]}
```



## Schema Game
    - game_key: The identifier of the game;
    - status: The current status of the game. Can be `waiting_for_players_to_join`, `playing` or `finished`;
    - number_of_players: Number of players on the game;
    - max_turns: The max number of guesses each player will have;
    - allow_repetition: Indicates if the code generated will have duplicated colors or not;
    - code_length: The length of the code that the players must guess;
    - colors: Array of all colors possibles;
    - current_turn: The current turn of guesses;
    - players: Array of names of all players that joined the game. *Only present when the game has not finished*;
    - player_key: The identifier of the player. *Only present when the game has not finished*;
    - my_guesses: Array of guesses from the current player. Each entry contains the code inputed, the amount of exact and amount of near colors. *Only present when the game has not finished*;
    - winner: Name of the winner of the game, if any. *Only present when the game has finished*;
    - guesses: All guesses separated by user. *Only present when the game has finished*;
    - Example: `{"game_key":"9nUdqDBHp1X6SbuxsF3tZSfM","status":"playing","number_of_players":2,"max_turns":10,"allow_repetition":true,"code_length":8,"colors":["R","B","G","Y","O","P","C","M"],"current_turn":1,"players":["GameMaster","John Doe"],"player_key":"JewMZX8mYcrAS3iNMFsWewbh","my_guesses":[{"code":"MOMGYBRY","exact":2,"near":1}]}`


# Jobs
To avoid keeping old games open, after 5 minutes of inactivity the game will be closed. To do so, a job is being used. Whenever the game is updated, it schedules a job for the next 5 minutes, so it can check if there was any update during this time.






