
<?php
$PG_STRING = 'host=localhost port=5432 dbname=pg user=postgres password=postgres';
$db = pg_connect($PG_STRING);

$fun = $_GET['function'];

switch ($fun)
{
    case 'get_header':
        $query = pg_query($db, "SELECT title FROM new WHERE new_id=" . $_GET['new']);
        echo pg_fetch_row($query)[0];
        break;
    case 'get_text':
        $query = pg_query($db, "SELECT text FROM new WHERE new_id=" . $_GET['new']);
        echo pg_fetch_row($query)[0];
        break;
    case 'get_tags':
        $tag_query = pg_query($db, 'SELECT * FROM new_tag WHERE new_id=' . $_GET['new']  . ";");
        $tag_arr = pg_fetch_all($tag_query);
        for ($j = 0; $j < count($tag_arr); $j++)
        {
            $one_tag_query = pg_query($db, 'SELECT * FROM tag WHERE tag_id=' . $tag_arr[$j]['tag_id']);
            $one_tag_arr = pg_fetch_row($one_tag_query);
            echo '<div>' . $one_tag_arr[1] . '</div>';
        }
        break;
    case 'get_authors':
        $author_query = pg_query($db, 'SELECT * FROM new_author WHERE new_id=' . $_GET['new'] . ";");
        $author_arr = pg_fetch_all($author_query);
        for ($j = 0; $j < count($author_arr); $j++)
        {
            $one_author_query = pg_query($db, 'SELECT * FROM usr WHERE usr.user_id=' . $author_arr[$j]['user_id']);
            $one_author_arr = pg_fetch_row($one_author_query);
            echo '<div>' . $one_author_arr[1] . '</div>';
        }
        break;
    case 'get_comments':
        $comments_query = pg_query($db, 'SELECT * FROM comment WHERE new_id=' . $_GET['new']);
        $comments_array = pg_fetch_all($comments_query);
        for ($j = 0; $j < count($comments_array); $j++)
        {
            echo '<div>';
            $one_new_query = pg_query($db, 'SELECT * FROM usr WHERE usr.user_id=' . $comments_array[$j]['user_id']);
            echo pg_fetch_row($one_new_query)[1];
            echo '<br>';
            echo $comments_array[$j]['text'];
            echo '</div>';
            echo '<br>';
        }
        break;
    case 'post_comment':
        if ($_GET['user'] == '')
        {
            break;
        }

        $user_id = pg_fetch_row(pg_query($db, "SELECT user_id FROM usr WHERE username='" . $_GET['user'] . "';"))[0];
        $role = pg_fetch_row(pg_query($db, "SELECT role_id FROM usr WHERE username='" . $_GET['user'] . "';"))[0];
        $can_comment = pg_fetch_row(pg_query($db, 'SELECT can_comment FROM role WHERE role_id=' . $role . ";"))[0];
        if ($can_comment == 't')
        {
            pg_query($db, "INSERT INTO comment (text, user_id, new_id) " .
                                "VALUES ('" . $_GET['text'] . "', ". $user_id .", " . $_GET['new'] . ");");
        }
}

pg_close($db);