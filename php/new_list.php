
<?php
$PG_STRING = 'host=localhost port=5432 dbname=pg user=postgres password=postgres';
$db = pg_connect($PG_STRING);

$func = $_GET['function'];

if (str_starts_with($func, "get_cat_")) {
    $query = pg_query($db, "SELECT * FROM category;");
    $query_arr = pg_fetch_all($query);
    echo $query_arr[$func[8] - 1]['name'];
}
elseif ($func == 'update_news') {
    if ($_GET['cat'] == 'all') {
        $query = pg_query($db, 'SELECT * FROM new WHERE is_published=true ORDER BY publish_time');
    }
    else {
        $query = pg_query($db, 'SELECT * FROM new WHERE is_published=true AND category_id=' . $_GET['cat'] . ' ORDER BY publish_time');
    }
    $query_arr = pg_fetch_all($query);
    for ($i = 0; $i < count($query_arr); $i++) {
        echo "<tr>";
        echo "<td>";
        echo $query_arr[$i]['title'];
        echo "</td>";
        echo "<td>";
        echo $query_arr[$i]['text'];
        echo "</td>";
        echo "<td>";
        $tag_query = pg_query($db, 'SELECT * FROM new_tag WHERE new_id=' . $query_arr[$i]['new_id'] . ";");
        $tag_arr = pg_fetch_all($tag_query);
        for ($j = 0; $j < count($tag_arr); $j++)
        {
            $one_tag_query = pg_query($db, 'SELECT * FROM tag WHERE tag_id=' . $tag_arr[$j]['tag_id']);
            $one_tag_arr = pg_fetch_row($one_tag_query);
            echo '<div>' . $one_tag_arr[1] . '</div>';
        }
        echo "</td>";

        echo "<td>";
        $author_query = pg_query($db, 'SELECT * FROM new_author WHERE new_id=' . $query_arr[$i]['new_id'] . ";");
        $author_arr = pg_fetch_all($author_query);
        for ($j = 0; $j < count($author_arr); $j++)
        {
            $one_author_query = pg_query($db, 'SELECT * FROM usr WHERE usr.user_id=' . $author_arr[$j]['user_id']);
            $one_author_arr = pg_fetch_row($one_author_query);
            echo '<div>' . $one_author_arr[1] . '</div>';
        }
        echo "</td>";

        echo "<td>";
        echo "<input id='register_button' type='button' value='Перейти' onclick='window.localStorage.setItem(\"new_id\", " . $query_arr[$i]['new_id'] . "); window.location.replace(\"http://localhost/new.html\");'>";
        echo "</td>";

        echo "</tr>";
    }
}
elseif ($func == 'can_write_news') {
    $user_id = pg_fetch_row(pg_query($db, "SELECT user_id FROM usr WHERE username='" . $_GET['user'] . "';"))[0];
    $role = pg_fetch_row(pg_query($db, "SELECT role_id FROM usr WHERE username='" . $_GET['user'] . "';"))[0];
    $can_write = pg_fetch_row(pg_query($db, 'SELECT can_write_news FROM role WHERE role_id=' . $role . ";"))[0];
    if ($can_write == 't')
    {
        echo 'True';
    }
    else
    {
        echo 'False';
    }
}

pg_close($db);