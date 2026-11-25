// The picker, status panel and requests all use this one language list.
function scr_dt_languages()
{
    if (!variable_global_exists("__dt_languages"))
    {
        global.__dt_languages = [
            { code: "ru", label: "Русский", title: "Google Переводчик", translate: "Перевести", hide: "Скрыть перевод", auto_caption: "Автоперевод", pos_caption: "Автопозиция", picker_title: "Язык перевода", enabled: "ВКЛ", disabled: "ВЫКЛ", loading: "Перевожу...", changed: "Язык:", picker_hint: "Стрелки + Enter / 1-9   F1: закрыть" },
            { code: "es", label: "Español", title: "Traductor Google", translate: "Traducir", hide: "Ocultar trad.", auto_caption: "Autotraducción", pos_caption: "Autoposición", picker_title: "Idioma", enabled: "ACT", disabled: "DES", loading: "Traduciendo...", changed: "Idioma:", picker_hint: "Flechas + Enter / 1-9   F1: cerrar" },
            { code: "pt", label: "Português (Brasil)", title: "Google Tradutor", translate: "Traduzir", hide: "Ocultar tradução", auto_caption: "Tradução auto.", pos_caption: "Autoposição", picker_title: "Idioma", enabled: "LIG", disabled: "DES", loading: "Traduzindo...", changed: "Idioma:", picker_hint: "Setas + Enter / 1-9   F1: fechar" },
            { code: "de", label: "Deutsch", title: "Google Übersetzer", translate: "Übersetzen", hide: "Übers. ausblenden", auto_caption: "Auto-Übersetzung", pos_caption: "Auto-Position", picker_title: "Zielsprache", enabled: "EIN", disabled: "AUS", loading: "Übersetzen...", changed: "Sprache:", picker_hint: "Pfeile + Enter / 1-9   F1: schließen" },
            { code: "pl", label: "Polski", title: "Tłumacz Google", translate: "Przetłumacz", hide: "Ukryj tłumaczenie", auto_caption: "Autotłumaczenie", pos_caption: "Autopozycja", picker_title: "Język tłumaczenia", enabled: "WŁ.", disabled: "WYŁ.", loading: "Tłumaczenie...", changed: "Język:", picker_hint: "Strzałki + Enter / 1-9   F1: zamknij" },
            { code: "uk", label: "Українська", title: "Google Перекладач", translate: "Перекласти", hide: "Сховати переклад", auto_caption: "Автопереклад", pos_caption: "Автопозиція", picker_title: "Мова перекладу", enabled: "УВІМ", disabled: "ВИМК", loading: "Перекладаю...", changed: "Мова:", picker_hint: "Стрілки + Enter / 1-9   F1: закрити" },
            { code: "tr", label: "Türkçe", title: "Google Çeviri", translate: "Çevir", hide: "Çeviriyi gizle", auto_caption: "Oto. çeviri", pos_caption: "Oto. konum", picker_title: "Çeviri dili", enabled: "AÇIK", disabled: "KAPALI", loading: "Çevriliyor...", changed: "Dil:", picker_hint: "Oklar + Enter / 1-9   F1: kapat" },
            { code: "it", label: "Italiano", title: "Google Traduttore", translate: "Traduci", hide: "Nascondi trad.", auto_caption: "Traduz. auto.", pos_caption: "Posizione auto.", picker_title: "Lingua", enabled: "ATT", disabled: "DIS", loading: "Traduzione...", changed: "Lingua:", picker_hint: "Frecce + Invio / 1-9   F1: chiudi" },
            { code: "fr", label: "Français", title: "Google Traduction", translate: "Traduire", hide: "Masquer trad.", auto_caption: "Traduction auto", pos_caption: "Position auto.", picker_title: "Langue cible", enabled: "ACT", disabled: "DÉS", loading: "Traduction...", changed: "Langue :", picker_hint: "Flèches + Entrée / 1-9   F1 : fermer" }
        ];
    }
    return global.__dt_languages;
}

