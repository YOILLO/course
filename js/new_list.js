
function update_news(cat, tag)
{
    console.log("aaaaaa");
    $.ajax({
        url: "php/new_list.php",
        method: "GET",
        data: 'function=update_news&cat=' + cat + '&tag=' + tag + '&username=' + window.localStorage.getItem('login'),
        dataType: "html",
        success: function(data){
            console.log(data);
            $('#news_table').html(data);
        },
        error: function(error){
            console.log(error);
        }
    });
}

function category_function_generator(num)
{
    return function ()
    {
        $.ajax({
            url: "php/new_list.php",
            method: "GET",
            data: 'function=get_cat_' + num,
            dataType: "html",
            success: function(data){
                console.log(data);
                $('#category_' + num).val(data.trim())
            },
            error: function(error){
                console.log(error);
            }
        });
    }
}

function set_category(num)
{
    return function (){
        update_news(num, 'all');
    }
}

$(document).ready(function () {
    $('#redact').hide();
    for (let i = 1; i <= 4; i++) {
        $("#category_" + i).click(set_category(i));
        category_function_generator(i)();
    }
    $("#category_all").click(set_category('all'));

    update_news('all', 'all');

    if (window.localStorage.getItem('login') != '') {
        $.ajax({
            url: "php/new_list.php",
            method: "GET",
            data: 'function=can_write_news&user=' + window.localStorage.getItem('login'),
            dataType: "html",
            success: function (data) {
                console.log(data);
                if (data == '\r\nTrue')
                {
                    $('#redact').show();
                }
            },
            error: function (error) {
                console.log(error);
            }
        });
    }
})
