-- ============================================================
--  Hyprland Lua Configuration
--  Hunter Thueson · hephaestus (desktop)
-- ============================================================


-- ----------------
--  SYSTEMD SESSION
-- ----------------
-- The HM module generates a hyprland.conf with dbus activation,
-- but Hyprland loads hyprland.lua and ignores it. We replicate
-- the activation here so the hyprland-session.target starts.

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all "
        .. "&& systemctl --user stop hyprland-session.target "
        .. "&& systemctl --user start hyprland-session.target")
end)


-- ----------------
--  MONITORS
-- ----------------
-- Gigabyte M28U (4K 28", primary, left)
-- Dell S2417DG (1440p 24", secondary, right)
--
-- Scale: M28U at 1.5x gives effective 2560x1440, matching the Dell.
-- Connector names may change after driver updates -- verify with
-- `hyprctl monitors` and adjust if needed.

hl.monitor({
    output   = "DP-5",
    mode     = "3840x2160@144",
    position = "0x0",
    scale    = "1.5",
})

hl.monitor({
    output   = "",
    mode     = "2560x1440@60",
    position = "auto-right",
    scale    = "1.2",
})

-- Fallback for any hotplugged monitor
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


-- ----------------
--  PROGRAMS
-- ----------------

local terminal    = "alacritty"
local browser     = "firefox"
local launcher    = "rofi -show drun -show-icons"
local fileManager = "dolphin"


-- ----------------
--  AUTOSTART
-- ----------------

-- Monitor orientations: change to "portrait" when a monitor is rotated.
-- Wallpapers are picked randomly from ~/images/wallpapers/<orientation>/
local monitor_wallpapers = {
    { output = "DP-5", orientation = "landscape" },     -- Gigabyte M28U 4K 144hz
    { output = "DP-4", orientation = "landscape" },     -- Dell S2417DG 1440p 165hz
    { output = "",     orientation = "landscape" },     -- Catch-all for any other monitor(s) detected
}

hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("nm-applet --indicator")

    -- Build a single shell script that waits for awww-daemon, then sets
    -- a random wallpaper on each monitor sequentially.
    local cmds = "while ! awww query 2>/dev/null; do sleep 0.2; done"
    for _, mon in ipairs(monitor_wallpapers) do
        cmds = cmds
            .. " && awww img --outputs " .. mon.output
            .. " --transition-type fade --transition-duration 2"
            .. " \"$(find ~/images/wallpapers/" .. mon.orientation
            .. " -type f \\( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.webp' \\) | shuf -n 1)\""
    end
    hl.exec_cmd(cmds)
end)


-- ----------------
--  ENVIRONMENT
-- ----------------

hl.env("XCURSOR_SIZE", "12")
hl.env("HYPRCURSOR_SIZE", "12")

-- Nvidia-specific (RTX 3090)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")


-- ----------------
--  LOOK AND FEEL
-- ----------------
-- Electro-swing palette:
--   base00 #131313  (background/shadow)
--   base02 #5e676a  (inactive border)
--   base0C #52e9e9  (cyan, active border start)
--   base0D #4c8cde  (blue, active border end)
--   base0E #ed83e2  (magenta, accent)

hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 5,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(52e9e9ee)", "rgba(4c8cdeee)"}, angle = 45 },
            inactive_border = "rgba(5e676aaa)",
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 6,
        rounding_power = 3,
        active_opacity   = 1.0,
        inactive_opacity = 0.97,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee131313,
        },
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})


-- ----------------
--  ANIMATIONS
-- ----------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })


-- ----------------
--  LAYOUTS
-- ----------------

hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})


-- ----------------
--  INPUT
-- ----------------

hl.config({
    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = false,
        },
    },
})


-- ----------------
--  KEYBINDINGS
-- ----------------

local mod = "SUPER"

-- Core
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + F",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + space",  hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + V",      hl.dsp.window.float({ action = "toggle" }))

-- Vim-style focus
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Vim-style window movement
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mod .. " + S",           hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mod .. " + SHIFT + S",   hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Fullscreen
hl.bind(mod .. " + SHIFT + F",   hl.dsp.window.fullscreen())

-- Toggle split direction (dwindle)
hl.bind(mod .. " + T",           hl.dsp.layout("togglesplit"))

-- Exit Hyprland
hl.bind(mod .. " + SHIFT + Q",   hl.dsp.exit())

-- Mouse binds
hl.bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Media / volume / brightness (XF86 keys, work when locked)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),                                  { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),                            { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),                            { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),                              { locked = true })

-- Screenshot
hl.bind(mod .. " + SHIFT + P",   hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("Print",                 hl.dsp.exec_cmd("hyprshot -m output"))


-- ----------------
--  WINDOW RULES
-- ----------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
