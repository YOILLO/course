
<?php
$PG_STRING = 'host=localhost port=5432 dbname=pg user=postgres password=postgres';
$db = pg_connect($PG_STRING);

switch ($_GET['function'])
{
    case 'send':
    {
        $row = pg_fetch_row(pg_query($db, "SELECT password FROM usr WHERE username='{$_GET['login']}'"));
        if ($row != null) {
            $password = $row[0];
            if ($_GET['password'] == $password) {
                echo "OK";
            } else {
                echo "Ошибка пароля";
            }
        }
        else
        {
            echo "Нет такого аккаунта";
        }
        break;
    }
    case 'register':
    {
        $row = pg_fetch_row(pg_query($db, "SELECT password FROM usr WHERE username='{$_GET['login']}'"));
        if ($row == null) {
            pg_query($db, "INSERT INTO usr (username, password, role_id)
                                    VALUES ('{$_GET['login']}', '{$_GET['password']}', 4)");
            echo 'OK';
        }
        else
        {
            echo "Этот логин занят";
        }
        break;
    }
}

pg_close($db);