function scr_dt_language()
{
    var _languages = scr_dt_languages();
    var _index = variable_global_exists("__dt_lang_index") ? global.__dt_lang_index : 0;
    return _languages[_index];
}

// Called with raw input, before the game polls it in obj_time Begin Step.
function scr_dt_update_language_picker()
{
    if (keyboard_check_pressed(vk_f1))
    {
        global.__dt_language_picker = !global.__dt_language_picker;
        if (global.__dt_language_picker) global.__dt_picker_focus = global.__dt_lang_index;
        snd_play(snd_select);
        return;
    }

    if (global.__dt_language_picker)
    {
        var _dt_count = array_length(scr_dt_languages());
        var _dt_focus = global.__dt_picker_focus;
        var _dt_col = _dt_focus mod 3;
        var _dt_row = _dt_focus div 3;
        var _dt_rows = ceil(_dt_count / 3);
        if (keyboard_check_pressed(vk_left)) _dt_col = (_dt_col + 2) mod 3;
        else if (keyboard_check_pressed(vk_right)) _dt_col = (_dt_col + 1) mod 3;
        else if (keyboard_check_pressed(vk_up)) _dt_row = (_dt_row + _dt_rows - 1) mod _dt_rows;
        else if (keyboard_check_pressed(vk_down)) _dt_row = (_dt_row + 1) mod _dt_rows;

        var _dt_next_focus = min(_dt_count - 1, _dt_row * 3 + _dt_col);
        if (_dt_next_focus != _dt_focus)
        {
            global.__dt_picker_focus = _dt_next_focus;
            snd_play(snd_select);
        }

        var _dt_selected = -1;
        for (var _dt_pick = 0; _dt_pick < _dt_count; _dt_pick++)
        {
            if (!keyboard_check_pressed(ord("1") + _dt_pick) &&
                !keyboard_check_pressed(vk_numpad1 + _dt_pick)) continue;
            _dt_selected = _dt_pick;
            break;
        }
        if (_dt_selected < 0 && keyboard_check_pressed(vk_enter))
            _dt_selected = global.__dt_picker_focus;

        if (_dt_selected >= 0)
        {
            global.__dt_language_picker = false;
            snd_play(snd_select);
            if (global.__dt_lang_index != _dt_selected)
            {
                global.__dt_lang_index = _dt_selected;
                global.lang_change_notif_timer = 2 * room_speed;
                // Drop cached text and outstanding response IDs for the old language.
                scr_dt_clear();
                global.__dt_next_poll = 0;
            }
        }
        return;
    }
}

function scr_dt_consume_picker_keys()
{
    // keyboard_clear also suppresses held keys until they are lifted. Clearing on
    // the closing frame keeps Enter/number/arrow presses from reaching the game.
    for (var _key = 2; _key < 256; _key++)
        if (keyboard_check(_key) || keyboard_check_pressed(_key) || keyboard_check_released(_key))
            keyboard_clear(_key);
    keyboard_clear(vk_anykey);
    keyboard_key = vk_nokey;
    keyboard_lastkey = vk_nokey;
    keyboard_lastchar = "";
}

function scr_dt_overlay_font(_code)
{
    return _code == "ru" ? fnt_dt_overlay_ru : fnt_dt_overlay;
}

