-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  ░░░░  VoidScript IDE  ░░░░  /  LunaLang IDE  ░░░░  /  NebScript IDE  ║
-- ║  Three Name Candidates — pick your favourite:                          ║
-- ║    1. NebScript   (nebula + script, dreamy + technical)                ║
-- ║    2. VoidScript  (void as in cosmic void, edgy & terse)               ║
-- ║    3. LunaLang    (lunar, clean, approachable)                         ║
-- ║                                                                        ║
-- ║  VERSION  : 1.0.0                                                      ║
-- ║  THEME    : Nebula  (dark purple / pink)                               ║
-- ║  LANGUAGES: NebScript · RbxPython · TypeRbx · Markdown · PlainText    ║
-- ║  MODULES  : 30 built-in  +  unlimited user-registered                  ║
-- ║                                                                        ║
-- ║  ONE-SCRIPT — paste the entire file into a Plugin Script in Studio.    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

if not plugin then warn("[NebScript] Must run as a Roblox Plugin.") return end

-- ════════════════════════════════════════════════════════════════════════════
--  SERVICES
-- ════════════════════════════════════════════════════════════════════════════
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local HttpService          = game:GetService("HttpService")
local RunService           = game:GetService("RunService")
local Selection            = game:GetService("Selection")
local StudioService        = game:GetService("StudioService")
local TweenService         = game:GetService("TweenService")
local UIS                  = game:GetService("UserInputService")

-- ════════════════════════════════════════════════════════════════════════════
--  NEBULA THEME
-- ════════════════════════════════════════════════════════════════════════════
local T = {
	-- Backgrounds
	BG_VOID      = Color3.fromRGB(  6,   4,  14),  -- deepest void
	BG_BASE      = Color3.fromRGB( 10,   7,  22),  -- main bg
	BG_SURFACE   = Color3.fromRGB( 15,  10,  32),  -- panels
	BG_ELEVATED  = Color3.fromRGB( 22,  14,  46),  -- raised elements
	BG_OVERLAY   = Color3.fromRGB( 28,  18,  58),  -- hover / selected
	BG_EDITOR    = Color3.fromRGB(  8,   6,  20),  -- editor bg
	BG_SIDEBAR   = Color3.fromRGB( 12,   8,  26),  -- sidebar bg
	BG_TAB       = Color3.fromRGB( 18,  12,  38),  -- inactive tab
	BG_TAB_ACT   = Color3.fromRGB( 32,  18,  64),  -- active tab
	BG_INPUT     = Color3.fromRGB( 14,  10,  30),  -- text inputs
	BG_SCROLLBAR = Color3.fromRGB( 40,  25,  80),  -- scrollbar track
	-- Nebula Accents
	NEBULA_PRI   = Color3.fromRGB(180,  80, 255),  -- primary purple
	NEBULA_SEC   = Color3.fromRGB(255,  80, 200),  -- hot pink
	NEBULA_TER   = Color3.fromRGB(130,  60, 220),  -- deep violet
	NEBULA_GLOW  = Color3.fromRGB(200, 100, 255),  -- glow purple
	NEBULA_DUST  = Color3.fromRGB( 90,  50, 160),  -- dim purple
	-- Extra accents
	CYAN         = Color3.fromRGB( 80, 220, 255),
	TEAL         = Color3.fromRGB( 60, 220, 190),
	GOLD         = Color3.fromRGB(255, 200,  60),
	GREEN        = Color3.fromRGB( 80, 255, 140),
	RED          = Color3.fromRGB(255,  75,  85),
	ORANGE       = Color3.fromRGB(255, 145,  50),
	-- Text
	TXT_BRIGHT   = Color3.fromRGB(240, 220, 255),
	TXT_PRIMARY  = Color3.fromRGB(200, 170, 240),
	TXT_DIM      = Color3.fromRGB(130, 100, 180),
	TXT_MUTED    = Color3.fromRGB( 70,  55, 110),
	TXT_WHITE    = Color3.fromRGB(255, 255, 255),
	-- Borders
	BORDER       = Color3.fromRGB( 45,  28,  90),
	BORDER_GLOW  = Color3.fromRGB(140,  60, 220),
	BORDER_PINK  = Color3.fromRGB(200,  60, 160),
	-- Syntax defaults (Nebula palette)
	SYN_KEYWORD  = Color3.fromRGB(220, 100, 255),  -- bright purple
	SYN_STRING   = Color3.fromRGB(255, 140, 180),  -- pink
	SYN_NUMBER   = Color3.fromRGB(130, 255, 180),  -- mint
	SYN_COMMENT  = Color3.fromRGB( 90,  65, 140),  -- muted violet
	SYN_FUNCTION = Color3.fromRGB(255, 200,  80),  -- gold
	SYN_TYPE     = Color3.fromRGB( 80, 230, 255),  -- cyan
	SYN_BUILTIN  = Color3.fromRGB(255, 100, 180),  -- hot pink
	SYN_OPERATOR = Color3.fromRGB(200, 160, 255),  -- lavender
	SYN_PARAM    = Color3.fromRGB(255, 180, 100),  -- amber
	SYN_MACRO    = Color3.fromRGB(255, 220,  60),  -- gold
	SYN_SPECIAL  = Color3.fromRGB( 80, 255, 220),  -- teal
	SYN_LABEL    = Color3.fromRGB(180, 255, 120),  -- lime
}

