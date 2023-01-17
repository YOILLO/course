
function get_header()
{
    $.ajax({
        url: "php/new.php",
        method: "GET",
        data: 'function=get_header&new=' + window.localStorage.getItem('new_id'),
        dataType: "html",
        success: function(data){
            console.log(data);
            $('#header').html(data);

        },
        error: function(error){
            console.log(error);
        }
    });
}

function get_text()
{
    $.ajax({
        url: "php/new.php",
        method: "GET",
        data: 'function=get_text&new=' + window.localStorage.getItem('new_id'),
        dataType: "html",
        success: function(data){
            console.log(data);
            $('#text').html(data);

        },
        error: function(error){
            console.log(error);
        }
    });
}

function get_tags()
{
    $.ajax({
        url: "php/new.php",
        method: "GET",
        data: 'function=get_tags&new=' + window.localStorage.getItem('new_id'),
        dataType: "html",
        success: function(data){
            console.log(data);
            $('#tags').html(data);

        },
        error: function(error){
            console.log(error);
        }
    });
}

function get_authors()
{
    $.ajax({
        url: "php/new.php",
        method: "GET",
        data: 'function=get_authors&new=' + window.localStorage.getItem('new_id'),
        dataType: "html",
        success: function(data){
            console.log(data);
            $('#authors').html(data);
        },
        error: function(error){
            console.log(error);
        }
    });
}

function get_comments()
{
    $.ajax({
        url: "php/new.php",
        method: "GET",
        data: 'function=get_comments&new=' + window.localStorage.getItem('new_id'),
        dataType: "html",
        success: function(data){
            console.log(data);
            $('#prev_comments').html(data);
        },
        error: function(error){
            console.log(error);
        }
    });
}

$(document).ready(function () {
    get_header();
    get_text();
    get_tags();
    get_authors();
    get_comments();

    if (window.localStorage.getItem('new_id') == '')
    {
        window.location.replace('http://localhost/news_list.html');
    }

    $('#back_id').click(function () {
        window.location.replace('http://localhost/news_list.html');
    });

    $("#send_comment").click(function (){
        $.ajax({
            url: "php/new.php",
            method: "GET",
            data: 'function=post_comment&new=' + window.localStorage.getItem('new_id') + "&user=" + window.localStorage.getItem('login') + '&text=' + $('#text_comment').val(),
            dataType: "html",
            success: function(data){
                console.log(data);
                get_comments();
            },
            error: function(error){
                console.log(error);
            }
        });
    });
})