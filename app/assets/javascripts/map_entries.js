$(document).ready(function () {
    $("#map_entry_index_toggler").click(function () {
        window.history.pushState({type:"map_entries"}, "", "/map_entries");
        Map.init();
    });

    $(".map_container .menu_toggler").live("click", function () {
        Map.Menu.toggle();
    });

    $("#new_map_entry").live("click", function () {
        Map.Entry.new();
    });
});
Map = {
    Menu:{
        toggle:function () {
            if ($(".map_container .menu_toggler").hasClass("selected")) {
                $(".map_container .menu_toggler").removeClass("selected");
                $(".map_container .menu").hide("fade");
            } else {
                $(".map_container .menu_toggler").addClass("selected");
                $(".map_container .menu").show("fade");
            }
        }
    },
    watchId:null,
    self:null,

    //primary map toggler
    init:function () {
        $(".container").empty();
        $("#map_entries_index_template").tmpl().appendTo(".container");
        Map.self = $('#map_canvas').gmap("get", "map");
        navigator.geolocation.getCurrentPosition(Map.update_position, Map.error);
        fireable = true
        google.maps.event.addListener(Map.self, "bounds_changed", function (event) {
            //fire an update event in a couple of seconds
            if (fireable) {
                fireable = false;
                window.setTimeout("Map.Entries.get();fireable=true", 2000);
            }
        });
    },
    update_position:function (position) {
        //console.log(position);
        Main.user.set({lat:position.coords.latitude, lng:position.coords.longitude});
        Map.User.render();
        Map.center(Main.user.get("lat"), Main.user.get("lng"));
        //Map.Entries.get();

        //render events that already have been initialized
        $.each(Main.MapEntryList.models, function (index, value) {
            //make a marker
            icon = "/assets/imperka.jpg"
            console.log(value);
            value.attributes.marker = $('#map_canvas').gmap('addMarker', {
                'role':"event",
                'position':value.attributes.lat + "," + value.attributes.lng,
                'bounds':false,
                'title':value.attributes.title,
                'content':value.attributes.description,
                'icon':icon
            });
        });
    },
    error:function (error) {
        //alert("error");
        //console.log(error);
    },
    center:function (lat, lng) {
        Map.self.setOptions({center:new google.maps.LatLng(lat, lng), zoom:17});
    },
    User:{
        marker:null,
        render:function () {
            if (Main.user.attributes.gender == false) {
                icon = "/assets/user_female.png"
            } else {
                icon = "/assets/user_male.png"
            }
            Map.User.marker = $('#map_canvas').gmap('addMarker', {
                'role':"you",
                'position':Main.user.attributes.lat + "," + Main.user.attributes.lng,
                'bounds':false,
                'title':"you",
                'content':"you",
                'icon':icon
            });
        }
    },
    Entry:{
        post:function () {
            tinyMCE.activeEditor.save();
            Map.Entry.Form.Spinner.show();
            $.ajax({
                type:"POST",
                url:"/map_entries",
                data:$("#map_entry_form").serialize(),
                error:function (request, status, error) {
                    x_alert(request.responseText);
                    Map.Entry.Form.Spinner.hide();
                    //tinyMCE.activeEditor.setContent("");
                },
                success:function (msg) {
                    Map.Entry.Form.Spinner.hide();
                    Map.Entry.Form.hide();
                }
            });
        },
        new:function () {
            x_alert("Now, click anywhere on the map.");
            google.maps.event.addListener(Map.self, "click", function (event) {
                var lat = event.latLng.lat();
                var lng = event.latLng.lng();
                // populate yor box/field with lat, lng
                Map.Entry.Form.init(lat, lng);
                Map.Entry.Form.show();
            });
        },
        Form:{
            Spinner:{
                show:function () {
                    $("#map_entry_form_container .glass").show();
                },
                hide:function () {
                    $("#map_entry_form_container .glass").hide();
                }
            },
            init:function (lat, lng) {
                $("#map_entry_form_container").remove();
                $("#new_map_entry_form_template").tmpl({position:{lat:lat, lng:lng}}).appendTo(".container");
                $("#map_entry_form_container").draggable();
                editor_init("map_entry_description");
                google.maps.event.clearListeners(Map.self, 'click');
            },
            show:function () {
                $("#map_entry_form_container").show();
            },
            hide:function () {
                $("#map_entry_form_container").hide();
            }
        }
    },
    Entries:{
        get:function () {
            $.ajax({
                type:"get",
                url:"/map_entries",
                data:{"lo[lat]":Map.self.getBounds().getSouthWest().lat(),
                    "lo[lng]":Map.self.getBounds().getSouthWest().lng(),
                    "hi[lat]":Map.self.getBounds().getNorthEast().lat(),
                    "hi[lng]":Map.self.getBounds().getNorthEast().lng(),
                    "x":Main.MapEntryList.pluck("id")}
            }).done(function (msg) {
                    Main.MapEntryList.add(msg.map_entries);
                    Map.Entries.render();
                }
            );
        },
        render:function () {
            $.each(Main.MapEntryList.where({marker:null}), function (index, value) {
                //make a marker
                icon = "/assets/marker.png"
                value.attributes.marker = $('#map_canvas').gmap('addMarker', {
                    'role':"event",
                    'position':value.attributes.lat + "," + value.attributes.lng,
                    'bounds':false,
                    'title':value.attributes.title,
                    'content':value.attributes.description,
                    'icon':icon
                });
            });
            //make list entries
            $(".event_list_container").empty();
            $.each(Main.MapEntryList.models, function (index, value) {
                $("#map_list_entry_template").tmpl(value.attributes).appendTo(".event_list_container");
            });
        }
    }
}