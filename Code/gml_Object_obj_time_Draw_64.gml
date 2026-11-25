// Rooms can draw before their first Step, including installation/loading screens.
if (!variable_global_exists("__dt_room") || global.__dt_room != room) exit;
if (!global.__dt_language_picker && !global.__dt_has_text &&
    !(variable_global_exists("lang_change_notif_timer") && global.lang_change_notif_timer > 0) &&
    !(variable_global_exists("autopos_notif_timer") && global.autopos_notif_timer > 0) &&
    !(variable_global_exists("auto_trans_notif_timer") && global.auto_trans_notif_timer > 0)) exit;

var _dt_saved_font = draw_get_font();
var _dt_saved_color = draw_get_color();
var _dt_saved_alpha = draw_get_alpha();
var _dt_saved_halign = draw_get_halign();
var _dt_saved_valign = draw_get_valign();
var _dt_saved_texfilter = gpu_get_texfilter();
gpu_set_texfilter(false);
draw_set_alpha(1);

var _dt_language = scr_dt_language();
var _dt_font = scr_dt_overlay_font(_dt_language.code);

var _dt_view = scr_dt_viewport();
var has_battle_controller = false;

if (object_exists(obj_battlecontroller))
    has_battle_controller = instance_exists(obj_battlecontroller);

var has_legend_cutscene = false;
var legend_asset = asset_get_index("obj_legend");

if (legend_asset >= 0 && instance_exists(legend_asset))
    has_legend_cutscene = true;

var intro_asset = asset_get_index("obj_intro");

if (intro_asset >= 0 && instance_exists(intro_asset))
    has_legend_cutscene = true;

var is_autopos_active = false;

if (variable_global_exists("is_autopos") && global.is_autopos == true)
{
    if (!has_battle_controller && !has_legend_cutscene)
        is_autopos_active = true;
}

var t_scale = 1;
var base_w = 380;
var base_sep = 20;

if (is_autopos_active)
{
    t_scale = 1.6;
    base_w = 342;
    base_sep = 20 / t_scale;
}

var _main_position = [false, false, 0, 0];
if (variable_global_exists("trans_main_text") && global.trans_main_text != "")
    _main_position = scr_dt_dialogue_position(0, _dt_view, is_autopos_active);
if (_main_position[0])
{
    draw_set_font(_dt_font);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var wx = 10;
    var wy = 10;
    var _main_wrap = base_w;
    var _main_scale = t_scale;
    var _left = 10;
    var _top = 10;
    var _right = 630;
    var _bottom = 470;
    if (is_autopos_active)
    {
        _left = _dt_view[5] + 10;
        _top = _dt_view[6] + 10;
        _right = _dt_view[5] + _dt_view[7] - 10;
        _bottom = _dt_view[6] + _dt_view[8] - 10;
        wx = _main_position[1] ? clamp(_main_position[2], _left, max(_left, _right - 100)) : _left;
        wy = _main_position[1] ? max(_top, _main_position[3]) : _top;
        _main_wrap = min(_main_wrap, (_right - wx) / _main_scale);
    }
    var _width = string_width_ext(global.trans_main_text, base_sep, _main_wrap);
    var _height = string_height_ext(global.trans_main_text, base_sep, _main_wrap);
    if (is_autopos_active)
        _main_scale = min(_main_scale, (_right - wx) / max(1, _width), (_bottom - _top) / max(1, _height));
    var mw = _width * _main_scale;
    var mh = _height * _main_scale;
    wx = clamp(wx, _left, max(_left, _right - mw));
    wy = clamp(wy, _top, max(_top, _bottom - mh));
    var bx = wx - 8;
    var by = wy - 8;
    draw_sprite_ext(spr_pxwhite, 0, bx, by, mw + 16, mh + 16, 0, c_black, 0.75);
    draw_set_color(c_black);
    draw_text_ext_transformed(wx + (2 * _main_scale), wy + (2 * _main_scale), global.trans_main_text, base_sep, _main_wrap, _main_scale, _main_scale, 0);
    draw_set_color(c_yellow);
    draw_text_ext_transformed(wx, wy, global.trans_main_text, base_sep, _main_wrap, _main_scale, _main_scale, 0);
}

