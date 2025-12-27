-- -- Base
import XMonad
-- import System.Directory
-- import System.IO (hClose, hPutStr, hPutStrLn)
-- import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W
--
--     -- Actions
-- import XMonad.Actions.CopyWindow (kill1)
-- import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
-- import XMonad.Actions.GridSelect
-- import XMonad.Actions.MouseResize
-- import XMonad.Actions.Promote
-- import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
-- import XMonad.Actions.WindowGo (runOrRaise)
-- import XMonad.Actions.WithAll (sinkAll, killAll)
-- import qualified XMonad.Actions.Search as S
--
--     -- Data
-- import Data.Char (isSpace, toUpper)
-- import Data.Maybe (fromJust)
import Data.Monoid
-- import Data.Maybe (isJust)
-- import Data.Tree
import qualified Data.Map as M
--
--     -- Hooks
-- import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
-- import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
-- import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
-- import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
-- import XMonad.Hooks.StatusBar
-- import XMonad.Hooks.StatusBar.PP
-- import XMonad.Hooks.WindowSwallowing
-- import XMonad.Hooks.WorkspaceHistory
--
--     -- Layouts
-- import XMonad.Layout.Accordion
-- import XMonad.Layout.GridVariants (Grid(Grid))
-- import XMonad.Layout.SimplestFloat
-- import XMonad.Layout.Spiral
-- import XMonad.Layout.ResizableTile
-- import XMonad.Layout.Tabbed
-- import XMonad.Layout.ThreeColumns
--
--     -- Layouts modifiers
-- import XMonad.Layout.LayoutModifier
-- import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
-- import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
-- import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
-- import XMonad.Layout.Renamed
-- import XMonad.Layout.ShowWName
-- import XMonad.Layout.Simplest
-- import XMonad.Layout.Spacing
-- import XMonad.Layout.SubLayouts
-- import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
-- import XMonad.Layout.WindowNavigation
-- import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
-- import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
--
--    -- Utilities
-- import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
-- import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack, trayerAboveXmobarEventHook, trayAbovePanelEventHook, trayerPaddingXmobarEventHook, trayPaddingXmobarEventHook, trayPaddingEventHook)
-- import XMonad.Util.NamedActions
-- import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
--------
import System.Exit
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Actions.CycleWS (nextScreen)
import XMonad.Prompt.Zsh
import XMonad.Layout.Tabbed
import XMonad.Actions.Navigation2D
import XMonad.Layout.Grid
myTerminal      = "kitty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2
myModMask       = mod4Mask

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor  = "#282a36"
myFocusedBorderColor = "#f34fff"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ 
     ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,xK_u), windows W.focusMaster  )
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)
    , ((modm .|. controlMask, xK_q     ), spawn "xmonad --recompile && xmonad --restart && echo 8 > ~/.xmonadcmp.log")
    ]
    ++
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
        ,  ("M-l"        , windows W.focusDown)
        ,  ("M-h"        , windows W.focusUp)
        ,  ("M-j"        , windows W.focusDown)
        ,  ("M-k"        , windows W.focusUp)
        ,  ("M-."        , nextScreen)
        ,  ("M-<Space>"  , sendMessage NextLayout)
        ,  ("M-<Return>" , zshPrompt def "/home/h/.local/bin/capture.zsh")
        ,  ("M--"        , sendMessage Shrink)
        ,  ("M-="        , sendMessage Expand)
        ,  ("M-S-l"      , windows W.swapDown)
        ,  ("M-S-h"      , windows W.swapUp)
        ,  ("M-t"        , withFocused $ windows . W.sink)
        ,  ("M-,"        , sendMessage (IncMasterN 1))
     ]
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
-- fontName = "xft:JetBrains Mono:regular:size=9:antialias=true:hinting=true",
  -- fontName = "xft:Ubuntu:bold:size=60",
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
myLayout =avoidStruts ( smartBorders tiled ||| smartBorders( noBorders(tabbed shrinkText myTabConfig))||| smartBorders Grid)

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
    , className =? "confirm"         --> doFloat
    , className =? "file_progress"   --> doFloat
    , className =? "dialog"          --> doFloat
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
my2D = navigation2DP def
                              ("<Up>", "<Left>", "<Down>", "<Right>")
                              [("M-",   windowGo  ),
                               ("M-S-", windowSwap)]
                              False
main = do 
    -- xmproc <- spawnPipe "xmobar -x 0 /home/h/.config/xmobar/myxmo"
    -- xmproc <- spawnPipe "polybar mainbar-xmonad"
    xmonad $ docks $ ewmh $ ewmhFullscreen $ my2D $ defaults

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
