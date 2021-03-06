<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Game Playing</title>
  </head>
  <body>
  <?php
  require_once 'config.php';
  $db = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

  // Check connection
  if($db === false){
    die("ERROR: Could not connect. " . mysqli_connect_error());
  }

  $query = "SELECT TEAM_ID FROM TEAMS WHERE TMANAGER_ID = (SELECT MANAGER_ID FROM MANAGER WHERE MUSER_ID = ?)";

  $stmt = $db->prepare($query);
  $stmt->bind_param('i', $user_id);
  $stmt->execute();
  $stmt->bind_result($_teamid);
  $stmt->fetch();
  $stmt->free_result();

  $query = "SELECT PLAYER_ID, FIRST_NAME, LAST_NAME, GAME_ID
  FROM PLAYER, (SELECT GAME_ID FROM GAMES LEFT JOIN PLAY ON GAME_ID = PGAME_ID WHERE PGAME_ID IS NULL) AS T
  WHERE PLTEAM_ID = ?
  ORDER BY GAME_ID";

  $stmt = $db->prepare($query);
  $stmt->bind_param('i', $_teamid);
  $stmt->execute();
  $stmt->store_result();
  $stmt->bind_result(
    $player_id,
    $first_name,
    $last_name,
    $game_id
  );
  ?>

  <table class="table table-bordered table-hover">
    <thead class="thead-dark">
      <tr class="info">
        <th scope="col">PLAYER ID</th>
        <th scope="col">FIRST NAME</th>
        <th scope="col">LAST NAME</th>
        <th scope="col">GAME ID</th>
        <th scope="col">ACTION</th>
      </tr>
  </thead>

  <?php

  $toggle = "table-active";
  $switch_color = false;
  while ($stmt->fetch()){
    if ($switch_color) {
        $toggle = "table-success";
        $switch_color = false;
      } else {
        $toggle = "table-light";
        $switch_color = true;
      }
    echo "<tr class=\"$toggle\">\n";
    echo "<th scope=\"row\">".$game_id."</th>\n";
    echo "<td>".$player_id."</td>\n";
    echo "<td>".$first_name."</td>\n";
    echo "<td>".$last_name."</td>\n";
    echo "<td>";
    echo "<a href='addPlayerToGame.php?id=" . $PLAYERID . "'>ADD</a>";
    // echo "<a href='removePlayerToGame.php?id=" . $PLAYERID . "'>REMOVE</a>";
    echo "</td>";

    echo "</tr>";
  }
 ?>
</table>

  </body>
</html>