// Called from the overlay's Draw GUI event; the caller restores the draw state.
function scr_dt_draw_language_picker(_current)
{
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _scale = min(1, min(_gui_w / 420, _gui_h / 154));
    var _x = floor((_gui_w - 404 * _scale) / 2);
    var _y = floor((_gui_h - 138 * _scale) / 2);
    var _languages = scr_dt_languages();

    draw_set_alpha(1);
    draw_set_font(fnt_dt_overlay);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + 404 * _scale, _y + 138 * _scale, false);
    draw_set_color(c_white);
    draw_rectangle(_x, _y, _x + 404 * _scale, _y + 138 * _scale, true);
    draw_set_color(c_yellow);
    draw_text_transformed(_x + 14 * _scale, _y + 8 * _scale, _current.picker_title, _scale, _scale, 0);

    for (var _i = 0; _i < array_length(_languages); _i++)
    {
        var _entry = _languages[_i];
        var _ix = _x + (12 + (_i mod 3) * 128) * _scale;
        var _iy = _y + (35 + (_i div 3) * 25) * _scale;
        var _active = _entry.code == _current.code;
        if (_active)
        {
            draw_set_color(make_color_rgb(17, 58, 62));
            draw_rectangle(_ix, _iy, _ix + 124 * _scale, _iy + 21 * _scale, false);
        }
        if (_i == global.__dt_picker_focus)
        {
            draw_set_color(c_yellow);
            draw_rectangle(_ix, _iy, _ix + 124 * _scale, _iy + 21 * _scale, true);
        }
        draw_set_color(_active ? c_aqua : c_white);
        var _text_scale = 0.65 * _scale;
        draw_text_transformed(_ix + 4 * _scale, _iy + 3 * _scale,
            string(_i + 1) + ". " + _entry.label, _text_scale, _text_scale, 0);
    }
    draw_set_color(c_silver);
    draw_text_transformed(_x + 14 * _scale, _y + 116 * _scale, _current.picker_hint,
        0.7 * _scale, 0.7 * _scale, 0);
}

// Collect the same visible-text candidates for manual and automatic translation.
function scr_dt_instance_text(_inst)
{
    var _fields = ["originalstring", "mystring", "myString", "mytext", "text"];
    for (var _i = 0; _i < array_length(_fields); _i++)
    {
        if (!variable_instance_exists(_inst, _fields[_i])) continue;
        var _value = variable_instance_get(_inst, _fields[_i]);
        if (is_string(_value) && _value != "") return _value;
    }
    return "";
}

function scr_dt_view_origin()
{
    var _camera = camera_get_active();
    if (_camera < 0 && view_enabled) _camera = view_get_camera(0);
    if (_camera < 0) return [false, 0, 0];
    return [true, camera_get_view_x(_camera), camera_get_view_y(_camera)];
}

// Visible camera and its destination rectangle in GUI coordinates.
function scr_dt_viewport()
{
    var _dt_cam = camera_get_active();
    var _dt_primary_view = false;
    if (view_enabled && view_get_visible(0))
    {
        var _dt_primary = view_get_camera(0);
        if (_dt_primary >= 0)
        {
            _dt_cam = _dt_primary;
            _dt_primary_view = true;
        }
    }
    if (_dt_cam < 0) return [false, 0, 0, 1, 1, 0, 0, 0, 0];
    var _dt_gui_w = display_get_gui_width();
    var _dt_gui_h = display_get_gui_height();
    var _dt_world_x = camera_get_view_x(_dt_cam);
    var _dt_world_y = camera_get_view_y(_dt_cam);
    var _dt_world_w = camera_get_view_width(_dt_cam);
    var _dt_world_h = camera_get_view_height(_dt_cam);
    var _dt_port_x = 0;
    var _dt_port_y = 0;
    var _dt_port_w = _dt_gui_w;
    var _dt_port_h = _dt_gui_h;
    if (_dt_primary_view && surface_exists(application_surface) && view_get_wport(0) > 0 && view_get_hport(0) > 0)
    {
        var _dt_xscale = _dt_gui_w / max(1, surface_get_width(application_surface));
        var _dt_yscale = _dt_gui_h / max(1, surface_get_height(application_surface));
        _dt_port_x = view_get_xport(0) * _dt_xscale;
        _dt_port_y = view_get_yport(0) * _dt_yscale;
        _dt_port_w = view_get_wport(0) * _dt_xscale;
        _dt_port_h = view_get_hport(0) * _dt_yscale;
    }
    return [_dt_world_w > 0 && _dt_world_h > 0 && _dt_port_w >= 80 && _dt_port_h >= 40,
        _dt_world_x, _dt_world_y, _dt_world_w, _dt_world_h, _dt_port_x, _dt_port_y, _dt_port_w, _dt_port_h];
}

