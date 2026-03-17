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
			end
			addTok(TT.NUMBER,src:sub(start,i-1))

		-- macro @
		elseif ch=="@" then
			local start=i; adv()
			while i<=n and c():match("[%w_]") do adv() end
			addTok(TT.MACRO,src:sub(start,i-1))

		-- identifier / keyword / builtin
		elseif ch:match("[%a_]") then
			local start=i
			while i<=n and c():match("[%w_]") do adv() end
			local w=src:sub(start,i-1)
			if kwSet[w] then addTok(TT.KEYWORD,w)
			elseif blSet[w] then addTok(TT.BUILTIN,w)
			elseif lang=="neb" and isNebBuiltinVar(w) then addTok(TT.BUILTIN_VAR,w)
			else addTok(TT.IDENT,w) end

		-- operators (try longest match first, up to 4 chars)
		elseif ch:match("[%+%-%*/%%<>=!&|%.%?:^~#$]") then
			local best=""
			for len=4,1,-1 do
				local op=src:sub(i,i+len-1)
				for _,allowed in ipairs(NEB_OPERATORS) do
					if op==allowed then best=op; break end
				end
				if best~="" then break end
			end
			if best~="" then addTok(TT.OPERATOR,best); adv(#best)
			else addTok(TT.OPERATOR,ch); adv() end

		-- punctuation
		elseif ch:match("[%(%)%[%]{}%;,]") then
			addTok(TT.PUNCT,ch); adv()

		else adv() end
	end
	addTok(TT.EOF,"")
	return tokens
end
-- ════════════════════════════════════════════════════════════════════════════
--  SYNTAX HIGHLIGHTER
--  Returns RichText-marked-up string for a single line
-- ════════════════════════════════════════════════════════════════════════════
local function escapeRT(s)
	return s:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
end
local function span(text, col)
	local h=colorToHex(col)
	return ('<font color="#%s">%s</font>'):format(h, escapeRT(text))
end
local function spanBold(text, col)
	local h=colorToHex(col)
	return ('<font color="#%s"><b>%s</b></font>'):format(h, escapeRT(text))
end

local function highlightLine(line, lang)
	if not line or line=="" then return "" end
	local toks = tokenise(line, lang)
	local out = ""
	for _,tok in ipairs(toks) do
		local v = tok.v
		if tok.t==TT.EOF or tok.t==TT.NEWLINE then
			-- skip
		elseif tok.t==TT.COMMENT then
			out=out..span(v, synColor("comment"))
		elseif tok.t==TT.KEYWORD then
			out=out..spanBold(v, synColor("keyword"))
		elseif tok.t==TT.BUILTIN then
			out=out..span(v, synColor("builtin"))
		elseif tok.t==TT.BUILTIN_VAR then
			out=out..spanBold(v, synColor("special"))
		elseif tok.t==TT.STRING then
			-- highlight $interpolation within strings
			if v:find("%$[%a_]") then
				local inner=v:sub(2,#v-1)
				local q=v:sub(1,1)
				local built=span(q, synColor("string"))
				local i2=1
				while i2<=#inner do
					local s2,e2=inner:find("%$([%a_][%w_]*)",i2)
					if s2 then
						built=built..span(inner:sub(i2,s2-1),synColor("string"))
						built=built..span(inner:sub(s2,e2),synColor("special"))
						i2=e2+1
					else
						built=built..span(inner:sub(i2),synColor("string")); break
					end
				end
				out=out..built..span(q,synColor("string"))
			else
				out=out..span(v, synColor("string"))
			end
		elseif tok.t==TT.NUMBER then
			out=out..span(v, synColor("number"))
		elseif tok.t==TT.MACRO then
			out=out..spanBold(v, synColor("macro"))
		elseif tok.t==TT.OPERATOR then
			out=out..span(v, synColor("operator"))
		elseif tok.t==TT.PUNCT then
			out=out..span(v, synColor("operator"))
		elseif tok.t==TT.IDENT then
			-- peek: if next meaningful token is ( it's a function call
			-- (simplified: just check plain token stream)
			out=out..escapeRT(v)
		else
			out=out..escapeRT(v)
		end
	end
	return out
end

-- ════════════════════════════════════════════════════════════════════════════
--  NEBSCRIPT COMPILER  (NebScript → Roblox Lua)
-- ════════════════════════════════════════════════════════════════════════════
local NEB_PREAMBLE = [[
--[[ NebScript Runtime — auto-inserted by compiler ]]
local __neb={};local __neb_mt={__index=__neb}
__neb.pipe=function(v,...)local r=v;for _,f in ipairs({...})do r=f(r)end;return r end
__neb.compose=function(...)local fs={...};return function(x)local r=x;for i=#fs,1,-1 do r=fs[i](r)end;return r end end
__neb.curry=function(f,a)return function(b)return f(a,b)end end
__neb.partial=function(f,...)local a={...};return function(...)local b={...};local c={}for _,v in ipairs(a)do c[#c+1]=v end;for _,v in ipairs(b)do c[#c+1]=v end;return f(table.unpack(c))end end
__neb.memo=function(f)local cache={};return function(...)local k=table.concat({...},"\1");if cache[k]==nil then cache[k]=f(...)end;return cache[k]end end
__neb.once=function(f)local d,r=false;return function(...)if not d then d=true;r=f(...)end;return r end end
__neb.map=function(t,f)local r={};for i,v in ipairs(t)do r[i]=f(v,i)end;return r end
__neb.filter=function(t,f)local r={};for _,v in ipairs(t)do if f(v)then r[#r+1]=v end end;return r end
__neb.reduce=function(t,f,init)local a=init;for _,v in ipairs(t)do a=f(a,v)end;return a end
__neb.range=function(a,b,s)s=s or 1;local r={};for i=a,b,s do r[#r+1]=i end;return r end
__neb.keys=function(t)local r={};for k in pairs(t)do r[#r+1]=k end;return r end
__neb.values=function(t)local r={};for _,v in pairs(t)do r[#r+1]=v end;return r end
__neb.deepcopy=function(t)if type(t)~="table"then return t end;local c={};for k,v in pairs(t)do c[__neb.deepcopy(k)]=__neb.deepcopy(v)end;return setmetatable(c,getmetatable(t))end
__neb.merge=function(...)local r={};for _,t in ipairs({...})do for k,v in pairs(t)do r[k]=v end end;return r end
__neb.id=function(x)return x end;__neb.noop=function()end
-- math extras
local PI,TAU,E,PHI=math.pi,math.pi*2,math.exp(1),(1+math.sqrt(5))/2
local INF,EPSILON=math.huge,1e-10
local ZERO,ONE=Vector3.zero,Vector3.one
local UP,DOWN,LEFT,RIGHT,FORWARD,BACK=Vector3.new(0,1,0),Vector3.new(0,-1,0),
  Vector3.new(-1,0,0),Vector3.new(1,0,0),Vector3.new(0,0,-1),Vector3.new(0,0,1)
local function clamp(v,lo,hi)return math.max(lo,math.min(hi,v))end
local function lerp(a,b,t)return a+(b-a)*t end
local function sign(x)return x>0 and 1 or x<0 and -1 or 0 end
local function round(x,d)local m=10^(d or 0);return math.floor(x*m+.5)/m end
local function map_range(v,a,b,c,d)return c+(v-a)*(d-c)/(b-a)end
--[[ End NebScript Runtime ]]
]]

local function compileNebScript(src)
	local out = src

	-- ── 1. String interpolation  "hello $name!"  →  "hello "..tostring(name).."!" ──
	out = out:gsub('"([^"]*)"', function(inner)
		if inner:find("%$[%a_]") then
			local r=inner:gsub("%$([%a_][%w_%.]*)", '"..tostring(%1).."')
			return '"'..r..'"'
		end
		return '"'..inner..'"'
	end)
	-- backtick template literal `hello ${name}` → "hello "..tostring(name)..""
	out = out:gsub("`([^`]*)`", function(inner)
		local r=inner:gsub("%${([^}]+)}", '"..tostring(%1).."')
		return '"'..r..'"'
	end)

	-- ── 2. Arrow fns  (a, b) -> expr  and  a -> expr  ──────────────────────
	out = out:gsub("%(([^%)]*)%)%s*%->%s*(%b{})", function(params,body)
		local inner=body:sub(2,#body-1)
		return "function("..params..")"..inner.." end"
	end)
	out = out:gsub("%(([^%)]*)%)%s*%->%s*([^\n{][^\n]*)", function(params,expr)
		return "function("..params..") return "..expr.." end"
	end)
	out = out:gsub("([%a_][%w_]*)%s*%->%s*([^\n{][^\n]*)", function(p,expr)
		return "function("..p..") return "..expr.." end"
	end)

	-- ── 3. Fat arrows  a => expr  ────────────────────────────────────────────
	out = out:gsub("([%a_][%w_]*)%s*=>%s*([^\n]+)", function(p,expr)
		return "function("..p..") return "..expr.." end"
	end)

	-- ── 4. Pipe  x |> fn1 |> fn2  ────────────────────────────────────────────
	local function resolvePipes(segment)
		local parts={}
		for piece in (segment.."|>"):gmatch("(.-)%s*|>%s*") do
			local trimmed=piece:match("^%s*(.-)%s*$")
			if trimmed~="" then parts[#parts+1]=trimmed end
		end
		if #parts<2 then return segment end
		local res=parts[1]
		for j=2,#parts do res=parts[j].."("..res..")" end
		return res
	end
	out = out:gsub("[^\n]+", function(line)
		if line:find("|>") then return resolvePipes(line) end
		return line
	end)

	-- ── 5. Nullish  x ?? y  ──────────────────────────────────────────────────
	out = out:gsub("([%w_%.%(%)%[%]\"'`]+)%s*%?%?%s*([%w_%.%(%)%[%]\"'`]+)",
		"(%1~=nil and %1 or %2)")

	-- ── 6. Safe nav  x?.y  and  x?.fn()  ─────────────────────────────────────
	out = out:gsub("([%a_][%w_]*)%?%.([%a_][%w_]*)(%()", function(obj,m,p)
		return "("..obj.." and "..obj..":"..m..p.." or nil)"
	end)
	out = out:gsub("([%a_][%w_]*)%?%.([%a_][%w_]*)", function(obj,m)
		return "("..obj.." and "..obj.."."..m.." or nil)"
	end)

	-- ── 7. Operators  ─────────────────────────────────────────────────────────
	out = out:gsub("%*%*", "^")                      -- ** → ^
	out = out:gsub("!==", "~="):gsub("===","==")     -- !== === 
	out = out:gsub("!=",  "~=")                      -- !=
	out = out:gsub("&&",  " and ")                   -- &&
	out = out:gsub("||",  " or ")                    -- ||
	-- ! (not) — only when not preceded by ~ or = 
	out = out:gsub("([^~=<>!])!([^=])", function(a,b) return a.." not "..b end)

	-- ── 8. Declarations  ─────────────────────────────────────────────────────
	out = out:gsub("%f[%a]let%f[%A]",   "local")
	out = out:gsub("%f[%a]const%f[%A]", "local")
	out = out:gsub("%f[%a]var%f[%A]",   "local")
	out = out:gsub("%f[%a]mut%f[%A]",   "local")

	-- ── 9. fn / func → function  ──────────────────────────────────────────────
	out = out:gsub("%f[%a]fn%f[%A]",   "function")
	out = out:gsub("%f[%a]func%f[%A]", "function")

	-- ── 10. elif → elseif  ────────────────────────────────────────────────────
	out = out:gsub("%f[%a]elif%f[%A]", "elseif")

	-- ── 11. unless / until  ───────────────────────────────────────────────────
	out = out:gsub("%f[%a]unless%f[%A]%s+(.-)%s+then", function(cond)
		return "if not ("..cond..") then"
	end)
	out = out:gsub("%f[%a]until%f[%A]%s+(.-)%s+do", function(cond)
		return "while not ("..cond..") do"
	end)

	-- ── 12. loop → while true do  ─────────────────────────────────────────────
	out = out:gsub("%f[%a]loop%f[%A]%s*\n", "while true do\n")
	out = out:gsub("%f[%a]loop%f[%A]%s*{",  "while true do")

	-- ── 13. for x in range(...)  ──────────────────────────────────────────────
	out = out:gsub("for%s+([%a_][%w_]*)%s+in%s+range%((%d+)%)",
		function(v,n) return "for "..v.."=1,"..n.." do" end)
	out = out:gsub("for%s+([%a_][%w_]*)%s+in%s+range%(([^,%)]+)%s*,%s*([^,%)]+)%)",
		function(v,a,b) return "for "..v.."="..a..","..b.." do" end)
	out = out:gsub("for%s+([%a_][%w_]*)%s+in%s+range%(([^,%)]+)%s*,%s*([^,%)]+)%s*,%s*([^%)]+)%)",
		function(v,a,b,s) return "for "..v.."="..a..","..b..","..s.." do" end)

	-- ── 14. match / case / default  ───────────────────────────────────────────
	local matchDepth=0
	out = out:gsub("match%s+([^\n{]+)%s*{", function(expr)
		matchDepth=matchDepth+1
		return "do local __m=("..expr:match("^%s*(.-)%s*$")..")"
	end)
	local caseNum=0
	out = out:gsub("case%s+([^\n:]+):", function(pat)
		caseNum=caseNum+1
		local kw = caseNum==1 and "if" or "elseif"
		return kw.." __m==("..pat:match("^%s*(.-)%s*$")..") then"
	end)
	out = out:gsub("%f[%a]default%f[%A]%s*:", "else")

	-- ── 15. struct  ───────────────────────────────────────────────────────────
	out = out:gsub("struct%s+([%a_][%w_]*)%s*(%b{})", function(name, body)
		local fields={}
		for f in body:sub(2,#body-1):gmatch("[%a_][%w_]*") do fields[#fields+1]=f end
		local params=table.concat(fields,",")
		local init={}; for _,f in ipairs(fields) do init[#init+1]=f.."="..f end
		return ("local %s={} %s.__index=%s\n"):format(name,name,name)..
		       ("function %s.new(%s) return setmetatable({%s},%s) end"):format(
		       name,params,table.concat(init,","),name)
	end)

	-- ── 16. class ... extends ... / class ...  ────────────────────────────────
	out = out:gsub("class%s+([%a_][%w_]*)%s+extends%s+([%a_][%w_]*)", function(n,p)
		return "local "..n.."=setmetatable({},{__index="..p.."}) "..n..".__index="..n
	end)
	out = out:gsub("class%s+([%a_][%w_]*)", function(n)
		return "local "..n.."={} "..n..".__index="..n
	end)

	-- ── 17. new ClassName(...)  ───────────────────────────────────────────────
	out = out:gsub("new%s+([%a_][%w_]*)%(", function(n) return n..".new(" end)

	-- ── 18. Spread  ...arr  →  table.unpack(arr)  ────────────────────────────
	out = out:gsub("%.%.%.([%a_][%w_]*)", function(v) return "table.unpack("..v..")" end)

	-- ── 19. import ... from "path"  ───────────────────────────────────────────
	out = out:gsub('import%s+([%a_][%w_]*)%s+from%s+"([^"]+)"',
		function(name,path) return 'local '..name..'=require("'..path..'")' end)
	out = out:gsub("import%s+([%a_][%w_]*)%s+from%s+'([^']+)'",
		function(name,path) return "local "..name.."=require('"..path.."')" end)
	out = out:gsub("%f[%a]export%f[%A]%s*", "")

	-- ── 20. try / catch  ──────────────────────────────────────────────────────
	out = out:gsub("try%s*(%b{})%s*catch%s*%(([^%)]+)%)%s*(%b{})",
		function(tbody,evar,cbody)
		return "local __ok,__err=pcall(function()\n"..tbody:sub(2,#tbody-1).."\nend)\n"..
		       "if not __ok then\nlocal "..evar:match("^%s*(.-)%s*$").."=__err\n"..cbody:sub(2,#cbody-1).."\nend"
	end)
	out = out:gsub("%f[%a]throw%f[%A]", "error")
	out = out:gsub("%f[%a]raise%f[%A]", "error")

	-- ── 21. Decorators  @name  →  comment  (can be extended)  ────────────────
	out = out:gsub("(@[%a_][%w_]*[^\n]*)\n", "-- [decorator] %1\n")

	-- ── 22. Type annotations  name: Type  →  name  ───────────────────────────
	-- strip `: SomeType` from fn params and let declarations
	out = out:gsub("([%a_][%w_]*)%s*:%s*[%a_][%w_%.<>|?%[%]]*", function(id)
		return id
	end)

	-- ── 23. :: namespace  →  .  ───────────────────────────────────────────────
	out = out:gsub("::", ".")

	-- ── 24. Compound operators  ───────────────────────────────────────────────
	-- x += y → x = x + y  (for supported set)
	local compound={["+="]="+",["-="]="-",["*="]="*",["/="]="/",["..="]=".."}
	for op,base in pairs(compound) do
		out = out:gsub("([%a_][%w_%.%[%]]*) "..op:gsub("%p","%%%1").." ([^\n]+)",
			function(lhs,rhs)
				return lhs.." = "..lhs.." "..base.." ("..rhs..")"
			end)
	end

	-- ── 25. Integer division  x // y  →  math.floor(x/y)  ───────────────────
	-- only when not a comment (// already stripped above at comment stage)
	out = out:gsub("([%w%)%]]+)%s*//%s*([%w%(]+)", function(a,b)
		return "math.floor("..a.."/"..b..")"
	end)

	-- ── 26. Always-positive modulo  x %% y  →  ((x%y)+y)%y  ─────────────────
	out = out:gsub("([%w%)%]]+)%s*%%%%s*([%w%(]+)", function(a,b)
		return "(("..a.."%"..b.."+"..b..")".."%"..b..")"
	end)

	-- ── 27. with ... using  ───────────────────────────────────────────────────
	out = out:gsub("with%s+(.-)%s+using%s+([%a_][%w_]*)", function(expr,name)
		return "do local "..name.."="..expr
	end)

	-- ── Done ──────────────────────────────────────────────────────────────────
	if S.cmp_insertPreamble then
		out = NEB_PREAMBLE.."\n"..out
	end
	if S.cmp_wrapInPcall then
		out = "local __ok,__err=pcall(function()\n"..out.."\nend)\nif not __ok then warn('[NebScript]',__err) end"
	end
	return out
end

-- ════════════════════════════════════════════════════════════════════════════
--  RBXPYTHON COMPILER  (Python-like → Roblox Lua)
-- ════════════════════════════════════════════════════════════════════════════
local function compileRbxPython(src)
	local lines={}
	for ln in (src.."\n"):gmatch("([^\n]*)\n") do lines[#lines+1]=ln end

	local out       = {}
	local indStack  = {0}
	local blockStack= {}   -- track what each indent opened

	local function curInd() return indStack[#indStack] end
	local function getInd(ln)
		local sp=ln:match("^( *)")
		return #sp
	end

	local function closeBlocks(newInd)
		while #indStack>1 and newInd<curInd() do
			table.remove(indStack)
			local blk=table.remove(blockStack)
			if blk=="try_pcall" then
				out[#out+1]="end)\nif not __ok then"
			elseif blk=="except" then
				out[#out+1]="end"
			else
				out[#out+1]="end"
			end
		end
	end

	local function py2lua(s)
		s=s:gsub("%f[%a]None%f[%A]","nil")
		s=s:gsub("%f[%a]True%f[%A]","true")
		s=s:gsub("%f[%a]False%f[%A]","false")
		s=s:gsub("%f[%a]and%f[%A]"," and ")
		s=s:gsub("%f[%a]or%f[%A]"," or ")
		s=s:gsub("%f[%a]not%f[%A]"," not ")
		s=s:gsub("!=","~=")
		s=s:gsub("%*%*","^")
		-- f-strings  f"hello {name}"
		s=s:gsub('f"([^"]*)"', function(inner)
			local r=inner:gsub("{([^}]+)}", '"..tostring(%1).."')
			return '"'..r..'"'
		end)
		-- self. → self:  for method calls only (heuristic)
		-- print( → print(
		return s
	end

	for _, rawLine in ipairs(lines) do
		local ind     = getInd(rawLine)
		local stripped= rawLine:match("^%s*(.-)%s*$")

		if stripped=="" then out[#out+1]=""; goto continue end

		closeBlocks(ind)

		local prefix=rawLine:match("^( *)")

		-- # comment
		if stripped:sub(1,1)=="#" then
			out[#out+1]=prefix.."--"..stripped:sub(2)
			goto continue
		end

		-- def name(params):
		do
			local fname,parms=stripped:match("^def%s+([%a_][%w_]*)%((.-)%)%s*:")
			if fname then
				local luaParams=parms:gsub("self,?%s*",""):gsub("%*([%a_][%w_]*)","...")
				out[#out+1]=prefix.."function "..fname.."("..luaParams..")"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="def"
				goto continue
			end
		end

		-- class Name(Base): or class Name:
		do
			local cname,cbase=stripped:match("^class%s+([%a_][%w_]*)%(([^%)]+)%)%s*:")
			if not cname then cname=stripped:match("^class%s+([%a_][%w_]*)%s*:") end
			if cname then
				if cbase then
					out[#out+1]=prefix.."local "..cname.."=setmetatable({},{__index="..cbase.."}) "..cname..".__index="..cname
				else
					out[#out+1]=prefix.."local "..cname.."={} "..cname..".__index="..cname
				end
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="class"
				goto continue
			end
		end

		-- if cond:
		do
			local cond=stripped:match("^if%s+(.+):")
			if cond then
				out[#out+1]=prefix.."if "..py2lua(cond).." then"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="if"
				goto continue
			end
		end

		-- elif cond:
		do
			local cond=stripped:match("^elif%s+(.+):")
			if cond then
				out[#out+1]=prefix.."elseif "..py2lua(cond).." then"
				goto continue
			end
		end

		-- else:
		if stripped:match("^else%s*:") then
			out[#out+1]=prefix.."else"; goto continue
		end

		-- for x in range(n): / for x in range(a,b): / for x in range(a,b,s):
		do
			local v,a,b,step=stripped:match("^for%s+([%a_][%w_]*)%s+in%s+range%(([^,%)]+)%s*,%s*([^,%)]+)%s*,%s*([^%)]+)%)%s*:")
			if v then
				out[#out+1]=prefix.."for "..v.."="..py2lua(a)..","..py2lua(b)..","..py2lua(step).." do"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="for"; goto continue
			end
			v,a,b=stripped:match("^for%s+([%a_][%w_]*)%s+in%s+range%(([^,%)]+)%s*,%s*([^%)]+)%)%s*:")
			if v then
				out[#out+1]=prefix.."for "..v.."="..py2lua(a)..","..py2lua(b).." do"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="for"; goto continue
			end
			v,a=stripped:match("^for%s+([%a_][%w_]*)%s+in%s+range%(([^%)]+)%)%s*:")
			if v then
				out[#out+1]=prefix.."for "..v.."=1,"..py2lua(a).." do"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="for"; goto continue
			end
		end

		-- for k, v in dict.items():
		do
			local k,v,d=stripped:match("^for%s+([%a_][%w_]*)%s*,%s*([%a_][%w_]*)%s+in%s+([%a_][%w_%.%(%)]+)%.items%(%)%s*:")
			if k then
				out[#out+1]=prefix.."for "..k..","..v.." in pairs("..d..") do"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="for"; goto continue
			end
		end

		-- for x in iterable:
		do
			local v,it=stripped:match("^for%s+([%a_][%w_]*)%s+in%s+([%a_][%w_%.%(%)]+)%s*:")
			if v then
				out[#out+1]=prefix.."for _,"..v.." in ipairs("..it..") do"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="for"; goto continue
			end
		end

		-- while cond:
		do
			local cond=stripped:match("^while%s+(.+):")
			if cond then
				out[#out+1]=prefix.."while "..py2lua(cond).." do"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="while"
				goto continue
			end
		end

		-- try:
		if stripped=="try:" then
			out[#out+1]=prefix.."local __ok,__err=pcall(function()"
			indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="try_pcall"
			goto continue
		end

		-- except (Exception as e): / except:
		do
			local evar=stripped:match("^except%s+[%a_%.]+%s+as%s+([%a_][%w_]*)%s*:")
			local bare=stripped:match("^except%s*:")
			if evar or bare then
				out[#out+1]=prefix.."local "..(evar or "__err").."=__err"
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="except"
				goto continue
			end
		end

		-- finally:
		if stripped=="finally:" then
			out[#out+1]=prefix.."-- [finally]"
			indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="finally"
			goto continue
		end

		-- with expr as var:
		do
			local expr,var=stripped:match("^with%s+(.-)%s+as%s+([%a_][%w_]*)%s*:")
			if expr then
				out[#out+1]=prefix.."do local "..var.."="..py2lua(expr)
				indStack[#indStack+1]=ind+1; blockStack[#blockStack+1]="with"
				goto continue
			end
		end

		-- pass
		if stripped=="pass" then out[#out+1]=prefix.."-- pass"; goto continue end

		-- return
		do
			local rv=stripped:match("^return%s*(.*)")
			if rv~=nil then out[#out+1]=prefix.."return "..py2lua(rv); goto continue end
		end

		-- raise / assert
		do
			local msg=stripped:match("^raise%s+(.*)")
			if msg then out[#out+1]=prefix.."error("..py2lua(msg)..")"; goto continue end
		end

		-- list comprehension  [expr for x in iter]  →  __neb.map(iter, fn)
		do
			local expr,v,it=stripped:match("%[(.-)%s+for%s+([%a_][%w_]*)%s+in%s+(.-)%]")
			if expr then
				-- approximate
				local converted=stripped:gsub("%[(.-)%s+for%s+([%a_][%w_]*)%s+in%s+(.-)%]",
					function(e,vv,iit)
						return "{}--[[comprehension: "..e.." for "..vv.." in "..iit.."]]"
					end)
				out[#out+1]=prefix..py2lua(converted); goto continue
			end
		end

		-- generic line
		out[#out+1]=prefix..py2lua(stripped)

		::continue::
	end

	closeBlocks(0)

	return "-- [RbxPython compiled]\n"..table.concat(out,"\n")
end

-- ════════════════════════════════════════════════════════════════════════════
--  TYPERBX COMPILER  (TypeScript-inspired → Roblox Lua)
-- ════════════════════════════════════════════════════════════════════════════
local function compileTypeRbx(src)
	local out=src

	-- ── 1. Interfaces / type aliases → comments ───────────────────────────────
	out=out:gsub("interface%s+[%a_][%w_<>, ]*%s*(%b{})", function(blk)
		return "--[[ interface removed ]]"
	end)
	out=out:gsub("type%s+[%a_][%w_<>, ]*%s*=[^\n]+","--[[ type alias ]]")
	out=out:gsub("namespace%s+[%a_][%w_]*%s*(%b{})","--[[ namespace ]]")
	out=out:gsub("declare%s+[^\n]+","--[[ declare ]]")

	-- ── 2. Enums  →  table  ───────────────────────────────────────────────────
	out=out:gsub("enum%s+([%a_][%w_]*)%s*(%b{})", function(name,body)
		local entries={}; local i=0
		for e in body:sub(2,#body-1):gmatch("[%a_][%w_]*") do
			entries[#entries+1]=e.."="..i; i=i+1
		end
		return "local "..name.."={"..table.concat(entries,",").."}"
	end)

	-- ── 3. Generics  Array<T>  →  Array  ─────────────────────────────────────
	out=out:gsub("<[%a_][%w_<>, |&%?]*>","")

	-- ── 4. Decorators  @Name  →  comment  ────────────────────────────────────
	out=out:gsub("(@[%a_][%w_]*[^\n]*)\n","-- [decorator] %1\n")

	-- ── 5. const / let / var → local  ────────────────────────────────────────
	out=out:gsub("%f[%a]const%f[%A]","local")
	out=out:gsub("%f[%a]let%f[%A]","local")
	out=out:gsub("%f[%a]var%f[%A]","local")

	-- ── 6. Visibility modifiers → strip  ─────────────────────────────────────
	for _,mod in ipairs({"public","private","protected","readonly","static",
	                     "abstract","override","declare","export default","export"}) do
		out=out:gsub("%f[%a]"..mod:gsub(" ","%%s+").."%f[%A]%s*","")
	end

	-- ── 7. Arrow fns  (x: T) => expr  /  (x) => { ... }  ────────────────────
	out=out:gsub("%(([^%)]*)%)%s*=>%s*(%b{})", function(params,body)
		-- strip types from params
		local p=params:gsub("([%a_][%w_]*)%s*:[^,%)]+","%1")
		return "function("..p..")"..body:sub(2,#body-1).." end"
	end)
	out=out:gsub("%(([^%)]*)%)%s*=>%s*([^\n{][^\n]*)", function(params,expr)
		local p=params:gsub("([%a_][%w_]*)%s*:[^,%)]+","%1")
		return "function("..p..") return "..expr.." end"
	end)
	out=out:gsub("([%a_][%w_]*)%s*=>%s*([^\n{][^\n]*)", function(p,expr)
		return "function("..p..") return "..expr.." end"
	end)

	-- ── 8. async function → function  ────────────────────────────────────────
	out=out:gsub("%f[%a]async%f[%A]%s+","")
	out=out:gsub("%f[%a]await%f[%A]%s+","")

	-- ── 9. class extends  ─────────────────────────────────────────────────────
	out=out:gsub("class%s+([%a_][%w_]*)%s+extends%s+([%a_][%w_%.]*)%s*(%b{})", function(n,p,body)
		local inner=body:sub(2,#body-1)
		-- constructor → .new
		inner=inner:gsub("constructor%(([^%)]+)%)", "function "..n..".new(%1)")
		inner=inner:gsub("constructor%(%)","function "..n..".new()")
		return "local "..n.."=setmetatable({},{__index="..p.."}) "..n..".__index="..n.."\n"..inner
	end)
	out=out:gsub("class%s+([%a_][%w_]*)%s*(%b{})", function(n,body)
		local inner=body:sub(2,#body-1)
		inner=inner:gsub("constructor%(([^%)]+)%)", "function "..n..".new(%1)")
		inner=inner:gsub("constructor%(%)","function "..n..".new()")
		return "local "..n.."={} "..n..".__index="..n.."\n"..inner
	end)

	-- ── 10. new ClassName(...)  ───────────────────────────────────────────────
	out=out:gsub("new%s+([%a_][%w_]*)%(", function(n) return n..".new(" end)

	-- ── 11. Type annotations on variables and params  ─────────────────────────
	out=out:gsub("([%a_][%w_]*)%s*:%s*[%a_][%w_%.<>|&%?%[%]]*","% 1")

	-- ── 12. Template literals  `hello ${name}`  ──────────────────────────────
	out=out:gsub("`([^`]*)`", function(inner)
		local r=inner:gsub("%${([^}]+)}", '"..tostring(%1).."')
		return '"'..r..'"'
	end)

	-- ── 13. !== / === / != ───────────────────────────────────────────────────
	out=out:gsub("!==","~="):gsub("===","=="):gsub("!=","~=")

	-- ── 14. && / || / !  ─────────────────────────────────────────────────────
	out=out:gsub("&&"," and "):gsub("||"," or ")
	out=out:gsub("([^~=!<>])!([^=])", function(a,b) return a.." not "..b end)

	-- ── 15. Nullish / optional chain  ────────────────────────────────────────
	out=out:gsub("([%w_%.%(%)%[%]\"'`]+)%s*%?%?%s*([%w_%.%(%)%[%]\"'`]+)",
		"(%1~=nil and %1 or %2)")
	out=out:gsub("([%a_][%w_]*)%?%.([%a_][%w_]*)", function(o,m)
		return "("..o.." and "..o.."."..m.." or nil)"
	end)

	-- ── 16. try / catch / finally  ───────────────────────────────────────────
	out=out:gsub("try%s*(%b{})%s*catch%s*%(([^%)]+)%)%s*(%b{})",
		function(tbody,evar,cbody)
		return "local __ok,__err=pcall(function()\n"..tbody:sub(2,#tbody-1).."\nend)\n"..
		       "if not __ok then\nlocal "..evar:match("[%a_][%w_]*").."=__err\n"..cbody:sub(2,#cbody-1).."\nend"
	end)
	out=out:gsub("throw%s+new%s+[%a_][%w_]*%(([^%)]+)%)", "error(%1)")
	out=out:gsub("%f[%a]throw%f[%A]%s+","error(")

	-- ── 17. import { x, y } from "mod"  ──────────────────────────────────────
	out=out:gsub('import%s*{([^}]+)}%s*from%s*"([^"]+)"', function(names,path)
		local r={}
		for nm in names:gmatch("[%a_][%w_]*") do
			r[#r+1]='local '..nm..'=require("'..path..'").'..nm
		end
		return table.concat(r,"\n")
	end)
	out=out:gsub('import%s+([%a_][%w_]*)%s+from%s+"([^"]+)"', function(n,p)
		return 'local '..n..'=require("'..p..'")'
	end)

	-- ── 18. Semicolons → remove  ──────────────────────────────────────────────
	out=out:gsub(";%s*\n","\n"):gsub(";%s*$","")

	-- ── 19. ** → ^  ──────────────────────────────────────────────────────────
	out=out:gsub("%*%*","^")

	return "-- [TypeRbx compiled]\n"..out
end

-- ════════════════════════════════════════════════════════════════════════════
--  MASTER COMPILE
-- ════════════════════════════════════════════════════════════════════════════
local function compile(content, lang)
	if lang=="neb" then
		return pcall(compileNebScript, content)
	elseif lang=="rbxpy" then
		return pcall(compileRbxPython, content)
	elseif lang=="typerbx" then
		return pcall(compileTypeRbx, content)
	elseif lang=="md" or lang=="txt" then
		return true, "--[[\n"..content.."\n]]"
	end
	return true, content
end

-- ════════════════════════════════════════════════════════════════════════════
--  OUTPUT TO STUDIO
-- ════════════════════════════════════════════════════════════════════════════
local function studioService()
	local map={
		ReplicatedStorage  = game:GetService("ReplicatedStorage"),
		ServerStorage      = game:GetService("ServerStorage"),
		ServerScriptService= game:GetService("ServerScriptService"),
		Workspace          = game:GetService("Workspace"),
	}
	return map[S.ws_rootService] or game:GetService("ReplicatedStorage")
end

local function getOrCreateFolder(parent, name)
	local f=parent:FindFirstChild(name)
	if f and f:IsA("Folder") then return f end
	local nf=Instance.new("Folder"); nf.Name=name; nf.Parent=parent; return nf
end

local function getOutputFolder(fileNode)
	-- Walk parent chain, collect folder names
	local chain={}
	local cur=fileNode.parent
	while cur and cur~=FS.root do
		table.insert(chain,1,cur.name)
		cur=cur.parent
	end
	local target=getOrCreateFolder(studioService(), S.ws_projectName)
	for _,folderName in ipairs(chain) do
		target=getOrCreateFolder(target, folderName)
	end
	return target
end

local function compileAndOutput(fileNode)
	if fileNode.type~="file" then return nil,"Not a file" end
	local ok, result = compile(fileNode.content, fileNode.lang)
	if not ok then return nil, tostring(result) end

	ChangeHistoryService:SetWaypoint("NebScript: compile "..fileNode.name)

	local folder=getOutputFolder(fileNode)
	local scriptName=fileNode.name:gsub("%.[%a]+$","")  -- strip extension

	local existing=folder:FindFirstChild(scriptName)
	if existing then existing:Destroy() end

	local inst
	local st=S.cmp_scriptType
	if st=="LocalScript" then inst=Instance.new("LocalScript")
	elseif st=="ModuleScript" then inst=Instance.new("ModuleScript")
	else inst=Instance.new("Script") end
	inst.Name=scriptName
	inst.Source=result
	inst.Parent=folder

	ChangeHistoryService:SetWaypoint("NebScript: done")
	fileNode.dirty=false
	return inst, nil
end

-- ════════════════════════════════════════════════════════════════════════════
--  30 BUILT-IN MODULES
-- ════════════════════════════════════════════════════════════════════════════
local BUILTIN_MODULES={}
local USER_MODULES={}

BUILTIN_MODULES["std"]=[[
-- std: NebScript Standard Library
-- Usage: import std from "std"  OR  local std = require(script.Parent.std)
local std={}
-- math
std.abs=math.abs; std.ceil=math.ceil; std.floor=math.floor
std.sqrt=math.sqrt; std.log=math.log; std.exp=math.exp
std.round=function(x,d)local m=10^(d or 0);return math.floor(x*m+.5)/m end
std.clamp=function(v,lo,hi)return math.max(lo,math.min(hi,v))end
std.lerp=function(a,b,t)return a+(b-a)*t end
std.smoothstep=function(t)return t*t*(3-2*t)end
std.smootherstep=function(t)return t*t*t*(t*(t*6-15)+10)end
std.map_range=function(v,a,b,c,d)return c+(v-a)*(d-c)/(b-a)end
std.sign=function(x)return x>0 and 1 or x<0 and -1 or 0 end
std.fract=function(x)return x-math.floor(x)end
std.wrap=function(v,lo,hi)return((v-lo)%(hi-lo))+lo end
std.pingpong=function(t,l)return l-math.abs(t%l*2-l)end
std.deg2rad=function(d)return d*math.pi/180 end
std.rad2deg=function(r)return r*180/math.pi end
std.between=function(v,lo,hi)return v>=lo and v<=hi end
std.approx=function(a,b,e)return math.abs(a-b)<=(e or 1e-10)end
-- string
std.trim=function(s)return s:match("^%s*(.-)%s*$")end
std.split=function(s,sep)local t={}for p in s:gmatch("[^"..sep.."]+")do t[#t+1]=p end;return t end
std.startswith=function(s,p)return s:sub(1,#p)==p end
std.endswith=function(s,p)return s:sub(-#p)==p end
std.contains=function(s,p)return s:find(p,1,true)~=nil end
std.count=function(s,p)local n=0;for _ in s:gmatch(p)do n=n+1 end;return n end
std.pad=function(s,n,c)c=c or" ";while #s<n do s=s..c end;return s end
std.lpad=function(s,n,c)c=c or" ";while #s<n do s=c..s end;return s end
std.titlecase=function(s)return s:gsub("(%a)([%w']*)",function(a,b)return a:upper()..b:lower()end)end
std.camelcase=function(s)local t=std.split(s,"_");local r=t[1]:lower();for i=2,#t do r=r..t[i]:sub(1,1):upper()..t[i]:sub(2):lower()end;return r end
-- table
std.keys=function(t)local r={}for k in pairs(t)do r[#r+1]=k end;return r end
std.values=function(t)local r={}for _,v in pairs(t)do r[#r+1]=v end;return r end
std.map=function(t,f)local r={}for i,v in ipairs(t)do r[i]=f(v,i)end;return r end
std.filter=function(t,f)local r={}for _,v in ipairs(t)do if f(v)then r[#r+1]=v end end;return r end
std.reduce=function(t,f,init)local a=init;for _,v in ipairs(t)do a=f(a,v)end;return a end
std.find=function(t,f)for i,v in ipairs(t)do if f(v)then return v,i end end end
std.every=function(t,f)for _,v in ipairs(t)do if not f(v)then return false end end;return true end
std.some=function(t,f)for _,v in ipairs(t)do if f(v)then return true end end;return false end
std.flat=function(t,d)d=d or 1;local r={}for _,v in ipairs(t)do if type(v)=="table"and d>0 then for _,w in ipairs(std.flat(v,d-1))do r[#r+1]=w end else r[#r+1]=v end end;return r end
std.unique=function(t)local s={};local r={}for _,v in ipairs(t)do if not s[v]then s[v]=true;r[#r+1]=v end end;return r end
std.zip=function(...)local ts={...};local r={}for i=1,#ts[1]do local row={}for _,t in ipairs(ts)do row[#row+1]=t[i]end;r[#r+1]=row end;return r end
std.range=function(a,b,s)s=s or 1;local r={}for i=a,b,s do r[#r+1]=i end;return r end
std.slice=function(t,a,b)local r={}for i=a or 1,b or #t do r[#r+1]=t[i]end;return r end
std.chunk=function(t,n)local r={}for i=1,#t,n do local c={}for j=i,math.min(i+n-1,#t)do c[#c+1]=t[j]end;r[#r+1]=c end;return r end
std.groupby=function(t,f)local r={}for _,v in ipairs(t)do local k=f(v);r[k]=r[k] or{};r[k][#r[k]+1]=v end;return r end
std.partition=function(t,f)local a,b={},{}for _,v in ipairs(t)do if f(v)then a[#a+1]=v else b[#b+1]=v end end;return a,b end
-- deep ops
std.deepcopy=function(t)if type(t)~="table"then return t end;local c={}for k,v in pairs(t)do c[std.deepcopy(k)]=std.deepcopy(v)end;return setmetatable(c,getmetatable(t))end
std.merge=function(...)local r={}for _,t in ipairs({...})do for k,v in pairs(t)do r[k]=v end end;return r end
std.freeze=function(t)return setmetatable({},{__index=t,__newindex=function()error("frozen table")end})end
-- type checks
std.isstring=function(v)return type(v)=="string"end
std.isnumber=function(v)return type(v)=="number"end
std.isbool=function(v)return type(v)=="boolean"end
std.istable=function(v)return type(v)=="table"end
std.isnil=function(v)return v==nil end
std.isfunc=function(v)return type(v)=="function"end
-- functional
std.pipe=function(v,...)local r=v;for _,f in ipairs({...})do r=f(r)end;return r end
std.compose=function(...)local fs={...};return function(x)local r=x;for i=#fs,1,-1 do r=fs[i](r)end;return r end end
std.curry=function(f,a)return function(b)return f(a,b)end end
std.partial=function(f,...)local a={...};return function(...)local b={...};local c={}for _,v in ipairs(a)do c[#c+1]=v end;for _,v in ipairs(b)do c[#c+1]=v end;return f(table.unpack(c))end end
std.memo=function(f)local cache={}return function(...)local k=table.concat({...},"\1")if cache[k]==nil then cache[k]=f(...)end;return cache[k]end end
std.once=function(f)local d,r=false;return function(...)if not d then d=true;r=f(...)end;return r end end
std.debounce=function(f,t)local last=0;return function(...)local now=tick()if now-last>=t then last=now;f(...)end end end
std.throttle=function(f,t)local q=false;return function(...)if not q then q=true;local a={...};task.delay(t,function()q=false;f(table.unpack(a))end)end end end
std.identity=function(x)return x end
std.noop=function()end
return std
]]

BUILTIN_MODULES["signal"]=[[
-- signal: Fast in-memory event system
local Signal={}; Signal.__index=Signal
function Signal.new()
	return setmetatable({_b=Instance.new("BindableEvent"),_conns={}},Signal)
end
function Signal:Connect(fn)
	local c=self._b.Event:Connect(fn); self._conns[#self._conns+1]=c; return c
end
function Signal:Once(fn)
	local c; c=self._b.Event:Connect(function(...)c:Disconnect();fn(...)end); return c
end
function Signal:Fire(...)  self._b:Fire(...) end
function Signal:Wait()     return self._b.Event:Wait() end
function Signal:DisconnectAll()
	for _,c in ipairs(self._conns)do pcall(function()c:Disconnect()end)end; self._conns={}
end
function Signal:Destroy()  self:DisconnectAll(); self._b:Destroy() end
return Signal
]]

BUILTIN_MODULES["state"]=[[
-- state: Reactive state atom
local Signal=require(script.Parent.signal)
local State={}; State.__index=State
function State.new(init)
	return setmetatable({_v=init,changed=Signal.new(),_watchers={}},State)
end
function State:get()return self._v end
function State:set(v)
	local old=self._v; self._v=v
	if old~=v then self.changed:Fire(v,old)
		for _,w in ipairs(self._watchers)do pcall(w,v,old)end end
end
function State:watch(fn)
	self._watchers[#self._watchers+1]=fn
	return function()for i,w in ipairs(self._watchers)do if w==fn then table.remove(self._watchers,i)break end end end
end
function State:map(fn)
	local d=State.new(fn(self._v))
	self:watch(function(v)d:set(fn(v))end); return d
end
function State:bind(inst,prop)
	self:watch(function(v)inst[prop]=v end); inst[prop]=self._v
end
return State
]]

BUILTIN_MODULES["promise"]=[[
-- promise: Lightweight Promises
local P={}; P.__index=P
local function isP(v)return type(v)=="table"and v._isP end
function P.new(fn)
	local p=setmetatable({_isP=true,_s="pending",_v=nil,_res={},_rej={}},P)
	local function res(v)if p._s~="pending"then return end; p._s="fulfilled"; p._v=v
		for _,f in ipairs(p._res)do task.spawn(f,v)end end
	local function rej(e)if p._s~="pending"then return end; p._s="rejected"; p._v=e
		for _,f in ipairs(p._rej)do task.spawn(f,e)end end
	task.spawn(function()local ok,e=pcall(fn,res,rej)if not ok then rej(e)end end)
	return p
end
function P:andThen(fn)
	return P.new(function(res,rej)
		local function h(v)local ok,r=pcall(fn,v)if ok then if isP(r)then r:andThen(res):catch(rej)else res(r)end else rej(r)end end
		if self._s=="fulfilled"then task.spawn(h,self._v)
		elseif self._s=="pending"then self._res[#self._res+1]=h end
	end)
end
function P:catch(fn)
	if self._s=="rejected"then task.spawn(fn,self._v)
	elseif self._s=="pending"then self._rej[#self._rej+1]=fn end; return self
end
function P:finally(fn) self:andThen(function(v)fn()return v end):catch(function()fn()end); return self end
P.resolve=function(v)return P.new(function(r)r(v)end)end
P.reject=function(e)return P.new(function(_,r)r(e)end)end
P.delay=function(t)return P.new(function(r)task.delay(t,r)end)end
P.all=function(ps)return P.new(function(res,rej)local rs={};local n=0
	for i,p in ipairs(ps)do p:andThen(function(v)rs[i]=v;n=n+1;if n==#ps then res(rs)end end):catch(rej)end end)end
P.race=function(ps)return P.new(function(res,rej)for _,p in ipairs(ps)do p:andThen(res):catch(rej)end end)end
return P
]]

BUILTIN_MODULES["class"]=[[
-- class: OOP base helpers
local class={}
function class.new(base)
	local cls={};cls.__index=cls
	if base then setmetatable(cls,{__index=base});cls.super=base end
	function cls:new(...)local i=setmetatable({},cls);if i.init then i:init(...)end;return i end
	function cls:is(other)return getmetatable(self)==other end
	return cls
end
function class.mixin(target,...)
	for _,src in ipairs({...})do for k,v in pairs(src)do if not target[k]then target[k]=v end end end
	return target
end
return class
]]

BUILTIN_MODULES["math2"]=[[
-- math2: Extended math
local m2={}
m2.PI=math.pi; m2.TAU=math.pi*2; m2.E=math.exp(1); m2.PHI=(1+math.sqrt(5))/2
m2.INF=math.huge; m2.EPSILON=1e-10; m2.SQRT2=math.sqrt(2)
m2.factorial=function(n)if n<=1 then return 1 end;return n*m2.factorial(n-1)end
m2.fib=function(n)local a,b=0,1;for _=1,n do a,b=b,a+b end;return a end
m2.gcd=function(a,b)while b~=0 do a,b=b,a%b end;return a end
m2.lcm=function(a,b)return math.abs(a*b)/m2.gcd(a,b)end
m2.isPrime=function(n)if n<2 then return false end;for i=2,math.sqrt(n)do if n%i==0 then return false end end;return true end
m2.clamp=function(v,lo,hi)return math.max(lo,math.min(hi,v))end
m2.lerp=function(a,b,t)return a+(b-a)*t end
m2.bilinearLerp=function(q00,q10,q01,q11,tx,ty)return m2.lerp(m2.lerp(q00,q10,tx),m2.lerp(q01,q11,tx),ty)end
m2.smoothstep=function(t)return t*t*(3-2*t)end
m2.smootherstep=function(t)return t*t*t*(t*(t*6-15)+10)end
m2.map=function(v,a,b,c,d)return c+(v-a)*(d-c)/(b-a)end
m2.round=function(x,d)local m=10^(d or 0);return math.floor(x*m+.5)/m end
m2.sign=function(x)return x>0 and 1 or x<0 and -1 or 0 end
m2.mod=function(a,b)return((a%b)+b)%b end
m2.log2=function(x)return math.log(x,2)end
m2.log10=function(x)return math.log(x,10)end
m2.avg=function(t)local s=0;for _,v in ipairs(t)do s=s+v end;return s/#t end
m2.sum=function(t)local s=0;for _,v in ipairs(t)do s=s+v end;return s end
m2.product=function(t)local p=1;for _,v in ipairs(t)do p=p*v end;return p end
m2.stdev=function(t)local avg=m2.avg(t);local s=0;for _,v in ipairs(t)do s=s+(v-avg)^2 end;return math.sqrt(s/#t)end
m2.deg2rad=function(d)return d*math.pi/180 end
m2.rad2deg=function(r)return r*180/math.pi end
m2.dist2d=function(x1,y1,x2,y2)return math.sqrt((x2-x1)^2+(y2-y1)^2)end
m2.dist3d=function(a,b)return(a-b).Magnitude end
m2.between=function(v,lo,hi)return v>=lo and v<=hi end
return m2
]]

BUILTIN_MODULES["easing"]=[[
-- easing: Easing functions
local E={}
E.linear=function(t)return t end
E.inQuad=function(t)return t*t end; E.outQuad=function(t)return t*(2-t)end
E.inOutQuad=function(t)return t<.5 and 2*t*t or -1+(4-2*t)*t end
E.inCubic=function(t)return t^3 end; E.outCubic=function(t)return 1-(1-t)^3 end
E.inQuart=function(t)return t^4 end; E.outQuart=function(t)return 1-(1-t)^4 end
E.inSine=function(t)return 1-math.cos(t*math.pi/2)end
E.outSine=function(t)return math.sin(t*math.pi/2)end
E.inOutSine=function(t)return-(math.cos(math.pi*t)-1)/2 end
E.inExpo=function(t)return t==0 and 0 or 2^(10*t-10)end
E.outExpo=function(t)return t==1 and 1 or 1-2^(-10*t)end
E.inCirc=function(t)return 1-math.sqrt(1-t^2)end
E.outCirc=function(t)return math.sqrt(1-(t-1)^2)end
E.inBack=function(t,s)s=s or 1.70158;return t^2*((s+1)*t-s)end
E.outBack=function(t,s)s=s or 1.70158;return 1+(t-1)^2*((s+1)*(t-1)+s)end
E.inElastic=function(t)return t==0 and 0 or t==1 and 1 or-(2^(10*t-10))*math.sin((t*10-10.75)*(2*math.pi)/3)end
E.outElastic=function(t)return t==0 and 0 or t==1 and 1 or 2^(-10*t)*math.sin((t*10-.75)*(2*math.pi)/3)+1 end
E.outBounce=function(t)local n1,d1=7.5625,2.75
	if t<1/d1 then return n1*t*t
	elseif t<2/d1 then t=t-1.5/d1;return n1*t*t+.75
	elseif t<2.5/d1 then t=t-2.25/d1;return n1*t*t+.9375
	else t=t-2.625/d1;return n1*t*t+.984375 end end
E.inBounce=function(t)return 1-E.outBounce(1-t)end
E.lerp=function(from,to,t,fn)return from+(to-from)*(fn or E.linear)(t)end
return E
]]

BUILTIN_MODULES["tween"]=[[
-- tween: TweenService helper
local TS=game:GetService("TweenService")
local tw={}
local STYLES={linear=Enum.EasingStyle.Linear,quad=Enum.EasingStyle.Quad,
	cubic=Enum.EasingStyle.Cubic,sine=Enum.EasingStyle.Sine,
	bounce=Enum.EasingStyle.Bounce,elastic=Enum.EasingStyle.Elastic,
	back=Enum.EasingStyle.Back,exp=Enum.EasingStyle.Exponential,
	circ=Enum.EasingStyle.Circular,quart=Enum.EasingStyle.Quart}
local DIRS={["in"]=Enum.EasingDirection.In,out=Enum.EasingDirection.Out,inout=Enum.EasingDirection.InOut}
tw.play=function(i,goal,dur,ease,dir,delay,rep,rev)
	local info=TweenInfo.new(dur or 1,STYLES[ease] or Enum.EasingStyle.Linear,
		DIRS[dir] or Enum.EasingDirection.Out,rep or 0,rev or false,delay or 0)
	local t=TS:Create(i,info,goal);t:Play();return t end
tw.wait=function(i,goal,dur,ease,dir)local t=tw.play(i,goal,dur,ease,dir);t.Completed:Wait();return t end
tw.fadein=function(i,d)return tw.play(i,{Transparency=0},d or .5,"sine","out")end
tw.fadeout=function(i,d)return tw.play(i,{Transparency=1},d or .5,"sine","in")end
tw.moveto=function(i,p,d)return tw.play(i,{Position=p},d or .5,"quad","out")end
tw.scaleto=function(i,sz,d)return tw.play(i,{Size=sz},d or .5,"back","out")end
tw.colorto=function(i,c,d)return tw.play(i,{Color=c},d or .5,"sine","inout")end
tw.sequence=function(steps)task.spawn(function()for _,s in ipairs(steps)do tw.wait(table.unpack(s))end end)end
return tw
]]

BUILTIN_MODULES["net"]=[[
-- net: RemoteEvent / RemoteFunction wrappers
local RS=game:GetService("ReplicatedStorage")
local RUN=game:GetService("RunService")
local isS=RUN:IsServer()
local net={}
local function gor(name,cls)
	local e=RS:FindFirstChild(name)
	if e then return e end
	if isS then local r=Instance.new(cls);r.Name=name;r.Parent=RS;return r end
	return RS:WaitForChild(name,10)
end
net.remote=function(n)return gor(n,"RemoteEvent")end
net.func=function(n)return gor(n,"RemoteFunction")end
net.fire=function(n,...)net.remote(n):FireServer(...)end
net.fireClient=function(n,p,...)net.remote(n):FireClient(p,...)end
net.fireAll=function(n,...)net.remote(n):FireAllClients(...)end
net.onServer=function(n,fn)net.remote(n).OnServerEvent:Connect(fn)end
net.onClient=function(n,fn)net.remote(n).OnClientEvent:Connect(fn)end
net.invoke=function(n,...)return net.func(n):InvokeServer(...)end
net.handle=function(n,fn)net.func(n).OnServerInvoke=fn end
return net
]]

BUILTIN_MODULES["player"]=[[
-- player: Player utilities
local Pl=game:GetService("Players")
local pl={}
pl.local_=function()return Pl.LocalPlayer end
pl.all=function()return Pl:GetPlayers()end
pl.byName=function(n)return Pl:FindFirstChild(n)end
pl.byId=function(id)return Pl:GetPlayerByUserId(id)end
pl.count=function()return #Pl:GetPlayers()end
pl.char=function(p)p=p or Pl.LocalPlayer;return p.Character or p.CharacterAdded:Wait()end
pl.humanoid=function(p)local c=pl.char(p);return c and c:FindFirstChildOfClass("Humanoid")end
pl.root=function(p)local c=pl.char(p);return c and c:FindFirstChild("HumanoidRootPart")end
pl.pos=function(p)local r=pl.root(p);return r and r.Position end
pl.onJoin=function(fn)Pl.PlayerAdded:Connect(fn);for _,p in ipairs(Pl:GetPlayers())do fn(p)end end
pl.onLeave=function(fn)Pl.PlayerRemoving:Connect(fn)end
pl.onDied=function(p,fn)local h=pl.humanoid(p);if h then h.Died:Connect(fn)end end
pl.onSpawn=function(p,fn)p.CharacterAdded:Connect(function(c)c:WaitForChild("HumanoidRootPart");fn(c)end)end
pl.teleport=function(p,pos)local r=pl.root(p);if r then r.CFrame=CFrame.new(pos)end end
pl.kick=function(p,msg)p:Kick(msg or"You were kicked.")end
return pl
]]

BUILTIN_MODULES["timer"]=[[
-- timer: Task/timer utilities
local timer={}
timer.after=function(t,fn)task.delay(t,fn)end
timer.every=function(interval,fn)local run=true;task.spawn(function()while run do task.wait(interval);if run then fn()end end end);return function()run=false end end
timer.debounce=function(fn,wait)local last=0;return function(...)local now=tick()if now-last>=wait then last=now;fn(...)end end end
timer.throttle=function(fn,t)local q=false;return function(...)if not q then q=true;local a={...};task.delay(t,function()q=false;fn(table.unpack(a))end)end end end
timer.stopwatch=function()local s=tick();return{elapsed=function()return tick()-s end,reset=function()s=tick()end,lap=function()local e=tick()-s;s=tick();return e end}end
timer.countdown=function(secs,onTick,onDone)task.spawn(function()for i=secs,1,-1 do if onTick then onTick(i)end;task.wait(1)end;if onDone then onDone()end end)end
timer.waitUntil=function(pred,timeout,interval)interval=interval or .1;timeout=timeout or 10;local e=0;while not pred()and e<timeout do e=e+task.wait(interval)end;return pred()end
return timer
]]

BUILTIN_MODULES["input"]=[[
-- input: UserInputService helpers
local UIS=game:GetService("UserInputService")
local inp={}
local held={}
UIS.InputBegan:Connect(function(i,gp)if not gp then held[i.KeyCode]=true end end)
UIS.InputEnded:Connect(function(i)held[i.KeyCode]=false end)
inp.isDown=function(k)return held[k]==true end
inp.isUp=function(k)return not inp.isDown(k)end
inp.onKey=function(k,fn,gp)return UIS.InputBegan:Connect(function(i,g)if i.KeyCode==k and(gp or not g)then fn(i)end end)end
inp.onRelease=function(k,fn)return UIS.InputEnded:Connect(function(i)if i.KeyCode==k then fn(i)end end)end
inp.mouse=function()return{pos=UIS:GetMouseLocation(),delta=UIS:GetMouseDelta(),down=function(b)return UIS:IsMouseButtonPressed(b or Enum.UserInputType.MouseButton1)end}end
inp.combo=function(keys,fn)return UIS.InputBegan:Connect(function(i,gp)if gp then return end;local all=true;for _,k in ipairs(keys)do if not inp.isDown(k)then all=false break end end;if all then fn()end end)end
inp.textInput=function(fn)return UIS.InputBegan:Connect(function(i,gp)if not gp and i.UserInputType==Enum.UserInputType.Keyboard then fn(i)end end)end
return inp
]]

BUILTIN_MODULES["gui"]=[[
-- gui: UI builder helpers
local gui={}
local function make(cls,props,parent)local i=Instance.new(cls);for k,v in pairs(props or{})do pcall(function()i[k]=v end)end;if parent then i.Parent=parent end;return i end
gui.frame=function(p,par)return make("Frame",p,par)end
gui.text=function(p,par)return make("TextLabel",p,par)end
gui.button=function(p,par)return make("TextButton",p,par)end
gui.image=function(p,par)return make("ImageLabel",p,par)end
gui.scroll=function(p,par)return make("ScrollingFrame",p,par)end
gui.input=function(p,par)return make("TextBox",p,par)end
gui.corner=function(par,r)local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=par;return c end
gui.padding=function(par,a)local p=Instance.new("UIPadding");p.PaddingTop=UDim.new(0,a);p.PaddingBottom=UDim.new(0,a);p.PaddingLeft=UDim.new(0,a);p.PaddingRight=UDim.new(0,a);p.Parent=par;return p end
gui.gradient=function(par,cols,rot)local g=Instance.new("UIGradient");local kps={}for i,c in ipairs(cols)do kps[i]=ColorSequenceKeypoint.new((i-1)/(#cols-1),c)end;g.Color=ColorSequence.new(kps);g.Rotation=rot or 0;g.Parent=par;return g end
gui.stroke=function(par,col,thick)local s=Instance.new("UIStroke");s.Color=col;s.Thickness=thick or 1;s.Parent=par;return s end
gui.onClick=function(b,fn)return b.Activated:Connect(fn)end
gui.animate=function(i,goal,dur)local TS=game:GetService("TweenService");local t=TS:Create(i,TweenInfo.new(dur or .3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),goal);t:Play();return t end
return gui
]]

BUILTIN_MODULES["camera"]=[[
-- camera: Camera helpers
local cam=workspace.CurrentCamera
local camera={}
camera.get=function()return workspace.CurrentCamera end
camera.fov=function(f)cam.FieldOfView=f end
camera.type=function(t)cam.CameraType=t end
camera.cf=function(cf)cam.CFrame=cf end
camera.lookat=function(pos,from)from=from or cam.CFrame.Position;cam.CFrame=CFrame.lookAt(from,pos)end
camera.lerpto=function(target,t)cam.CFrame=cam.CFrame:Lerp(target,t)end
camera.orbit=function(center,angle,radius,height)
	local x=center.X+math.cos(angle)*radius
	local z=center.Z+math.sin(angle)*radius
	cam.CFrame=CFrame.lookAt(Vector3.new(x,center.Y+(height or 10),z),center)
end
camera.shake=function(intensity,duration)
	task.spawn(function()local t=0;while t<duration do local dt=task.wait();t=t+dt
		cam.CFrame=cam.CFrame*CFrame.new((math.random()-.5)*intensity,(math.random()-.5)*intensity,(math.random()-.5)*intensity)
	end end)
end
return camera
]]

BUILTIN_MODULES["physics"]=[[
-- physics: Raycasting and physics helpers
local phys={}
phys.ray=function(origin,dir,params)return workspace:Raycast(origin,dir,params)end
phys.rayScreen=function(screenPos,cam,dist)
	cam=cam or workspace.CurrentCamera
	local u=cam:ScreenPointToRay(screenPos.X,screenPos.Y)
	return workspace:Raycast(u.Origin,u.Direction*(dist or 1000))
end
phys.rayBetween=function(a,b,params)return phys.ray(a,b-a,params)end
phys.inBox=function(cf,size)return workspace:GetPartBoundsInBox(cf,size,OverlapParams.new())end
phys.inRadius=function(center,r)return workspace:GetPartBoundsInRadius(center,r,OverlapParams.new())end
phys.impulse=function(part,vel)
	local att=Instance.new("Attachment");att.Parent=part
	local lv=Instance.new("LinearVelocity");lv.Attachment0=att;lv.VectorVelocity=vel;lv.MaxForce=math.huge;lv.Parent=part
	task.delay(.05,function()lv:Destroy();att:Destroy()end)
end
return phys
]]

BUILTIN_MODULES["color"]=[[
-- color: Color utilities
local col={}
col.rgb=function(r,g,b)return Color3.fromRGB(r,g,b)end
col.hsv=function(h,s,v)return Color3.fromHSV(h,s,v)end
col.hex=function(h)h=h:gsub("#","");return Color3.fromRGB(tonumber(h:sub(1,2),16),tonumber(h:sub(3,4),16),tonumber(h:sub(5,6),16))end
col.toHex=function(c)return("%02X%02X%02X"):format(math.floor(c.R*255+.5),math.floor(c.G*255+.5),math.floor(c.B*255+.5))end
col.lerp=function(a,b,t)return a:Lerp(b,t)end
col.darken=function(c,a)local h,s,v=Color3.toHSV(c);return Color3.fromHSV(h,s,math.max(0,v-a))end
col.lighten=function(c,a)local h,s,v=Color3.toHSV(c);return Color3.fromHSV(h,s,math.min(1,v+a))end
col.saturate=function(c,a)local h,s,v=Color3.toHSV(c);return Color3.fromHSV(h,math.min(1,s+a),v)end
col.desaturate=function(c,a)local h,s,v=Color3.toHSV(c);return Color3.fromHSV(h,math.max(0,s-a),v)end
col.complement=function(c)local h,s,v=Color3.toHSV(c);return Color3.fromHSV((h+.5)%1,s,v)end
col.gradient=function(colors,t)local n=#colors;local sc=t*(n-1);local idx=math.max(1,math.min(n-1,math.floor(sc)+1));return colors[idx]:Lerp(colors[idx+1] or colors[idx],sc-math.floor(sc))end
col.RED=Color3.fromRGB(255,75,85); col.GREEN=Color3.fromRGB(80,255,140); col.BLUE=Color3.fromRGB(80,140,255)
col.WHITE=Color3.new(1,1,1); col.BLACK=Color3.new(0,0,0); col.CYAN=Color3.fromRGB(80,220,255)
col.PURPLE=Color3.fromRGB(140,60,220); col.PINK=Color3.fromRGB(255,80,200); col.GOLD=Color3.fromRGB(255,200,60)
return col
]]

BUILTIN_MODULES["vec"]=[[
-- vec: Vector math utilities
local vec={}
vec.new2=function(x,y)return Vector2.new(x,y)end
vec.new3=function(x,y,z)return Vector3.new(x,y,z)end
vec.lerp=function(a,b,t)return a:Lerp(b,t)end
vec.dist=function(a,b)return(b-a).Magnitude end
vec.dir=function(a,b)return(b-a).Unit end
vec.dot=function(a,b)return a:Dot(b)end
vec.cross=function(a,b)return a:Cross(b)end
vec.reflect=function(v,n)return v-2*v:Dot(n)*n end
vec.angle=function(a,b)return math.acos(math.clamp(a.Unit:Dot(b.Unit),-1,1))end
vec.snap=function(v,g)return Vector3.new(math.floor(v.X/g+.5)*g,math.floor(v.Y/g+.5)*g,math.floor(v.Z/g+.5)*g)end
vec.midpoint=function(a,b)return(a+b)/2 end
vec.rand2=function(m)m=m or 1;local a=math.random()*math.pi*2;return Vector2.new(math.cos(a),math.sin(a))*m end
vec.rand3=function(m)m=m or 1;return Vector3.new(math.random()-.5,math.random()-.5,math.random()-.5).Unit*m end
vec.project=function(v,on)return on*(v:Dot(on)/on:Dot(on))end
vec.ZERO=Vector3.zero; vec.ONE=Vector3.one
vec.UP=Vector3.new(0,1,0); vec.DOWN=Vector3.new(0,-1,0)
vec.RIGHT=Vector3.new(1,0,0); vec.LEFT=Vector3.new(-1,0,0)
vec.FWD=Vector3.new(0,0,-1); vec.BACK=Vector3.new(0,0,1)
return vec
]]

BUILTIN_MODULES["datastore"]=[[
-- datastore: DataStore wrapper with retry + cache
local DSS=game:GetService("DataStoreService")
local DS={}; DS.__index=DS
function DS.new(name,scope)
	return setmetatable({_s=DSS:GetDataStore(name,scope),_cache={},_retries=3},DS)
end
function DS:_try(fn)local ok,r;for i=1,self._retries do ok,r=pcall(fn)if ok then return ok,r end;task.wait(.5*i)end;return ok,r end
function DS:get(key,def)if self._cache[key]~=nil then return self._cache[key]end;local ok,v=self:_try(function()return self._s:GetAsync(key)end);if ok then self._cache[key]=v~=nil and v or def;return self._cache[key]end;return def end
function DS:set(key,val)self._cache[key]=val;return self:_try(function()self._s:SetAsync(key,val)end)end
function DS:update(key,fn)return self:_try(function()return self._s:UpdateAsync(key,function(old)local n=fn(old);self._cache[key]=n;return n end)end)end
function DS:remove(key)self._cache[key]=nil;return self:_try(function()self._s:RemoveAsync(key)end)end
function DS:inc(key,d)return self:update(key,function(v)return(v or 0)+(d or 1)end)end
function DS:getOrSet(key,defaultFn)local v=self:get(key);if v==nil then v=defaultFn();self:set(key,v)end;return v end
return DS
]]

BUILTIN_MODULES["pool"]=[[
-- pool: Object pool
local Pool={}; Pool.__index=Pool
function Pool.new(template,size)
	local p=setmetatable({_tmpl=template,_avail={},_active={},_create=nil,_reset=nil},Pool)
	for _=1,size or 10 do p._avail[#p._avail+1]=template:Clone()end;return p
end
function Pool:onCreate(fn)self._create=fn;return self end
function Pool:onReset(fn)self._reset=fn;return self end
function Pool:get(parent)
	local obj=#self._avail>0 and table.remove(self._avail,#self._avail) or self._tmpl:Clone()
	if self._reset then self._reset(obj)end
	obj.Parent=parent or workspace;self._active[#self._active+1]=obj;return obj
end
function Pool:release(obj)obj.Parent=nil;for i,a in ipairs(self._active)do if a==obj then table.remove(self._active,i)break end end;self._avail[#self._avail+1]=obj end
function Pool:releaseAll()for _,o in ipairs(self._active)do o.Parent=nil;self._avail[#self._avail+1]=o end;self._active={}end
function Pool:size()return #self._avail+#self._active end
return Pool
]]

BUILTIN_MODULES["animation"]=[[
-- animation: AnimationTrack helpers
local anim={}
anim.load=function(hum,id)local a=Instance.new("Animation");a.AnimationId=id;return hum.Animator:LoadAnimation(a)end
anim.play=function(hum,id,priority,speed)local t=anim.load(hum,id);if priority then t.Priority=priority end;t:Play();if speed then t:AdjustSpeed(speed)end;return t end
anim.stopAll=function(hum)for _,t in ipairs(hum.Animator:GetPlayingAnimationTracks())do t:Stop()end end
anim.isPlaying=function(hum,id)for _,t in ipairs(hum.Animator:GetPlayingAnimationTracks())do if t.Animation.AnimationId==id then return true,t end end;return false end
anim.blend=function(hum,fromId,toId,dur)local _,fromT=anim.isPlaying(hum,fromId);local toT=anim.load(hum,toId);toT:Play(dur);if fromT then fromT:Stop(dur)end;return toT end
return anim
]]

BUILTIN_MODULES["sound"]=[[
-- sound: Sound management
local SS=game:GetService("SoundService")
local TS=game:GetService("TweenService")
local snd={}; snd._s={}
snd.create=function(id,parent,props)
	local s=Instance.new("Sound");s.SoundId=id:find("rbxassetid://")and id or "rbxassetid://"..id
	for k,v in pairs(props or{})do s[k]=v end;s.Parent=parent or SS;snd._s[id]=s;return s end
snd.play=function(id,parent,props)local s=snd._s[id] or snd.create(id,parent,props);s:Play();return s end
snd.stop=function(id)local s=snd._s[id];if s then s:Stop()end end
snd.once=function(id,parent)local s=snd.play(id,parent);s.Ended:Connect(function()s:Destroy();snd._s[id]=nil end);return s end
snd.fadein=function(id,dur)local s=snd._s[id];if not s then return end;s.Volume=0;s:Play();TS:Create(s,TweenInfo.new(dur or 1),{Volume=1}):Play()end
snd.fadeout=function(id,dur)local s=snd._s[id];if not s then return end;local t=TS:Create(s,TweenInfo.new(dur or 1),{Volume=0});t:Play();t.Completed:Connect(function()s:Stop()end)end
return snd
]]

BUILTIN_MODULES["tag"]=[[
-- tag: CollectionService helpers
local CS=game:GetService("CollectionService")
local tag={}
tag.add=function(i,t)CS:AddTag(i,t)end
tag.remove=function(i,t)CS:RemoveTag(i,t)end
tag.has=function(i,t)return CS:HasTag(i,t)end
tag.get=function(t)return CS:GetTagged(t)end
tag.onAdded=function(t,fn)CS:GetInstanceAddedSignal(t):Connect(fn);for _,i in ipairs(CS:GetTagged(t))do fn(i)end end
tag.onRemoved=function(t,fn)CS:GetInstanceRemovedSignal(t):Connect(fn)end
tag.toggle=function(i,t)if tag.has(i,t)then tag.remove(i,t)else tag.add(i,t)end end
return tag
]]

BUILTIN_MODULES["fsm"]=[[
-- fsm: Finite State Machine
local FSM={}; FSM.__index=FSM
function FSM.new(init)
	return setmetatable({_state=init,_trans={},_enter={},_exit={},_any={}},FSM)
end
function FSM:state(name,cfg)
	if cfg then if cfg.enter then self._enter[name]=cfg.enter end;if cfg.exit then self._exit[name]=cfg.exit end end;return self
end
function FSM:on(from,event,to,guard)
	self._trans[from]=self._trans[from] or{}; self._trans[from][event]={to=to,guard=guard};return self
end
function FSM:send(event,...)
	local tmap=self._trans[self._state];if not tmap then return false end
	local t=tmap[event];if not t then return false end
	if t.guard and not t.guard(self,...)then return false end
	local old=self._state;if self._exit[old]then self._exit[old](self)end
	self._state=t.to;if self._enter[t.to]then self._enter[t.to](self)end
	for _,fn in ipairs(self._any)do fn(self._state,old)end;return true
end
function FSM:current()return self._state end
function FSM:is(s)return self._state==s end
function FSM:onAny(fn)self._any[#self._any+1]=fn end
return FSM
]]

BUILTIN_MODULES["log"]=[[
-- log: Structured logger
local log={}; log.level="info"
local LEVELS={debug=0,info=1,warn=2,error=3,none=4}
local function should(l)return(LEVELS[l] or 0)>=(LEVELS[log.level] or 0)end
local PRE="[NebScript]"
log.debug=function(...)if should"debug"then print(PRE,"[DBG]",...)end end
log.info=function(...)if should"info"then print(PRE,"[INF]",...)end end
log.warn=function(...)if should"warn"then warn(PRE,"[WRN]",...)end end
log.error=function(...)if should"error"then error(PRE.." [ERR] "..tostring(select(1,...)),2)end end
log.assert=function(cond,msg)if not cond then log.error(msg)end end
log.time=function(name,fn)local t=tick();local r={fn()};log.info(name.." took "..("%.4f"):format(tick()-t).."s");return table.unpack(r)end
log.table=function(t,name,d)name=name or"table";d=d or 0;local ind=(" "):rep(d*2);print(ind..name..":");for k,v in pairs(t)do if type(v)=="table"then log.table(v,tostring(k),d+1)else print(ind.."  "..tostring(k).."="..tostring(v))end end end
return log
]]

BUILTIN_MODULES["serialiser"]=[[
-- serialiser: Roblox type serialisation
local ser={}
ser.v3=function(v)return{x=v.X,y=v.Y,z=v.Z}end
ser.v2=function(v)return{x=v.X,y=v.Y}end
ser.cf=function(c)local rx,ry,rz=c:ToEulerAnglesXYZ();return{px=c.X,py=c.Y,pz=c.Z,rx=rx,ry=ry,rz=rz}end
ser.col=function(c)return{r=c.R,g=c.G,b=c.B}end
ser.udim2=function(u)return{xs=u.X.Scale,xo=u.X.Offset,ys=u.Y.Scale,yo=u.Y.Offset}end
ser.dV3=function(t)return Vector3.new(t.x,t.y,t.z)end
ser.dV2=function(t)return Vector2.new(t.x,t.y)end
ser.dCF=function(t)return CFrame.new(t.px,t.py,t.pz)*CFrame.fromEulerAnglesXYZ(t.rx,t.ry,t.rz)end
ser.dCol=function(t)return Color3.new(t.r,t.g,t.b)end
ser.dUDim2=function(t)return UDim2.new(t.xs,t.xo,t.ys,t.yo)end
ser.auto=function(v)local t=typeof(v)
	if t=="Vector3"then return ser.v3(v)elseif t=="Vector2"then return ser.v2(v)
	elseif t=="CFrame"then return ser.cf(v)elseif t=="Color3"then return ser.col(v)
	elseif t=="UDim2"then return ser.udim2(v)else return v end end
return ser
]]

BUILTIN_MODULES["config"]=[[
-- config: Config/settings system
local Config={}; Config.__index=Config
function Config.new(defaults)
	local c=setmetatable({_d={},_def=defaults or{},_watch={}},Config)
	for k,v in pairs(defaults or{})do c._d[k]=v end;return c
end
function Config:get(k)return self._d[k]end
function Config:set(k,v)local old=self._d[k];self._d[k]=v;for _,fn in ipairs(self._watch[k] or{})do pcall(fn,v,old)end end
function Config:reset(k)if k then self:set(k,self._def[k])else for kk in pairs(self._def)do self:set(kk,self._def[kk])end end end
function Config:watch(k,fn)self._watch[k]=self._watch[k] or{};self._watch[k][#self._watch[k]+1]=fn end
function Config:load(t)for k,v in pairs(t)do self:set(k,v)end end
function Config:dump()local r={}for k,v in pairs(self._d)do r[k]=v end;return r end
return Config
]]

BUILTIN_MODULES["path"]=[[
-- path: Instance path navigation
local path={}
path.get=function(str,root)root=root or game;local cur=root;for p in str:gmatch("[^/%.]+")do if p==".."then cur=cur.Parent or cur elseif p~="."then cur=cur:FindFirstChild(p);if not cur then return nil end end end;return cur end
path.wait=function(str,timeout,root)root=root or game;timeout=timeout or 10;local cur=root;for p in str:gmatch("[^/%.]+")do cur=cur:WaitForChild(p,timeout);if not cur then return nil end end;return cur end
path.str=function(inst)local ps={}local cur=inst;while cur and cur~=game do ps[1]=cur.Name..( #ps>0 and "."..ps[1] or"");cur=cur.Parent end;return table.concat(ps)end
path.find=function(root,pred)for _,d in ipairs(root:GetDescendants())do if pred(d)then return d end end end
path.findAll=function(root,pred)local r={}for _,d in ipairs(root:GetDescendants())do if pred(d)then r[#r+1]=d end end;return r end
path.byClass=function(root,cls)return path.findAll(root,function(i)return i:IsA(cls)end)end
path.byTag=function(root,t)return path.findAll(root,function(i)return game:GetService("CollectionService"):HasTag(i,t)end)end
return path
]]

BUILTIN_MODULES["registry"]=[[
-- registry: Module / service registry
local reg={}
reg._m={};reg._s={}
reg.register=function(name,mod)if reg._m[name]then warn("[registry] overwrite:"..name)end;reg._m[name]=mod end
reg.get=function(name)return reg._m[name]end
reg.require=function(name)local m=reg._m[name];if not m then error("[registry] not found:"..name)end;return m end
reg.singleton=function(name,factory)if not reg._s[name]then reg._s[name]=factory()end;return reg._s[name]end
reg.list=function()local r={}for k in pairs(reg._m)do r[#r+1]=k end;table.sort(r);return r end
reg.unregister=function(name)reg._m[name]=nil;reg._s[name]=nil end
return reg
]]

BUILTIN_MODULES["task2"]=[[
-- task2: Extended task utilities
local t2={}
t2.waitUntil=function(pred,timeout,interval)interval=interval or .1;timeout=timeout or 10;local e=0;while not pred()and e<timeout do e=e+task.wait(interval)end;return pred()end
t2.retry=function(fn,n,delay)for i=1,n or 3 do local ok,r=pcall(fn);if ok then return r end;if i<(n or 3)then task.wait(delay or .5)end end;error("all retries failed")end
t2.background=function(fn,...)task.spawn(fn,...)end
t2.timeout=function(fn,secs)local done,result=false;task.spawn(function()result={pcall(fn)};done=true end);local e=0;while not done and e<secs do e=e+task.wait(.05)end;if not done then return nil,"timeout"end;return table.unpack(result)end
t2.parallel=function(fns)local r={};local n=0;local done=Instance.new("BindableEvent")
	for i,fn in ipairs(fns)do task.spawn(function()r[i]={pcall(fn)};n=n+1;if n==#fns then done:Fire()end end)end
	done.Event:Wait();done:Destroy();return r end
t2.queue=function()local q={_q={},_run=false}
	function q:push(fn)self._q[#self._q+1]=fn;if not self._run then self._run=true
		task.spawn(function()while #self._q>0 do pcall(table.remove(self._q,1))end;self._run=false end)end end
	return q end
return t2
]]

BUILTIN_MODULES["bench"]=[[
-- bench: Benchmarking
local bench={}
bench.run=function(name,fn,n)n=n or 1000;local r={}for _=1,n do local t=tick();fn();r[#r+1]=tick()-t end
	table.sort(r);local s=0;for _,v in ipairs(r)do s=s+v end
	print(("[bench] %s | avg=%.4fms min=%.4fms max=%.4fms (%d)"):format(name,s/n*1000,r[1]*1000,r[#r]*1000,n));return{avg=s/n,min=r[1],max=r[#r],med=r[math.floor(n/2)]}end
bench.compare=function(fns,n)local fastest,fastestT=nil,math.huge;local results={}
	for name,fn in pairs(fns)do results[name]=bench.run(name,fn,n);if results[name].avg<fastestT then fastest,fastestT=name,results[name].avg end end
	print("[bench] Fastest: "..fastest);return results end
bench.memDiff=function(fn)collectgarbage("collect");local b=collectgarbage("count");fn();collectgarbage("collect");return(collectgarbage("count")-b)*1024 end
return bench
]]

BUILTIN_MODULES["iter"]=[[
-- iter: Lazy iterator chains
local iter={}
function iter.from(t)
	local obj={_t=t}
	function obj:map(fn)local r={}for i,v in ipairs(self._t)do r[i]=fn(v,i)end;return iter.from(r)end
	function obj:filter(fn)local r={}for _,v in ipairs(self._t)do if fn(v)then r[#r+1]=v end end;return iter.from(r)end
	function obj:take(n)local r={}for i=1,math.min(n,#self._t)do r[i]=self._t[i]end;return iter.from(r)end
	function obj:skip(n)local r={}for i=n+1,#self._t do r[#r+1]=self._t[i]end;return iter.from(r)end
	function obj:reduce(fn,init)local a=init;for _,v in ipairs(self._t)do a=fn(a,v)end;return a end
	function obj:each(fn)for _,v in ipairs(self._t)do fn(v)end end
	function obj:toTable()return{table.unpack(self._t)}end
	function obj:first()return self._t[1]end
	function obj:last()return self._t[#self._t]end
	function obj:count()return #self._t end
	function obj:sort(fn)local r={table.unpack(self._t)};table.sort(r,fn);return iter.from(r)end
	function obj:unique()local s={};local r={}for _,v in ipairs(self._t)do if not s[v]then s[v]=true;r[#r+1]=v end end;return iter.from(r)end
	return obj
end
iter.range=function(a,b,s)s=s or 1;local t={}for i=a,b,s do t[#t+1]=i end;return iter.from(t)end
iter.zip=function(...)local ts={...};local r={}for i=1,#ts[1]do local row={}for _,t in ipairs(ts)do row[#row+1]=t[i]end;r[#r+1]=row end;return iter.from(r)end
return iter
]]

BUILTIN_MODULES["inventory"]=[[
-- inventory: Generic inventory / item system
local Inv={}; Inv.__index=Inv
function Inv.new(maxSize)return setmetatable({_items={},_max=maxSize or math.huge,_change=nil},Inv)end
function Inv:add(item,amount)amount=amount or 1
	if #self._items>=self._max then return false,"full"end
	local ex=self:find(item.id or item.name)
	if ex and item.stackable then ex.amount=(ex.amount or 1)+amount
	else self._items[#self._items+1]={data=item,amount=amount}end
	if self._change then self._change(self._items)end;return true end
function Inv:remove(id,amount)amount=amount or 1;for i,sl in ipairs(self._items)do if(sl.data.id or sl.data.name)==id then sl.amount=(sl.amount or 1)-amount;if sl.amount<=0 then table.remove(self._items,i)end;if self._change then self._change(self._items)end;return true end end;return false end
function Inv:find(id)for _,sl in ipairs(self._items)do if(sl.data.id or sl.data.name)==id then return sl end end end
function Inv:has(id,n)local sl=self:find(id);return sl and(sl.amount or 1)>=(n or 1)end
function Inv:count()return #self._items end
function Inv:clear()self._items={};if self._change then self._change({})end end
function Inv:all()return self._items end
function Inv:onChange(fn)self._change=fn end
return Inv
]]

BUILTIN_MODULES["http"]=[[
-- http: HttpService wrapper (server-side only)
local HS=game:GetService("HttpService")
local http={}
http.get=function(url,headers)return pcall(function()return HS:GetAsync(url,true,headers)end)end
http.post=function(url,body,ct,headers)return pcall(function()return HS:PostAsync(url,body,ct or Enum.HttpContentType.ApplicationJson,false,headers)end)end
http.getJson=function(url,headers)local ok,raw=http.get(url,headers);if not ok then return false,raw end;return pcall(function()return HS:JSONDecode(raw)end)end
http.postJson=function(url,data,headers)return http.post(url,HS:JSONEncode(data),Enum.HttpContentType.ApplicationJson,headers)end
http.encode=function(d)return HS:JSONEncode(d)end
http.decode=function(s)return HS:JSONDecode(s)end
http.urlEncode=function(s)return HS:UrlEncode(s)end
return http
]]

local function listModules()
	local names={}
	for k in pairs(BUILTIN_MODULES) do names[#names+1]=k end
	for k in pairs(USER_MODULES) do names[#names+1]=k end
	table.sort(names)
	return names
end

local function getModuleContent(name)
	return BUILTIN_MODULES[name] or USER_MODULES[name]
end

local function registerUserModule(name, content)
	USER_MODULES[name] = content or ("-- Module: "..name.."\nlocal M={}\n\nreturn M\n")
end
-- ════════════════════════════════════════════════════════════════════════════
--  UI PRIMITIVES
-- ════════════════════════════════════════════════════════════════════════════
local function mkFrame(props)
	local f=Instance.new("Frame"); f.BorderSizePixel=0; f.BackgroundTransparency=0
	for k,v in pairs(props or{})do pcall(function()f[k]=v end)end; return f
end
local function mkText(props)
	local t=Instance.new("TextLabel"); t.BorderSizePixel=0; t.BackgroundTransparency=1
	t.Font=Enum.Font.RobotoMono; t.TextSize=13; t.TextXAlignment=Enum.TextXAlignment.Left
	t.TextColor3=T.TXT_PRIMARY
	for k,v in pairs(props or{})do pcall(function()t[k]=v end)end; return t
end
local function mkBtn(props)
	local b=Instance.new("TextButton"); b.BorderSizePixel=0; b.AutoButtonColor=false
	b.Font=Enum.Font.RobotoMono; b.TextSize=13; b.TextColor3=T.TXT_PRIMARY
	for k,v in pairs(props or{})do pcall(function()b[k]=v end)end; return b
end
local function mkBox(props)
	local b=Instance.new("TextBox"); b.BorderSizePixel=0; b.ClearTextOnFocus=false
	b.Font=Enum.Font.RobotoMono; b.TextSize=13; b.TextColor3=T.TXT_PRIMARY
	b.BackgroundColor3=T.BG_INPUT; b.PlaceholderColor3=T.TXT_MUTED
	b.TextXAlignment=Enum.TextXAlignment.Left
	for k,v in pairs(props or{})do pcall(function()b[k]=v end)end; return b
end
local function mkScroll(props)
	local s=Instance.new("ScrollingFrame"); s.BorderSizePixel=0
	s.ScrollBarThickness=5; s.ScrollBarImageColor3=T.NEBULA_DUST
	s.CanvasSize=UDim2.new(0,0,0,0); s.AutomaticCanvasSize=Enum.AutomaticSize.Y
	for k,v in pairs(props or{})do pcall(function()s[k]=v end)end; return s
end
local function mkCorner(parent, r)
	local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 6); c.Parent=parent; return c
end
local function mkPad(parent,t,b,l,r)
	local p=Instance.new("UIPadding"); p.PaddingTop=UDim.new(0,t or 4)
	p.PaddingBottom=UDim.new(0,b or 4); p.PaddingLeft=UDim.new(0,l or 6)
	p.PaddingRight=UDim.new(0,r or 6); p.Parent=parent; return p
end
local function mkList(parent, dir, pad)
	local l=Instance.new("UIListLayout"); l.FillDirection=dir or Enum.FillDirection.Vertical
	l.SortOrder=Enum.SortOrder.LayoutOrder; l.Padding=UDim.new(0,pad or 0)
	l.Parent=parent; return l
end
local function mkStroke(parent, col, thick, trans)
	local s=Instance.new("UIStroke"); s.Color=col or T.BORDER
	s.Thickness=thick or 1; s.Transparency=trans or 0
	s.Parent=parent; return s
end
local function mkGradient(parent, cols, rot)
	local g=Instance.new("UIGradient")
	local kps={}; for i,c in ipairs(cols) do kps[i]=ColorSequenceKeypoint.new((i-1)/(#cols-1),c) end
	g.Color=ColorSequence.new(kps); g.Rotation=rot or 0; g.Parent=parent; return g
end
local function tween(inst,goal,dur,style,dir)
	local t=TweenService:Create(inst,TweenInfo.new(dur or .2,
		style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),goal)
	t:Play(); return t
end

-- ── Popup helpers ────────────────────────────────────────────────────────────
local GUI_ROOT  -- set during buildUI
local function overlay(zIndex)
	local o=mkFrame({Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),
		BackgroundTransparency=0.55,ZIndex=zIndex or 120,Parent=GUI_ROOT})
	return o
end
local function dialog(parent, w, h, zIndex)
	local d=mkFrame({Size=UDim2.new(0,w,0,h),
		Position=UDim2.new(.5,-w/2,.5,-h/2),
		BackgroundColor3=T.BG_SURFACE,ZIndex=(zIndex or 120)+1,Parent=parent})
	mkCorner(d,10)
	mkStroke(d,T.NEBULA_PRI,1.5)
	mkGradient(d,{T.BG_SURFACE,T.BG_ELEVATED},90)
	return d
end

local function showInputDialog(title, placeholder, callback)
	local ov=overlay(); local d=dialog(ov,380,160)
	mkText({Text=title,Size=UDim2.new(1,-20,0,28),Position=UDim2.new(0,12,0,10),
		TextColor3=T.NEBULA_PRI,Font=Enum.Font.GothamBold,TextSize=14,ZIndex=d.ZIndex+1,Parent=d})
	local box=mkBox({Text="",PlaceholderText=placeholder or "",
		Size=UDim2.new(1,-24,0,34),Position=UDim2.new(0,12,0,46),
		BackgroundColor3=T.BG_INPUT,ZIndex=d.ZIndex+1,Parent=d})
	mkCorner(box,6); mkStroke(box,T.NEBULA_DUST,1); mkPad(box,0,0,8,8)
	local function finish(val) ov:Destroy(); if callback then callback(val) end end
	local ok=mkBtn({Text="Confirm",Size=UDim2.new(0,110,0,32),Position=UDim2.new(.5,-118,.0,108),
		BackgroundColor3=T.NEBULA_PRI,TextColor3=T.TXT_WHITE,Font=Enum.Font.GothamBold,TextSize=13,ZIndex=d.ZIndex+1,Parent=d})
	mkCorner(ok,6)
	local cancel=mkBtn({Text="Cancel",Size=UDim2.new(0,110,0,32),Position=UDim2.new(.5,8,0,108),
		BackgroundColor3=T.BG_OVERLAY,TextColor3=T.TXT_DIM,Font=Enum.Font.GothamBold,TextSize=13,ZIndex=d.ZIndex+1,Parent=d})
	mkCorner(cancel,6)
	ok.Activated:Connect(function() finish(box.Text) end)
	cancel.Activated:Connect(function() finish(nil) end)
	ov.Activated:Connect(function() finish(nil) end)
	box:CaptureFocus()
end

local function showDropdown(title, options, callback)
	local h=50+#options*40
	local ov=overlay(); local d=dialog(ov,320,h)
	mkText({Text=title,Size=UDim2.new(1,-20,0,28),Position=UDim2.new(0,12,0,10),
		TextColor3=T.NEBULA_PRI,Font=Enum.Font.GothamBold,TextSize=14,ZIndex=d.ZIndex+1,Parent=d})
	local function finish(val) ov:Destroy(); if callback then callback(val) end end
	for i,opt in ipairs(options) do
		local btn=mkBtn({Text=opt,Size=UDim2.new(1,-24,0,34),
			Position=UDim2.new(0,12,0,40+(i-1)*38),
			BackgroundColor3=T.BG_ELEVATED,TextColor3=T.TXT_PRIMARY,
			Font=Enum.Font.RobotoMono,TextSize=13,ZIndex=d.ZIndex+1,Parent=d})
		mkCorner(btn,6)
		btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=T.BG_OVERLAY},.1) end)
		btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=T.BG_ELEVATED},.1) end)
		btn.Activated:Connect(function() finish(opt) end)
	end
end

local function showConfirm(msg, callback)
	local ov=overlay(); local d=dialog(ov,380,140)
	mkText({Text=msg,Size=UDim2.new(1,-24,0,68),Position=UDim2.new(0,12,0,10),
		TextColor3=T.TXT_PRIMARY,TextSize=13,TextWrapped=true,ZIndex=d.ZIndex+1,Parent=d})
	local function finish(val) ov:Destroy(); if callback then callback(val) end end
	local yes=mkBtn({Text="Yes, proceed",Size=UDim2.new(0,130,0,32),Position=UDim2.new(.5,-138,0,100),
		BackgroundColor3=T.RED,TextColor3=T.TXT_WHITE,Font=Enum.Font.GothamBold,TextSize=13,ZIndex=d.ZIndex+1,Parent=d})
	mkCorner(yes,6)
	local no=mkBtn({Text="Cancel",Size=UDim2.new(0,110,0,32),Position=UDim2.new(.5,8,0,100),
		BackgroundColor3=T.BG_OVERLAY,TextColor3=T.TXT_DIM,Font=Enum.Font.GothamBold,TextSize=13,ZIndex=d.ZIndex+1,Parent=d})
	mkCorner(no,6)
	yes.Activated:Connect(function() finish(true) end)
	no.Activated:Connect(function() finish(false) end)
end

-- ── Toast ────────────────────────────────────────────────────────────────────
local TOAST_Y = 0
local function toast(msg, kind)
	kind=kind or"info"
	local cols={info=T.NEBULA_PRI,success=T.GREEN,warn=T.GOLD,error=T.RED}
	local col=cols[kind] or T.NEBULA_PRI
	TOAST_Y=TOAST_Y+1
	local lbl=mkText({Text=(" ◈  "..msg.."  "),
		Size=UDim2.new(0,0,0,34),AutomaticSize=Enum.AutomaticSize.X,
		Position=UDim2.new(.5,0,1,-(46+((TOAST_Y-1)*42))),AnchorPoint=Vector2.new(.5,0),
		BackgroundColor3=T.BG_SURFACE,BackgroundTransparency=0,
		TextColor3=col,Font=Enum.Font.GothamBold,TextSize=12,ZIndex=180,Parent=GUI_ROOT})
	mkCorner(lbl,8); mkStroke(lbl,col,1.5); mkPad(lbl,0,0,12,12)
	task.delay(2.8,function()
		tween(lbl,{BackgroundTransparency=1,TextTransparency=1},.4)
		task.delay(.45,function() pcall(lbl.Destroy,lbl); TOAST_Y=math.max(0,TOAST_Y-1) end)
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
--  EDITOR STATE
-- ════════════════════════════════════════════════════════════════════════════
local openTabs  = {}   -- { node, frame, label, dot (dirty indicator) }
local activeTab = nil  -- node

local editorBox     = nil   -- TextBox (main editing surface)
local lineNumScroll = nil
local editorScroll  = nil
local sidebarScroll = nil
local fileTreeCont  = nil
local statusLangLbl = nil
local statusLineLbl = nil
local statusMsgLbl  = nil
local settingsFrame = nil
local modulesFrame  = nil
local problemsFrame = nil
local problemsCont  = nil
local searchBar     = nil
local replaceBar    = nil
local dragging      = nil  -- node being dragged

local function setStatus(msg, kind)
	if statusMsgLbl then
		local cols={info=T.TXT_DIM,success=T.GREEN,warn=T.GOLD,error=T.RED}
		statusMsgLbl.Text=msg; statusMsgLbl.TextColor3=cols[kind] or T.TXT_DIM
	end
end

-- Save active tab content from editor
local function saveActiveContent()
	if activeTab and editorBox then
		local prev=activeTab.content
		activeTab.content=editorBox.Text
		if activeTab.content~=prev then activeTab.dirty=true end
	end
end

-- Update line numbers
local function refreshLineNumbers(text)
	if not lineNumScroll then return end
	for _,c in ipairs(lineNumScroll:GetChildren()) do
		if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
	end
	local count=0; for _ in (text.."\n"):gmatch("[^\n]*\n") do count=count+1 end
	local fs=tonumber(S.ed_fontSize) or 14
	for i=1,count do
		mkText({Text=tostring(i),Size=UDim2.new(1,0,0,fs+4),
			TextColor3=T.TXT_MUTED,TextXAlignment=Enum.TextXAlignment.Right,
			TextSize=fs,Font=Enum.Font.RobotoMono,LayoutOrder=i,Parent=lineNumScroll})
	end
end

local function findTabInfo(node)
	for i,ti in ipairs(openTabs) do if ti.node==node then return i,ti end end
end

local function refreshTabBar()
	for _,ti in ipairs(openTabs) do
		local isAct=ti.node==activeTab
		tween(ti.frame,{BackgroundColor3=isAct and T.BG_TAB_ACT or T.BG_TAB},.1)
		ti.label.TextColor3=isAct and T.TXT_BRIGHT or T.TXT_DIM
		ti.dot.TextColor3=ti.node.dirty and T.NEBULA_SEC or Color3.new(0,0,0)
	end
end

local function loadTabContent(node)
	saveActiveContent()
	activeTab=node
	if editorBox then
		editorBox.Text=node.content or ""
		refreshLineNumbers(node.content or "")
	end
	if statusLangLbl then
		local names={neb="NebScript",rbxpy="RbxPython",typerbx="TypeRbx",md="Markdown",txt="PlainText"}
		statusLangLbl.Text=names[node.lang] or node.lang
	end
	refreshTabBar()
end

-- ── File-tree rebuild (forward declare) ──────────────────────────────────────
local refreshFileTree

local function closeTab(node)
	local idx,ti=findTabInfo(node)
	if not idx then return end
	local doClose=function()
		ti.frame:Destroy()
		table.remove(openTabs,idx)
		if activeTab==node then
			activeTab=nil
			if #openTabs>0 then
				loadTabContent(openTabs[math.min(idx,#openTabs)].node)
			else
				if editorBox then editorBox.Text="" end
				refreshLineNumbers("")
			end
		end
	end
	if S.ui_confirmClose and node.dirty then
		showConfirm("Close '"..node.name.."'?  Unsaved changes will be lost.", function(y)
			if y then doClose() end
		end)
	else doClose() end
end

local function openTab(node)
	if node.type~="file" then return end
	local _,existing=findTabInfo(node)
	if existing then loadTabContent(node); return end

	local LANG_ICON={neb="✦",rbxpy="⌘",typerbx="τ",md="⬡",txt="⬢"}
	local LANG_COL={neb=T.NEBULA_PRI,rbxpy=T.GREEN,typerbx=T.CYAN,md=T.GOLD,txt=T.TXT_DIM}
	local icon=LANG_ICON[node.lang] or "•"
	local lcol=LANG_COL[node.lang] or T.TXT_DIM

	-- find tabBar (set during buildUI)
	local tabBar=GUI_ROOT and GUI_ROOT:FindFirstChild("TabBar",true)
	if not tabBar then return end

	local tabFrame=mkFrame({Size=UDim2.new(0,170,1,0),BackgroundColor3=T.BG_TAB,
		LayoutOrder=#openTabs+1,Parent=tabBar})
	mkCorner(tabFrame,0)
	mkStroke(tabFrame,T.BORDER,1)

	-- accent stripe on active
	local stripe=mkFrame({Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,0,0),
		BackgroundColor3=lcol,BackgroundTransparency=1,Parent=tabFrame})

	local dot=mkText({Text="●",Size=UDim2.new(0,14,1,0),Position=UDim2.new(0,4,0,0),
		TextColor3=Color3.new(0,0,0),TextSize=8,TextXAlignment=Enum.TextXAlignment.Center,
		Parent=tabFrame})

	local iconLbl=mkText({Text=icon,Size=UDim2.new(0,16,1,0),Position=UDim2.new(0,16,0,0),
		TextColor3=lcol,TextSize=12,TextXAlignment=Enum.TextXAlignment.Center,Parent=tabFrame})

	local label=mkText({Text=node.name,Size=UDim2.new(1,-56,1,0),Position=UDim2.new(0,34,0,0),
		TextColor3=T.TXT_DIM,TextTruncate=Enum.TextTruncate.AtEnd,TextSize=12,Parent=tabFrame})

	local closeBtn=mkBtn({Text="✕",Size=UDim2.new(0,20,0,20),
		Position=UDim2.new(1,-22,.5,-10),
		BackgroundColor3=T.BG_OVERLAY,TextColor3=T.TXT_MUTED,TextSize=11,
		Font=Enum.Font.GothamBold,Parent=tabFrame})
	mkCorner(closeBtn,4)

	local ti={node=node,frame=tabFrame,label=label,dot=dot,stripe=stripe}
	table.insert(openTabs,ti)

	tabFrame.Activated:Connect(function() loadTabContent(node) end)
	closeBtn.Activated:Connect(function() closeTab(node) end)
	tabFrame.MouseEnter:Connect(function()
		if activeTab~=node then tween(tabFrame,{BackgroundColor3=T.BG_OVERLAY},.1) end
	end)
	tabFrame.MouseLeave:Connect(function()
		if activeTab~=node then tween(tabFrame,{BackgroundColor3=T.BG_TAB},.1) end
	end)

	loadTabContent(node)
	tween(stripe,{BackgroundTransparency=0},.15)
end

-- ════════════════════════════════════════════════════════════════════════════
--  FILE TREE
-- ════════════════════════════════════════════════════════════════════════════
local LANG_BADGE_COL={neb=T.NEBULA_PRI,rbxpy=T.GREEN,typerbx=T.CYAN,md=T.GOLD,txt=T.TXT_DIM}
local LANG_BADGE_TXT={neb="NEB",rbxpy="PY",typerbx="TS",md="MD",txt="TXT"}

refreshFileTree = function()
	if not fileTreeCont then return end
	for _,c in ipairs(fileTreeCont:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
	if not FS.root then return end

	local order=0
	local function buildNode(node, depth)
		order=order+1
		local indent=depth*14

		if node.type=="folder" then
			local row=mkFrame({Size=UDim2.new(1,0,0,26),BackgroundColor3=Color3.new(0,0,0),
				BackgroundTransparency=1,LayoutOrder=order,Parent=fileTreeCont})

			local btn=mkBtn({Text="",Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),
				BackgroundTransparency=1,Parent=row})

			mkText({Text=node.expanded and "▾ 📂" or "▸ 📁",
				Size=UDim2.new(0,60,1,0),Position=UDim2.new(0,indent+4,0,0),
				TextColor3=T.GOLD,Font=Enum.Font.GothamBold,TextSize=12,Parent=row})

			mkText({Text=node.name,Size=UDim2.new(1,-(indent+68),1,0),
				Position=UDim2.new(0,indent+62,0,0),TextColor3=T.GOLD,
				Font=Enum.Font.GothamBold,TextSize=12,Parent=row})

			btn.MouseEnter:Connect(function()
				row.BackgroundColor3=T.BG_OVERLAY; row.BackgroundTransparency=0
			end)
			btn.MouseLeave:Connect(function()
				if dragging then
					-- keep highlight
				else row.BackgroundTransparency=1 end
			end)
			btn.MouseButton1Click:Connect(function()
				node.expanded=not node.expanded; refreshFileTree(); saveProject()
			end)
			-- Drop target
			btn.MouseButton1Up:Connect(function()
				if dragging and dragging~=node then
					fsMoveInto(dragging, node)
					dragging=nil; node.expanded=true
					refreshFileTree(); saveProject()
					toast("Moved into '"..node.name.."'","success")
				end
			end)

			-- Context: right-click → add file / add folder / rename / delete
			btn.MouseButton2Click:Connect(function()
				showDropdown("📁 "..node.name.." ›", {"New File","New Subfolder","Rename","Delete Folder"}, function(choice)
					if choice=="New File" then
						showDropdown("Language",{"NebScript","RbxPython","TypeRbx","Markdown","PlainText"},function(lang)
							local langMap={NebScript="neb",RbxPython="rbxpy",TypeRbx="typerbx",Markdown="md",PlainText="txt"}
							showInputDialog("New File Name","main.neb",function(name)
								if name and name~="" then
									local f=fsNode("file",name,node,{lang=langMap[lang] or "neb",content=""})
									node.expanded=true
									refreshFileTree(); saveProject()
									openTab(f)
									toast("Created '"..name.."'","success")
								end
							end)
						end)
					elseif choice=="New Subfolder" then
						showInputDialog("Subfolder Name","subfolder",function(name)
							if name and name~="" then
								fsNode("folder",name,node)
								node.expanded=true
								refreshFileTree(); saveProject()
							end
						end)
					elseif choice=="Rename" then
						showInputDialog("Rename Folder",node.name,function(name)
							if name and name~="" then fsRename(node,name); refreshFileTree(); saveProject() end
						end)
					elseif choice=="Delete Folder" then
						showConfirm("Delete folder '"..node.name.."' and ALL its contents?",function(y)
							if y then fsRemove(node); refreshFileTree(); saveProject() end
						end)
					end
				end)
			end)

			if node.expanded then
				for _,child in ipairs(node.children) do buildNode(child,depth+1) end
			end

		else -- file
			local lcol=LANG_BADGE_COL[node.lang] or T.TXT_DIM
			local ltxt=LANG_BADGE_TXT[node.lang] or "?"
			local isActive=activeTab==node

			local row=mkFrame({Size=UDim2.new(1,0,0,24),
				BackgroundColor3=isActive and T.BG_OVERLAY or Color3.new(0,0,0),
				BackgroundTransparency=isActive and 0 or 1,
				LayoutOrder=order,Parent=fileTreeCont})

			if isActive then mkStroke(row,T.NEBULA_PRI,1) end

			local badge=mkText({Text=ltxt,Size=UDim2.new(0,26,0,14),
				Position=UDim2.new(0,indent+4,.5,-7),
				BackgroundColor3=lcol,BackgroundTransparency=0,
				TextColor3=T.BG_VOID,TextXAlignment=Enum.TextXAlignment.Center,
				Font=Enum.Font.GothamBold,TextSize=8,Parent=row})
			mkCorner(badge,3)

			local dirtyDot=mkText({Text="●",Size=UDim2.new(0,10,1,0),
				Position=UDim2.new(1,-12,0,0),
				TextColor3=node.dirty and T.NEBULA_SEC or Color3.new(0,0,0),
				TextSize=8,TextXAlignment=Enum.TextXAlignment.Center,Parent=row})

			mkText({Text=node.name,Size=UDim2.new(1,-(indent+36),1,0),
				Position=UDim2.new(0,indent+32,0,0),
				TextColor3=isActive and T.TXT_BRIGHT or T.TXT_PRIMARY,
				Font=isActive and Enum.Font.GothamBold or Enum.Font.RobotoMono,
				TextSize=12,Parent=row})

			local btn=mkBtn({Text="",Size=UDim2.new(1,0,1,0),
				BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Parent=row})

			btn.MouseEnter:Connect(function()
				if not isActive then
					row.BackgroundColor3=T.BG_ELEVATED; row.BackgroundTransparency=0
				end
			end)
			btn.MouseLeave:Connect(function()
				if not isActive then row.BackgroundTransparency=1 end
			end)
			btn.MouseButton1Click:Connect(function()
				openTab(node); refreshFileTree()
			end)
			-- Drag start
			btn.MouseButton1Down:Connect(function() dragging=node end)
			btn.MouseButton1Up:Connect(function()
				if dragging==node then dragging=nil end
			end)

			-- Right-click context
			btn.MouseButton2Click:Connect(function()
				showDropdown("📄 "..node.name.." ›",
					{"Open","Change Language","Rename","Duplicate","Compile","Delete"}, function(choice)
					if choice=="Open" then
						openTab(node)
					elseif choice=="Change Language" then
						showDropdown("Select Language",{"NebScript","RbxPython","TypeRbx","Markdown","PlainText"},function(lang)
							local m={NebScript="neb",RbxPython="rbxpy",TypeRbx="typerbx",Markdown="md",PlainText="txt"}
							node.lang=m[lang] or "neb"; refreshFileTree(); saveProject()
							toast("Language changed to "..lang,"info")
						end)
					elseif choice=="Rename" then
						showInputDialog("Rename File",node.name,function(name)
							if name and name~="" then fsRename(node,name); refreshFileTree(); saveProject() end
						end)
					elseif choice=="Duplicate" then
						local newNode=fsNode("file",node.name.."_copy",node.parent,{lang=node.lang,content=node.content})
						refreshFileTree(); saveProject()
						toast("Duplicated","success")
					elseif choice=="Compile" then
						saveActiveContent()
						local inst,err=compileAndOutput(node)
						if inst then toast("Compiled → "..inst.Name,"success")
						else toast(tostring(err),"error") end
					elseif choice=="Delete" then
						showConfirm("Delete '"..node.name.."'?",function(y)
							if y then
								local _,ti=findTabInfo(node)
								if ti then closeTab(node) end
								fsRemove(node); refreshFileTree(); saveProject()
								toast("Deleted","warn")
							end
						end)
					end
				end)
			end)
		end
	end

	buildNode(FS.root, 0)

	local cnt=#fileTreeCont:GetChildren()-1
	fileTreeCont.Size=UDim2.new(1,0,0,math.max(cnt*26,200))
	if sidebarScroll then
		sidebarScroll.CanvasSize=UDim2.new(0,0,0,cnt*26+20)
	end
end

-- ════════════════════════════════════════════════════════════════════════════
--  SETTINGS PANEL BUILDER
-- ════════════════════════════════════════════════════════════════════════════
local function buildSettings()
	if not settingsFrame then return end
	for _,c in ipairs(settingsFrame:GetChildren()) do c:Destroy() end

	local scroll=mkScroll({Size=UDim2.new(1,0,1,-50),Position=UDim2.new(0,0,0,50),
		BackgroundColor3=T.BG_SURFACE,Parent=settingsFrame})

	local cont=mkFrame({Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
		BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Parent=scroll})
	mkList(cont,Enum.FillDirection.Vertical,0)
	mkPad(cont,8,8,14,14)

	-- Section header
	local function sec(title, icon)
		local h=mkFrame({Size=UDim2.new(1,0,0,30),BackgroundColor3=T.BG_ELEVATED,
			BackgroundTransparency=0,Parent=cont})
		mkCorner(h,4)
		mkText({Text=icon.."  "..title:upper(),Size=UDim2.new(1,-12,1,0),
			Position=UDim2.new(0,10,0,0),TextColor3=T.NEBULA_PRI,
			Font=Enum.Font.GothamBold,TextSize=11,Parent=h})
		mkStroke(h,T.NEBULA_DUST,1)
		return h
	end

	-- Row with label + widget
	local function row(label, widget)
		local r=mkFrame({Size=UDim2.new(1,0,0,38),BackgroundColor3=Color3.new(0,0,0),
			BackgroundTransparency=1,Parent=cont})
		mkText({Text=label,Size=UDim2.new(.55,0,1,0),Position=UDim2.new(0,0,0,0),
			TextColor3=T.TXT_PRIMARY,TextSize=12,Font=Enum.Font.RobotoMono,Parent=r})
		if widget then
			widget.Size=UDim2.new(.42,0,0,28); widget.Position=UDim2.new(.57,0,.5,-14)
			widget.Parent=r
		end
		return r
	end

	local function textInput(key, ph)
		local b=mkBox({Text=tostring(S[key] or ""),PlaceholderText=ph or ""})
		mkCorner(b,5); mkStroke(b,T.NEBULA_DUST,1); mkPad(b,0,0,8,8)
		b.FocusLost:Connect(function() S[key]=b.Text; saveSettings() end)
		return b
	end
	local function toggle(key)
		local b=mkBtn({Text=S[key] and "● ON" or "○ OFF",
			BackgroundColor3=S[key] and T.NEBULA_TER or T.BG_OVERLAY,
			TextColor3=S[key] and T.TXT_WHITE or T.TXT_DIM,
			Font=Enum.Font.GothamBold,TextSize=11})
		mkCorner(b,5)
		b.Activated:Connect(function()
			S[key]=not S[key]; saveSettings()
			b.Text=S[key] and "● ON" or "○ OFF"
			tween(b,{BackgroundColor3=S[key] and T.NEBULA_TER or T.BG_OVERLAY},.15)
			b.TextColor3=S[key] and T.TXT_WHITE or T.TXT_DIM
		end)
		return b
	end
	local function colorInput(key)
		local c=hexToColor(S[key] or "B450FF")
		local frame=mkFrame({BackgroundColor3=c})
		mkCorner(frame,5); mkStroke(frame,T.NEBULA_DUST,1)
		local b=mkBox({Text=S[key] or "B450FF",BackgroundColor3=Color3.new(0,0,0),
			BackgroundTransparency=.4,TextColor3=T.TXT_WHITE,TextXAlignment=Enum.TextXAlignment.Center,
			TextSize=11,Size=UDim2.new(1,0,1,0)})
		mkCorner(b,5); b.Parent=frame
		b.FocusLost:Connect(function()
			local hex=b.Text:gsub("#",""):upper()
			if #hex==6 then
				S[key]=hex; frame.BackgroundColor3=hexToColor(hex); saveSettings()
			end
		end)
		return frame
	end

	-- ── Editor ──────────────────────────────────────────────────────────────
	sec("Editor","⚙")
	row("Font Size",           textInput("ed_fontSize","14"))
	row("Tab Size",            textInput("ed_tabSize","4"))
	row("Word Wrap",           toggle("ed_wordWrap"))
	row("Line Numbers",        toggle("ed_lineNumbers"))
	row("Auto-Close Brackets", toggle("ed_autoCloseBrackets"))
	row("Auto-Close Strings",  toggle("ed_autoCloseStrings"))
	row("Highlight Active Line",toggle("ed_highlightLine"))
	row("Smooth Scroll",       toggle("ed_smoothScroll"))
	row("Show Whitespace",     toggle("ed_showWhitespace"))
	row("Cursor Style",        textInput("ed_cursorStyle","line"))
	row("Minimap",             toggle("ed_minimap"))
	row("Breadcrumbs",         toggle("ed_breadcrumbs"))
	row("Indent Guides",       toggle("ed_indentGuides"))
	row("Fold Gutter",         toggle("ed_foldGutter"))
	row("Rulers (cols,comma)", textInput("ed_rulers","80,120"))

	-- ── Syntax Colors ────────────────────────────────────────────────────────
	sec("Syntax Colors","🎨")
	row("Keywords",    colorInput("syn_keyword"))
	row("Strings",     colorInput("syn_string"))
	row("Numbers",     colorInput("syn_number"))
	row("Comments",    colorInput("syn_comment"))
	row("Functions",   colorInput("syn_function"))
	row("Types",       colorInput("syn_type"))
	row("Builtins",    colorInput("syn_builtin"))
	row("Operators",   colorInput("syn_operator"))
	row("Parameters",  colorInput("syn_param"))
	row("Macros",      colorInput("syn_macro"))
	row("Special",     colorInput("syn_special"))
	row("Labels",      colorInput("syn_label"))

	-- ── Compiler ─────────────────────────────────────────────────────────────
	sec("Compiler","🔧")
	row("Script Type",       textInput("cmp_scriptType","Script"))
	row("Target Service",    textInput("cmp_targetService","ServerScriptService"))
	row("Strict Mode",       toggle("cmp_strictMode"))
	row("Show Warnings",     toggle("cmp_warnings"))
	row("Insert Preamble",   toggle("cmp_insertPreamble"))
	row("Wrap in pcall",     toggle("cmp_wrapInPcall"))

	-- ── Workspace ────────────────────────────────────────────────────────────
	sec("Workspace","📁")
	row("Project Name",      textInput("ws_projectName","MyProject"))
	row("Root Service",      textInput("ws_rootService","ReplicatedStorage"))

	-- ── Interface ────────────────────────────────────────────────────────────
	sec("Interface","🖥")
	row("Status Bar",        toggle("ui_showStatusBar"))
	row("Problems Panel",    toggle("ui_showProblems"))
	row("Animated UI",       toggle("ui_animateUI"))
	row("Particle Background",toggle("ui_particlesBG"))
	row("Confirm on Close",  toggle("ui_confirmClose"))
	row("Autosave (secs)",   textInput("ui_autosave","60"))
	row("Tooltips",          toggle("ui_tooltips"))

	-- ── Keybinds ─────────────────────────────────────────────────────────────
	sec("Keybinds (display)","⌨")
	row("Compile",           textInput("kb_compile","F5"))
	row("Save",              textInput("kb_save","Ctrl+S"))
	row("New File",          textInput("kb_newFile","Ctrl+N"))
	row("Close Tab",         textInput("kb_closeTab","Ctrl+W"))
	row("Find",              textInput("kb_find","Ctrl+F"))
	row("Replace",           textInput("kb_replace","Ctrl+H"))
	row("Comment/Uncomment", textInput("kb_comment","Ctrl+/"))
	row("Duplicate Line",    textInput("kb_duplicateLine","Ctrl+D"))

	-- ── Reset ────────────────────────────────────────────────────────────────
	local resetBtn=mkBtn({Text="↺  Reset All to Defaults",
		Size=UDim2.new(1,0,0,38),BackgroundColor3=T.RED,TextColor3=T.TXT_WHITE,
		Font=Enum.Font.GothamBold,TextSize=13,Parent=cont})
	mkCorner(resetBtn,6)
	resetBtn.Activated:Connect(function()
		showConfirm("Reset ALL settings to defaults?",function(y)
			if y then S=deepCopy(DEFAULTS); saveSettings(); buildSettings()
				toast("Settings reset","info") end
		end)
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
--  MODULES PANEL BUILDER
-- ════════════════════════════════════════════════════════════════════════════
local function buildModules()
	if not modulesFrame then return end
	for _,c in ipairs(modulesFrame:GetChildren()) do
		if not c:IsA("UIStroke") then c:Destroy() end
	end

	mkText({Text="📦  MODULES  ("..#listModules()..")",
		Size=UDim2.new(1,-16,0,30),Position=UDim2.new(0,12,0,10),
		TextColor3=T.NEBULA_PRI,Font=Enum.Font.GothamBold,TextSize=13,Parent=modulesFrame})

	local scroll=mkScroll({Size=UDim2.new(1,0,1,-100),Position=UDim2.new(0,0,0,48),
		BackgroundColor3=T.BG_SURFACE,Parent=modulesFrame})

	local cont=mkFrame({Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
		BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Parent=scroll})
	mkList(cont,Enum.FillDirection.Vertical,2)
	mkPad(cont,4,4,8,8)

	for _,name in ipairs(listModules()) do
		local isUser=USER_MODULES[name]~=nil
		local btn=mkBtn({Text="  "..name..(isUser and "  [custom]" or ""),
			Size=UDim2.new(1,0,0,30),BackgroundColor3=T.BG_ELEVATED,
			TextColor3=isUser and T.NEBULA_SEC or T.TXT_PRIMARY,
			TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.RobotoMono,TextSize=12,
			Parent=cont})
		mkCorner(btn,5)
		btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=T.BG_OVERLAY},.1) end)
		btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=T.BG_ELEVATED},.1) end)
		btn.Activated:Connect(function()
			-- Open module content as a read-only tab
			local content=getModuleContent(name)
			if content and FS.root then
				local tmp=fsNode("file",name..".mod","__view__",{lang="neb",content=content})
				-- temporary node not in tree
				tmp.parent=nil; FS.index[tmp.id]=nil
				-- just directly open a tab with a node
				local fakeTi; local tabBar=GUI_ROOT and GUI_ROOT:FindFirstChild("TabBar",true)
				if tabBar then
					local _,ex=findTabInfo(tmp)
					if not ex then openTab(tmp) end
				end
				toast("Viewing module: "..name,"info")
			end
		end)
	end

	local regBtn=mkBtn({Text="+  Register Custom Module",
		Size=UDim2.new(1,-16,0,34),Position=UDim2.new(0,8,1,-44),
		BackgroundColor3=T.NEBULA_TER,TextColor3=T.TXT_WHITE,
		Font=Enum.Font.GothamBold,TextSize=13,Parent=modulesFrame})
	mkCorner(regBtn,6)
	regBtn.Activated:Connect(function()
		showInputDialog("Module Name","myModule",function(name)
			if name and name~="" then
				registerUserModule(name)
				buildModules()
				toast("Registered: "..name,"success")
			end
		end)
	end)
end

-- ════════════════════════════════════════════════════════════════════════════
--  PROBLEMS PANEL
-- ════════════════════════════════════════════════════════════════════════════
local problems={}
local function clearProblems()
	problems={}
	if problemsCont then
		for _,c in ipairs(problemsCont:GetChildren()) do
			if not c:IsA("UIListLayout") then c:Destroy() end
		end
	end
end
local function addProblem(msg, file, line_, severity)
	severity=severity or "error"
	local cols={error=T.RED,warning=T.GOLD,info=T.CYAN}
	local icons={error="✕",warning="⚠",info="ℹ"}
	table.insert(problems,{msg=msg,file=file,line=line_,severity=severity})
	if not problemsCont then return end
	local col=cols[severity] or T.RED
	local row=mkFrame({Size=UDim2.new(1,0,0,26),BackgroundColor3=Color3.new(0,0,0),
		BackgroundTransparency=1,Parent=problemsCont})
	mkText({Text=icons[severity].." "..msg..(file and (" ["..file..":"..tostring(line_).."]") or ""),
		Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,8,0,0),
		TextColor3=col,TextSize=11,Font=Enum.Font.RobotoMono,
		TextTruncate=Enum.TextTruncate.AtEnd,Parent=row})
end

-- ════════════════════════════════════════════════════════════════════════════
--  MAIN UI BUILD
-- ════════════════════════════════════════════════════════════════════════════
local function buildUI()
	-- Destroy existing
	local existing=game:GetService("CoreGui"):FindFirstChild("NebScriptIDE")
	if existing then existing:Destroy() end

	local screenGui=Instance.new("ScreenGui")
	screenGui.ResetOnSpawn=false; screenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	screenGui.Name="NebScriptIDE"; screenGui.Parent=game:GetService("CoreGui")
	GUI_ROOT=screenGui

	-- ── ROOT FRAME ────────────────────────────────────────────────────────────
	local root=mkFrame({Size=UDim2.new(1,0,1,0),BackgroundColor3=T.BG_VOID,Parent=screenGui})
	root.Name="__Root"

	-- ── PARTICLE BACKGROUND ───────────────────────────────────────────────────
	for i=1,80 do
		local px=math.random(); local py=math.random()
		local size=math.random(1,3)
		local alpha=math.random()*0.6+0.1
		local hue=math.random(270,320)/360
		local star=mkFrame({Size=UDim2.new(0,size,0,size),
			Position=UDim2.new(px,0,py,0),
			BackgroundColor3=Color3.fromHSV(hue,.8,.9),
			BackgroundTransparency=1-alpha,ZIndex=0,Parent=root})
		mkCorner(star,2)
		-- Twinkle animation
		if i%3==0 then
			local function twinkle()
				tween(star,{BackgroundTransparency=1-(alpha*.3)},math.random()*2+1,
					Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
				task.delay(math.random()*2+1,function()
					tween(star,{BackgroundTransparency=1-alpha},math.random()*2+1,
						Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
					task.delay(math.random()*3+2,twinkle)
				end)
			end
			task.delay(math.random()*5,twinkle)
		end
	end

	-- ── TOOLBAR (top 46px) ────────────────────────────────────────────────────
	local toolbar=mkFrame({Size=UDim2.new(1,0,0,46),BackgroundColor3=T.BG_SURFACE,Parent=root})
	mkStroke(toolbar,T.BORDER,1)
	mkGradient(toolbar,{T.BG_ELEVATED,T.BG_SURFACE},0)

	-- Logo
	local logoText=mkText({
		Text='<font color="#B450FF"><b>✦ Neb</b></font><font color="#FF50C8"><b>Script</b></font>  <font color="#5A4190">IDE</font>',
		RichText=true,
		Size=UDim2.new(0,160,1,0),Position=UDim2.new(0,12,0,0),
		Font=Enum.Font.GothamBold,TextSize=16,Parent=toolbar})

	-- Toolbar buttons
	local tbBtns={
		{icon="＋",tip="New File (Ctrl+N)",action="new_file"},
		{icon="📂",tip="New Folder",action="new_folder"},
		{icon="▶",tip="Compile Active (F5)",action="compile"},
		{icon="⬡",tip="Compile All",action="compile_all"},
		{icon="⚙",tip="Settings",action="settings"},
		{icon="📦",tip="Modules",action="modules"},
		{icon="🔍",tip="Find / Replace (Ctrl+F)",action="find"},
		{icon="✦",tip="About NebScript",action="about"},
	}

	local tbX=168
	local function makeTbBtn(icon, action)
		local btn=mkBtn({Text=icon,Size=UDim2.new(0,38,0,34),
			Position=UDim2.new(0,tbX,0.5,-17),
			BackgroundColor3=T.BG_ELEVATED,TextColor3=T.TXT_PRIMARY,
			Font=Enum.Font.GothamBold,TextSize=16,Parent=toolbar})
		mkCorner(btn,6)
		tbX=tbX+42
		btn.MouseEnter:Connect(function()
			tween(btn,{BackgroundColor3=T.BG_OVERLAY},.1)
			btn.TextColor3=T.NEBULA_PRI
		end)
		btn.MouseLeave:Connect(function()
			tween(btn,{BackgroundColor3=T.BG_ELEVATED},.1)
			btn.TextColor3=T.TXT_PRIMARY
		end)
		return btn
	end

	local btnHandles={}
	for _,info in ipairs(tbBtns) do
		btnHandles[info.action]=makeTbBtn(info.icon, info.action)
	end

	-- Version label
	mkText({Text="v1.0.0",Size=UDim2.new(0,60,1,0),Position=UDim2.new(1,-70,0,0),
		TextColor3=T.TXT_MUTED,TextSize=11,TextXAlignment=Enum.TextXAlignment.Right,Parent=toolbar})

	-- ── BODY (below toolbar) ──────────────────────────────────────────────────
	local body=mkFrame({Size=UDim2.new(1,0,1,-46),Position=UDim2.new(0,0,0,46),
		BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Parent=root})

	-- ── SIDEBAR ───────────────────────────────────────────────────────────────
	local SIDEBAR_W=tonumber(S.ui_sidebarWidth) or 220
	local sidebar=mkFrame({Size=UDim2.new(0,SIDEBAR_W,1,0),BackgroundColor3=T.BG_SIDEBAR,Parent=body})
	mkStroke(sidebar,T.BORDER,1)

	-- Sidebar header
	local sbHeader=mkFrame({Size=UDim2.new(1,0,0,34),BackgroundColor3=T.BG_ELEVATED,Parent=sidebar})
	mkGradient(sbHeader,{T.BG_ELEVATED,T.BG_SIDEBAR},90)
	mkText({Text="  EXPLORER",Size=UDim2.new(1,-70,1,0),TextColor3=T.NEBULA_PRI,
		Font=Enum.Font.GothamBold,TextSize=11,Parent=sbHeader})

	-- Sidebar action buttons
	local function sbBtn(icon, x, tip)
		local b=mkBtn({Text=icon,Size=UDim2.new(0,26,0,26),Position=UDim2.new(1,-(x),0.5,-13),
			BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,
			TextColor3=T.TXT_DIM,TextSize=14,Font=Enum.Font.GothamBold,Parent=sbHeader})
		b.MouseEnter:Connect(function() b.TextColor3=T.NEBULA_PRI end)
		b.MouseLeave:Connect(function() b.TextColor3=T.TXT_DIM end)
		return b
	end
	local newFileBtn=sbBtn("＋",60,"New File")
	local newFolderBtn=sbBtn("📁",30,"New Folder")

	-- Project name label
	local projLabel=mkText({Text="  "..S.ws_projectName,
		Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0,34),
		TextColor3=T.TXT_MUTED,TextSize=10,Font=Enum.Font.Gotham,Parent=sidebar})

	-- File tree scroll
	sidebarScroll=mkScroll({Size=UDim2.new(1,0,1,-56),Position=UDim2.new(0,0,0,56),
		BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Parent=sidebar})

	fileTreeCont=mkFrame({Size=UDim2.new(1,0,0,200),BackgroundColor3=Color3.new(0,0,0),
		BackgroundTransparency=1,Parent=sidebarScroll})
	mkList(fileTreeCont)

	-- ── TAB BAR ───────────────────────────────────────────────────────────────
	local mainArea=mkFrame({Size=UDim2.new(1,-SIDEBAR_W,1,0),Position=UDim2.new(0,SIDEBAR_W,0,0),
		BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Parent=body})

	local tabBar=mkScroll({Name="TabBar",Size=UDim2.new(1,0,0,36),
		BackgroundColor3=T.BG_SURFACE,
		ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.X,
		CanvasSize=UDim2.new(0,0,0,0),Parent=mainArea})
	mkStroke(tabBar,T.BORDER,1)
	local tabList=mkList(tabBar,Enum.FillDirection.Horizontal,0)
	tabBar.Name="TabBar"

	-- ── SEARCH BAR (hidden by default) ───────────────────────────────────────
	searchBar=mkFrame({Size=UDim2.new(1,0,0,36),Position=UDim2.new(0,0,0,36),
		BackgroundColor3=T.BG_ELEVATED,Visible=false,Parent=mainArea})
	mkStroke(searchBar,T.NEBULA_DUST,1)
	mkPad(searchBar,4,4,8,8)

	local findBox=mkBox({PlaceholderText="Find…",Size=UDim2.new(.42,0,1,-8),
		Position=UDim2.new(0,0,.5,-0),BackgroundColor3=T.BG_INPUT,Parent=searchBar})
	mkCorner(findBox,5); mkStroke(findBox,T.NEBULA_DUST,1); mkPad(findBox,0,0,6,6)

	local replBox=mkBox({PlaceholderText="Replace…",Size=UDim2.new(.42,0,1,-8),
		Position=UDim2.new(.44,0,.5,-0),BackgroundColor3=T.BG_INPUT,Parent=searchBar})
	mkCorner(replBox,5); mkStroke(replBox,T.NEBULA_DUST,1); mkPad(replBox,0,0,6,6)

	local replBtn=mkBtn({Text="Replace All",Size=UDim2.new(.12,0,1,-8),
		Position=UDim2.new(.87,0,.5,-0),BackgroundColor3=T.NEBULA_TER,
		TextColor3=T.TXT_WHITE,Font=Enum.Font.GothamBold,TextSize=11,Parent=searchBar})
	mkCorner(replBtn,5)

	local closeSearchBtn=mkBtn({Text="✕",Size=UDim2.new(0,26,1,-8),
		Position=UDim2.new(1,-28,.5,-0),
		BackgroundColor3=T.BG_OVERLAY,TextColor3=T.TXT_DIM,Parent=searchBar})
	mkCorner(closeSearchBtn,5)
	closeSearchBtn.Activated:Connect(function() searchBar.Visible=false end)
	replBtn.Activated:Connect(function()
		local find=findBox.Text; local repl=replBox.Text
		if find~="" and activeTab then
			saveActiveContent()
			activeTab.content=activeTab.content:gsub(find:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%1"),repl)
			editorBox.Text=activeTab.content
			toast("Replaced all occurrences of '"..find.."'","success")
		end
	end)

	-- ── EDITOR AREA ───────────────────────────────────────────────────────────
	local PROBLEMS_H=120
	local editorArea=mkFrame({Size=UDim2.new(1,0,1,-36-PROBLEMS_H-(S.ui_showStatusBar and 28 or 0)),
		Position=UDim2.new(0,0,0,72),BackgroundColor3=T.BG_EDITOR,Parent=mainArea})

	-- Line numbers pane
	local lineNumPane=mkFrame({Size=UDim2.new(0,44,1,0),BackgroundColor3=T.BG_VOID,Parent=editorArea})
	mkStroke(lineNumPane,T.BORDER,1)
	lineNumScroll=mkFrame({Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),
		BackgroundTransparency=1,ClipsDescendants=true,Parent=lineNumPane})
	mkList(lineNumScroll); mkPad(lineNumScroll,4,4,2,4)

	-- Editor TextBox
	editorScroll=mkScroll({Size=UDim2.new(1,-44,1,0),Position=UDim2.new(0,44,0,0),
		BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,
		ScrollBarThickness=6,ScrollBarImageColor3=T.NEBULA_DUST,
		CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
		Parent=editorArea})

	editorBox=mkBox({Text="",PlaceholderText="-- Start coding in NebScript, RbxPython, or TypeRbx…",
		Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
		Position=UDim2.new(0,0,0,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,
		TextColor3=T.TXT_PRIMARY,TextXAlignment=Enum.TextXAlignment.Left,
		TextYAlignment=Enum.TextYAlignment.Top,Font=Enum.Font.RobotoMono,
		TextSize=tonumber(S.ed_fontSize) or 14,ClearTextOnFocus=false,
		MultiLine=true,TextWrapped=S.ed_wordWrap,
		PlaceholderColor3=T.TXT_MUTED,Parent=editorScroll})
	mkPad(editorBox,6,6,10,10)

	-- Update line numbers as user types
	editorBox:GetPropertyChangedSignal("Text"):Connect(function()
		refreshLineNumbers(editorBox.Text)
		if activeTab then
			activeTab.content=editorBox.Text
			activeTab.dirty=true
		end
	end)

	-- ── PROBLEMS PANEL ────────────────────────────────────────────────────────
	local probPanel=mkFrame({Size=UDim2.new(1,0,0,PROBLEMS_H),
		Position=UDim2.new(0,0,1,-PROBLEMS_H-(S.ui_showStatusBar and 28 or 0)),
		BackgroundColor3=T.BG_SURFACE,Parent=mainArea})
	mkStroke(probPanel,T.BORDER,1)

	mkText({Text="  ⚠  PROBLEMS",Size=UDim2.new(1,0,0,24),
		TextColor3=T.GOLD,Font=Enum.Font.GothamBold,TextSize=11,
		BackgroundColor3=T.BG_ELEVATED,BackgroundTransparency=0,Parent=probPanel})

	local probScroll=mkScroll({Size=UDim2.new(1,0,1,-24),Position=UDim2.new(0,0,0,24),
		BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Parent=probPanel})
	problemsCont=mkFrame({Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
		BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,Parent=probScroll})
	mkList(problemsCont)

	-- ── STATUS BAR ────────────────────────────────────────────────────────────
	local statusBar
	if S.ui_showStatusBar then
		statusBar=mkFrame({Size=UDim2.new(1,0,0,28),Position=UDim2.new(0,0,1,-28),
			BackgroundColor3=T.NEBULA_TER,Parent=mainArea})
		mkGradient(statusBar,{T.NEBULA_TER,T.BG_ELEVATED},0)

		statusLangLbl=mkText({Text="NebScript",Size=UDim2.new(0,100,1,0),
			Position=UDim2.new(0,8,0,0),TextColor3=T.TXT_WHITE,
			Font=Enum.Font.GothamBold,TextSize=11,Parent=statusBar})

		statusLineLbl=mkText({Text="Ln 1, Col 1",Size=UDim2.new(0,120,1,0),
			Position=UDim2.new(0,110,0,0),TextColor3=T.TXT_DIM,
			TextSize=11,Parent=statusBar})

		mkText({Text="NebScript IDE  •  v1.0.0  •  Nebula Theme",
			Size=UDim2.new(.5,0,1,0),Position=UDim2.new(.25,0,0,0),
			TextColor3=T.TXT_DIM,TextXAlignment=Enum.TextXAlignment.Center,
			TextSize=11,Parent=statusBar})

		statusMsgLbl=mkText({Text="Ready",Size=UDim2.new(0,200,1,0),
			Position=UDim2.new(1,-208,0,0),TextColor3=T.TXT_DIM,
			TextXAlignment=Enum.TextXAlignment.Right,TextSize=11,Parent=statusBar})
	end

	-- ── SETTINGS FRAME (overlay panel) ───────────────────────────────────────
	settingsFrame=mkFrame({Size=UDim2.new(0,500,1,0),Position=UDim2.new(1,0,0,0),
		BackgroundColor3=T.BG_SURFACE,ZIndex=50,Parent=mainArea})
	mkStroke(settingsFrame,T.NEBULA_PRI,1.5)

	mkText({Text="  ⚙  SETTINGS",Size=UDim2.new(1,0,0,40),
		BackgroundColor3=T.BG_ELEVATED,BackgroundTransparency=0,
		TextColor3=T.NEBULA_PRI,Font=Enum.Font.GothamBold,TextSize=14,ZIndex=51,Parent=settingsFrame})
	local closeSettings=mkBtn({Text="✕",Size=UDim2.new(0,28,0,28),
		Position=UDim2.new(1,-34,0,6),BackgroundColor3=T.BG_OVERLAY,
		TextColor3=T.TXT_DIM,ZIndex=52,Parent=settingsFrame})
	mkCorner(closeSettings,6)
	closeSettings.Activated:Connect(function()
		tween(settingsFrame,{Position=UDim2.new(1,0,0,0)},.25,Enum.EasingStyle.Back,Enum.EasingDirection.In)
	end)
	buildSettings()

	-- ── MODULES FRAME (overlay panel) ────────────────────────────────────────
	modulesFrame=mkFrame({Size=UDim2.new(0,400,1,0),Position=UDim2.new(1,0,0,0),
		BackgroundColor3=T.BG_SURFACE,ZIndex=50,Parent=mainArea})
	mkStroke(modulesFrame,T.NEBULA_SEC,1.5)
	local closeMods=mkBtn({Text="✕",Size=UDim2.new(0,28,0,28),
		Position=UDim2.new(1,-34,0,6),BackgroundColor3=T.BG_OVERLAY,
		TextColor3=T.TXT_DIM,ZIndex=52,Parent=modulesFrame})
	mkCorner(closeMods,6)
	closeMods.Activated:Connect(function()
		tween(modulesFrame,{Position=UDim2.new(1,0,0,0)},.25,Enum.EasingStyle.Back,Enum.EasingDirection.In)
	end)
	buildModules()

	-- ── TOOLBAR ACTIONS ───────────────────────────────────────────────────────
	local function newFile()
		if not FS.root then toast("No project open","warn"); return end
		showDropdown("Language",{"NebScript","RbxPython","TypeRbx","Markdown","PlainText"},function(lang)
			local m={NebScript="neb",RbxPython="rbxpy",TypeRbx="typerbx",Markdown="md",PlainText="txt"}
			showInputDialog("File Name","main.neb",function(name)
				if name and name~="" then
					local node=fsNode("file",name,FS.root,{lang=m[lang] or "neb",content=""})
					refreshFileTree(); saveProject(); openTab(node)
					toast("Created '"..name.."'","success")
				end
			end)
		end)
	end

	local function newFolder()
		if not FS.root then toast("No project open","warn"); return end
		showInputDialog("Folder Name","myfolder",function(name)
			if name and name~="" then
				fsNode("folder",name,FS.root); FS.root.expanded=true
				refreshFileTree(); saveProject()
				toast("Created folder '"..name.."'","success")
			end
		end)
	end

	local function compileActive()
		saveActiveContent()
		if not activeTab then toast("No file open","warn"); return end
		clearProblems()
		local inst,err=compileAndOutput(activeTab)
		if inst then
			setStatus("Compiled → "..inst:GetFullName(),"success")
			toast("Compiled: "..activeTab.name,"success")
			activeTab.dirty=false; refreshFileTree(); refreshTabBar()
		else
			setStatus("Compile error","error")
			addProblem(tostring(err), activeTab.name, nil, "error")
			toast("Compile failed","error")
		end
	end

	local function compileAll()
		if not FS.root then toast("No project","warn"); return end
		saveActiveContent()
		clearProblems()
		local count=0; local errors=0
		local function recurse(node)
			if node.type=="file" and node.lang~="md" and node.lang~="txt" then
				local _,err=compileAndOutput(node)
				if err then errors=errors+1; addProblem(tostring(err),node.name,nil,"error")
				else count=count+1; node.dirty=false end
			elseif node.type=="folder" then
				for _,child in ipairs(node.children) do recurse(child) end
			end
		end
		recurse(FS.root)
		refreshTabBar()
		if errors>0 then
			toast("Compiled "..count.." / errors: "..errors,"warn")
		else
			toast("All "..count.." files compiled ✓","success")
		end
	end

	btnHandles["new_file"].Activated:Connect(newFile)
	btnHandles["new_folder"].Activated:Connect(newFolder)
	btnHandles["compile"].Activated:Connect(compileActive)
	btnHandles["compile_all"].Activated:Connect(compileAll)
	newFileBtn.Activated:Connect(newFile)
	newFolderBtn.Activated:Connect(newFolder)

	btnHandles["settings"].Activated:Connect(function()
		local shown=settingsFrame.Position.X.Scale>=.9
		if shown then
			tween(settingsFrame,{Position=UDim2.new(1,-500,0,0)},.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		else
			tween(settingsFrame,{Position=UDim2.new(1,0,0,0)},.25,Enum.EasingStyle.Back,Enum.EasingDirection.In)
		end
	end)

	btnHandles["modules"].Activated:Connect(function()
		local shown=modulesFrame.Position.X.Scale>=.9
		if shown then
			buildModules()
			tween(modulesFrame,{Position=UDim2.new(1,-400,0,0)},.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		else
			tween(modulesFrame,{Position=UDim2.new(1,0,0,0)},.25,Enum.EasingStyle.Back,Enum.EasingDirection.In)
		end
	end)

	btnHandles["find"].Activated:Connect(function()
		searchBar.Visible=not searchBar.Visible
		if searchBar.Visible then findBox:CaptureFocus() end
	end)

	btnHandles["about"].Activated:Connect(function()
		showConfirm(
			"NebScript IDE  v1.0.0\n\nThree name candidates:\n  1. NebScript\n  2. VoidScript\n  3. LunaLang\n\nNebula Theme · Rust/Swift syntax vibe\nLanguages: NebScript · RbxPython · TypeRbx",
			function() end)
	end)

	-- Keyboard shortcuts
	UIS.InputBegan:Connect(function(inp, gp)
		if gp then return end
		local ctrl=UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)
		if inp.KeyCode==Enum.KeyCode.F5 then compileActive()
		elseif ctrl and inp.KeyCode==Enum.KeyCode.S then
			saveActiveContent(); saveProject(); toast("Saved","success")
		elseif ctrl and inp.KeyCode==Enum.KeyCode.N then newFile()
		elseif ctrl and inp.KeyCode==Enum.KeyCode.W then
			if activeTab then closeTab(activeTab) end
		elseif ctrl and inp.KeyCode==Enum.KeyCode.F then
			searchBar.Visible=not searchBar.Visible
			if searchBar.Visible then findBox:CaptureFocus() end
		elseif ctrl and inp.KeyCode==Enum.KeyCode.Return then
			compileActive()
		end
	end)

	-- ── AUTOSAVE ──────────────────────────────────────────────────────────────
	local autosaveInterval=tonumber(S.ui_autosave) or 0
	if autosaveInterval>0 then
		task.spawn(function()
			while GUI_ROOT and GUI_ROOT.Parent do
				task.wait(autosaveInterval)
				saveActiveContent(); saveProject()
				setStatus("Autosaved","success")
			end
		end)
	end

	-- ── INITIALISE PROJECT ────────────────────────────────────────────────────
	local loaded=loadProject()
	if not loaded then
		-- First run: ask for project name + service
		showDropdown("Root Service",{"ReplicatedStorage","ServerStorage","ServerScriptService","Workspace"},function(svc)
			S.ws_rootService=svc or "ReplicatedStorage"
			showInputDialog("Project Name","MyProject",function(name)
				S.ws_projectName=name or "MyProject"
				saveSettings()
				FS.root=fsNode("folder",S.ws_projectName,nil)
				FS.root.expanded=true
				-- Create starter file
				local starter=fsNode("file","main.neb",FS.root,{lang="neb",content=[[
// Welcome to NebScript!
// Language: NebScript (Rust/Swift modern vibe)
// Compiles to Roblox Lua

@roblox
fn main() {
    let message = "Hello from $NebScript!"
    print(message)

    // Range loop
    for i in range(1, 10) {
        let squared = i ** 2
        print(fmt("  %d² = %d", i, squared))
    }

    // Pipeline example
    let result = [1,2,3,4,5]
        |> filter(fn(x) -> x % 2 == 0)
        |> map(fn(x) -> x * 10)
    print(result)

    // Pattern matching
    let score = 85
    match score {
        case 90: print("A grade")
        case 80: print("B grade")
        case 70: print("C grade")
        default: print("Keep trying!")
    }
}

main()
]]})
				refreshFileTree(); saveProject()
				openTab(starter)
				projLabel.Text="  "..S.ws_projectName
				toast("Project '"..S.ws_projectName.."' created!","success")
			end)
		end)
	else
		refreshFileTree()
		projLabel.Text="  "..S.ws_projectName
		-- Open first file if any
		if FS.root then
			local function findFirst(node)
				if node.type=="file" then return node end
				for _,c in ipairs(node.children or {}) do
					local f=findFirst(c); if f then return f end
				end
			end
			local first=findFirst(FS.root)
			if first then openTab(first) end
		end
		toast("Loaded project: "..S.ws_projectName,"success")
	end
end

-- ════════════════════════════════════════════════════════════════════════════
--  PLUGIN BUTTON & LIFECYCLE
-- ════════════════════════════════════════════════════════════════════════════
local pluginToolbar = plugin:CreateToolbar("NebScript IDE")
local pluginButton  = pluginToolbar:CreateButton(
	"NebScript IDE",
	"Open NebScript IDE — multi-language transpiler for Roblox",
	""   -- icon asset id (blank = default)
)

local guiOpen = false

pluginButton.Click:Connect(function()
	guiOpen = not guiOpen
	if guiOpen then
		buildUI()
		pluginButton:SetActive(true)
	else
		local existing=game:GetService("CoreGui"):FindFirstChild("NebScriptIDE")
		if existing then
			saveActiveContent(); saveProject()
			existing:Destroy()
		end
		GUI_ROOT=nil
		pluginButton:SetActive(false)
	end
end)

plugin.Unloading:Connect(function()
	saveActiveContent(); saveProject(); saveSettings()
	local existing=game:GetService("CoreGui"):FindFirstChild("NebScriptIDE")
	if existing then existing:Destroy() end
end)
