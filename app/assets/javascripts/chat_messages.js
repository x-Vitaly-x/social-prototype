$(document).ready(function () {
    Chat.init();
    Chat.get();
    chat_message_update_fired = false;
    var chat_message_update_fired = false;
    $("#lines").scroll(function () {
        h = scrollBottom($("#lines"));
        //console.log(h);
        if (h < 20) {
            //get new messages
            if (!chat_message_update_fired) {
                Chat.get();
                chat_message_update_fired = true;
            }
        } else {
            chat_message_update_fired = false;
        }
    });
});
Chat = {
    socket:"",
    offset:0,
    finished:false,
    init:function () {
        console.log(io);
        Main.socket.on('connect', function () {
            $('#chat').addClass('connected');
        });
        Main.socket.on('announcement', function (msg) {
            console.log("announcement");
            console.log(msg);
            Chat.Message.render_new({avatar:"/assets/message_information.png",content:msg});
        });
        Main.socket.on('nicknames', function (nicknames) {
            console.log("nicknames");
            console.log(nicknames);
            //console.log(Object.keys(nicknames).length);
            //console.log(nicknames.length);
            $(".online_counter").text("Online (" + Object.keys(nicknames).length + ") :")
            for (var i in nicknames) {
                Chat.Nickname.set(nicknames[i]);
            }
        });
// listen to chat messages
        Main.socket.on('chat/general', function (from, msg) {
            console.log("chat");
            console.log(msg);
            Chat.Message.render_new(msg);
        });
        Main.socket.on('reconnect', function () {
            console.log("reconnect");
            /*Chat.Message.render_new({
                content:'Reconnected to the server'
            });  */
        });
        Main.socket.on('reconnecting', function () {
            console.log("reconnecting");
            /*Chat.Message.render_new({
                content:'Attempting to re-connect to the server'
            });   */
        });
        Main.socket.on('error', function (e) {
            console.log("error");
            console.log(e);
            Chat.Message.render_new(e ? e : {
                content:'A unknown error occurred'
            });
        });
    },
    get:function () {
        if (!Chat.finished) {
            Chat.Spinner.show();
            $.ajax({
                type:"GET",
                url:"/chat_messages",
                data:"offset=" + Chat.offset
            }).done(function (msg) {

                    if (msg.messages.length != 0) {
                        Main.ChatMessageList = new ChatMessageList(msg.messages);
                        Chat.offset = msg.offset
                        $.each(Main.ChatMessageList.models, function (index, value) {
                            Chat.Message.render(value.attributes);
                        });
                        Chat.Spinner.hide();
                    } else {
                        Chat.finished = true;
                        Chat.Spinner.hide();
                    }

                }
            );
        }
    },
    Nickname:{
        set:function (nickname) {
            Main.OnlineList.add({id:nickname})
        }
    },
    Message:{
        post:function () {
            Chat.Spinner.show();
            $.ajax({
                type:"POST",
                url:"/chat_messages",
                data:"message=" + $("#message").val(),
                success:function () {
                    Chat.Spinner.hide();
                    $("#message").val("");
                },
                error:function (request, status, error) {
                    alert(request.responseText);
                    Chat.Spinner.hide();
                    $("#message").val("");
                }

            });
            return false;
        },
        render:function (msg) {
            //console.log(msg);
            $("#chat_message_template").tmpl({message:msg}).appendTo('#lines .messages_container');
        },
        render_new:function (msg) {
            //console.log(from);
            //console.log(msg);
            $("#chat_message_template").tmpl({message:msg}).prependTo('#lines .messages_container');
        }
    },
    Spinner:{
        show:function () {
            $(".right_panel .glass").show();
        },
        hide:function () {
            $(".right_panel .glass").hide();
        }
    }
};