// A regular dialogue is locked to its box, not to the writer's cached drawing
// offsets (which the game can update during camera pans and portrait changes).
function scr_dt_dialogue_panel_anchor(_panel, _portrait)
{
    var _f = scr_dt_numeric_field(_panel, "f", 1);
    var _side = scr_dt_numeric_field(_panel, "side", 1);
    return [round(19 * _f + scr_dt_numeric_field(_panel, "xoff", 0)) + (10 + 58 * _portrait) * _f,
        round(20 * _f + scr_dt_numeric_field(_panel, "yoff", 0)) + (155 * _side - 5) * _f];
}

function scr_dt_writer_anchor(_writer, _view)
{
    if (_writer == noone || !instance_exists(_writer)) return [false, 0, 0];
    var _x = _writer.x - _view[1];
    var _y = _writer.y - _view[2];
    var _box = false;
    var _panel_type = asset_get_index("obj_dialoguer");
    if (_panel_type >= 0 && object_exists(_panel_type))
    {
        for (var _i = 0; _i < instance_number(_panel_type); _i++)
        {
            var _panel = instance_find(_panel_type, _i);
            if (_panel == noone || !instance_exists(_panel)) continue;
            if (!variable_instance_exists(_panel, "writer")) continue;
            if (_panel.writer != _writer) continue;
            if (variable_instance_exists(_panel, "drawbox"))
                if (!_panel.drawbox) continue;
            var _portrait = 0;
            if (variable_global_exists("fc")) _portrait = (global.fc > 0) ? 1 : 0;
            var _origin = scr_dt_dialogue_panel_anchor(_panel, _portrait);
            _x = _origin[0];
            _y = _origin[1];
            _box = true;
            break;
        }
    }
    if (!_box)
    {
        // Standalone and boxless writers may intentionally draw away from their instance origin.
        var _text_x = scr_dt_numeric_field(_writer, "writingx", _writer.x) - _view[1];
        var _text_y = scr_dt_numeric_field(_writer, "writingy", _writer.y) - _view[2];
        if (_text_x >= 0 && _text_x < _view[3] && _text_y >= 0 && _text_y < _view[4])
        {
            _x = _text_x;
            _y = _text_y;
        }
    }
    // If neither anchor is on screen, use the normal overlay position, not the nearest edge.
    if (!(_x >= 0 && _x < _view[3] && _y >= 0 && _y < _view[4])) return [false, 0, 0];
    return [true, _view[5] + _x * _view[7] / _view[3], _view[6] + _y * _view[8] / _view[4]];
}

// Return [draw, follow, x, y]. Do not flash a stale line in the default position
// while Step and Draw are observing different writers or the camera is switching.
function scr_dt_dialogue_position(_slot, _view, _autopos)
{
    if (!_autopos) return [true, false, 0, 0];
    var _writer = global.__dt_writers[_slot];
    if (_writer == noone || !instance_exists(_writer))
    {
        global.__dt_positions[_slot] = undefined;
        return [false, false, 0, 0];
    }
    var _state = global.__dt_positions[_slot];
    if (is_undefined(_state)) _state = { writer: noone, anchor: undefined, misses: 0 };
    if (_state.writer != _writer)
    {
        _state = { writer: _writer, anchor: undefined, misses: 0 };
        global.__dt_positions[_slot] = _state;
    }
    if (!_view[0])
    {
        _state.misses = 0;
        return [false, false, 0, 0];
    }
    var _anchor = scr_dt_writer_anchor(_writer, _view);
    if (_anchor[0])
    {
        _state.anchor = _anchor;
        _state.misses = 0;
        return [true, true, _anchor[1], _anchor[2]];
    }
    if (_state.misses < 3) _state.misses++;
    // Keep the latest position for a brief loss. Only use the corner for a
    // live writer that stays off-screen for three consecutive draw frames.
    if (_state.misses >= 3)
    {
        _state.anchor = undefined;
        return [true, false, 0, 0];
    }
    if (is_undefined(_state.anchor)) return [false, false, 0, 0];
    return [true, true, _state.anchor[1], _state.anchor[2]];
}

