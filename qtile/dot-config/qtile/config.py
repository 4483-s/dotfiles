import os
import subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import colors

from keybindings import mod, myTerm, keys

subprocess.run("wlr-randr --output HDMI-A-1 --right-of HDMI-A-2 &", shell=True)
# subprocess.run("gammastep -O 4455 &", shell=True)
groups = []
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
# The default layout for each of the 10 workspaces
group_layouts = [
    "monadtall",
    "max",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        )
    )

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

colors = colors.Dracula

layout_theme = {
    "border_width": 2,
    "margin": 1,
    # "border_focus": colors[8],
    "border_focus": "f34fff",
    "border_normal": colors[0],
}

layouts = [
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    layout.Tile(**layout_theme),
    layout.Max(**layout_theme),
    # layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Stack(**layout_theme, num_stacks=2),
    layout.ScreenSplit(**layout_theme),
    layout.Plasma(**layout_theme),
    layout.Spiral(**layout_theme),
    # layout.Slice(**layout_theme),
    layout.MonadThreeCol(**layout_theme),
]

widget_defaults = dict(
    font="Ubuntu Bold",
    fontsize=12,
    padding=0,
    # background=colors[0]
    background="00000000",
)

extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widgets_list = [
        widget.Prompt(font="Ubuntu Mono", fontsize=14, foreground=colors[1]),
        widget.GroupBox(
            fontsize=10,
            margin_y=5,
            margin_x=10,
            padding_y=0,
            padding_x=2,
            borderwidth=3,
            active=colors[8],
            inactive=colors[9],
            rounded=True,
            highlight_color=colors[0],
            highlight_method="line",
            this_current_screen_border=colors[7],
            this_screen_border=colors[4],
            other_current_screen_border=colors[7],
            other_screen_border=colors[4],
            hide_unused=True,
        ),
        widget.CurrentLayout(foreground=colors[1], padding=5, mode="both"),
        # widget.WindowName(foreground=colors[6], padding=8, max_chars=40),
        widget.TaskList(
            fmt="<i>{}</i>",
            border="59045c",
            fontsize=13,
            background="00000000",
            highlight_method="block",
            # foreground="000000",
            # center_aligned=True,
        ),
        widget.Chord(),
        widget.CPU(
            foreground=colors[4],
            padding=8,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")},
            format="Cpu: {load_percent}%",
        ),
        widget.Memory(
            foreground=colors[8],
            padding=8,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")},
            format="{MemUsed: .0f}{mm}",
            fmt="Mem: {}",
        ),
        widget.DF(
            update_interval=60,
            foreground=colors[5],
            padding=8,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("notify-disk")},
            partition="/",
            # format = '[{p}] {uf}{m} ({r:.0f}%)',
            format="{uf}{m} free",
            fmt="Disk: {}",
            visible_on_warn=False,
        ),
        # pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '{print $2}' | tr -d ' '
        widget.Volume(
            foreground=colors[7],
            padding=8,
            fmt="Vol: {}",
            get_volume_command="""pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '{print $2}' | tr -d ' '""",
            volume_down_command="""pactl set-sink-volume @DEFAULT_SINK@ -1%""",
            volume_up_command="""pactl set-sink-volume @DEFAULT_SINK@ +1%""",
        ),
        # widget.Volume(
        #     foreground=colors[7],
        #     padding=8,
        #     fmt="Vol: {}",
        # ),
        widget.Clock(
            foreground=colors[8],
            padding=8,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("notify-date")},
            ## Uncomment for date and time
            # format = "%a, %b %d - %H:%M",
            ## Uncomment for time only
            format="%I:%M %p",
        ),
        # widget.Systray(padding=6),
        widget.Battery(),
    ]
    return widgets_list


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1


# All other monitors' bars will display everything but widgets 22 (systray) and 23 (spacer).
def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    # del widgets_screen2[16:17]
    widgets_screen2.append(
        widget.Wallpaper(directory=os.path.expanduser("~") + "/Pictures/backgrounds")
    )
    return widgets_screen2


def init_screens():
    return [
        Screen(
            bottom=bar.Bar(
                widgets=init_widgets_screen1(),
                margin=[0, 0, 0, 0],
                size=18,
                background="00000000",
            ),
            wallpaper=os.path.expanduser("~") + "/Pictures/backgrounds/0310.jpg",
            wallpaper_mode="fill",
        ),
        Screen(
            bottom=bar.Bar(
                widgets=init_widgets_screen2(), margin=[0, 0, 0, 0], size=18
            ),
            # wallpaper=os.path.expanduser("~") + "/Pictures/backgrounds/0142.jpg",
            wallpaper=os.path.expanduser("~") + "/Pictures/backgrounds/0124.jpg",
            wallpaper_mode="fill",
        ),
        # Screen(
        #     top=bar.Bar(widgets=init_widgets_screen2(), margin=[8, 12, 0, 12], size=30)
        # ),
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
    # Drag(["mod1"], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    # Drag(["mod1"], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    # Click(["mod1"], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="dialog"),  # dialog boxes
        Match(wm_class="download"),  # downloads
        Match(wm_class="error"),  # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="notification"),  # notifications
        Match(wm_class="pinentry-gtk-2"),  # GPG key password entry
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="toolbar"),  # toolbars
        Match(wm_class="Yad"),  # yad boxes
        Match(title="branchdialog"),  # gitk
        Match(title="Confirmation"),  # tastyworks exit box
        Match(title="Qalculate!"),  # qalculate-gtk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="tastycharts"),  # tastytrade pop-out charts
        Match(title="tastytrade"),  # tastytrade pop-out side gutter
        Match(title="tastytrade - Portfolio Report"),  # tastytrade pop-out allocation
        Match(wm_class="tasty.javafx.launcher.LauncherFxApp"),  # tastytrade settings
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None
wmname = "LG3D"
