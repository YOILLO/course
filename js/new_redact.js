function update_news_list()
{
    $.ajax({
        url: "php/new_redact.php",
        method: "GET",
        data: 'function=update_news&user=' + window.localStorage.getItem('login'),
        dataType: "html",
        success: function (data) {
            console.log(data);
            $("#news_select").html(data);
        },
        error: function (error) {
            console.log(error);
        }
    });
}

function update_tags_list()
{
    $.ajax({
        url: "php/new_redact.php",
        method: "GET",
        data: 'function=update_tags&user=' + window.localStorage.getItem('login'),
        dataType: "html",
        success: function (data) {
            console.log(data);
            $("#tag_select").html(data);
        },
        error: function (error) {
            console.log(error);
        }
    });
}

function send_new()
{
    new_title = $('#news_select').val();
    header = $('#header_redact').val();
    text = $('#text_redact').val();
    $.ajax({
        url: "php/new_redact.php",
        method: "GET",
        data: 'function=send_new&user=' + window.localStorage.getItem('login') + "&password=" + window.localStorage.getItem('password') + "&header=" + header + "&text=" + text + "&old_header=" + new_title,
        dataType: "html",
        success: function (data) {
            console.log(data);
            update_news_list();
            update_tags_list();
        },
        error: function (error) {
            console.log(error);
        }
    });
}

function add_tag()
{
    new_title = $('#news_select').val();
    tag = $('#tag_select').val();
    $.ajax({
        url: "php/new_redact.php",
        method: "GET",
        data: 'function=add_tag&user=' + window.localStorage.getItem('login') + "&password=" + window.localStorage.getItem('password') + "&tag=" + tag + "&header=" + new_title,
        dataType: "html",
        success: function (data) {
            console.log(data);
        },
        error: function (error) {
            console.log(error);
        }
    });
}

function remove_tag()
{
    new_title = $('#news_select').val();
    tag = $('#tag_select').val();
    $.ajax({
        url: "php/new_redact.php",
        method: "GET",
        data: 'function=remove_tag&user=' + window.localStorage.getItem('login') + "&password=" + window.localStorage.getItem('password') + "&tag=" + tag + "&header=" + new_title,
        dataType: "html",
        success: function (data) {
            console.log(data);
        },
        error: function (error) {
            console.log(error);
        }
    });
}

function get_new()
{
    $.ajax({
        url: "php/new_redact.php",
        method: "GET",
        data: 'function=get_new&user=' + window.localStorage.getItem('login') + '&header=' + $('#news_select').val(),
        dataType: "html",
        success: function (data) {
            console.log(data);
            $("#header_redact").val($('#news_select').val());
            $("#text_redact").val(data);
        },
        error: function (error) {
            console.log(error);
        }
    });
}

$(document).ready(function () {
    if (window.localStorage.getItem('login') == '')
    {
        window.location.replace('http://localhost/news_list.html');
    }

    update_news_list();
    update_tags_list();
})