function scr_dt_snapshot()
{
    var _lines = array_create(11, "");
    var _writers = array_create(11, noone);
    var _choices = array_create(4, "");
    var _types = [asset_get_index("obj_writer"), asset_get_index("obj_menuwriter")];
    var _origin = scr_dt_view_origin();
    var _line = 1;
    for (var _type = 0; _type < array_length(_types); _type++)
    {
        var _obj = _types[_type];
        if (_obj < 0) continue;
        var _count = instance_number(_obj);
        for (var _i = 0; _i < _count; _i++)
        {
            var _writer = instance_find(_obj, _i);
            if (_writer == noone || !instance_exists(_writer)) continue;
            var _seen = false;
            for (var _j = 0; _j < 11; _j++)
                if (_writers[_j] == _writer) _seen = true;
            if (_seen) continue;
            // Animated text belongs to the dialogue request, even if it is the entire line.
            var _raw = scr_dt_clean_text(scr_dt_instance_text(_writer), true);
            if (_raw == "") continue;

            var _slot = -1;
            if (_lines[0] == "" && (!_origin[0] || _writer.y - _origin[2] > 260 || _writer.x - _origin[1] < 150))
                _slot = 0;
            else if (_line < 11)
            {
                _slot = _line;
                _line++;
            }
            if (_slot >= 0)
            {
                _lines[_slot] = _raw;
                _writers[_slot] = _writer;
            }
        }
    }
    // Centered or custom panels can be the only writer and still be primary dialogue.
    if (_lines[0] == "" && _line > 1)
    {
        _lines[0] = _lines[1];
        _writers[0] = _writers[1];
        _lines[1] = "";
        _writers[1] = noone;
    }

    var _chooser = instance_find(obj_choicer_neo, 0);
    if (_chooser == noone) _chooser = instance_find(obj_choicer_old, 0);
    if (_chooser != noone && instance_exists(_chooser))
    {
        // Some panels carry their own choices. Prefer populated slots on the active chooser;
        // fill the remaining slots from the shared array when that is the panel's layout.
        var _choice_fields = ["text", "mytext"];
        for (var _field = 0; _field < array_length(_choice_fields); _field++)
        {
            if (!variable_instance_exists(_chooser, _choice_fields[_field])) continue;
            var _values = variable_instance_get(_chooser, _choice_fields[_field]);
            if (!is_array(_values)) continue;
            for (var _k = 0; _k < min(4, array_length(_values)); _k++)
                if (_choices[_k] == "" && is_string(_values[_k])) _choices[_k] = _values[_k];
        }
        // Some encounters (including Mike) use fewer than four options.
        if (variable_global_exists("choicemsg"))
        {
            var _shared = global.choicemsg;
            if (is_array(_shared))
            {
                var _available = min(array_length(_choices), array_length(_shared));
                for (var _k = 0; _k < _available; _k++)
                {
                    var _choice = _shared[_k];
                    if (_choices[_k] == "" && is_string(_choice)) _choices[_k] = _choice;
                }
            }
        }
    }
    return { lines: _lines, writers: _writers, choices: _choices };
}

function scr_dt_new_bubble()
{
    return { source: "", instance: noone, request: -1, translated: "", deadline: 0, anchor_x: 0, anchor_y: 0, kind: 0 };
}

