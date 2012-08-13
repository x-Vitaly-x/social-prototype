// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
// require_tree .
var chat_message = Backbone.Model.extend({
    initialize:function () {
        // alert("Welcome to this action");
    }
});
var comment = Backbone.Model.extend({
    defaults:{
        id:0,
        hide_answers:true
    },
    initialize:function () {
        this.CommentList = new CommentList();
        // alert("Welcome to this action");
    }
});
var news_entry = Backbone.Model.extend({
    initialize:function () {
        this.CommentList = new CommentList();
        // alert("Welcome to this action");
    }
});
var map_entry = Backbone.Model.extend({
    defaults:{
        id:'0',
        marker:null
    },
    initialize:function () {
        this.CommentList = new CommentList();
        // alert("Welcome to this action");
    }
});
var albumx = Backbone.Model.extend({
    defaults:{
        id:'0'
    },
    initialize:function (data) {
        if (typeof(data) != "undefined") {
            this.PhotoList = new PhotoList(data.images);
        } else {
            this.PhotoList = new PhotoList();
        }
        // alert("Welcome to this action");
    }
});
var imagex = Backbone.Model.extend({
    defaults:{
        id:'0'
    },
    initialize:function (data) {
        this.CommentList = new CommentList();
    }
});

//*******************************************************************************
//core collections
var ChatMessageList = Backbone.Collection.extend({
    model:chat_message
});
var NewsEntryList = Backbone.Collection.extend({
    model:news_entry
});
var CommentList = Backbone.Collection.extend({
    model:comment
});
var MapEntryList = Backbone.Collection.extend({
    model:map_entry,
    comparator:function (event) {
        return -event.get("id");
    }
});
var AlbumList = Backbone.Collection.extend({
    model:albumx,
    comparator:function (event) {
        return event.get("position");
    }
});
var PhotoList = Backbone.Collection.extend({
    model:imagex,
    comparator:function (event) {
        return event.get("position");
    }
});
user = Backbone.Model.extend({

    defaults:{
        id:'0',
        lat:0,
        lng:0
    },
    initialize:function () {
        this.AlbumList = new AlbumList();
        this.PhotoList = new PhotoList();
    }
});
var UserList = Backbone.Collection.extend({
    model:user,
    defaults:{
        id:0
    }
});
main = Backbone.Model.extend({

    defaults:{
        id:'0'
    },
    initialize:function () {
        this.socket = io.connect("http://x-chat-server-x.herokuapp.com:80");
        this.image_tmp = new imagex();
        this.user = new user();// you
        this.user_tmp = new user();// anyone
        this.TmpCommentList = new CommentList();// temporary comment list for entry/image/etc comments
        this.TmpAlbumList = new AlbumList();// temporary album list
        this.TmpUserList = new UserList();// temporary user list
        this.album_tmp = new albumx();
        this.ChatMessageList = new ChatMessageList();
        this.NewsEntryList = new NewsEntryList();
        this.OnlineList = new Backbone.Collection();
        this.CommentList = new CommentList();// global comment list for all comments
        this.MapEntryList = new MapEntryList();
    },
    get_user_tmp:function (id) {
        // either get a new user from the list, or initialize him
        u = Main.TmpUserList.get(id);
        if (typeof(u) == "undefined") {
            // not initialized
            u = new user({id:id});
        }
        return u;
    }
});

var Main = new main();