if (variable_global_exists("trans_enemy_texts"))
{
    var e_colors = [255, 16776960, 65280, 42495, 13353215, 65535, 16711935, 16777215, 8388736, 8421376];
    var ey = 10;
    for (var m = 0; m < 10; m++)
    {
        var etext = global.trans_enemy_texts[m];
        
        if (etext != "")
        {
            var _position = scr_dt_dialogue_position(m + 1, _dt_view, is_autopos_active);
            if (!_position[0]) continue;
            draw_set_font(_dt_font);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            var base_ew = 220 / t_scale;
            var base_esep = 20 / t_scale;
            var ew = string_width_ext(etext, base_esep, base_ew) * t_scale;
            var eh = string_height_ext(etext, base_esep, base_ew) * t_scale;
            var ex = 630 - ew - 16;
            var ey_draw = ey;
            
            var _dt_follow = _position[1];
            if (_dt_follow)
            {
                ex = clamp(_position[2], _dt_view[5] + 10,
                    max(_dt_view[5] + 10, _dt_view[5] + _dt_view[7] - ew - 10));
                ey_draw = clamp(_position[3], _dt_view[6] + 10,
                    max(_dt_view[6] + 10, _dt_view[6] + _dt_view[8] - eh - 18));
            }
            if (!_dt_follow)
            {
                ex = clamp(ex, 10, max(10, 640 - ew - 10));
                ey_draw = clamp(ey_draw, 10, max(10, 480 - eh - 10));
            }
            var bx = ex - 8;
            var by = ey_draw;
            
            if (_dt_follow)
                by = ey_draw - 8;
            
            draw_sprite_ext(spr_pxwhite, 0, bx, by, ew + 16, eh + 16, 0, c_black, 0.75);
            draw_set_color(c_black);
            draw_text_ext_transformed(ex + (2 * t_scale), ey_draw + 8 + (2 * t_scale), etext, base_esep, base_ew, t_scale, t_scale, 0);
            draw_set_color(e_colors[m]);
            draw_text_ext_transformed(ex, ey_draw + 8, etext, base_esep, base_ew, t_scale, t_scale, 0);
            ey += (eh + 24);
        }
    }
}

if (variable_global_exists("trans_choice_texts"))
{
    var grid_x = [60, 360, 210, 210];
    var grid_y = [385, 385, 345, 425];
    var choicer_y_offset = 0;
    
    if (_dt_view[0] && instance_exists(obj_writer) && !has_battle_controller && !has_legend_cutscene)
    {
        var _dt_dialogue = global.__dt_writers[0];
        if (_dt_dialogue != noone && instance_exists(_dt_dialogue) &&
            _dt_dialogue.y - _dt_view[2] < 200 && _dt_dialogue.x - _dt_view[1] < 150)
            choicer_y_offset = -300;
    }

    for (var c = 0; c < 4; c++)
    {
        var ctext = global.trans_choice_texts[c];
        
        if (ctext != "")
        {
                draw_set_font(_dt_font);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            var base_cw = 220 / t_scale;
            var base_ceh = 20 / t_scale;
            var cw = string_width_ext(ctext, base_ceh, base_cw) * t_scale;
            var eh = string_height_ext(ctext, base_ceh, base_cw) * t_scale;
            var cx = grid_x[c];
            var cy = grid_y[c] + choicer_y_offset;
            
            if (c == 0)
                cx = 170 - (cw / 2);
            
            if (c == 1)
                cx = 470 - (cw / 2);
            
            if (c == 2 || c == 3)
                cx = 320 - (cw / 2);
            
            cx = clamp(cx, 10, 640 - cw - 10);
            cy = clamp(cy, 10, 480 - eh - 10);
            draw_sprite_ext(spr_pxwhite, 0, cx - 8, cy - 4, cw + 16, eh + 8, 0, c_black, 0.75);
            draw_set_color(c_black);
            draw_text_ext_transformed(cx + (2 * t_scale), cy + (2 * t_scale), ctext, base_ceh, base_cw, t_scale, t_scale, 0);
            draw_set_color(c_aqua);
            draw_text_ext_transformed(cx, cy, ctext, base_ceh, base_cw, t_scale, t_scale, 0);
        }
    }
}

