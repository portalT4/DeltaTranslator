var _dt_saved_font = draw_get_font();
var _dt_saved_color = draw_get_color();
var _dt_saved_alpha = draw_get_alpha();
var _dt_saved_halign = draw_get_halign();
var _dt_saved_valign = draw_get_valign();
var _dt_saved_texfilter = gpu_get_texfilter();
gpu_set_texfilter(false);
var _dt_language = scr_dt_language();
draw_set_font(scr_dt_overlay_font(_dt_language.code));
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var box_x1 = 215;
var box_y1 = 4;
var box_x2 = 316;
var box_y2 = 100;
draw_set_alpha(0.65);
draw_rectangle_color(box_x1, box_y1, box_x2, box_y2, c_black, c_black, c_black, c_black, false);
draw_set_alpha(0.8);
draw_rectangle_color(box_x1, box_y1, box_x2, box_y2, c_white, c_white, c_white, c_white, true);
draw_set_alpha(1);
var text_scale = 0.5;
var str_title = _dt_language.title + ":";
var str_f5 = "F5: " + _dt_language.translate;
var str_f6 = "F6: " + _dt_language.hide;
var str_f3 = "F3: " + _dt_language.auto_caption;
var str_f2 = "F2: " + _dt_language.pos_caption;
var str_f1 = "F1: " + _dt_language.picker_title;
var str_on = _dt_language.enabled;
var str_off = _dt_language.disabled;

draw_set_color(c_yellow);
draw_text_transformed(box_x1 + 6, box_y1 + 4, str_title, text_scale, text_scale, 0);
draw_set_color(c_white);
draw_text_transformed(box_x1 + 6, box_y1 + 15, str_f5, text_scale, text_scale, 0);
draw_text_transformed(box_x1 + 6, box_y1 + 25, str_f6, text_scale, text_scale, 0);
draw_text_transformed(box_x1 + 6, box_y1 + 35, str_f3, text_scale, text_scale, 0);
draw_text_transformed(box_x1 + 6, box_y1 + 45, str_f2, text_scale, text_scale, 0);
draw_text_transformed(box_x1 + 6, box_y1 + 55, str_f1, text_scale, text_scale, 0);
draw_set_color(make_color_rgb(241, 156, 187));
var is_auto_on = str_off;
var status_color = 255;

if (variable_global_exists("auto_translate"))
{
    if (global.auto_translate == true)
    {
        is_auto_on = str_on;
        status_color = 65280;
    }
}

draw_text_transformed(box_x1 + 6, box_y1 + 66, _dt_language.auto_caption + ":", text_scale, text_scale, 0);
draw_set_color(status_color);
draw_text_transformed(box_x2 - 6 - string_width(is_auto_on) * text_scale, box_y1 + 66, is_auto_on, text_scale, text_scale, 0);
draw_set_color(make_color_rgb(241, 156, 187));
var is_pos_on = str_off;
var pos_color = 255;

if (variable_global_exists("is_autopos"))
{
    if (global.is_autopos == true)
    {
        is_pos_on = str_on;
        pos_color = 65280;
    }
}

draw_text_transformed(box_x1 + 6, box_y1 + 76, _dt_language.pos_caption + ":", text_scale, text_scale, 0);
draw_set_color(pos_color);
draw_text_transformed(box_x2 - 6 - string_width(is_pos_on) * text_scale, box_y1 + 76, is_pos_on, text_scale, text_scale, 0);
draw_set_color(c_aqua);
draw_text_transformed(box_x1 + 6, box_y1 + 86, _dt_language.label, text_scale, text_scale, 0);
draw_set_font(_dt_saved_font);
draw_set_color(_dt_saved_color);
draw_set_alpha(_dt_saved_alpha);
draw_set_halign(_dt_saved_halign);
draw_set_valign(_dt_saved_valign);
gpu_set_texfilter(_dt_saved_texfilter);
