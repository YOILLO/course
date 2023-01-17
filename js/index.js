function send_register_message(login, password, fun)
{
    $.ajax({
        url: "php/index.php",
        method: "GET",
        data: 'function=' + fun + '&login=' + login + '&password=' + password,
        dataType: "html",
        success: function(data){
            console.log(data);
            if (data == '\r\nOK')
            {
                window.localStorage.setItem('login', login);
                window.localStorage.setItem('password', password);
                window.location.replace('http://localhost/news_list.html');
            }
            $('#error_msg').text(data);

        },
        error: function(error){
            console.log(error);
        }
    });
}

function register()
{
    login = $('#username-textinput').val();
    password = $('#password-textinput').val();
    send_register_message(login, password, 'register');
}

function send()
{
    login = $('#username-textinput').val();
    password = $('#password-textinput').val();
    send_register_message(login, password, 'send');
}

$(document).ready(function(){
    $("#register_button").click(register);
    $("#send_button").click(send);
    window.localStorage.clear();
})