// Project nearby captions through the same world-to-GUI transform as speech bubbles.
if (_dt_view[0] && array_length(global.__dt_bubbles) > 0)
{
    var _dt_world_x = _dt_view[1];
    var _dt_world_y = _dt_view[2];
    var _dt_world_w = _dt_view[3];
    var _dt_world_h = _dt_view[4];
    var _dt_port_x = _dt_view[5];
    var _dt_port_y = _dt_view[6];
    var _dt_port_w = _dt_view[7];
    var _dt_port_h = _dt_view[8];
    for (var _dt_i = 0; _dt_i < array_length(global.__dt_bubbles); _dt_i++)
    {
        var _dt_entry = global.__dt_bubbles[_dt_i];
        if (_dt_entry.deadline <= current_time || _dt_entry.translated == "") continue;
        var _dt_inst = _dt_entry.instance;
        var _dt_below = _dt_entry.kind == 3;
        if (_dt_inst != noone && instance_exists(_dt_inst))
        {
            if (!_dt_inst.visible) continue;
            if (_dt_entry.kind != 0)
            {
                if (scr_dt_caption_source(_dt_inst, _dt_entry.kind) != _dt_entry.source) continue;
            }
            var _dt_bubble_x = _dt_inst.x;
            var _dt_bubble_y = _dt_inst.y;
            var _dt_parallax = scr_dt_numeric_field(_dt_inst, "parallax_depth", 0);
            if (_dt_parallax > 0)
            {
                var _dt_center_x = _dt_world_x + _dt_world_w / 2;
                var _dt_center_y = _dt_world_y + _dt_world_h / 2;
                var _dt_plat_type = asset_get_index("obj_plat_camera");
                if (_dt_plat_type >= 0 && object_exists(_dt_plat_type))
                {
                    var _dt_plat = instance_find(_dt_plat_type, 0);
                    if (_dt_plat != noone && instance_exists(_dt_plat))
                    {
                        _dt_center_x = _dt_plat.x;
                        _dt_center_y = _dt_plat.y;
                    }
                }
                _dt_bubble_x = lerp(_dt_bubble_x, _dt_center_x, 1 - _dt_parallax);
                _dt_bubble_y = lerp(_dt_bubble_y, _dt_center_y, 1 - _dt_parallax);
            }
            _dt_entry.anchor_x = _dt_bubble_x;
            _dt_entry.anchor_y = _dt_bubble_y - scr_dt_bubble_top_margin(_dt_inst);
            if (_dt_below)
            {
                // Smallface text starts 70 pixels right of the mini portrait.
                _dt_entry.anchor_x = _dt_bubble_x + 84;
                _dt_entry.anchor_y = _dt_bubble_y + 34;
            }
        }
        else if (_dt_entry.kind != 0) continue;

        // Only legacy world bubbles can keep their last anchor after expiration.
        var _dt_anchor_x = _dt_port_x + (_dt_entry.anchor_x - _dt_world_x) * _dt_port_w / _dt_world_w;
        var _dt_anchor_y = _dt_port_y + (_dt_entry.anchor_y - _dt_world_y) * _dt_port_h / _dt_world_h;
        if (_dt_anchor_x < _dt_port_x || _dt_anchor_x > _dt_port_x + _dt_port_w ||
            _dt_anchor_y < _dt_port_y || _dt_anchor_y > _dt_port_y + _dt_port_h) continue;
        draw_set_font(_dt_font);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        var _dt_wrap = min(_dt_below ? 220 : 320, _dt_port_w - 32);
        var _dt_width = string_width_ext(_dt_entry.translated, 20, _dt_wrap) + 16;
        var _dt_height = string_height_ext(_dt_entry.translated, 20, _dt_wrap) + 12;
        var _dt_left = clamp(_dt_anchor_x - _dt_width / 2, _dt_port_x + 4,
            max(_dt_port_x + 4, _dt_port_x + _dt_port_w - _dt_width - 4));
        var _dt_top = _dt_below ? _dt_anchor_y + 4 : _dt_anchor_y - _dt_height - 8;
        _dt_top = clamp(_dt_top, _dt_port_y + 4,
            max(_dt_port_y + 4, _dt_port_y + _dt_port_h - _dt_height - 4));
        draw_sprite_ext(spr_pxwhite, 0, _dt_left, _dt_top, _dt_width, _dt_height, 0, c_black, 0.85);
        draw_set_color(c_lime);
        draw_text_ext(_dt_left + 8, _dt_top + 6, _dt_entry.translated, 20, _dt_wrap);
    }
}

