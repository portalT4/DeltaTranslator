// Begin Step owns the picker keyboard input, including the frame on which it closes.
if (!variable_global_exists("__dt_room") || global.__dt_room != room) exit;

if (variable_global_exists("auto_trans_notif_timer") && global.auto_trans_notif_timer > 0)
    global.auto_trans_notif_timer -= 1;
if (variable_global_exists("autopos_notif_timer") && global.autopos_notif_timer > 0)
    global.autopos_notif_timer -= 1;
if (global.lang_change_notif_timer > 0) global.lang_change_notif_timer -= 1;

if (global.__dt_picker_captured) exit;

if (keyboard_check_pressed(vk_f3))
{
    if (!variable_global_exists("auto_translate"))
        global.auto_translate = false;
    
    global.auto_translate = !global.auto_translate;
    global.auto_trans_notif_timer = 2 * room_speed;
    scr_dt_clear();
    global.__dt_next_poll = 0;
    
    if (global.auto_translate)
        snd_play(snd_bell);
    else
        snd_play(snd_cantselect);
}

if (keyboard_check_pressed(vk_f2))
{
    if (!variable_global_exists("is_autopos"))
        global.is_autopos = false;
    
    global.is_autopos = !global.is_autopos;
    global.__dt_positions = array_create(11, undefined);
    global.autopos_notif_timer = 2 * room_speed;
    
    if (global.is_autopos)
        snd_play(snd_spearrise);
    else
        snd_play(snd_cantselect);
}

var _dt_auto = variable_global_exists("auto_translate") && global.auto_translate;
if (keyboard_check_pressed(vk_f6) && global.__dt_has_text)
{
    snd_play(snd_select);
    // Keep the source keys to avoid immediately bringing back the same text on the next poll.
    var _dt_lines = global.__dt_line_keys;
    var _dt_choices = global.__dt_choice_keys;
    var _dt_bubbles = global.__dt_bubbles;
    scr_dt_clear();
    global.__dt_line_keys = _dt_lines;
    global.__dt_choice_keys = _dt_choices;
    global.__dt_bubbles = _dt_bubbles;
    for (var _dt_i = 0; _dt_i < array_length(_dt_bubbles); _dt_i++)
    {
        var _dt_entry = _dt_bubbles[_dt_i];
        _dt_entry.request = -1;
        _dt_entry.translated = "";
    }
}

if (!_dt_auto && global.trans_timer > 0)
{
    global.trans_timer--;
    if (global.trans_timer <= 0) scr_dt_clear();
}

var _dt_manual = keyboard_check_pressed(vk_f5);
if (_dt_manual) snd_play(snd_select);
if (_dt_manual || (_dt_auto && current_time >= global.__dt_next_poll))
{
    global.__dt_next_poll = current_time + 150;
    scr_trigger_translation(_dt_manual);
}
