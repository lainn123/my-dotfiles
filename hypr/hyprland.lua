-- ==============================================================================
-- HYPRLAND - CONFIGURAÇÃO (LUA) + PYWAL
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. CARREGAR CORES DO PYWAL
-- ------------------------------------------------------------------------------
local function get_wal_color(index, fallback)
    local path = os.getenv("HOME") .. "/.cache/wal/colors"
    local file = io.open(path, "r")
    if not file then return fallback end

    local i = 0
    for line in file:lines() do
        if i == index then
            file:close()
            local hex = line:gsub("#", "")
            return "0xff" .. hex
        end
        i = i + 1
    end
    file:close()
    return fallback
end

local active_border_col = get_wal_color(1, "0xff89b4fa")   -- Cor principal
local inactive_border_col = get_wal_color(0, "0xff1e1e2e") -- Cor de fundo

-- ------------------------------------------------------------------------------
-- 2. MONITORES
-- ------------------------------------------------------------------------------
hl.monitor({
    output = "DP-1",
    mode = "1920x1080@165",
    position = "0x0",
    scale = "1",
})

-- ------------------------------------------------------------------------------
-- 3. AUTOSTART
-- ------------------------------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css")
end)

-- ------------------------------------------------------------------------------
-- 4. ANIMAÇÕES & REGRAS DE JANELA
-- ------------------------------------------------------------------------------
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3.5, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.5, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default", style = "slide" })

hl.window_rule({ match = { title = "^(Wallpaper Sidebar)$" }, float = true })
hl.layer_rule({ match = { namespace = "rofi" }, animation = "popin" })

-- ------------------------------------------------------------------------------
-- 5. BINDS / ATALHOS DE TECLADO
-- ------------------------------------------------------------------------------
local mainMod = "SUPER"

-- Sistema & Aplicativos
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("foot"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("rofi -show drun -theme ~/.config/rofi/config.rasi"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + N", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.local/bin/wallpaper_selector"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"))

-- Janelas & Navegação
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Tab", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("~/.local/bin/volume.sh up"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("~/.local/bin/volume.sh mute"))
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("~/.local/bin/volume.sh down"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/.config/hypr/get-cover.sh && hyprlock"))

-- Player de Mídia (Strawberry)
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("strawberry"))
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("strawberry --play-pause"))
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd("strawberry --prev"))
hl.bind(mainMod .. " + F8", hl.dsp.exec_cmd("strawberry --next"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("strawberry --volume-down"))
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("strawberry --volume-up"))
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("strawberry --volume-mute"))

-- Workspaces (1 a 9)
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- ------------------------------------------------------------------------------
-- 6. CONFIGURAÇÕES GERAIS E VISUAIS
-- ------------------------------------------------------------------------------
hl.config({
    input = {
        kb_layout = "br",
        repeat_rate = 25,
        repeat_delay = 500,
        follow_mouse = 1,
        touchpad = {
            tap_to_click = true,
            tap_and_drag = true,
            disable_while_typing = true,
        },
    },
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 3,
        ["col.active_border"] = active_border_col,
        ["col.inactive_border"] = inactive_border_col,
    },
    decoration = {
        rounding = 1,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false,
        },
    },
    animations = {
        enabled = true,
    },
})

-- ------------------------------------------------------------------------------
-- 7. VARIÁVEIS DE AMBIENTE
-- ------------------------------------------------------------------------------
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- HyprMod managed settings
require("hyprland-gui")
