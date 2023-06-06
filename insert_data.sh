#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games,teams")
cat games.csv | while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if
 [[ $WINNER != "winner" ]]
then
$PSQL "INSERT INTO teams (name) select '$WINNER' WHERE NOT EXISTS (select 1 from teams WHERE name = '$WINNER')" 
fi
if
[[ $OPPONENT != "opponent" ]]
then
$PSQL "INSERT  INTO teams (name) select '$OPPONENT' WHERE NOT EXISTS (SELECT  1 from teams WHERE name ='$OPPONENT')"
fi

if 
[[ $YEAR != "year"  &&  $ROUND != "round"  &&   $WINNER != "winner"  ]]

then

$PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) values ('$YEAR','$ROUND',(SELECT team_id from teams where name ='$WINNER'), (SELECT  team_id from teams where name='$OPPONENT'), '$WINNER_GOALS', '$OPPONENT_GOALS')" 
fi
done < games.csv