function scr_dt_clear()
{
    global.trans_main_id = -1;
    global.trans_main_text = "";
    global.trans_enemy_ids = array_create(10, -1);
    global.trans_enemy_texts = array_create(10, "");
    global.trans_choice_ids = array_create(4, -1);
    global.trans_choice_texts = array_create(4, "");
    global.trans_timer = 0;
    global.__dt_line_keys = array_create(11, "");
    global.__dt_choice_keys = array_create(4, "");
    global.__dt_writers = array_create(11, noone);
    global.__dt_positions = array_create(11, undefined);
    global.__dt_has_text = false;
    // Keep type indices stable across chapters: world bubble, couch, Tenna, smallface.
    global.__dt_caption_types = [asset_get_index("obj_talkbubble"), asset_get_index("obj_couchwriter"),
        asset_get_index("obj_tennatalkbubble"), asset_get_index("obj_smallface")];
    global.__dt_funnytext_type = asset_get_index("obj_funnytext");
    global.__dt_bubbles = [];
}

// Animated lettering is not stored as text. Decode only known text sprites, not arbitrary artwork.
function scr_dt_funnytext_label(_sprite)
{
    if (is_undefined(_sprite)) return "";
    if (!sprite_exists(_sprite)) return "";
    var _name = sprite_get_name(_sprite);
    if (string_pos("spr_ja_funnytext_", _name) == 1) _name = string_delete(_name, 1, 17);
    else if (string_pos("spr_funnytext_", _name) == 1) _name = string_delete(_name, 1, 14);
    else return "";
    var _len = string_length(_name);
    if (_len > 5 && string_copy(_name, _len - 4, 5) == "_loop")
        _name = string_copy(_name, 1, _len - 5);
    switch (_name)
    {
        case "alligator": return "alligator";
        case "amazing_01": return "amazing";
        case "ass": return "ass";
        case "big": return "big";
        case "board": return "board";
        case "bonus_round": return "bonus round";
        case "breaking_news": return "breaking news";
        case "brother": return "brother";
        case "challenge": return "challenge";
        case "city_feet": return "city feet";
        case "coffee": return "coffee";
        case "dark_fountain": return "dark fountain";
        case "daisuki": return "love";
        case "dump_her": return "dump her";
        case "flames": return "flames";
        case "fun": return "fun";
        case "fun_o_meter": return "fun-o-meter";
        case "game": return "game";
        case "game_over": return "game over";
        case "gentle": return "gentle";
        case "grand_prize": return "grand prize";
        case "green_room": return "green room";
        case "hall_of_fame": return "hall of fame";
        case "know_tv": return "I know TV";
        case "love": return "love";
        case "lovely": return "lovely";
        case "lovers": return "lovers";
        case "names": return "names";
        case "over": return "over";
        case "physical_challenge": return "physical challenge";
        case "physical_challenges": return "physical challenges";
        case "prizes": return "prizes";
        case "quizzes": return "quizzes";
        case "relax": return "relax";
        case "rock_concert": return "rock concert";
        case "round": return "round";
        case "round_1": return "round 1";
        case "rounds": return "rounds";
        case "special": return "special";
        case "star": return "star";
        case "stars": return "stars";
        case "stop": return "stop";
        case "susiezilla": return "Susiezilla";
        case "tan": return "tan";
        case "tears": return "tears";
        case "toriel": return "Toriel";
        case "tv_time": return "TV time";
        case "win": return "win";
        case "win_big": return "win big";
        case "word": return "word";
        case "dump_her_ja": return "dump her";
    }
    return "";
}