if (variable_global_exists("lang_change_notif_timer") && global.lang_change_notif_timer > 0)
{
    var draw_alpha = clamp(global.lang_change_notif_timer / max(1, room_speed / 2), 0, 1);
    draw_set_font(_dt_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    var notif_str = _dt_language.changed + " " + _dt_language.label;
    draw_set_color(c_black);
    draw_set_alpha(draw_alpha);
    draw_text(321, 371, notif_str);
    draw_set_color(c_aqua);
    draw_text(320, 370, notif_str);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (variable_global_exists("autopos_notif_timer") && global.autopos_notif_timer > 0)
{
    var alpha = global.autopos_notif_timer / (2 * room_speed);
    var pulse = 0.7 + (0.3 * sin(global.autopos_notif_timer * 0.15));
    var draw_alpha = alpha * pulse;
    draw_set_font(_dt_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    var notif_str = (_dt_language.pos_caption + ": " + _dt_language.disabled);
    var notif_col = 255;
    
    if (global.is_autopos)
    {
        notif_str = (_dt_language.pos_caption + ": " + _dt_language.enabled);
        notif_col = 65280;
    }
    
    draw_set_color(c_black);
    draw_set_alpha(draw_alpha);
    draw_text(321, 401, notif_str);
    draw_set_color(notif_col);
    draw_text(320, 400, notif_str);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (variable_global_exists("auto_trans_notif_timer") && global.auto_trans_notif_timer > 0)
{
    var alpha = global.auto_trans_notif_timer / (2 * room_speed);
    var pulse = 0.7 + (0.3 * sin(global.auto_trans_notif_timer * 0.15));
    var draw_alpha = alpha * pulse;
    draw_set_font(_dt_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    var notif_str = (_dt_language.auto_caption + ": " + _dt_language.disabled);
    var notif_col = 255;
    
    if (global.auto_translate)
    {
        notif_str = (_dt_language.auto_caption + ": " + _dt_language.enabled);
        notif_col = 65280;
    }
    
    draw_set_color(c_black);
    draw_set_alpha(draw_alpha);
    draw_text(321, 431, notif_str);
    draw_set_color(notif_col);
    draw_text(320, 430, notif_str);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (global.__dt_language_picker) scr_dt_draw_language_picker(_dt_language);

draw_set_font(_dt_saved_font);
draw_set_color(_dt_saved_color);
draw_set_alpha(_dt_saved_alpha);
draw_set_halign(_dt_saved_halign);
draw_set_valign(_dt_saved_valign);
gpu_set_texfilter(_dt_saved_texfilter);
