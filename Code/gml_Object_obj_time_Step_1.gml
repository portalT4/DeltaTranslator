// Prepended to vanilla Begin Step, before DELTARUNE reads its keyboard bindings.
if (!variable_global_exists("__dt_lang_index"))
{
    var _dt_languages = scr_dt_languages();
    global.__dt_lang_index = 0;
    global.__dt_language_picker = false;
    // Platform locale variants such as pt-BR and es-ES use the same translation target.
    var _dt_os_lang = string_copy(string_lower(os_get_language()), 1, 2);
    for (var _dt_language_i = 0; _dt_language_i < array_length(_dt_languages); _dt_language_i++)
    {
        if (_dt_os_lang != _dt_languages[_dt_language_i].code) continue;
        global.__dt_lang_index = _dt_language_i;
        break;
    }
}

var _dt_picker_was_open = global.__dt_language_picker;
if (!variable_global_exists("__dt_room") || global.__dt_room != room)
{
    scr_dt_clear();
    global.__dt_room = room;
    global.__dt_next_poll = 0;
    global.__dt_language_picker = false;
    global.lang_change_notif_timer = 0;
}

global.__dt_picker_captured = _dt_picker_was_open || keyboard_check_pressed(vk_f1);
if (global.__dt_picker_captured)
{
    scr_dt_update_language_picker();
    scr_dt_consume_picker_keys();
}
