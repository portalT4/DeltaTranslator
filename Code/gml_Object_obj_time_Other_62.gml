// Ignore HTTP events from the game and responses belonging to a previous room.
if (!variable_global_exists("__dt_room") || global.__dt_room != room) exit;
var _dt_id = ds_map_find_value(async_load, "id");
if (!is_numeric(_dt_id) || _dt_id < 0) exit;

var _dt_slot = -1;
if (_dt_id == global.trans_main_id) _dt_slot = 0;
for (var _i = 0; _i < 10; _i++)
    if (_dt_id == global.trans_enemy_ids[_i]) _dt_slot = _i + 1;
for (var _i = 0; _i < 4; _i++)
    if (_dt_id == global.trans_choice_ids[_i]) _dt_slot = _i + 11;
var _dt_bubble = -1;
if (_dt_slot < 0)
{
    for (var _i = 0; _i < array_length(global.__dt_bubbles); _i++)
        if (_dt_id == global.__dt_bubbles[_i].request) _dt_bubble = _i;
    if (_dt_bubble < 0) exit;
    if (global.__dt_bubbles[_dt_bubble].deadline <= current_time) exit;
}

var _dt_status = ds_map_find_value(async_load, "status");
if (_dt_status > 0) exit;
var _dt_result = "";
var _dt_raw = ds_map_find_value(async_load, "result");
if (_dt_status == 0 && ds_map_find_value(async_load, "http_status") == 200 && is_string(_dt_raw))
{
    try
    {
        var _dt_json = json_parse(_dt_raw);
        if (is_array(_dt_json) && array_length(_dt_json) > 0 && is_array(_dt_json[0]))
        {
            var _dt_segments = _dt_json[0];
            for (var _i = 0; _i < array_length(_dt_segments); _i++)
            {
                var _dt_part = _dt_segments[_i];
                if (!is_array(_dt_part) || array_length(_dt_part) == 0 || !is_string(_dt_part[0])) continue;
                if (_dt_result != "" && string_char_at(_dt_result, string_length(_dt_result)) != " ") _dt_result += " ";
                _dt_result += _dt_part[0];
            }
        }
    }
    catch (_dt_error) { _dt_result = ""; }
}

if (_dt_bubble >= 0)
{
    var _dt_entry = global.__dt_bubbles[_dt_bubble];
    _dt_entry.translated = _dt_result;
    _dt_entry.request = -1;
    if (_dt_result != "") _dt_entry.deadline = current_time + 3000;
}
else if (_dt_slot == 0)
{
    global.trans_main_text = _dt_result;
    global.trans_main_id = -1;
}
else if (_dt_slot < 11)
{
    global.trans_enemy_texts[_dt_slot - 1] = _dt_result;
    global.trans_enemy_ids[_dt_slot - 1] = -1;
}
else
{
    global.trans_choice_texts[_dt_slot - 11] = _dt_result;
    global.trans_choice_ids[_dt_slot - 11] = -1;
}
