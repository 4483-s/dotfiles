import XMonad
import qualified XMonad.StackSet as W
import Data.Monoid
import qualified Data.Map as M
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Actions.Submap
import System.Exit
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Actions.CycleWS (nextScreen, prevScreen)
import XMonad.Prompt.Zsh
import XMonad.Layout.Tabbed
import XMonad.Actions.Navigation2D
import XMonad.Layout.Grid
import XMonad.Hooks.WindowSwallowing
import XMonad.Actions.PerLayoutKeys
import XMonad.Actions.WindowGo (runOrRaise, ifWindow)
import Data.List (isInfixOf)
import XMonad.Hooks.FloatNext
-- import XMonad.Hooks.ManageHelpers


myTerminal      = "kitty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2
myModMask       = mod4Mask

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- myNormalBorderColor  = "#282a36"
myNormalBorderColor  = "#111111"
-- myFocusedBorderColor = "#f34fff"
-- myFocusedBorderColor = "#46d9ff"
myFocusedBorderColor = "#f402fc"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ 
     ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    ]
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

ezKeybindings = [ 
-- , ("M-C-s", unGrab *> spawn "scrot -s"        )
           ("M-a"        , spawn       "wmscript-a"  ) -- test
        ,  ("M-;"        , spawn myTerminal)
        ,  ("M-/"        , spawn "mscript b")
        -- ,  ("M-m"        , unGrab >> spawn "xdotool key --clearmodifiers ctrl+Tab")
        -- ,  ("M-n"        , unGrab >> spawn "xdotool key --clearmodifiers ctrl+shift+Tab")
        ,  ("M-m"        , unGrab >> spawn "xdo1.sh 0")
        ,  ("M-n"        , unGrab >> spawn "xdo1.sh 1")
        ,  ("M-o"        , spawn "waterfox")
        ,  ("M-p"        , spawn "rofi -show drun -m -1")
        ,  ("M-y"        , kill)
        ,  ("M-S-q"      , io exitSuccess)
        ,  ("M-q"        , spawn "xmonad --recompile && xmonad --restart && echo 8 > ~/.xmonadcmp.log")
        ,  ("M-."        , nextScreen)
        ,  ("M-,"        , prevScreen)
        ,  ("M-<Space>"  , sendMessage NextLayout)
        ,  ("M-<Return>" , zshPrompt def "capture.zsh")
        ,  ("M-h"        , sendMessage Shrink)
        ,  ("M-l"        , sendMessage Expand)
        ,  ("M-S-j"      , windows W.swapDown)
        ,  ("M-S-k"      , windows W.swapUp)
        ,  ("M-t"        , withFocused $ windows . W.sink)
--        ,  ("M-,"        , sendMessage (IncMasterN 1))
        ,  ("M-e"        , windows W.swapMaster)
        ,  ("M-i i"        , spawn (myTerminal ++ " -e fish"))
        ,  ("M-i u"        , spawn (myTerminal ++ " -e bash"))
        ,  ("M-i p"        , spawn "waterfox --private-window")
        ,  ("M-<F9>"     , spawn "bash -c '[[ $(setxkbmap -query | grep -P layout:.*ru ) ]] && setxkbmap us || setxkbmap ru'")
        ,  ("M-<F2>"     , spawn "pactl set-sink-volume @DEFAULT_SINK@ -1%")
        ,  ("M-<F3>"     , spawn "pactl set-sink-volume @DEFAULT_SINK@ +1%")
        ,  ("M-w"        , windows W.focusMaster  )
        ,  ("M-d"        , (do toggleFloatNext;spawn myTerminal )  )
        ,  ("M-j"        , bindByLayout [
               ("Tabbed Simplest", windows W.focusUp)
            ,  ("", windows W.focusDown)
              ])
        ,  ("M-k", bindByLayout [
               ("Tabbed Simplest", windows W.focusDown)
            ,  ("", windows W.focusUp)
              ])

     ] ++ [
    ("M-u", submap . M.fromList $
       [
        ((0, xK_1),         spawn "wmscript-u-1"),
        ((0, xK_2),         spawn "wmscript-u-2"),
        ((0, xK_3),         spawn "wmscript-u-3"),
        ((0, xK_4),         spawn "wmscript-u-4"),
        ((0, xK_5),         spawn "wmscript-u-5"),
        ((0, xK_6),         spawn "wmscript-u-6"),
        ((0, xK_7),         spawn "wmscript-u-7"),
        ((0, xK_8),         spawn "wmscript-u-8"),
        ((0, xK_9),         spawn "wmscript-u-9"),
        ((0, xK_0),         spawn "wmscript-u-0"),

        ((0, xK_y),         spawn "wmscript-u-y"),
        ((0, xK_u),         spawn "wmscript-u-u"),
        ((0, xK_i),         spawn "wmscript-u-i"),
        ((0, xK_o),         spawn "wmscript-u-o"),
        ((0, xK_p),         spawn "wmscript-u-p"),
        ((0, xK_h),         spawn "wmscript-u-h"),
        ((0, xK_j),         spawn "wmscript-u-j"),
        ((0, xK_k),         spawn "wmscript-u-k"),
        ((0, xK_l),         spawn "wmscript-u-l"),
        ((0, xK_n),         spawn "wmscript-u-n"),
        ((0, xK_m),         spawn "wmscript-u-m"),
        ((0, xK_q),         spawn "wmscript-u-q"), -- test
        ((0, xK_semicolon), spawn "wmscript-u-semicolon"),
        ((0, xK_comma),     spawn "wmscript-u-comma"),
        ((0, xK_period),    spawn "wmscript-u-peroid"),
        ((0, xK_slash),     spawn "wmscript-u-slash"),
        ((0, xK_Return),    spawn "wmscript-u-Return")
       ])
     ]
     -- ++ 
     --  [ ("M-d",spawn "alacritty")
     --        | c <- ["alacritty"] 
     --        , let keyBinding = ("M-d", spawn "kitty")
     --        ]
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
-- myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"
-- fontName = "xft:JetBrains Mono:regular:size=9:antialias=true:hinting=true",
  fontName = "xft:Ubuntu Mono:bold:pixelsize=14",
  activeColor = "#04ddf9",
  activeTextColor = "#490b13",
  inactiveColor = "#333333",
  decoHeight = 14,
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

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "confirm"         --> doFloat
    , className =? "file_progress"   --> doFloat
    , className =? "dialog"          --> doFloat
    , className =? "Gimp"           --> doFloat
    -- , className =? "Alacritty"           --> doCenterFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myEventHook = mempty
-- myEventHook= swallowEventHook (className =? "Alacritty" <||> className =? "kitty") (return True)
-- myEventHook = docksEventHook <+> handleEventHook def <+> fullscreenEventHook
myLogHook = return ()

myStartupHook = do 
  -- spawnOnce "feh --bg-fill ~/Pictures/backgrounds/0142.jpg &"
--spawnOnce "feh --randomize --bg-fill ~/Pictures/2wallpapers/*"  -- feh set random wallpaper
  setWMName "LG3D"

main = do 
    xmonad $ docks $ ewmh $ ewmhFullscreen $ defaults
    -- xmproc <- spawnPipe "polybar mainbar-xmonad"
    -- xmonad $ docks $ ewmh $ ewmhFullscreen $ my2D $ defaults

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
        manageHook         = floatNextHook <> myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
 `additionalKeysP` ezKeybindings
