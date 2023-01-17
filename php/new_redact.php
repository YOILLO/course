
<?php
$PG_STRING = 'host=localhost port=5432 dbname=pg user=postgres password=postgres';
$db = pg_connect($PG_STRING);

switch ($_GET['function'])
{
    case 'update_news':
    {
        $new_query = pg_query($db, 'SELECT * FROM new;');
        $new_arr = pg_fetch_all($new_query);
        for ($j = 0; $j < count($new_arr); $j++)
        {
            echo '<option>' . $new_arr[$j]['title'] . '</option>';
        }
        break;
    }
    case 'update_tags':
    {
        $tag_query = pg_query($db, 'SELECT * FROM tag;');
        $tag_arr = pg_fetch_all($tag_query);
        for ($j = 0; $j < count($tag_arr); $j++)
        {
            echo '<option>' . $tag_arr[$j]['name'] . '</option>';
        }
        break;
    }
    case 'get_new':
    {
        $text_query = pg_query($db, "SELECT text FROM new WHERE title='" . $_GET['header'] . "';");
        echo pg_fetch_row($text_query)[0];
        break;
    }
    case 'send_new':
    {
        $new_id = pg_fetch_row(pg_query($db, "SELECT new_id FROM new WHERE title='" . $_GET['old_header'] . "';"))[0];
        $ctg_id = pg_fetch_row(pg_query($db, "SELECT category_id FROM new WHERE title='" . $_GET['old_header'] . "';"))[0];
        $user_id = pg_fetch_row(pg_query($db, "SELECT user_id FROM usr WHERE username='" . $_GET['user'] . "';"))[0];
        pg_query($db, "SELECT UpdateNew(" . $user_id . ", '" . $_GET['password'] . "', '" . $_GET['header'] . "', '" . $_GET['text'] . "', " . $ctg_id . ", " . $new_id .");");
        break;
    }
    case 'add_tag':
    {
        $new_id = pg_fetch_row(pg_query($db, "SELECT new_id FROM new WHERE title='" . $_GET['header'] . "';"))[0];
        $tag_id = pg_fetch_row(pg_query($db, "SELECT tag_id FROM tag WHERE name='" . $_GET['tag'] ."';"))[0];
        $user_id = pg_fetch_row(pg_query($db, "SELECT user_id FROM usr WHERE username='" . $_GET['user'] . "';"))[0];
        echo $tag_id;
        pg_query($db, "SELECT AddTag(" . $user_id . ", '" . $_GET['password'] . "', " . $new_id . ", " . $tag_id . ");");
        break;
    }
    case 'remove_tag':
    {
        $new_id = pg_fetch_row(pg_query($db, "SELECT new_id FROM new WHERE title='" . $_GET['header'] . "';"))[0];
        $tag_id = pg_fetch_row(pg_query($db, "SELECT tag_id FROM tag WHERE name='" . $_GET['tag'] ."';"))[0];
        $user_id = pg_fetch_row(pg_query($db, "SELECT user_id FROM usr WHERE username='" . $_GET['user'] . "';"))[0];
        pg_query($db, "SELECT RemoveTag(" . $user_id . ", '" . $_GET['password'] . "', " . $new_id . ", " . $tag_id . ");");
        break;
    }
}

pg_close($db);