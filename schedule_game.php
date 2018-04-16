<!DOCTYPE html>
<html>
  <head>
    <title>schedule</title>
  </head>
  <body>
    <h1 >Schedule all Games</h1>

    <?php
      require_once('config.php');
      // Connect to database

      /* Attempt to connect to MySQL database */
      $link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

      // Check connection
      if($link === false){
          die("ERROR: Could not connect. " . mysqli_connect_error());
      }

        $sql= "SELECT

              GAMES.START_DAY,
              GAMES.END_DAY,
              GAMES.SCORE

              FROM PLAY
              RIGHT JOIN GAMES ON
              PLAY.PGAME_ID = GAMES.GAME_ID
              GROUP BY GAMES.GAME_ID

          ";
          $sql1= "SELECT


              TEAMS.TEAM_NAME,
              TEAMS.WIN,
              TEAMS.LOSS
              FROM PLAY
              RIGHT JOIN TEAMS ON
              PLAY.PTEAM_ID= TEAMS.TEAM_ID


            ";
      $stmt = $link->prepare($sql);
      $stmt1 = $link->prepare($sql1);
      $stmt -> execute();
      $stmt->store_result();
      $stmt->bind_result(
         $STD,
        $ETD,
        $SC

      );
      $stmt1 -> execute();
      $stmt1->store_result();
      $stmt1->bind_result(

        $TN,
        $W,
        $L
      );
    ?>


    <?php
      echo "GAME:  ".$stmt->num_rows."<br/>";
    ?>


    <table style="border:1px solid black; border-collapse:collapse;">
      <tr>
        <th colspan="9" style="vertical-align:top; border:1px solid black; background: lightgreen;">Schedule</th>
      </tr>
      <tr>

        <th style="vertical-align:top; border:1px solid black; background: lightgreen;">START_DAYS</th>
          <th style="vertical-align:top; border:1px solid black; background: lightgreen;">END_DAYS</th>
        <th style="vertical-align:top; border:1px solid black; background: lightgreen;">SCORES</th>

        <th style="vertical-align:top; border:1px solid black; background: lightgreen;">TEAM A NAME</th>
          <th style="vertical-align:top; border:1px solid black; background: lightgreen;">WIN  </th>
        <th style="vertical-align:top; border:1px solid black; background: lightgreen;">LOSS</th>

        <th style="vertical-align:top; border:1px solid black; background: lightgreen;">TEAM B NAME</th>
          <th style="vertical-align:top; border:1px solid black; background: lightgreen;">WIN  </th>
        <th style="vertical-align:top; border:1px solid black; background: lightgreen;">LOSS</th>
      </tr>
      <?php


        while($stmt->fetch()){

          echo "<tr>\n";



          echo "<td  style='vertical-align:top; border:1px solid black;'>". $STD ."</td>\n";
          echo "<td style='vertical-align:top; border:1px solid black;'> ". $ETD ."</td>\n";
          echo "<td style='vertical-align:top; border:1px solid black;'>". $SC ."</td>\n";
          while($stmt1->fetch()){
                  echo "<td  style='vertical-align:top; border:1px solid black;'>". $TN ."</td>\n";
                  echo "<td style='vertical-align:top; border:1px solid black;'> ". $W ."</td>\n";
                  echo "<td style='vertical-align:top; border:1px solid black;'>". $L ."</td>\n";
                  

                }

          echo "</tr>";

}



        $stmt->free_result();

        $stmt1->free_result();






        $link->close();

      ?>

    </table>

  </body>
</html>