function scr_dt_inline_label(_digit)
{
    if (string_length(_digit) != 1 || string_pos(_digit, "0123456789") == 0) return "";
    if (!variable_global_exists("writerobj") || !variable_global_exists("writerimg")) return "";
    var _objects = global.writerobj;
    var _sprites = global.writerimg;
    if (!is_array(_objects) || !is_array(_sprites)) return "";
    var _i = real(_digit);
    if (_i >= array_length(_objects) || _i >= array_length(_sprites)) return "";
    var _type = global.__dt_funnytext_type;
    if (_type < 0 || _objects[_i] != _type) return "";
    return scr_dt_funnytext_label(_sprites[_i]);
}

function scr_dt_clean_text(_raw, _embedded)
{
    var _clean = "";
    var _len = string_length(_raw);
    for (var _i = 1; _i <= _len; _i++)
    {
        var _ch = string_char_at(_raw, _i);
        if (_ch == "\\")
        {
            if (_embedded && string_char_at(_raw, _i + 1) == "O")
                _clean += scr_dt_inline_label(string_char_at(_raw, _i + 2));
            _i += 2;
            continue;
        }
        if (_ch == "^") { _i++; continue; }
        if (_ch == "&" || _ch == "#" || _ch == "|") _clean += " ";
        else if (_ch != "*" && _ch != "/" && _ch != "%") _clean += _ch;
    }
    return string_trim(_clean);
}

function scr_dt_request(_raw, _lang, _literal)
{
    var _clean = _literal ? string_trim(_raw) : scr_dt_clean_text(_raw, false);
    if (_clean == "") return -1;
    var _encoded = "";
    var _hex = "0123456789ABCDEF";
    for (var _j = 1; _j <= string_byte_length(_clean); _j++)
    {
        var _byte = string_byte_at(_clean, _j);
        if ((_byte >= 48 && _byte <= 57) || (_byte >= 65 && _byte <= 90) || (_byte >= 97 && _byte <= 122))
            _encoded += chr(_byte);
        else
            _encoded += "%" + string_char_at(_hex, (_byte div 16) + 1) + string_char_at(_hex, (_byte mod 16) + 1);
    }
    return http_get("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" + _lang + "&dt=t&q=" + _encoded);
}

function scr_dt_numeric_field(_inst, _name, _fallback)
{
    if (!variable_instance_exists(_inst, _name)) return _fallback;
    var _value = variable_instance_get(_inst, _name);
    return is_numeric(_value) ? _value : _fallback;
}

function scr_dt_bubble_top_margin(_inst)
{
    return max(0, scr_dt_numeric_field(_inst, "bubbleheight", 8))
        + max(0, scr_dt_numeric_field(_inst, "bubblepadding", 0))
        + max(0, scr_dt_numeric_field(_inst, "outlineThickness", 0)) + 8;
}

// Read only text from instances that are actually being shown.
function scr_dt_caption_source(_inst, _kind)
{
    switch (_kind)
    {
        case 1:
            if (!_inst.init || _inst.mode != 2 || _inst.myalpha <= 0 || _inst.x == -1) return "";
            return string_trim(string_replace_all(_inst.mystring, "#", " "));
        case 2:
            if (!_inst.init) return "";
            break;
        case 3:
            if (global.darkzone != 1 || _inst.getrid || !instance_exists(_inst.writergod)) return "";
            if (_inst.type != 0 && _inst.type != 3 && !_inst.active) return "";
            return string_trim(string_replace_all(_inst.mystring, "#", " "));
    }
    if (!variable_instance_exists(_inst, "truetext")) return "";
    var _text = variable_instance_get(_inst, "truetext");
    return is_string(_text) ? string_trim(_text) : "";
}

