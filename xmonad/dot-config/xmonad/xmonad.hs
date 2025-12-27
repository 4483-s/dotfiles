import XMonad
import Data.Monoid
import System.Exit
import XMonad.Operations
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig
-- import XMonad.Layout.Spiral
-- import XMonad.Layout.Grid
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CycleWS (nextScreen)
import XMonad.Prompt.Zsh
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
-- import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
-- import XMonad.Layout.HintedGrid

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
myTerminal      = "kitty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2
myModMask       = mod4Mask

-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor  = "#282a36"
myFocusedBorderColor = "#f34fff"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ 
     ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,xK_u), windows W.focusMaster  )
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)
    , ((modm .|. controlMask, xK_q     ), spawn "xmonad --recompile && xmonad --restart && echo 8 > ~/.xmonadcmp.log")
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

ezKeybindings = [ 
-- ("M-S-z", spawn "xscreensaver-command -lock")
-- , ("M-C-s", unGrab *> spawn "scrot -s"        )
           ("M-;"        , spawn myTerminal)
        ,  ("M-m"        , unGrab >> spawn "xdotool key --clearmodifiers ctrl+Tab")
        ,  ("M-n"        , unGrab >> spawn "xdotool key --clearmodifiers ctrl+shift+Tab")
        ,  ("M-i"        , unGrab >> spawn "xdotool key --clearmodifiers ctrl+w")
        ,  ("M-o"        , spawn "waterfox")
        ,  ("M-p"        , spawn "dmenu_run")
        ,  ("M-y"        , kill)
        ,  ("M-j"        , windows W.focusDown)
        ,  ("M-k"        , windows W.focusUp)
        ,  ("M-."        , nextScreen)
        ,  ("M-<Space>"  , sendMessage NextLayout)
        ,  ("M-<Return>" , zshPrompt def "/home/h/.local/bin/capture.zsh")
        ,  ("M--"        , sendMessage Shrink)
        ,  ("M-="        , sendMessage Expand)
        ,  ("M-S-j"      , windows W.swapDown  )
        ,  ("M-S-k"      , windows W.swapUp    )
        ,  ("M-t"        , withFocused $ windows . W.sink)
        ,  ("M-,"        , sendMessage (IncMasterN 1))
     ]
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                      >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                      >> windows W.shiftMaster)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
-- activeColor        
-- inactiveColor      
-- urgentColor        
-- activeBorderColor  
-- inactiveBorderColor
-- urgentBorderColor  
-- activeBorderWidth  
-- inactiveBorderWidth
-- urgentBorderWidth  
-- activeTextColor    
-- inactiveTextColor  
-- urgentTextColor    
-- fontName           
-- decoWidth          
-- decoHeight         
-- windowTitleAddons  
-- windowTitleIcons   
myTabConfig = def {
  activeColor = "#04ddf9",
  activeTextColor = "#490b13",
  inactiveColor = "#333333",
  decoHeight = 15,
  activeBorderWidth = 0,
  inactiveBorderWidth =0,
  urgentBorderWidth=0
  }

    --   simpleTabbed, tabbed, addTabs
    -- , simpleTabbedAlways, tabbedAlways, addTabsAlways
    -- , simpleTabbedBottom, tabbedBottom, addTabsBottom
    -- , simpleTabbedLeft, tabbedLeft, addTabsLeft
    -- , simpleTabbedRight, tabbedRight, addTabsRight
    -- , simpleTabbedBottomAlways, tabbedBottomAlways, addTabsBottomAlways
    -- , simpleTabbedLeftAlways, tabbedLeftAlways, addTabsLeftAlways
    -- , simpleTabbedRightAlways, tabbedRightAlways, addTabsRightAlways

-- myLayout =avoidStruts ( smartBorders tiled ||| smartBorders (Mirror  tiled) ||| smartBorders Full ||| Grid|||spiral (6/7) )
-- simpleTabbedRight, tabbedRight, addTabsRight
myLayout =avoidStruts ( smartBorders tiled ||| smartBorders( noBorders(tabbed shrinkText myTabConfig)))

  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty
-- myEventHook = docksEventHook <+> handleEventHook def <+> fullscreenEventHook
------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do 
  -- spawnOnce "feh --bg-fill ~/Pictures/backgrounds/0142.jpg &"
  spawnOnce "feh --randomize --bg-fill ~/Pictures/backgrounds/*"  -- feh set random wallpaper
  spawnOnce "volumeicon"
  setWMName "LG3D"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do 
    -- xmproc <- spawnPipe "xmobar -x 0 /home/h/.config/xmobar/myxmo"
    -- xmproc <- spawnPipe "polybar mainbar-xmonad"
    xmonad $ docks $ ewmh $ ewmhFullscreen  $ defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
 `additionalKeysP` ezKeybindings
-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