-- ════════════════════════════════════════════════════════════════════════════
--  DEFAULT SETTINGS
-- ════════════════════════════════════════════════════════════════════════════
local DEFAULTS = {
	-- ── Editor ──────────────────────────────────────────────
	ed_fontSize          = 14,
	ed_tabSize           = 4,
	ed_softTabs          = true,
	ed_wordWrap          = false,
	ed_lineNumbers       = true,
	ed_showWhitespace    = false,
	ed_autoCloseBrackets = true,
	ed_autoCloseStrings  = true,
	ed_highlightLine     = true,
	ed_smoothScroll      = true,
	ed_cursorBlink       = true,
	ed_cursorStyle       = "line",      -- line | block | underline
	ed_fontFamily        = "RobotoMono",
	ed_minimap           = true,
	ed_breadcrumbs       = true,
	ed_indentGuides      = true,
	ed_rulers            = "",          -- comma-sep column numbers e.g. "80,120"
	ed_foldGutter        = true,
	ed_scrollPastEnd     = true,
	-- ── Syntax Colors (hex strings, no #) ────────────────────
	syn_keyword          = "DC64FF",
	syn_string           = "FF8CB4",
	syn_number           = "82FFB4",
	syn_comment          = "5A4190",
	syn_function         = "FFC850",
	syn_type             = "50E6FF",
	syn_builtin          = "FF64B4",
	syn_operator         = "C8A0FF",
	syn_param            = "FFB464",
	syn_macro            = "FFDC3C",
	syn_special          = "50FFDC",
	syn_label            = "B4FF78",
	-- ── Theme Overrides ──────────────────────────────────────
	theme_bgEditor       = "08060E",
	theme_bgSidebar      = "0C081A",
	theme_accentPrimary  = "B450FF",
	theme_accentSecondary= "FF50C8",
	-- ── Compiler ─────────────────────────────────────────────
	cmp_targetService    = "ServerScriptService",
	cmp_scriptType       = "Script",   -- Script | LocalScript | ModuleScript
	cmp_strictMode       = false,
	cmp_warnings         = true,
	cmp_optimise         = false,
	cmp_insertPreamble   = true,
	cmp_wrapInPcall      = false,
	-- ── Workspace ────────────────────────────────────────────
	ws_projectName       = "MyProject",
	ws_rootService       = "ReplicatedStorage",
	-- ── Keybinds (display / doc only) ────────────────────────
	kb_compile           = "F5",
	kb_save              = "Ctrl+S",
	kb_newFile           = "Ctrl+N",
	kb_closeTab          = "Ctrl+W",
	kb_find              = "Ctrl+F",
	kb_replace           = "Ctrl+H",
	kb_comment           = "Ctrl+/",
	kb_indent            = "Tab",
	kb_outdent           = "Shift+Tab",
	kb_duplicateLine     = "Ctrl+D",
	kb_moveLine          = "Alt+Up/Down",
	kb_selectAll         = "Ctrl+A",
	kb_undo              = "Ctrl+Z",
	kb_redo              = "Ctrl+Y",
	-- ── UI ───────────────────────────────────────────────────
	ui_showStatusBar     = true,
	ui_showProblems      = true,
	ui_showMinimap       = true,
	ui_animateUI         = true,
	ui_particlesBG       = true,
	ui_confirmClose      = true,
	ui_autosave          = 60,          -- seconds; 0 = off
	ui_recentFilesMax    = 20,
	ui_tooltips          = true,
	ui_sidebarWidth      = 220,
}

local function deepCopy(t)
	local c = {}; for k,v in pairs(t) do c[k]=v end; return c
end

local S  -- active settings table

local function loadSettings()
	local ok, val = pcall(function() return plugin:GetSetting("NebScript_Settings_v1") end)
	local base = deepCopy(DEFAULTS)
	if ok and type(val) == "table" then
		for k,v in pairs(val) do base[k]=v end
	end
	return base
end

local function saveSettings()
	pcall(function() plugin:SetSetting("NebScript_Settings_v1", S) end)
end

S = loadSettings()

-- colour helper
local function hexToColor(hex)
	hex = (hex or "FFFFFF"):gsub("#","")
	return Color3.fromRGB(
		tonumber(hex:sub(1,2),16) or 255,
		tonumber(hex:sub(3,4),16) or 255,
		tonumber(hex:sub(5,6),16) or 255
	)
end
local function colorToHex(c)
	return ("%02X%02X%02X"):format(
		math.floor(c.R*255+.5),
		math.floor(c.G*255+.5),
		math.floor(c.B*255+.5))
end
local function synColor(key)
	local h = S["syn_"..key]
	return h and hexToColor(h) or (T["SYN_"..key:upper()] or T.TXT_PRIMARY)
end

-- ════════════════════════════════════════════════════════════════════════════
--  VIRTUAL FILE SYSTEM
-- ════════════════════════════════════════════════════════════════════════════
-- node = {
--   type     : "file" | "folder"
--   name     : string
--   lang     : "neb"|"rbxpy"|"typerbx"|"md"|"txt"  (file only)
--   content  : string                               (file only)
--   children : { node }                             (folder only)
--   expanded : bool                                 (folder only)
--   parent   : node | nil
--   id       : string (8-char GUID)
--   dirty    : bool                                 (file, unsaved changes)
-- }

local FS = { root=nil, index={} }

local function genId()
	return HttpService:GenerateGUID(false):sub(1,8)
end

local function fsNode(type_, name, parent, extra)
	local n = { type=type_, name=name, parent=parent, id=genId() }
	if type_=="folder" then n.children={}; n.expanded=false
	else n.content=""; n.lang="neb"; n.dirty=false end
	if extra then for k,v in pairs(extra) do n[k]=v end end
	FS.index[n.id] = n
	if parent then table.insert(parent.children, n) end
	return n
end

local function fsRemove(node)
	FS.index[node.id] = nil
	if node.parent then
		for i,c in ipairs(node.parent.children) do
			if c==node then table.remove(node.parent.children,i); break end
		end
	end
	if node.type=="folder" then
		for _,child in ipairs(node.children) do fsRemove(child) end
	end
end

local function fsMoveInto(node, newParent)
	if node==newParent then return end
	-- prevent moving into own descendant
	local cur=newParent
	while cur do if cur==node then return end; cur=cur.parent end
	if node.parent then
		for i,c in ipairs(node.parent.children) do
			if c==node then table.remove(node.parent.children,i); break end
		end
	end
	node.parent = newParent
	table.insert(newParent.children, node)
end

local function fsRename(node, newName)
	node.name = newName
end

local function fsSerialise(node)
	if node.type=="file" then
		return {t="f",n=node.name,l=node.lang,c=node.content,id=node.id,d=node.dirty}
	else
		local ch={}
		for _,child in ipairs(node.children) do ch[#ch+1]=fsSerialise(child) end
		return {t="d",n=node.name,id=node.id,e=node.expanded,ch=ch}
	end
end

local function fsDeserialise(data, parent)
	if data.t=="f" then
		local n={type="file",name=data.n,lang=data.l or "neb",content=data.c or "",
		         parent=parent,id=data.id or genId(),dirty=false}
		FS.index[n.id]=n; return n
	else
		local n={type="folder",name=data.n,parent=parent,
		         children={},id=data.id or genId(),expanded=data.e or false}
		FS.index[n.id]=n
		for _,cd in ipairs(data.ch or {}) do
			table.insert(n.children, fsDeserialise(cd,n))
		end
		return n
	end
end

local function saveProject()
	if not FS.root then return end
	local ok = pcall(function()
		plugin:SetSetting("NebScript_Project_v1", HttpService:JSONEncode({
			name    = S.ws_projectName,
			service = S.ws_rootService,
			root    = fsSerialise(FS.root),
		}))
	end)
end

local function loadProject()
	local ok, raw = pcall(function() return plugin:GetSetting("NebScript_Project_v1") end)
	if ok and type(raw)=="string" and raw~="" then
		local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
		if ok2 and data and data.root then
			FS.index = {}
			FS.root  = fsDeserialise(data.root, nil)
			S.ws_projectName = data.name or S.ws_projectName
			S.ws_rootService = data.service or S.ws_rootService
			return true
		end
	end
	return false
end

-- ════════════════════════════════════════════════════════════════════════════
--  NEBSCRIPT LANGUAGE DEFINITION  (Rust/Swift modern vibe)
-- ════════════════════════════════════════════════════════════════════════════
--[[
  NebScript  —  a strongly-expressive transpiled language for Roblox Lua.
  Design philosophy: Rust/Swift modern syntax, rich built-ins,
  zero-cost-abstractions feel, pattern matching, pipe chains, macros,
  trait-like interfaces, and full Roblox API access.

  THREE NAME CANDIDATES:
    1. NebScript   – nebula + script
    2. VoidScript  – cosmic void aesthetic
    3. LunaLang    – lunar, clean feel
]]

-- ── Keywords (70+) ──────────────────────────────────────────────────────────
local NEB_KEYWORDS = {
	-- control flow
	"if","elif","else","end","match","case","default","when","then",
	"while","for","loop","break","continue","return","yield",
	"unless","until","do","repeat","defer","fallthrough",
	-- declarations
	"let","const","var","mut","fn","func","lambda","closure",
	"class","struct","enum","trait","impl","interface","type","alias",
	"module","mod","import","export","from","use","include","require",
	-- visibility / modifiers
	"pub","priv","prot","pkg","static","final","sealed","abstract",
	"override","virtual","inline","extern","async","await","spawn",
	"lazy","move","ref","pin","unpin","unsafe","safe","atomic",
	-- logic / boolean
	"and","or","not","in","is","isnt","has","hasnt","as","where",
	"true","false","nil","null","void","self","super","this",
	"some","none","ok","err","typeof","sizeof","alignof",
	-- error handling
	"try","catch","throw","raise","except","finally","ensure",
	"panic","assert","unreachable","todo","debug","trace",
	-- roblox-specific
	"game","workspace","script","plugin","part","model","tween",
	"remote","event","signal","service","player","character",
	"humanoid","tool","gui","touched","changed","added","removing",
	-- special NebScript
	"macro","pipe","compose","curry","partial","memo","once",
	"with","using","test","bench","profile","derive","new","delete",
}

-- ── Built-in functions (60+) ────────────────────────────────────────────────
local NEB_BUILTINS = {
	-- math
	"abs","ceil","floor","round","sqrt","cbrt","pow","log","log2","log10",
	"sin","cos","tan","asin","acos","atan","atan2","exp","hypot",
	"min","max","clamp","lerp","map_range","sign","fract","wrap","pingpong",
	"random","seed","noise","smooth","smoothstep","smootherstep",
	"deg2rad","rad2deg","approx","between","divmod","gcd","lcm",
	-- string
	"len","upper","lower","trim","ltrim","rtrim","split","join",
	"replace","contains","startswith","endswith","find","gmatch",
	"format","fmt","byte","char","rep","sub","reverse","pad","lpad","rpad",
	"count","titlecase","camelcase","snakecase","kebabcase","escape","unescape",
	-- table / array / iterator
	"push","pop","shift","unshift","insert","remove","sort","sorted",
	"map","filter","reduce","find_item","findindex","every","some",
	"flat","flatmap","zip","unzip","enumerate","range","slice",
	"concat","unique","reverse_arr","keys","values","entries",
	"groupby","partition","chunk","take","skip","first","last",
	"deepcopy","shallowcopy","merge","diff","intersect","freeze","seal",
	-- type
	"typeof","tostring","tonumber","tobool","toint","tofloat","parse",
	"isstring","isnumber","isbool","istable","isnil","isfunc","isnan","isinf",
	-- io / debug
	"print","warn","error","info","log","dbg","assert","pcall","xpcall",
	-- roblox task
	"wait","delay","spawn","task_wait","task_delay","task_spawn","task_defer",
	-- vector / CFrame
	"vec2","vec3","cframe","cf_angles","cf_lookat","color3","color3_rgb","color3_hsv",
	"udim","udim2","rect","region3","ray",
	-- signal
	"connect","disconnect","fire","wait_signal","once_signal","debounce","throttle",
	-- utility
	"pipe","compose","curry","partial","flip","identity","noop","memo","once_fn",
	"uuid","hash","timestamp","encode_json","decode_json",
}

-- ── Built-in variables / constants ──────────────────────────────────────────
local NEB_BUILTIN_VARS = {
	-- roblox globals
	"game","workspace","script","plugin","shared","_G","_VERSION","_ENV",
	-- math constants
	"PI","TAU","E","PHI","INF","NAN","MAXINT","MININT","EPSILON","SQRT2","SQRT3",
	-- colour constants
	"RED","GREEN","BLUE","WHITE","BLACK","YELLOW","CYAN","MAGENTA",
	"TRANSPARENT","GRAY","ORANGE","PURPLE","PINK","LIME","TEAL","INDIGO",
	-- vector constants
	"ZERO","ONE","UP","DOWN","LEFT","RIGHT","FORWARD","BACK",
	"ZERO2","ONE2","ZERO3","ONE3","X_AXIS","Y_AXIS","Z_AXIS",
	-- time / frame
	"TIME","DELTA","TICK","CLOCK","FRAMERATE","FRAME","DT",
	-- special
	"NULL","VOID","TRUE","FALSE","SELF","SUPER","ENV","ARGS","ARGV",
}

-- ── Unique NebScript operators ───────────────────────────────────────────────
local NEB_OPERATORS = {
	"|>", "<|",        -- pipes: value |> fn , fn <| value
	"??", "?.",        -- nullish coalescing, safe navigation
	"**",              -- power
	"//",              -- integer division
	"%%",              -- always-positive modulo
	"<=>",             -- spaceship / three-way comparison
	"->", "=>",        -- arrow fn (slim), fat arrow fn
	"::", "..",        -- namespace scope, concat
	"@",               -- macro/decorator prefix
	"#",               -- length / count prefix
	"$",               -- string interpolation sigil
	"...",             -- spread / vararg
	"&&", "||", "!",   -- logical shortcuts
	"!=", "===", "!==",-- equality variants
	"+=","-=","*=","/=","//=","**=","%%=","..=","&&=","||=",
	"&","^","~","<<",">>",  -- bitwise
	"<<=",">>=","&=","^=","|=",
}

-- ── NebScript macro list ─────────────────────────────────────────────────────
local NEB_MACROS = {
	"@memo","@once","@debounce","@throttle","@deprecated","@unstable",
	"@override","@abstract","@final","@inline","@extern","@unsafe",
	"@derive","@serialise","@roblox","@client","@server","@shared",
	"@component","@system","@signal","@event","@hook","@reactive",
	"@test","@bench","@profile","@log","@trace","@assert_type",
}

-- ════════════════════════════════════════════════════════════════════════════
--  TOKENISER  (shared, used by both compiler + syntax highlighter)
-- ════════════════════════════════════════════════════════════════════════════
local TT = {
	KEYWORD="KW", IDENT="ID", NUMBER="NUM", STRING="STR",
	OPERATOR="OP", PUNCT="PU", COMMENT="CM", NEWLINE="NL",
	MACRO="MA", BUILTIN="BL", BUILTIN_VAR="BV", EOF="EOF",
}

local function isNebKeyword(w)
	for _,k in ipairs(NEB_KEYWORDS) do if k==w then return true end end
end
local function isNebBuiltin(w)
	for _,b in ipairs(NEB_BUILTINS) do if b==w then return true end end
end
local function isNebBuiltinVar(w)
	for _,v in ipairs(NEB_BUILTIN_VARS) do if v==w then return true end end
end

-- Produce a flat token list from source
local function tokenise(src, lang)
	local tokens, i, line, n = {}, 1, 1, #src
	local function c(off) return src:sub(i+(off or 0), i+(off or 0)) end
	local function s(a,b) return src:sub(i+a, i+b) end
	local function adv(n_) i=i+(n_ or 1) end

	-- language-specific keyword sets
	local kwSet, blSet
	if lang=="rbxpy" then
		kwSet = {if_=1,elif=1,else_=1,for_=1,while_=1,def=1,class_=1,
		         return_=1,import=1,from=1,as=1,try=1,except=1,finally=1,
		         with=1,pass=1,break_=1,continue_=1,and_=1,or_=1,not_=1,
		         in=1,is=1,None=1,True=1,False=1,lambda=1,yield=1,
		         global=1,nonlocal=1,raise=1,del=1,assert=1,async=1,await=1,
		         match=1,case=1}
		blSet = {print=1,len=1,range=1,type=1,str=1,int=1,float=1,
		         bool=1,list=1,dict=1,tuple=1,set=1,zip=1,enumerate=1,
		         map=1,filter=1,sorted=1,reversed=1,sum=1,min=1,max=1,
		         abs=1,round=1,isinstance=1,hasattr=1,getattr=1,setattr=1,
		         super=1,property=1,staticmethod=1,classmethod=1}
	elseif lang=="typerbx" then
		kwSet = {const=1,let=1,var=1,function_=1,class_=1,interface=1,
		         type=1,enum=1,if_=1,else_=1,for_=1,while_=1,do_=1,
		         return_=1,import=1,export=1,from=1,as=1,extends=1,
		         implements=1,new=1,this=1,super=1,typeof=1,instanceof=1,
		         in=1,of=1,break_=1,continue_=1,try=1,catch=1,finally=1,
		         throw=1,async=1,await=1,public=1,private=1,protected=1,
		         readonly=1,static=1,abstract=1,override=1,null=1,
		         undefined=1,true_=1,false_=1,void=1,never=1,any=1,
		         string_=1,number=1,boolean=1,keyof=1,infer=1,namespace=1,
		         declare=1,module=1,satisfies=1}
		blSet = {console=1,Math=1,Object=1,Array=1,String=1,Number=1,
		         Boolean=1,Promise=1,JSON=1,Map=1,Set=1,Date=1,
		         setTimeout=1,setInterval=1,clearTimeout=1,fetch=1,
		         require=1,module_=1,exports=1,Symbol=1,Reflect=1,Proxy=1}
	else -- neb
		kwSet={}; for _,k in ipairs(NEB_KEYWORDS) do kwSet[k]=true end
		blSet={}; for _,b in ipairs(NEB_BUILTINS) do blSet[b]=true end
	end

	local function addTok(type_,val,extraLine)
		tokens[#tokens+1]={t=type_,v=val,ln=extraLine or line}
	end

	while i<=n do
		local ch=c()

		-- newline
		if ch=="\n" then
			addTok(TT.NEWLINE,"\n"); line=line+1; adv()

		-- whitespace
		elseif ch==" " or ch=="\t" or ch=="\r" then adv()

		-- Lua block comment --[[
		elseif ch=="-" and s(1,3)=="--[" and (s(3,3)=="[" or s(3,3)=="=") then
			local start=i; local level=0
			local j=i+2
			while j<=n and src:sub(j,j)=="=" do level=level+1; j=j+1 end
			if src:sub(j,j)=="[" then
				j=j+1
				local close="]"..("="):rep(level).."]"
				local endIdx=src:find(close,j,true)
				if endIdx then
					local blk=src:sub(start,endIdx+#close-1)
					for _ in blk:gmatch("\n") do line=line+1 end
					addTok(TT.COMMENT,blk); i=endIdx+#close
				else addTok(TT.COMMENT,src:sub(start)); i=n+1 end
			else
				-- treat as line comment
				while i<=n and c()~="\n" do adv() end
				addTok(TT.COMMENT,src:sub(start,i-1))
			end

		-- line comment -- or //
		elseif (ch=="-" and s(1,1)=="-") or (ch=="/" and s(1,1)=="/") then
			local start=i; adv(2)
			while i<=n and c()~="\n" do adv() end
			addTok(TT.COMMENT,src:sub(start,i-1))

		-- block comment /* */
		elseif ch=="/" and s(1,1)=="*" then
			local start=i; adv(2)
			while i<=n do
				if c()=="*" and s(1,1)=="/" then adv(2); break end
				if c()=="\n" then line=line+1 end; adv()
			end
			addTok(TT.COMMENT,src:sub(start,i-1))

		-- Lua long string [[ or [==[
		elseif ch=="[" and (s(1,1)=="[" or s(1,1)=="=") then
			local level=0; local j=i+1
			while j<=n and src:sub(j,j)=="=" do level=level+1; j=j+1 end
			if src:sub(j,j)=="[" then
				j=j+1
				local close="]"..("="):rep(level).."]"
				local endIdx=src:find(close,j,true)
				if endIdx then
					local blk=src:sub(i,endIdx+#close-1)
					for _ in blk:gmatch("\n") do line=line+1 end
					addTok(TT.STRING,blk); i=endIdx+#close
				else addTok(TT.STRING,src:sub(i)); i=n+1 end
			else addTok(TT.PUNCT,"["); adv() end

		-- strings
		elseif ch=='"' or ch=="'" or ch=="`" then
			local q=ch; local start=i; adv()
			local val=q
			while i<=n do
				local cc=c()
				if cc==q then val=val..q; adv(); break
				elseif cc=="\\" then val=val..cc..c(1); adv(2)
				elseif cc=="\n" then line=line+1; val=val..cc; adv()
				else val=val..cc; adv() end
			end
			addTok(TT.STRING,val)

		-- numbers  (0x hex, 0b bin, 0o oct, decimal with _ separators)
		elseif ch:match("%d") or (ch=="." and s(1,1):match("%d")) then
			local start=i
			if ch=="0" and (s(1,1)=="x" or s(1,1)=="X") then
				adv(2); while i<=n and c():match("[%da-fA-F_]") do adv() end
			elseif ch=="0" and (s(1,1)=="b" or s(1,1)=="B") then
				adv(2); while i<=n and c():match("[01_]") do adv() end
			elseif ch=="0" and (s(1,1)=="o" or s(1,1)=="O") then
				adv(2); while i<=n and c():match("[0-7_]") do adv() end
			else
				while i<=n and (c():match("[%d_]") or
				      (c()=="." and s(1,1):match("%d") and not src:sub(i-1,i-1):match("%d%.%d"))) do adv() end
				if c()=="e" or c()=="E" then
					adv()
					if c()=="+" or c()=="-" then adv() end
					while i<=n and c():match("%d") do adv() end
				end
				-- suffix: f32, u64, i32, etc.
				if c():match("[uifz]") then
					local j2=i; while j2<=n and src:sub(j2,j2):match("[%a%d]") do j2=j2+1 end; i=j2
				end


		else adv() end
	end
	addTok(TT.EOF,"")
	return tokens
end