// Slots are independent of dialogue, and reused when their instances disappear.
function scr_dt_track_bubbles(_manual, _lang, _loading)
{
    var _now = current_time;
    for (var _i = 0; _i < array_length(global.__dt_bubbles); _i++)
        if (global.__dt_bubbles[_i].deadline <= _now) global.__dt_bubbles[_i] = scr_dt_new_bubble();

    for (var _kind = 0; _kind < array_length(global.__dt_caption_types); _kind++)
    {
        var _type = global.__dt_caption_types[_kind];
        if (_type < 0 || !object_exists(_type)) continue;
        var _count = instance_number(_type);
        for (var _i = 0; _i < _count; _i++)
        {
            var _inst = instance_find(_type, _i);
            if (_inst == noone || !instance_exists(_inst)) continue;
            if (!_inst.visible || _inst.object_index != _type) continue;
            var _source = scr_dt_caption_source(_inst, _kind);
            if (_source == "") continue;

            var _slot = -1;
            var _idle = -1;
            for (var _j = 0; _j < array_length(global.__dt_bubbles); _j++)
            {
                var _candidate = global.__dt_bubbles[_j];
                if (_candidate.instance == _inst) { _slot = _j; break; }
                if (_idle < 0 && _candidate.source == "") _idle = _j;
                if (_idle < 0 && _candidate.kind != 0 && !instance_exists(_candidate.instance)) _idle = _j;
            }
            if (_slot < 0) _slot = _idle;
            if (_slot < 0)
            {
                _slot = array_length(global.__dt_bubbles);
                if (_slot >= 24) continue;
                global.__dt_bubbles[_slot] = scr_dt_new_bubble();
            }
            var _entry = global.__dt_bubbles[_slot];
            var _same = _entry.instance == _inst && _entry.source == _source;
            _entry.deadline = _now + 3000;
            if (!_manual && _same) continue;
            _entry.instance = _inst;
            _entry.kind = _kind;
            _entry.anchor_x = _inst.x;
            _entry.anchor_y = _inst.y - scr_dt_bubble_top_margin(_inst);
            _entry.source = _source;
            _entry.request = scr_dt_request(_source, _lang, true);
            _entry.translated = _entry.request < 0 || _kind == 3 ? "" : _loading;
        }
    }

    for (var _i = 0; _i < array_length(global.__dt_bubbles); _i++)
    {
        var _entry = global.__dt_bubbles[_i];
        if (_entry.request >= 0 || _entry.translated != "") return true;
    }
    return false;
}

function scr_trigger_translation(_manual)
{
    var _snapshot = scr_dt_snapshot();
    var _language = scr_dt_language();
    var _lang = _language.code;
    var _loading = _language.loading;

    var _any = false;
    global.__dt_writers = _snapshot.writers;
    for (var _i = 0; _i < 11; _i++)
    {
        var _raw = _snapshot.lines[_i];
        if (_raw != "") _any = true;
        var _key = _raw == "" ? "" : _lang + ":" + _raw;
        if (!_manual && _key == global.__dt_line_keys[_i]) continue;
        global.__dt_line_keys[_i] = _key;
        var _request = _key == "" ? -1 : scr_dt_request(_raw, _lang, true);
        var _text = _request < 0 ? "" : _loading;
        if (_i == 0)
        {
            global.trans_main_id = _request;
            global.trans_main_text = _text;
        }
        else
        {
            global.trans_enemy_ids[_i - 1] = _request;
            global.trans_enemy_texts[_i - 1] = _text;
        }
    }
    for (var _i = 0; _i < 4; _i++)
    {
        var _raw = _snapshot.choices[_i];
        if (_raw != "") _any = true;
        var _key = _raw == "" ? "" : _lang + ":" + _raw;
        if (!_manual && _key == global.__dt_choice_keys[_i]) continue;
        global.__dt_choice_keys[_i] = _key;
        var _request = _key == "" ? -1 : scr_dt_request(_raw, _lang, false);
        global.trans_choice_ids[_i] = _request;
        global.trans_choice_texts[_i] = _request < 0 ? "" : _loading;
    }
    if (scr_dt_track_bubbles(_manual, _lang, _loading)) _any = true;
    global.__dt_has_text = _any;
    if (_manual) global.trans_timer = _any ? 15 * room_speed : 0;
}
