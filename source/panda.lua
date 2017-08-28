-- title:  8 Bit Panda
-- author: Bruno Oliveira
-- desc:   A panda platformer
-- script: lua
-- saveid: eightbitpanda
--
-- WARNING: this file must be kept under
-- 64kB (TIC-80 limit)!

NAME="8-BIT PANDA"
C=8
ROWS=17
COLS=30
SCRW=240
SCRH=136

-- jump sequence (delta y at each frame)
JUMP_DY={-3,-3,-3,-3,-2,-2,-2,-2,
  -1,-1,0,0,0,0,0}

-- swimming seq (implemented as a "jump")
SWIM_JUMP_DY={-2,-2,-1,-1,-1,-1,0,0,0,0,0}
RESURF_DY={-3,-3,-2,-2,-1,-1,0,0,0,0,0}

-- attack sequence (1=preparing,
-- 2=attack,3=recovery)
ATK_SEQ={1,1,1,1,2,3,3,3}

-- die sequence (dx,dy)
DIE_SEQ={{-1,-1},{-2,-2},{-3,-3},{-4,-4},
 {-5,-5},{-6,-5},{-7,-4},{-8,-3},{-8,-2},
 {-8,1},{-8,3},{-8,5},{-8,9},{-8,13},
 {-8,17},{-8,21},{-8,26},{-8,32},{-8,39}
}

-- display x coords in which
-- to keep the player (for scrolling)
SX_MIN=50
SX_MAX=70

-- entity/tile solidity
SOL={
 NOT=0,  -- not solid
 HALF=1, -- only when going down,
         -- allows movement upward.
 FULL=2, -- fully solid
}

FIRE={
 -- duration of fire powerup
 DUR=1000,
 -- time between successive fires.
 INTERVAL=20,
 -- offset from player pos
 OFFY=2,OFFX=7,OFFX_FLIP=-2,
 OFFX_PLANE=14,OFFY_PLANE=8,
 -- projectile collision rect
 COLL={x=0,y=0,w=3,h=3},
}

-- Tiles
-- 0: empty
-- 1-79: static solid blocks
-- 80-127: decorative
-- 128-239: entities
-- 240-255: special markers
T={
 EMPTY=0,
 -- platform that's only solid when
 -- going down, but allows upward move
 HPLAF=4,
 
 SURF=16,
 WATER=32,
 WFALL=48,

 TARMAC=52, -- (where plane can land).

 -- sprite id above which tiles are
 -- non-solid decorative elements
 FIRST_DECO=80,

 -- level-end gate components
 GATE_L=110,GATE_R=111,
 GATE_L2=142,GATE_R=143,

 -- tile id above which tiles are
 -- representative of entities, not bg
 FIRST_ENT=128,
 
 -- tile id above which tiles have special
 -- meanings
 FIRST_META=240,
 
 -- number markers (used for level
 -- packing and annotations).
 META_NUM_0=240,
   -- followed by nums 1-9.
 
 -- A/B markers (entity-specific meaning)
 META_A=254,
 META_B=255
}

-- Autocomplete of tiles patterns.
-- Auto filled when top left map tile
-- is present.
TPAT={
 [85]={w=2,h=2},
 [87]={w=2,h=2},
 [94]={w=2,h=2},
 [89]={w=2,h=2},
}

-- solidity of tiles (overrides)
TSOL={
 [T.EMPTY]=SOL.NOT,
 [T.HPLAF]=SOL.HALF,
 [T.SURF]=SOL.NOT,
 [T.WATER]=SOL.NOT,
 [T.WFALL]=SOL.NOT,
}

-- animated tiles
TANIM={
 [T.SURF]={T.SURF,332},
 [T.WFALL]={T.WFALL,333,334,335},
}

-- sprites
S={
 PLR={  -- player sprites
  STAND=257,
  WALK1=258,
  WALK2=259,
  JUMP=273,
  SWING=276,
  SWING_C=260,
  HIT=277,
  HIT_C=278,
  DIE=274,
  SWIM1=267,SWIM2=268,
  -- overlays for fire powerup
  FIRE_BAMBOO=262, -- bamboo powerup
  FIRE_F=265,  -- suit, front
  FIRE_P=266,  -- suit, profile
  FIRE_S=284,  -- suit, swimming
  -- overlays for super panda powerup
  SUPER_F=281, -- suit, front
  SUPER_P=282, -- suit, profile
  SUPER_S=283, -- suit, swimming
 },
 EN={  -- enemy sprites
  A=176,
  B=177,
  DEMON=178,
  DEMON_THROW=293,
  SLIME=180,
  BAT=181,
  HSLIME=182, -- hidden slime
  DASHER=183,
  VBAT=184,
  SDEMON=185, -- snow demon
  SDEMON_THROW=300,
  PDEMON=188,  -- plasma demon
  PDEMON_THROW=317,
  FISH=189,
  FISH2=190,
 },
 -- crumbling block
 CRUMBLE=193,CRUMBLE_2=304,CRUMBLE_3=305,
 FIREBALL=179,
 FIRE_1=263,FIRE_2=264,
 LIFT=192,
 PFIRE=263, -- player fire (bamboo)
 FIRE_PWUP=129,
 -- background mountains
 BGMNT={DIAG=496,FULL=497},
 SCRIM=498, -- also 499,500
 SPIKE=194,
 CHEST=195,CHEST_OPEN=311,
 -- timed platform (opens and closes)
 TPLAF=196,TPLAF_HALF=312,TPLAF_OFF=313,
 SUPER_PWUP=130,
 SIGN=197,
 SNOWBALL=186,
 FLAG=198,
 FLAG_T=326,  -- flag after taken
 ICICLE=187,   -- icicle while hanging
 ICICLE_F=303, -- icicle falling
 PLANE=132,  -- plane (item)
 AVIATOR=336, -- aviator sprite (3x2)
 AVIATOR_PROP_1=339, -- propeller anim
 AVIATOR_PROP_2=340, -- propeller anim
 PLASMA=279,  -- plasma ball
 SICICLE=199,   -- stone-themed icicle,
                -- while hanging
 SICICLE_F=319, -- stone-themed icicle,
                -- while falling
 FUEL=200,      -- fuel item
 IC_FUEL=332,   -- icon for HUD
 TINY_NUM_00=480, -- "00" sprite
 TINY_NUM_50=481, -- "50" sprite
 TINY_NUM_R1=482, -- 1-10, right aligned
 
 -- food items
 FOOD={LEAF=128,A=133,B=134,C=135,D=136},
 
 SURF1=332,SURF2=333, -- water surface fx

 -- world map tiles
 WLD={
  -- tiles that player can walk on
  ROADS={13,14,15,30,31,46,47},
  -- level tiles
  LVL1=61,LVL2=62,LVL3=63,
  LVLF=79, -- finale level
  -- "cleared level" tile
  LVLC=463,
 },
 
 -- Special EIDs that don't correspond to
 -- sprites. ID must be > 512
 POP=600, -- entity that dies immediately
          -- with a particle effect
}

-- Sprite numbers also function as entity
-- IDs. For readability we write S.FOO
-- when it's a sprite but EID.FOO when
-- it identifies an entity type.
EID=S

-- anims for each entity ID
ANIM={
 [EID.EN.A]={S.EN.A,290},
 [EID.EN.B]={S.EN.B,291},
 [EID.EN.DEMON]={S.EN.DEMON,292},
 [EID.EN.SLIME]={S.EN.SLIME,295},
 [EID.EN.BAT]={S.EN.BAT,296},
 [EID.FIREBALL]={S.FIREBALL,294},
 [EID.FOOD.LEAF]={S.FOOD.LEAF,288,289},
 [EID.PFIRE]={S.PFIRE,264},
 [EID.FIRE_PWUP]={S.FIRE_PWUP,306,307},
 [EID.EN.HSLIME]={S.EN.HSLIME,297},
 [EID.SPIKE]={S.SPIKE,308},
 [EID.CHEST]={S.CHEST,309,310},
 [EID.EN.DASHER]={S.EN.DASHER,314},
 [EID.EN.VBAT]={S.EN.VBAT,298},
 [EID.SUPER_PWUP]={S.SUPER_PWUP,320,321},
 [EID.EN.SDEMON]={S.EN.SDEMON,299},
 [EID.SNOWBALL]={S.SNOWBALL,301},
 [EID.FOOD.D]={S.FOOD.D,322,323,324},
 [EID.FLAG]={S.FLAG,325},
 [EID.ICICLE]={S.ICICLE,302},
 [EID.SICICLE]={S.SICICLE,318},
 [EID.PLANE]={S.PLANE,327,328,329},
 [EID.EN.PDEMON]={S.EN.PDEMON,316},
 [EID.PLASMA]={S.PLASMA,280},
 [EID.FUEL]={S.FUEL,330,331},
 [EID.EN.FISH]={S.EN.FISH,368},
 [EID.EN.FISH2]={S.EN.FISH2,369},
}

PLANE={
 START_FUEL=2000,
 MAX_FUEL=4000,
 FUEL_INC=1000,
 FUEL_BAR_W=50
}

-- modes
M={
 BOOT=0,
 TITLE=1,    -- title screen
 TUT=2,      -- instructions
 RESTORE=3,  -- prompting to restore game
 WLD=4,      -- world map
 PREROLL=5,  -- "LEVEL X-Y" banner
 PLAY=6,
 DYING=7,    -- die anim
 EOL=8,      -- end of level
 GAMEOVER=9,
 WIN=10,     -- beat entire game
}

-- collider rects
CR={
 PLR={x=2,y=0,w=4,h=8},
 AVIATOR={x=-6,y=2,w=18,h=10},
 -- default
 DFLT={x=2,y=0,w=4,h=8},
 FULL={x=0,y=0,w=8,h=8},
 -- small projectiles
 BALL={x=2,y=2,w=3,h=3},
 -- just top rows
 TOP={x=0,y=0,w=8,h=2},
 -- player attack
 ATK={x=6,y=0,w=7,h=8},
 -- what value to use for x instead if
 -- player is flipped (facing left)
 ATK_FLIP_X=-5,
 FOOD={x=1,y=1,w=6,h=6},
}

-- max dist entity to update it
ENT_MAX_DIST=220

-- EIDs to always update regardless of
-- distance.
ALWAYS_UPDATED_EIDS={
 -- lifts need to always be updated for
 -- position determinism.
 [EID.LIFT]=true
}

-- player damage types
DMG={
 MELEE=0,      -- melee attack
 FIRE=1,       -- fire from fire powerup
 PLANE_FIRE=2, -- fire from plane
}

-- default palette
PAL={
 [0]=0x000000,  [1]=0x402434,
 [2]=0x30346d,  [3]=0x4a4a4a,
 [4]=0x854c30,  [5]=0x346524,
 [6]=0xd04648,  [7]=0x757161,
 [8]=0x34446d,  [9]=0xd27d2c,
 [10]=0x8595a1, [11]=0x6daa2c,
 [12]=0x1ce68d, [13]=0x6dc2ca,
 [14]=0xdad45e, [15]=0xdeeed6,
}

-- music tracks
BGM={A=0,B=1,EOL=2,C=3,WLD=4,TITLE=5,
 FINAL=6,WIN=7}

-- bgm for each mode (except M.PLAY, which
-- is special)
BGMM={
 [M.TITLE]=BGM.TITLE,
 [M.WLD]=BGM.WLD,
 [M.EOL]=BGM.EOL,
 [M.WIN]=BGM.WIN,
}

-- map data is organized in pages.
-- Each page is 30x17. TIC80 has 64 map
-- pages laid out as an 8x8 grid. We
-- number them in reading order, so 0
-- is top left, 63 is bottom right.

-- Level info.
-- Levels in the cart are packed
-- (RLE compressed). When a level is loaded,
-- it gets unpacked to the top 8 map pages
-- (0,0-239,16).
--  palor: palette overrides
--  pkstart: map page where packed
--    level starts.
--  pklen: length of level. Entire level
--    must be on same page row, can't
--    span multiple page rows.
LVL={
 {
  name="1-1",bg=2,
  palor={},
  pkstart=8,pklen=3,
  mus=BGM.A,
 },
 {
  name="1-2",bg=0,
  palor={[8]=0x102428},
  pkstart=11,pklen=2,
  mus=BGM.B,
 },
 {
  name="1-3",bg=2,
  pkstart=13,pklen=3,
  mus=BGM.C,
 },
 {
  name="2-1",bg=1,
  palor={[8]=0x553838},
  pkstart=16,pklen=3,
  mus=BGM.A,
  save=true,
 },
 {
  name="2-2",bg=0,
  palor={[8]=0x553838},
  pkstart=19,pklen=2,
  snow={clr=2},
  mus=BGM.B,
 },
 {
  name="2-3",bg=1,
  palor={[8]=0x553838},
  pkstart=21,pklen=3,
  mus=BGM.C,
 },
 {
  name="3-1",bg=2,
  palor={[8]=0x7171ae},
  pkstart=24,pklen=3,
  snow={clr=10},
  mus=BGM.A,
  save=true,
 },
 {
  name="3-2",bg=0,
  palor={[8]=0x3c3c50},
  pkstart=27,pklen=2,
  snow={clr=10},
  mus=BGM.B,
 },
 {
  name="3-3",bg=2,
  palor={[8]=0x7171ae},
  pkstart=29,pklen=3,
  mus=BGM.C,
 },
 {
  name="4-1",bg=2,
  palor={[2]=0x443c14,[8]=0x504410},
  pkstart=32,pklen=3,
  mus=BGM.A,
  save=true,
 },
 {
  name="4-2",bg=2,
  palor={[2]=0x443c14,[8]=0x504410},
  pkstart=35,pklen=2,
  mus=BGM.B,
 },
 {
  name="4-3",bg=2,
  palor={[2]=0x443c14,[8]=0x504410},
  pkstart=37,pklen=3,
  mus=BGM.C,
 },
 {
  name="5-1",bg=1,
  palor={[8]=0x553838},
  pkstart=40,pklen=3,
  mus=BGM.A,
  save=true,
 },
 {
  name="5-2",bg=1,
  palor={[8]=0x553838},
  pkstart=43,pklen=2,
  mus=BGM.B,
  save=false,
 },
 {
  name="5-3",bg=1,
  palor={[8]=0x553838},
  pkstart=45,pklen=3,
  mus=BGM.C,
  save=false,
 },
 {
  name="6-1",bg=0,
  palor={[8]=0x303030},
  pkstart=48,pklen=3,
  mus=BGM.FINAL,
  save=true,
  snow={clr=8},
 },
 {
  name="6-2",bg=0,
  palor={[8]=0x303030},
  pkstart=51,pklen=5,
  mus=BGM.FINAL,
  save=false,
  snow={clr=8},
 },
}

-- length of unpacked level, in cols
-- 240 means the top 8 map pages
LVL_LEN=240

-- sound specs
SND={
 KILL={sfxid=62,note=30,dur=5},
 JUMP={sfxid=61,note=30,dur=4},
 SWIM={sfxid=61,note=50,dur=3},
 ATTACK={sfxid=62,note=40,dur=4},
 POINT={sfxid=60,note=60,dur=5,speed=3},
 DIE={sfxid=63,note=18,dur=20,speed=-1},
 HURT={sfxid=63,note="C-4",dur=4},
 PWUP={sfxid=60,note=45,dur=15,speed=-2},
 ONEUP={sfxid=60,note=40,dur=60,speed=-3},
 PLANE={sfxid=59,note="C-4",dur=70,speed=-3},
 OPEN={sfxid=62,note="C-3",dur=4,speed=-2},
}

-- world map consts
WLD={
 -- foreground tile page
 FPAGE=61,
 -- background tile page
 BPAGE=62,
}

-- WLD point of interest types
POI={
 LVL=0,
}

-- settings
Sett={
 snd=true,
 mus=true
}

-- game state
Game={
 -- mode
 m=M.BOOT,
 -- ticks since mode start
 t=0,
 -- current level# we're playing
 lvlNo=0,
 lvl=nil,  -- shortcut to LVL[lvlNo]
 -- scroll offset in current level
 scr=0,
 -- auto-generated background mountains
 bgmnt=nil,
 -- snow flakes (x,y pairs). These don't
 -- change, we just shift when rendering.
 snow=nil,
 -- highest level cleared by player,
 -- -1 if no level cleared
 topLvl=-1,
}

-- world map state
Wld={
 -- points of interest (levels, etc)
 pois={},
 -- savegame start pos (maps start level
 -- to col,row)
 spos={},
 plr={
  -- start pos
  x0=-1,y0=-1,
  -- player pos, in pixels not row/col
  x=0,y=0,
  -- player move dir, if moving. Will move
  -- until plr arrives at next cell
  dx=0,dy=0,
  -- last move dir
  ldx=0,ldy=0,
  -- true iff player facing left
  flipped=false,
 }
}

-- player
Plr={} -- deep-copied from PLR_INIT_STATE
PLR_INIT_STATE={
 lives=3,
 x=0,y=0, -- current pos
 dx=0,dy=0, -- last movement
 flipped=false, -- if true, is facing left
 jmp=0, -- 0=not jumping, otherwise
        -- it's the cur jump frame
 jmpSeq=JUMP_DY, -- set during jump
 grounded=false,
 swim=false,
 -- true if plr is near surface of water
 surf=false,
 -- attack state. 0=not attacking,
 -- >0 indexes into ATK_SEQ
 atk=0,
 -- die animation frame, 0=not dying
 -- indexes into DIE_SEQ
 dying=0,
 -- nudge (movement resulting from
 -- collisions)
 nudgeX=0,nudgeY=0,
 -- if >0, has fire bamboo powerup
 -- and this is the countdown to end
 firePwup=0,
 -- if >0 player has fired bamboo.
 -- This is ticks until player can fire
 -- again.
 fireCd=0,
 -- if >0, is invulnerable for this
 -- many ticks, 0 if not invulnerable
 invuln=0,
 -- if true, has the super panda powerup
 super=false,
 -- if != 0, player is being dragged
 -- horizontally (forced to move in that
 -- direction -- >0 is right, <0 is left)
 -- The abs value is how many frames
 -- this lasts for.
 drag=0,
 -- the sign message (index) the player
 -- is currently reading.
 signMsg=0,
 -- sign cycle counter: 1 when just
 -- starting to read sign, increases.
 -- when player stops reading sign,
 -- decreases back to 0.
 signC=0,
 -- respawn pos, 0,0 if unset
 respX=-1,respY=-1,
 -- if >0, the player is on the plane
 -- and this is the fuel left (ticks).
 plane=0,
 -- current score
 score=0,
 -- for performance, we keep the
 -- stringified score ready for display
 scoreDisp={text=nil,value=-1},
 -- time (Game.t) when score last changed
 scoreMt=-999,
 -- if >0, player is blocked from moving
 -- for that many frames.
 locked=0,
}

-- max cycle counter for signs
SIGN_C_MAX=10

-- sign texts.
SIGN_MSGS={
 [0]={
  l1="Green bamboo protects",
  l2="against one enemy attack.",
 },
 [1]={
  l1="Yellow bamboo allows you to throw",
  l2="bamboo shoots (limited time).",
 },
 [2]={
  l1="Pick up leaves and food to get",
  l2="points. 10,000 = extra life.",
 },
 [4]={
  l1="Bon voyage!",
  l2="Don't run out of fuel.",
 },
}

-- entities
Ents={}

-- particles
Parts={}

-- score toasts
Toasts={}

-- animated tiles, for quick lookup
-- indexed by COLUMN.
-- Tanims[c] is a list of integers
-- indicating rows of animated tiles.
Tanims={}

function SetMode(m)
 Game.m=m
 Game.t=0
 if m~=M.PLAY and m~=M.DYING and
   m~=M.EOL then
  ResetPal()
 end
 UpdateMus()
end

function UpdateMus()
 if Game.m==M.PLAY then
  PlayMus(Game.lvl.mus)
 else
  PlayMus(BGMM[Game.m] or -1)
 end
end

function TIC()
 CheckDbgMenu()
 if Plr.dbg then
  DbgTic()
  return
 end
 Game.t=Game.t+1
 TICF[Game.m]()
end

function CheckDbgMenu()
 if not btn(6) then
  Game.dbgkc=0
  return
 end
 if btnp(0) then
  Game.dbgkc=10+(Game.dbgkc or 0)
 end
 if btnp(1) then
  Game.dbgkc=1+(Game.dbgkc or 0)
 end
 if Game.dbgkc==42 then Plr.dbg=true end
end

function Boot()
 ResetPal()
 WldInit()
 SetMode(M.TITLE)
end

-- restores default palette with
-- the given overrides.
function ResetPal(palor)
 for c=0,15 do
  local clr=PAL[c]
  if palor and palor[c] then
   clr=palor[c]
  end
  poke(0x3fc0+c*3+0,(clr>>16)&255)
  poke(0x3fc0+c*3+1,(clr>>8)&255)
  poke(0x3fc0+c*3+2,clr&255)
 end
end

function TitleTic()
 ResetPal()
 cls(2)
 local m=MapPageStart(63)
 map(m.c,m.r,30,17,0,0,0)

 spr(S.PLR.WALK1+(time()//128)%2,16,104,0)
 rect(0,0,240,24,5)
 print(NAME,88,10)
 rect(0,24,240,1,15)
 rect(0,26,240,1,5)
 rect(0,SCRH-8,SCRW,8,0)
 print("github.com/btco/panda",60,SCRH-7,7)
 
 if (time()//512)%2>0 then
  print("- PRESS 'Z' TO START -",65,84,15)
 end

 RendSpotFx(COLS//2,ROWS//2,Game.t)
 if btnp(4) then
  SetMode(M.RESTORE)
 end
end

function RestoreTic()
 local saveLvl=pmem(0) or 0
 if saveLvl<1 then
  StartGame(1)
  return
 end
 
 Game.restoreSel=Game.restoreSel or 0
 
 cls(0)
 local X=40
 local Y1=30
 local Y2=60
 print("CONTINUE (LEVEL "..
   LVL[saveLvl].name ..")",X,Y1)
 print("START NEW GAME",X,Y2)
 spr(S.PLR.STAND,X-20,
  Iif(Game.restoreSel>0,Y2,Y1))
 if btnp(0) or btnp(1) then
  Game.restoreSel=
   Iif(Game.restoreSel>0,0,1)
 elseif btnp(4) then
  StartGame(Game.restoreSel>0 and
    1 or saveLvl)
 end
end

function TutTic()
 cls(0)
 if Game.tutdone then
  StartLvl(1)
  return
 end
 local p=MapPageStart(56)
 map(p.c,p.r,COLS,ROWS)

 print("CONTROLS",100,10)
 print("JUMP",56,55);
 print("ATTACK",72,90);
 print("MOVE",160,50);
 print("10,000 PTS = EXTRA LIFE",60,110,3);

 if Game.t>150 and 0==((Game.t//16)%2) then
   print("- Press Z to continue -",60,130)
 end

 if Game.t>150 and btnp(4) then
  Game.tutdone=true
  StartLvl(1)
 end
end

function WldTic()
 WldUpdate()
 WldRend()
end

function PrerollTic()
 cls(0)
 print("LEVEL "..Game.lvl.name,100,40)
 spr(S.PLR.STAND,105,60)
 print("X " .. Plr.lives,125,60)
 if Game.t>60 then
  SetMode(M.PLAY)
 end
end

function PlayTic()
 if Plr.dbgFly then
  UpdateDbgFly()
 else
  UpdatePlr()
  UpdateEnts()
  UpdateParts()
  DetectColl()
  ApplyNudge()
  CheckEndLvl()
 end
 AdjustScroll() 
 Rend()
 if Game.m==M.PLAY then
  RendSpotFx((Plr.x-Game.scr)//C,
    Plr.y//C,Game.t)
 end
end

function EolTic()
 if Game.t>160 then
  AdvanceLvl()
  return
 end
 Rend()
 print("LEVEL CLEAR",80,20)
end

function DyingTic()
 Plr.dying=Plr.dying+1

 if Game.t>100 then
  if Plr.lives>1 then
   Plr.lives=Plr.lives-1
   SetMode(M.WLD)
  else
   SetMode(M.GAMEOVER)
  end
 else
  Rend()
 end
end

function GameOverTic()
 cls(0)
 print("GAME OVER!",92,50)
 if Game.t>150 then
  SetMode(M.TITLE)
 end
end

function WinTic()
 cls(0)
 Game.scr=0
 local m=MapPageStart(57)
 map(m.c,m.r,
   math.min(30,(Game.t-300)//8),17,0,0,0)
 print("THE END!",100,
   math.max(20,SCRH-Game.t//2))
 print("Thanks for playing!",70,
   math.max(30,120+SCRH-Game.t//2))
 
 if Game.t%100==0 then
  SpawnParts(PFX.FW,Rnd(40,SCRW-40),
   Rnd(40,SCRH-40),Rnd(2,15))
 end

 UpdateParts()
 RendParts()

 if Game.t>1200 and btnp(4) then
  SetMode(M.TITLE)
 end
end

TICF={
 [M.BOOT]=Boot,
 [M.TITLE]=TitleTic,
 [M.TUT]=TutTic,
 [M.RESTORE]=RestoreTic,
 [M.WLD]=WldTic,
 [M.PREROLL]=PrerollTic,
 [M.PLAY]=PlayTic,
 [M.DYING]=DyingTic,
 [M.GAMEOVER]=GameOverTic,
 [M.EOL]=EolTic,
 [M.WIN]=WinTic,
}

function StartGame(startLvlNo)
 Game.topLvl=startLvlNo-1
 Plr=DeepCopy(PLR_INIT_STATE)
 -- put player at the right start pos
 local sp=Wld.spos[startLvlNo] or 
   {x=Wld.plr.x0,y=Wld.plr.y0}
 Wld.plr.x=sp.x
 Wld.plr.y=sp.y
 SetMode(M.WLD)
end

function StartLvl(lvlNo)
 local oldLvlNo=Game.lvlNo
 Game.lvlNo=lvlNo
 Game.lvl=LVL[lvlNo]
 Game.scr=0
 local old=Plr
 Plr=DeepCopy(PLR_INIT_STATE)
 -- preserve lives, score
 Plr.lives=old.lives
 Plr.score=old.score
 Plr.super=old.super
 if oldLvlNo==lvlNo then
  Plr.respX=old.respX
  Plr.respY=old.respY
 end
 SetMode(M.PREROLL)
 Ents={}
 Parts={}
 Toasts={}
 Tanims={}
 UnpackLvl(lvlNo,UMODE.GAME)
 GenBgMnt()
 GenSnow()
 ResetPal(Game.lvl.palor)
 AdjustRespawnPos()
 if Game.lvl.save then
  pmem(0,Max(pmem(0) or 0,
    Game.lvlNo))
 end
end

function AdjustRespawnPos()
 if Plr.respX<0 then return end
 for i=1,#Ents do
  local e=Ents[i]
  if e.eid==EID.FLAG and e.x<Plr.respX then
   EntRepl(e,EID.FLAG_T)
  end
 end
 Plr.x=Plr.respX
 Plr.y=Plr.respY
end

-- generates background mountains.
function GenBgMnt()
 local MAX_Y=12
 local MIN_Y=2
 -- min/max countdown to change direction:
 local MIN_CD=2
 local MAX_CD=6
 Game.bgmnt={}
 RndSeed(Game.lvlNo)
 local y=Rnd(MIN_Y,MAX_Y)
 local dy=1
 local cd=Rnd(MIN_CD,MAX_CD)
 for i=1,LVL_LEN do
  Ins(Game.bgmnt,{y=y,dy=dy})
  cd=cd-1
  if cd<=0 or y+dy<MIN_Y or y+dy>MAX_Y then
   -- keep same y but change direction
   cd=Rnd(MIN_CD,MAX_CD)
   dy=-dy
  else
   y=y+dy
  end
 end
 RndSeed(time())
end

function GenSnow()
 if not Game.lvl.snow then
  Game.snow=nil
  return
 end
 Game.snow={}
 for r=0,ROWS-1,2 do
  for c=0,COLS-1,2 do
   Ins(Game.snow,{
    x=c*C+Rnd(-8,8),
    y=r*C+Rnd(-8,8)
   })
  end
 end
end

-- Whether player is on solid ground.
function IsOnGround()
 return not CanMove(Plr.x,Plr.y+1)
end

-- Get level tile at given point
function LvlTileAtPt(x,y)
 return LvlTile(x//C,y//C)
end

-- Get level tile.
function LvlTile(c,r)
 if c<0 or c>=LVL_LEN then return 0 end
 if r<0 then return 0 end
 -- bottom-most tile repeats infinitely
 -- below (to allow player to swim
 -- when bottom tile is water).
 if r>=ROWS then r=ROWS-1 end
 return mget(c,r)
end

function SetLvlTile(c,r,t)
 if c<0 or c>=LVL_LEN then return false end
 if r<0 or r>=ROWS then return false end
 mset(c,r,t)
end

function UpdatePlr()
 local oldx=Plr.x
 local oldy=Plr.y

 Plr.plane=Max(Plr.plane-1,0)
 Plr.fireCd=Max(Plr.fireCd-1,0)
 Plr.firePwup=Max(Plr.firePwup-1,0)
 Plr.invuln=Max(Plr.invuln-1,0)
 Plr.drag=Iif2(Plr.drag>0,Plr.drag-1,
   Plr.drag<0,Plr.drag+1,0)
 Plr.signC=Max(Plr.signC-1,0)
 Plr.locked=Max(Plr.locked-1,0)
 UpdateSwimState()
 
 local swimmod=Plr.swim and Game.t%2 or 0

 if (Plr.plane==0 and Plr.jmp==0 and
   not IsOnGround()) then
  -- fall
  Plr.y=Plr.y+1-swimmod
 end
 
 -- check if player fell into pit
 if Plr.y>SCRH+8 then
  StartDying()
  return
 end

 -- horizontal movement
 local dx=0
 local dy=0
 local wantLeft=Plr.locked==0 and
   Iif(Plr.drag==0,btn(2),Plr.drag<0)
 local wantRight=Plr.locked==0 and
   Iif(Plr.drag==0,btn(3),Plr.drag>0)
 local wantJmp=Plr.locked==0 and
   Plr.plane==0 and btnp(4) and Plr.drag==0
 local wantAtk=Plr.locked==0 and
   btnp(5) and Plr.drag==0

 if wantLeft then
  dx=-1+swimmod
  -- plane doesn't flip
  Plr.flipped=true
 elseif wantRight then
  dx=1-swimmod
  Plr.flipped=false
 end

 -- vertical movement (plane only)
 dy=dy+Iif2(Plr.plane>0 and btn(0) and
   Plr.y>8,-1,
   Plr.plane>0 and btn(1) and
   Plr.y<SCRH-16,1,0)

 -- is player flipped (facing left?)
 Plr.flipped=Iif3(
   Plr.plane>0,false,btn(2),true,
   btn(3),false,Plr.flipped)

 TryMoveBy(dx,dy)
 
 Plr.grounded=Plr.plane==0 and IsOnGround()
 
 local canJmp=Plr.grounded or Plr.swim
 -- jump
 if wantJmp and canJmp then
  Plr.jmp=1
  Plr.jmpSeq=Plr.surf and
    RESURF_DY or
    (Plr.swim and SWIM_JUMP_DY or
    JUMP_DY)
  Snd(Plr.surf and SND.JUMP or
    Plr.swim and SND.SWIM or SND.JUMP)
  -- TODO play swim snd if swim
 end

 if Plr.jmp>#Plr.jmpSeq then
  -- end jump
  Plr.jmp=0
 elseif Plr.jmp>0 then
  local ok=TryMoveBy(
    0,Plr.jmpSeq[Plr.jmp])
  -- if blocked, cancel jump
  Plr.jmp=ok and Plr.jmp+1 or 0
 end
 
 -- attack
 if Plr.atk==0 then
  if wantAtk then
   -- start attack sequence
   if Plr.plane==0 then Plr.atk=1 end
   Snd(SND.ATTACK)
   TryFire()
  end
 elseif Plr.atk>#ATK_SEQ then
  -- end of attack sequence
  Plr.atk=0
 else
  -- advance attack sequence
  Plr.atk=Plr.atk+1
 end

 -- check plane landing
 if Plr.plane>0 then CheckTarmac() end

 Plr.dx=Plr.x-oldx
 Plr.dy=Plr.y-oldy
end

function IsWater(t)
 return t==T.WATER or t==T.SURF or
   t==T.WFALL
end

function UpdateSwimState()
 local wtop=IsWater(
   LvlTileAtPt(Plr.x+4,Plr.y+1))
 local wbottom=IsWater(
   LvlTileAtPt(Plr.x+4,Plr.y+7))
 local wtop2=IsWater(
   LvlTileAtPt(Plr.x+4,Plr.y-8))
 Plr.swim=wtop and wbottom
 -- is plr near surface?
 Plr.surf=wbottom and not wtop2
end

function UpdateDbgFly()
 local d=Iif(btn(4),5,1)
 if btn(0) then Plr.y=Plr.y-d end
 if btn(1) then Plr.y=Plr.y+d end
 if btn(2) then Plr.x=Plr.x-d end
 if btn(3) then Plr.x=Plr.x+d end
 if btn(5) then Plr.dbgFly=false end
end

function TryFire()
 if Plr.firePwup<1 and Plr.plane==0 then
  return
 end
 if Plr.fireCd>0 then return end
 Plr.fireCd=FIRE.INTERVAL
 local x=Plr.x
 if Plr.plane==0 then
  x=x+(Plr.flipped and
    FIRE.OFFX_FLIP or FIRE.OFFX)
 else
  -- end of plane
  x=x+FIRE.OFFX_PLANE
 end
 local y=Plr.y+Iif(Plr.plane>0,
   FIRE.OFFY_PLANE,FIRE.OFFY)
 local e=EntAdd(EID.PFIRE,x,y)
 e.moveDx=Plr.plane>0 and 2 or
   (Plr.flipped and -1 or 1)
 e.ttl=Plr.plane>0 and e.ttl//2 or e.ttl
end

function ApplyNudge()
 Plr.y=Plr.y+Plr.nudgeY
 Plr.x=Plr.x+Plr.nudgeX
 Plr.nudgeX=0
 Plr.nudgeY=0
end

function TryMoveBy(dx,dy)
 if CanMove(Plr.x+dx,Plr.y+dy) then
  Plr.x=Plr.x+dx
  Plr.y=Plr.y+dy
  return true
 end
 return false
end

function GetPlrCr()
 return Iif(Plr.plane>0,CR.AVIATOR,CR.PLR)
end

-- Check if plr can move to given pos.
function CanMove(x,y)
 local dy=y-Plr.y
 local pcr=GetPlrCr()
 local r=CanMoveEx(x,y,pcr,dy)
 if not r then return false end

 -- check if would bump into solid ent
 local pr=RectXLate(pcr,x,y)
 for i=1,#Ents do
  local e=Ents[i]
  local effSolid=(e.sol==SOL.FULL) or
   (e.sol==SOL.HALF and dy>0 and
   Plr.y+5<e.y) -- (HACK)
  if effSolid then
   local er=RectXLate(e.coll,e.x,e.y)
   if RectIsct(pr,er) then
    return false
   end
  end
 end
 return true
end

function EntCanMove(e,x,y)
 return CanMoveEx(x,y,e.coll,y-e.y)
end

function GetTileSol(t)
 local s=TSOL[t]
 -- see if an override is present.
 if s~=nil then return s end
 -- default:
 return Iif(t>=T.FIRST_DECO,SOL.NOT,SOL.FULL)
end

-- x,y: candidate pos; cr: collision rect
-- dy: y direction of movement
function CanMoveEx(x,y,cr,dy)
 local x1=x+cr.x
 local y1=y+cr.y
 local x2=x1+cr.w-1
 local y2=y1+cr.h-1
 -- check all tiles touched by the rect
 local startC=x1//C
 local endC=x2//C
 local startR=y1//C
 local endR=y2//C
 for c=startC,endC do
  for r=startR,endR do
   local sol=GetTileSol(LvlTile(c,r))
   if sol==SOL.FULL then return false end
  end
 end

 -- special case: check for half-solidity
 -- tiles. Only solid when standing on
 -- top of them (y2%C==0) and going
 -- down (dy>0).
 local sA=GetTileSol(LvlTileAtPt(x1,y2))
 local sB=GetTileSol(LvlTileAtPt(x2,y2))
 if dy>0 and (sA==SOL.HALF or
   sB==SOL.HALF) and
   y2%C==0 then return false end
 
 return true
end

function EntWouldFall(e,x)
 return EntCanMove(e,x,e.y+1)
end

-- check if player landed plane on tarmac
function CheckTarmac()
 local pr=RectXLate(
   CR.AVIATOR,Plr.x,Plr.y)
 local bottom=pr.y+pr.h+1
 local t1=LvlTileAtPt(pr.x,bottom)
 local t2=LvlTileAtPt(pr.x+pr.w,bottom)
 if t1==T.TARMAC and t2==T.TARMAC then
  -- landed
  Plr.plane=0
  SpawnParts(PFX.POP,Plr.x+4,Plr.y,14)
  -- TODO: more vfx, sfx
 end
end

function AdjustScroll()
 local dispx=Plr.x-Game.scr
 if dispx>SX_MAX then
  Game.scr=Plr.x-SX_MAX
 elseif dispx<SX_MIN then
  Game.scr=Plr.x-SX_MIN
 end
end

function AddToast(points,x,y)
 local rem=points%100
 if points>1000 or (rem~=50 and rem~=0) then
  return
 end
 local sp2=rem==50 and S.TINY_NUM_50 or
   S.TINY_NUM_00
 local sp1=points>=100 and 
   (S.TINY_NUM_R1-1+points//100) or 0
 Ins(Toasts,{
    x=Iif(points>=100,x-8,x-12),
    y=y,ttl=40,sp1=sp1,sp2=sp2})
end

-- tx,ty: position where to show toast
-- (optional)
function AddScore(points,tx,ty)
 local old=Plr.score
 Plr.score=Plr.score+points
 Plr.scoreMt=Game.t
 if (old//10000)<(Plr.score//10000) then
  Snd(SND.ONEUP)
  Plr.lives=Plr.lives+1
  -- TODO: vfx
 else
  Snd(SND.POINT)
 end
 if tx and ty then
  AddToast(points,tx,ty)
 end
end

function StartDying()
 SetMode(M.DYING)
 Snd(SND.DIE)
 Plr.dying=1 -- start die anim
 Plr.super=false
 Plr.firePwup=0
 Plr.plane=0
end

function EntAdd(newEid,newX,newY)
 local e={
  eid=newEid,
  x=newX,
  y=newY
 }
 Ins(Ents,e)
 EntInit(e)
 return e
end

function EntInit(e)
 -- check if we have an animation for it
 if ANIM[e.eid] then
  e.anim=ANIM[e.eid]
  e.sprite=e.anim[1]
 else
  -- default to static sprite image
  e.sprite=e.eid
 end
 -- whether ent sprite is flipped
 e.flipped=false
 -- collider rect
 e.coll=CR.DFLT
 -- solidity (defaults to not solid)
 e.sol=SOL.NOT
 -- EBT entry
 local ebte=EBT[e.eid]
 -- behaviors
 e.beh=ebte and ebte.beh or {}
 -- copy initial behavior data to entity
 for _,b in pairs(e.beh) do
  ShallowMerge(e,b.data)
 end
 -- overlay the entity-defined data.
 if ebte and ebte.data then
  ShallowMerge(e,ebte.data)
 end
 -- call the entity init funcs
 for _,b in pairs(e.beh) do
  if b.init then b.init(e) end
 end
end

function EntRepl(e,eid,data)
 e.dead=true
 local newE=EntAdd(eid,e.x,e.y)
 if data then
  ShallowMerge(newE,data)
 end
end

function EntHasBeh(e,soughtBeh)
 for _,b in pairs(e.beh) do
  if b==soughtBeh then return true end
 end
 return false
end

function EntAddBeh(e,beh)
 if EntHasBeh(e,beh) then return end
 -- note: can't mutate the original
 -- e.beh because it's a shared ref.
 e.beh=DeepCopy(e.beh)
 ShallowMerge(e,beh.data,true)
 Ins(e.beh,beh)
end

function UpdateEnts()
 -- iterate backwards so we can delete
 for i=#Ents,1,-1 do
  local e=Ents[i]
  UpdateEnt(e)
  if e.dead then
   -- delete
   Rem(Ents,i)
  end  
 end
end

function UpdateEnt(e)
 if not ALWAYS_UPDATED_EIDS[e.eid] and
   Abs(e.x-Plr.x)>ENT_MAX_DIST then
  -- too far, don't update
  return
 end
 -- update anim frame
 if e.anim then
  e.sprite=e.anim[1+(time()//128)%#e.anim]  
 end
 -- run update behaviors
 for _,b in pairs(e.beh) do
  if b.update then b.update(e) end
 end
end

function GetEntAt(x,y)
 for i=1,#Ents do
  local e=Ents[i]
  if e.x==x and e.y==y then return e end
 end
 return nil
end

-- detect collisions
function DetectColl()
 -- player rect
 local pr=RectXLate(GetPlrCr(),
  Plr.x,Plr.y)
  
 -- attack rect
 local ar=nil
 if ATK_SEQ[Plr.atk]==2 then
  -- player is attacking, so check if
  -- entity was hit by attack
  ar=RectXLate(CR.ATK,Plr.x,Plr.y)
  if Plr.flipped then
   ar.x=Plr.x+CR.ATK_FLIP_X
  end
 end

 for i=1,#Ents do
  local e=Ents[i]
  local er=RectXLate(e.coll,e.x,e.y)
  if RectIsct(pr,er) then
   -- collision between player and ent
   HandlePlrColl(e)
  elseif ar and RectIsct(ar,er) then
   -- ent hit by player attack
   HandleDamage(e,DMG.MELEE)
  end
 end
end

function CheckEndLvl()
 local t=LvlTileAtPt(
   Plr.x+C//2,Plr.y+C//2)
 if t==T.GATE_L or t==T.GATE_R or
    t==T.GATE_L2 or t==T.GATE_R2 then
  EndLvl()
 end
end

function EndLvl()
 Game.topLvl=Max(
   Game.topLvl,Game.lvlNo)
 SetMode(M.EOL)
end

function AdvanceLvl()
 if Game.lvlNo>=#LVL then
  -- end of game.
  SetMode(M.WIN)
 else
  -- go back to map.
  SetMode(M.WLD)
 end
end

-- handle collision w/ given ent
function HandlePlrColl(e)
 for _,b in pairs(e.beh) do
  if b.coll then b.coll(e) end
  if e.dead then break end
 end
end

function HandleDamage(e,dtype)
 for _,b in pairs(e.beh) do
  if b.dmg then b.dmg(e,dtype) end
  if e.dead then
   SpawnParts(PFX.POP,e.x+4,e.y+4,e.clr)
   Snd(SND.KILL)
   break
  end
 end
end

function HandlePlrHurt()
 if Plr.invuln>0 then return end
 if Plr.plane==0 and Plr.super then
  Snd(SND.HURT)
  Plr.super=false
  Plr.invuln=100
  Plr.drag=Iif(Plr.dx>=0,-10,10)
  Plr.jmp=0
 else
  StartDying()
 end
end

function Snd(spec)
 if not Sett.snd then return end
 sfx(spec.sfxid,spec.note,spec.dur,
   0,spec.vol or 15,spec.speed or 0)
end

function PlayMus(musid)
 if Sett.mus or musid==-1 then
  music(musid)
 end
end


---------------------------------------
-- PARTICLES
---------------------------------------

-- possible effects
PFX={
 POP={
  rad=4,
  count=15,
  speed=4,
  fall=true,
  ttl=15
 },
 FW={ -- fireworks
  rad=3,
  count=40,
  speed=1,
  fall=false,
  ttl=100
 }
}

-- fx=one of the effects in PFX
-- cx,cy=center, clr=the color
function SpawnParts(fx,cx,cy,clr)
 for i=1,fx.count do
  local r=Rnd01()*fx.rad
  local phi=Rnd01()*math.pi*2
  local part={
   x=cx+r*Cos(phi),
   y=cy+r*Sin(phi),
   vx=fx.speed*Cos(phi),
   vy=fx.speed*Sin(phi),
   fall=fx.fall,
   ttl=fx.ttl,
   age=0,
   clr=clr
  }
  Ins(Parts,part)
 end
end

function UpdateParts()
 -- iterate backwards so we can delete
 for i=#Parts,1,-1 do
  local p=Parts[i]
  p.age=p.age+1
  if p.age>=p.ttl then
   -- delete
   Rem(Parts,i)
  else
   p.x=p.x+p.vx
   p.y=p.y+p.vy+(p.fall and p.age//2 or 0)
  end
 end
end

function RendParts()
 for i,p in pairs(Parts) do
  pix(p.x-Game.scr,p.y,p.clr)
 end
end

---------------------------------------
-- WLD MAP
---------------------------------------
-- convert "World W-L" into index
function Wl(w,l) return (w-1)*3+l end

-- Init world (runs once at start of app).
function WldInit()
 for r=0,ROWS-1 do
  for c=0,COLS-1 do
   local t=WldFgTile(c,r)
   local lval=WldLvlVal(t)
   if t==T.META_A then
    -- player start pos
    Wld.plr.x0=c*C
    Wld.plr.y0=(r-1)*C
   elseif t==T.META_B then
    local mv=WldGetTag(c,r)
    -- savegame start pos
    Wld.spos[Wl(mv,1)]={
      x=c*C,y=(r-1)*C}
   elseif lval>0 then
    local mv=WldGetTag(c,r)
    -- It's a level tile.
    local poi={c=c,r=r,
     t=POI.LVL,lvl=Wl(mv,lval)}
    Ins(Wld.pois,poi)
   end
  end
 end
end

-- Looks around tc,tr for a numeric tag.
function WldGetTag(tc,tr)
 for r=tr-1,tr+1 do
  for c=tc-1,tc+1 do
   local mv=MetaVal(WldFgTile(c,r),0)
   if mv>0 then
    return mv
   end
  end
 end
 trace("No WLD tag @"..tc..","..tr)
 return 0
end

-- Returns the value (1, 2, 3) of a WLD
-- level tile.
function WldLvlVal(t)
 return Iif4(t==S.WLD.LVLF,1,
   t==S.WLD.LVL1,1,
   t==S.WLD.LVL2,2,
   t==S.WLD.LVL3,3,0)
end

function WldFgTile(c,r)
 return MapPageTile(WLD.FPAGE,c,r)
end

function WldBgTile(c,r)
 return MapPageTile(WLD.BPAGE,c,r)
end

function WldPoiAt(c,r)
 for i=1,#Wld.pois do
  local poi=Wld.pois[i]
  if poi.c==c and poi.r==r then
   return poi
  end
 end
 return nil
end

function WldHasRoadAt(c,r)
 local t=WldFgTile(c,r)
 for i=1,#S.WLD.ROADS do
  if S.WLD.ROADS[i]==t then
   return true
  end
 end
 return false
end

function WldUpdate()
 local p=Wld.plr  -- shorthand

 if p.dx~=0 or p.dy~=0 then
  -- Just move.
  p.x=p.x+p.dx
  p.y=p.y+p.dy
  if p.x%C==0 and p.y%C==0 then
   -- reached destination.
   p.ldx=p.dx
   p.ldy=p.dy
   p.dx=0
   p.dy=0
  end
  return
 end

 if btn(0) then WldTryMove(0,-1) end
 if btn(1) then WldTryMove(0,1) end
 if btn(2) then WldTryMove(-1,0) end
 if btn(3) then WldTryMove(1,0) end

 Wld.plr.flipped=Iif(
   Iif(Wld.plr.flipped,btn(3),btn(2)),
   not Wld.plr.flipped,
   Wld.plr.flipped) -- wtf

 if btnp(4) then
  local poi=WldPoiAt(p.x//C,p.y//C)
  if poi and poi.lvl>Game.topLvl then
   if poi.lvl==1 then
    SetMode(M.TUT)
   else
    StartLvl(poi.lvl)
   end
  end
 end
end

function WldTryMove(dx,dy)
 local p=Wld.plr  -- shorthand

 -- if we are in locked POI, we can only
 -- come back the way we came.
 local poi=WldPoiAt(p.x//C,p.y//C)
 if not Plr.dbgFly and poi and
   poi.lvl>Game.topLvl and
   (dx ~= -p.ldx or dy ~= -p.ldy) then
  return 
 end

 -- target row,col
 local tc=p.x//C+dx
 local tr=p.y//C+dy
 if WldHasRoadAt(tc,tr) or
    WldPoiAt(tc,tr) then
  -- Destination is a road or level.
  -- Move is valid.
  p.dx=dx
  p.dy=dy
  return
 end
end

function WldFgRemapFunc(t)
 return t<T.FIRST_META and t or 0 
end

function WldRend()
 if Game.m~=M.WLD then return end
 cls(2)
 rect(0,SCRH-8,SCRW,8,0)
 local fp=MapPageStart(WLD.FPAGE)
 local bp=MapPageStart(WLD.BPAGE)
 -- render map bg
 map(bp.c,bp.r,COLS,ROWS,0,0,0,1)
 -- render map fg, excluding markers
 map(fp.c,fp.r,COLS,ROWS,0,0,0,1,
   WldFgRemapFunc)

 -- render the "off" version of level
 -- tiles on top of cleared levels.
 for _,poi in pairs(Wld.pois) do
  if poi.lvl<=Game.topLvl then
   spr(S.WLD.LVLC,poi.c*C,poi.r*C,0)
  end
 end

 print("SELECT LEVEL TO PLAY",
   70,10)
 print("= MOVE",34,SCRH-6)
 print("= ENTER LEVEL",98,SCRH-6)

 RendSpotFx(Wld.plr.x//C,
   Wld.plr.y//C,Game.t)
 if 0==(Game.t//16)%2 then
  rectb(Wld.plr.x-3,Wld.plr.y-3,13,13,15)
 end
 spr(S.PLR.STAND,Wld.plr.x,Wld.plr.y,0,
   1,Wld.plr.flipped and 1 or 0)
 RendHud()
end

---------------------------------------
-- LEVEL UNPACKING
---------------------------------------
-- unpack modes
UMODE={
 GAME=0, -- unpack for gameplay
 EDIT=1, -- unpack for editing
}

function MapPageStart(pageNo)
 return {c=(pageNo%8)*30,r=(pageNo//8)*17} 
end

function MapPageTile(pageNo,c,r,newVal)
 local pstart=MapPageStart(pageNo)
 if newVal then
  mset(c+pstart.c,r+pstart.r,newVal)
 end
 return mget(c+pstart.c,r+pstart.r)
end

-- Unpacked level is written to top 8
-- map pages (cells 0,0-239,16).
function UnpackLvl(lvlNo,mode)
 local lvl=LVL[lvlNo]
 local start=MapPageStart(lvl.pkstart)
 local offc=start.c
 local offr=start.r
 local len=lvl.pklen*30
 local endc=FindLvlEndCol(offc,offr,len)

 MapClear(0,0,LVL_LEN,ROWS)
 
 -- next output col
 local outc=0
 
 -- for each col in packed map
 for c=offc,endc do
  local cmd=mget(c,offr)
  local copies=MetaVal(cmd,1)
  -- create that many copies of this col
  for i=1,copies do
   CreateCol(c,outc,offr,mode==UMODE.GAME)
   -- advance output col
   outc=outc+1
   if outc>=LVL_LEN then
    trace("ERROR: level too long: "..lvlNo)
    return
   end
  end
 end

 -- if in gameplay, expand patterns and
 -- remove special markers
 -- (first META_A is player start pos)
 if mode==UMODE.GAME then
  for c=0,LVL_LEN-1 do
   for r=0,ROWS-1 do
    local t=mget(c,r)
    local tpat=TPAT[t]
    if tpat then ExpandTpat(tpat,c,r) end
    if Plr.x==0 and Plr.y==0 and
      t==T.META_A then
     -- player start position.
     Plr.x=c*C
     Plr.y=r*C
    end
    if t>=T.FIRST_META then
     mset(c,r,0)
    end
   end
  end
  if Plr.x==0 and Plr.y==0 then
   trace("*** start pos UNSET L"..lvlNo)
  end
  FillWater()
  SetUpTanims()
 end
end

-- expand tile pattern at c,r
function ExpandTpat(tpat,c,r)
 local s=mget(c,r)
 for i=0,tpat.w-1 do
  for j=0,tpat.h-1 do
   mset(c+i,r+j,s+j*16+i)
  end
 end
end

-- Sets up tile animations.
function SetUpTanims()
 for c=0,LVL_LEN-1 do
  for r=0,ROWS-1 do
   local t=mget(c,r)
   if TANIM[t] then
    TanimAdd(c,r)
   end
  end
 end
end

function FindLvlEndCol(c0,r0,len)
 -- iterate backwards until we find a
 -- non-empty col.
 for c=c0+len-1,c0,-1 do
  for r=r0,r0+ROWS-1 do
   if mget(c,r)>0 then
    -- rightmost non empty col
    return c
   end
  end
 end
 return c0
end

function FillWater()
 -- We fill downward from surface tiles,
 -- Downward AND upward from water tiles.
 local surfs={}  -- surface tiles
 local waters={} -- water tiles
 for c=LVL_LEN-1,0,-1 do
  for r=ROWS-1,0,-1 do
   if mget(c,r)==T.SURF then
    Ins(surfs,{c=c,r=r})
   elseif mget(c,r)==T.WATER then
    Ins(waters,{c=c,r=r})
   end
  end
 end
 
 for i=1,#surfs do
  local s=surfs[i]
  -- fill water below this tile
  FillWaterAt(s.c,s.r,1)
 end
 for i=1,#waters do
  local s=waters[i]
  -- fill water above AND below this tile
  FillWaterAt(s.c,s.r,-1)
  FillWaterAt(s.c,s.r,1)
 end
end

-- Fill water starting (but not including)
-- given tile, in the given direction
-- (1:down, -1:up)
function FillWaterAt(c,r0,dir)
 local from=r0+dir
 local to=Iif(dir>0,ROWS-1,0)
 for r=from,to,dir do
  if mget(c,r)==T.EMPTY then
   mset(c,r,T.WATER)
  else
   return
  end
 end
end

function TanimAdd(c,r)
 if Tanims[c] then
  Ins(Tanims[c],r)
 else
  Tanims[c]={r}
 end
end

-- pack lvl from 0,0-239,16 to the packed
-- level area of the indicated level
function PackLvl(lvlNo)
 local lvl=LVL[lvlNo]
 local start=MapPageStart(lvl.pkstart)
 local outc=start.c
 local outr=start.r
 local len=lvl.pklen*30
 
 local endc=FindLvlEndCol(0,0,LVL_LEN)
  
 -- pack
 local reps=0
 MapClear(outc,outr,len,ROWS)
 for c=0,endc do
  if c>0 and MapColsEqual(c,c-1,0) and
    reps<12 then
   -- increment repeat marker on prev col
   local m=mget(outc-1,outr)  
   m=Iif(m==0,T.META_NUM_0+2,m+1)
   mset(outc-1,outr,m)
   reps=reps+1
  else
   reps=1
   -- copy col to packed level
   MapCopy(c,0,outc,outr,1,ROWS)
   outc=outc+1
   if outc>=start.c+len then
    trace("Capacity exceeded.")
    return false
   end
  end
 end
 trace("packed "..(endc+1).." -> "..
  (outc+1-start.c))
 return true
end

-- Create map col (dstc,0)-(dstc,ROWS-1)
-- from source col located at
-- (srcc,offr)-(srcc,offr+ROWS-1).
-- if ie, instantiates entities.
function CreateCol(srcc,dstc,offr,ie)
 -- copy entire column first
 MapCopy(srcc,offr,dstc,0,1,ROWS)
 mset(dstc,0,T.EMPTY) -- top cell is empty
 if not ie then return end
 -- instantiate entities
 for r=1,ROWS-1 do
  local t=mget(dstc,r)
  if t>=T.FIRST_ENT and EBT[t] then
   -- entity tile: create entity
   mset(dstc,r,T.EMPTY)
   EntAdd(t,dstc*C,r*C)
  end
 end
end

---------------------------------------
-- RENDERING
---------------------------------------

function Rend()
 RendBg()
 if Game.snow then RendSnow() end
 RendMap()
 RendTanims()
 RendEnts()
 RendToasts()
 if Game.m==M.EOL then RendScrim() end
 RendPlr()
 RendParts()
 RendHud()
 RendSign()
end

function RendBg()
 local END_R=ROWS
 cls(Game.lvl.bg)
 local offset=Game.scr//2+50
 -- If i is a col# of mountains (starting
 -- at index 1), then its screen pos
 -- sx=(i-1)*C-off
 -- Solving for i, i=1+(sx+off)/C
 -- so at the left of screen, sx=0, we
 -- have i=1+off/C
 local startI=Max(1,1+offset//C)
 local endI=Min(
   startI+COLS,#Game.bgmnt)
 for i=startI,endI do
  local sx=(i-1)*C-offset
  local part=Game.bgmnt[i]
  for r=part.y,END_R do
   local spid=Iif(r==part.y,
    S.BGMNT.DIAG,S.BGMNT.FULL)
   spr(spid,(i-1)*C-offset,r*C,0,1,
    Iif(part.dy>0,1,0))
  end
 end
end

function RendSnow()
 local dx=-Game.scr
 local dy=Game.t//2
 for _,p in pairs(Game.snow) do
  local sx=((p.x+dx)%SCRW+SCRW)%SCRW
  local sy=((p.y+dy)%SCRH+SCRH)%SCRH
  pix(sx,sy,Game.lvl.snow.clr)
 end
end

function RendToasts()
 for i=#Toasts,1,-1 do
  local t=Toasts[i]
  t.ttl=t.ttl-1
  if t.ttl<=0 then
   Toasts[i]=Toasts[#Toasts]
   Rem(Toasts)
  else
   t.y=t.y-1
   spr(t.sp1,t.x-Game.scr,t.y,0)
   spr(t.sp2,t.x-Game.scr+C,t.y,0)
  end
 end
end

function RendMap()
 -- col c is rendered at
 --   sx=-Game.scr+c*C
 -- Setting sx=0 and solving for c
 --   c=Game.scr//C
 local c=Game.scr//C
 local sx=-Game.scr+c*C
 local w=Min(COLS+1,LVL_LEN-c)
 if c<0 then
  sx=sx+C*(-c)
  c=0
 end
 map(
  -- col,row,w,h
  c,0,w,ROWS,
  -- sx,sy,colorkey,scale
  sx,0,0,1)
end

function RendPlr()
 local spid
 local walking=false

 if Plr.plane>0 then
  RendPlane()
  return
 end

 if Plr.dying>0 then
  spid=S.PLR.DIE
 elseif Plr.atk>0 then
  spid=
    ATK_SEQ[Plr.atk]==1 and S.PLR.SWING
    or S.PLR.HIT
 elseif Plr.grounded then
  if btn(2) or btn(3) then
   spid=S.PLR.WALK1+time()%2
   walking=true
  else
   spid=S.PLR.STAND
  end
 elseif Plr.swim then
  spid=S.PLR.SWIM1+(Game.t//4)%2
 else
  spid=S.PLR.JUMP
 end 
 
 local sx=Plr.x-Game.scr
 local sy=Plr.y
 local flip=Plr.flipped and 1 or 0
 
 -- apply dying animation
 if spid==S.PLR.DIE then
  if Plr.dying<=#DIE_SEQ then
   sx=sx+DIE_SEQ[Plr.dying][1]
   sy=sy+DIE_SEQ[Plr.dying][2]
  else
   sx=-1000
   sy=-1000
  end
 end

 -- if invulnerable, blink
 if Plr.invuln>0 and
   0==(Game.t//4)%2 then return end
 
 spr(spid,sx,sy,0,1,flip)
 
 -- extra sprite for attack states
 if spid==S.PLR.SWING then
  spr(S.PLR.SWING_C,sx,sy-C,0,1,flip)
 elseif spid==S.PLR.HIT then
  spr(S.PLR.HIT_C,
    sx+(Plr.flipped and -C or C),
    sy,0,1,flip)
 end

 -- draw super panda overlay if player
 -- has the super panda powerup
 if Plr.super then
  local osp=Iif3(Plr.atk>0,S.PLR.SUPER_F,
   Plr.swim and not Plr.grounded,
   S.PLR.SUPER_S,
   walking,S.PLR.SUPER_P,S.PLR.SUPER_F)
  spr(osp,sx,Plr.y,0,1,flip)
 end

 -- draw overlays (blinking bamboo and
 -- yellow body) if powerup
 if spid~=S.PLR.SWING and Plr.firePwup>0
   and (time()//128)%2==0 then
  spr(S.PLR.FIRE_BAMBOO,sx,Plr.y,0,1,flip)
 end
 if Plr.firePwup>100 or 
    1==(Plr.firePwup//16)%2 then
  local osp=Iif3(Plr.atk>0,S.PLR.FIRE_F,
   Plr.swim and not Plr.grounded,
   S.PLR.FIRE_S,
   walking,S.PLR.FIRE_P,S.PLR.FIRE_F)
  spr(osp,sx,Plr.y,0,1,flip)
 end

 -- if just respawned, highlight player
 if Game.m==M.PLAY and Plr.dying==0 and
   Plr.respX>=0 and Game.t<100 and
   (Game.t//8)%2==0 then
  rectb(Plr.x-Game.scr-2,Plr.y-2,
    C+4,C+4,15)
 end
end

function RendPlane()
 local ybias=(Game.t//8)%2==0 and 1 or 0

 local sx=Plr.x-Game.scr
 spr(S.AVIATOR,
   sx-C,Plr.y+ybias,0,1,0,0,3,2)
 local spid=(Game.t//4)%2==0 and
   S.AVIATOR_PROP_1 or S.AVIATOR_PROP_2
 spr(spid,sx+C,
   Plr.y+ybias+4,0)
end

function RendHud()
 rect(0,0,SCRW,C,3)

 if Plr.scoreDisp.value~=Plr.score then
  Plr.scoreDisp.value=Plr.score
  Plr.scoreDisp.text=Lpad(Plr.score,6)
 end

 local clr=15

 print(Plr.scoreDisp.text,192,1,clr,true)
 print((Game.m==M.WLD and
   "WORLD MAP" or
   ("LEVEL "..Game.lvl.name)),95,1,7)
 spr(S.PLR.STAND,5,0,0)
 print("x "..Plr.lives,16,1)

 if Plr.plane>0 then
  local barw=PLANE.FUEL_BAR_W
  local lx=120-barw//2
  local y=8
  local clr=(Plr.plane<800 and
    (Game.t//16)%2==0) and 6 or 14
  local clrLo=(clr==14 and 4 or clr)
  print("E",lx-7,y,clr)
  print("F",lx+barw+1,y,14)
  rectb(lx,y,barw,6,clrLo)
  local bw=Plr.plane*
    (PLANE.FUEL_BAR_W-2)//PLANE.MAX_FUEL
  rect(lx+1,y+1,Max(bw,1),4,clr)
  pix(lx+barw//4,y+4,clrLo)
  pix(lx+barw//2,y+4,clrLo)
  pix(lx+barw//2,y+3,clrLo)
  pix(lx+3*barw//4,y+4,clrLo)
 end
end

function RendEnts()
 for i=1,#Ents do
  local e=Ents[i]
  local sx=e.x-Game.scr
  if sx>-C and sx<SCRW then
   spr(e.sprite,sx,e.y,0,1,
     e.flipped and 1 or 0)
  end
 end
end

function RendScrim(sp)
 sp=sp or Iif3(Game.t>45,0,
  Game.t>30,S.SCRIM+2,
  Game.t>15,S.SCRIM+1,
  S.SCRIM)
 for r=0,ROWS-1 do
  for c=0,COLS-1 do
   spr(sp,c*C,r*C,15)
  end
 end
end

-- Render spotlight effect.
-- fc,fr: cell at center of effect
-- t: clock (ticks)
function RendSpotFx(fc,fr,t)
 local rad=Max(0,t//2-2) -- radius
 if rad>COLS then return end
 for r=0,ROWS-1 do
  for c=0,COLS-1 do
   local d=Max(Abs(fc-c),
     Abs(fr-r))
   local sa=d-rad  -- scrim amount
   local spid=Iif2(sa<=0,-1,sa<=3,
     S.SCRIM+sa-1,0)
   if spid>=0 then
    spr(spid,c*C,r*C,15)
   end
  end
 end
end

function RendSign()
 if 0==Plr.signC then return end
 local w=Plr.signC*20
 local h=Plr.signC*3
 local x=SCRW//2-w//2
 local y=SCRH//2-h//2-20
 local s=SIGN_MSGS[Plr.signMsg]
 rect(x,y,w,h,15)
 if Plr.signC==SIGN_C_MAX then
  print(s.l1,x+6,y+8,0)
  print(s.l2,x+6,y+8+C,0)
 end
end

-- Rend tile animations
function RendTanims()
 local c0=Max(0,Game.scr//C)
 local cf=c0+COLS
 for c=c0,cf do
  local anims=Tanims[c]
  if anims then
   for i=1,#anims do
    local r=anims[i]
    local tanim=TANIM[mget(c,r)]
    if tanim then
     local spid=tanim[
       1+(Game.t//16)%#tanim]
     spr(spid,c*C-Game.scr,r*C)
    end
   end
  end
 end
end

--------------------------------------
-- ENTITY BEHAVIORS
---------------------------------------

-- move hit modes: what happens when
-- entity hits something solid.
MOVE_HIT={
 NONE=0,
 STOP=1,
 BOUNCE=2,
 DIE=3,
}

-- aim mode
AIM={
 NONE=0,   -- just shoot in natural
           -- direction of projectile
 HORIZ=1,  -- adjust horizontal vel to
           -- go towards player
 VERT=2,   -- adjust vertical vel to go
           -- towards player
 FULL=3,   -- adjust horiz/vert to aim
           -- at player
}

-- moves horizontally
-- moveDen: every how many ticks to move
-- moveDx: how much to move
-- moveHitMode: what to do on wall hit
-- noFall: if true, flip instead of falling
function BehMove(e)
 if e.moveT>0 then e.moveT=e.moveT-1 end
 if e.moveT==0 then return end
 if e.moveWaitPlr>0 then
  if Abs(Plr.x-e.x)>e.moveWaitPlr then
   return
  else e.moveWaitPlr=0 end
 end
 e.moveNum=e.moveNum+1
 if e.moveNum<e.moveDen then return end
 e.moveNum=0
 
 if e.noFall and
   EntWouldFall(e,e.x+e.moveDx) then
  -- flip rather than fall
  e.moveDx=-e.moveDx
  e.flipped=e.moveDx>0
 elseif e.moveHitMode==MOVE_HIT.NONE or
    EntCanMove(e,e.x+e.moveDx,e.y) then
  e.x=e.x+(e.moveDx or 0)
  e.y=e.y+(e.moveDy or 0)
 elseif e.moveHitMode==MOVE_HIT.BOUNCE
   then
  e.moveDx=-(e.moveDx or 0)
  e.flipped=e.moveDx>0
 elseif e.moveHitMode==MOVE_HIT.DIE then
  e.dead=true
 end
end

-- Moves up/down.
-- e.yamp: amplitude
function BehUpDownInit(e)
 e.maxy=e.y
 e.miny=e.maxy-e.yamp
end

function BehUpDown(e)
 e.ynum=e.ynum+1
 if e.ynum<e.yden then return end
 e.ynum=0
 e.y=e.y+e.dy
 if e.y<=e.miny then e.dy=1 end
 if e.y>=e.maxy then e.dy=-1 end
end

function BehFacePlr(e)
 e.flipped=Plr.x>e.x
 if e.moveDx then
  e.moveDx=Abs(e.moveDx)*
   (e.flipped and 1 or -1)
 end
end

-- automatically flips movement
-- flipDen: every how many ticks to flip
function BehFlip(e)
 e.flipNum=e.flipNum+1
 if e.flipNum<e.flipDen then return end
 e.flipNum=0
 e.flipped=not e.flipped
 e.moveDx=(e.moveDx and -e.moveDx or 0)
end

function BehJump(e)
 if e.jmp==0 then
  e.jmpNum=e.jmpNum+1
  if e.jmpNum<e.jmpDen or
    not e.grounded then return end
  e.jmpNum=0
  e.jmp=1
 else
  -- continue jump  
  e.jmp=e.jmp+1
  if e.jmp>#JUMP_DY then
   -- end jump
   e.jmp=0
  else
   local dy=JUMP_DY[e.jmp]
   if EntCanMove(e,e.x,e.y+dy) then
    e.y=e.y+dy
   else
    e.jmp=0
   end
  end
 end
end

function BehFall(e)
 e.grounded=not EntCanMove(e,e.x,e.y+1)
 if not e.grounded and e.jmp==0 then
  e.y=e.y+1
 end
end

function BehTakeDmg(e,dtype)
 if not ArrayContains(e.dtypes,dtype) then
  return
 end
 e.hp=e.hp-1
 if e.hp>0 then return end
 e.dead=true
 -- drop loot?
 local roll=Rnd(0,99)
 -- give bonus probability to starting
 -- levels (decrease roll value)
 roll=Max(Iif2(Game.lvlNo<2,roll-50,
   Game.lvlNo<4,roll-25,roll),0)
 if roll<e.lootp then
  local i=Rnd(1,#e.loot)
  i=Min(Max(i,1),#e.loot)
  local l=EntAdd(e.loot[i],e.x,e.y-4)
  EntAddBeh(l,BE.MOVE)
  ShallowMerge(l,{moveDy=-1,moveDx=0,
    moveDen=1,moveT=8})
 end
end

function BehPoints(e)
 e.dead=true
 AddScore(e.value or 50,e.x+4,e.y-4)
end

function BehHurt(e)
 HandlePlrHurt()
end

function BehLiftInit(e)
 -- lift top and bottom y:
 local a=C*FetchTile(
   T.META_A,e.x//C)
 local b=C*FetchTile(
   T.META_B,e.x//C)
 if a>b then
  e.boty=a
  e.topy=b
  e.dir=1
 else
  e.topy=a
  e.boty=b
  e.dir=-1
 end 
 e.coll=CR.FULL
end

function BehLift(e)
 e.liftNum=e.liftNum+1
 if e.liftNum<e.liftDen then return end
 e.liftNum=0
 e.y=e.y+e.dir
 if e.dir>0 and e.y>e.boty or 
   e.dir<0 and e.y<e.topy then
  e.dir=-e.dir
 end
end

function BehLiftColl(e)
 -- Lift hit player. Just nudge the player
 Plr.nudgeY=Iif(e.y>Plr.y,-1,1)
end

function BehShootInit(e)
 e.shootNum=Rnd(0,e.shootDen-1)
end

function BehShoot(e)
 e.shootNum=e.shootNum+1
 if e.shootNum<30 then
  e.sprite=e.shootSpr or e.sprite
 end
 if e.shootNum<e.shootDen then return end
 e.shootNum=0
 local shot=EntAdd(
   e.shootEid or EID.FIREBALL,e.x,e.y)
 e.sprite=e.shootSpr or e.sprite
 shot.moveDx=
   Iif(shot.moveDx==nil,0,shot.moveDx)
 shot.moveDy=
   Iif(shot.moveDy==nil,0,shot.moveDy)

 if e.aim==AIM.HORIZ then
  shot.moveDx=(Plr.x>e.x and 1 or -1)*
   Abs(shot.moveDx)
 elseif e.aim==AIM.VERT then
  shot.moveDy=(Plr.y>e.y and 1 or -1)*
   Abs(shot.moveDy)
 elseif e.aim==AIM.FULL then
  local tx=Plr.x-shot.x
  local ty=Plr.y-shot.y
  local mag=math.sqrt(tx*tx+ty*ty)
  local spd=math.sqrt(
    shot.moveDx*shot.moveDx+
    shot.moveDy*shot.moveDy)
  shot.moveDx=math.floor(0.5+tx*spd/mag)
  shot.moveDy=math.floor(0.5+ty*spd/mag)
  if shot.moveDx==0 and shot.moveDy==0 then
   shot.moveDx=-1
  end
 end
end

function BehCrumble(e)
 if not e.crumbling then
  -- check if player on tile
  if Plr.x<e.x-8 then return end
  if Plr.x>e.x+8 then return end
  -- check if player is standing on it
  local pr=RectXLate(
    GetPlrCr(),Plr.x,Plr.y)
  local er=RectXLate(e.coll,e.x,e.y-1)
  e.crumbling=RectIsct(pr,er)
 end

 if e.crumbling then
  -- count down to destruction
  e.cd=e.cd-1
  e.sprite=Iif(e.cd>66,S.CRUMBLE,
    Iif(e.cd>33,S.CRUMBLE_2,S.CRUMBLE_3))
  if e.cd<0 then e.dead=true end
 end
end

function BehTtl(e)
 e.ttl=e.ttl-1
 if e.ttl <= 0 then e.dead = true end
end

function BehDmgEnemy(e)
 local fr=RectXLate(FIRE.COLL,e.x,e.y)
 for i=1,#Ents do
  local ent=Ents[i]
  local er=RectXLate(ent.coll,ent.x,ent.y)
  if e~=ent and RectIsct(fr,er) and
    EntHasBeh(ent,BE.VULN) then
   -- ent hit by player fire
   HandleDamage(ent,Plr.plane>0 and
     DMG.PLANE_FIRE or DMG.FIRE)
   e.dead=true
  end
 end
end

function BehGrantFirePwupColl(e)
 Plr.firePwup=FIRE.DUR
 e.dead=true
 Snd(SND.PWUP)
end

function BehGrantSuperPwupColl(e)
 Plr.super=true
 e.dead=true
 Snd(SND.PWUP)
end

function BehReplace(e)
 local d=Abs(e.x-Plr.x)
 if d<e.replDist then
  EntRepl(e,e.replEid,e.replData)
 end
end

function BehChestInit(e)
 -- ent on top of chest is the contents
 local etop=GetEntAt(e.x,e.y-C)
 if etop then
  e.cont=etop.eid
  etop.dead=true
 else
  e.cont=S.FOOD.LEAF
 end
 -- check multiplier
 e.mul=MetaVal(
  mget(e.x//C,e.y//C-2),1)
 e.open=false
end

function BehChestDmg(e)
 if e.open then return end
 SpawnParts(PFX.POP,e.x+4,e.y+4,14)
 Snd(SND.OPEN);
 e.anim=nil
 e.sprite=S.CHEST_OPEN
 e.open=true
 local by=e.y-C
 local ty=e.y-2*C
 local lx=e.x-C
 local cx=e.x
 local rx=e.x+C
 local c=e.cont
 EntAdd(c,cx,by)
 if e.mul>1 then EntAdd(c,cx,ty) end
 if e.mul>2 then EntAdd(c,lx,by) end
 if e.mul>3 then EntAdd(c,rx,by) end
 if e.mul>4 then EntAdd(c,lx,ty) end
 if e.mul>5 then EntAdd(c,rx,ty) end
end

function BehTplafInit(e)
 e.phase=MetaVal(FetchEntTag(e),0)
end

function BehTplaf(e)
 local UNIT=40     -- in ticks
 local PHASE_LEN=3 -- in units
 local uclk=e.phase+Game.t//UNIT
 local open=((uclk//PHASE_LEN)%2==0)
 local tclk=e.phase*UNIT+Game.t
 e.sprite=Iif2(
  (tclk%(UNIT*PHASE_LEN)<=6),
  S.TPLAF_HALF,open,S.TPLAF,S.TPLAF_OFF)
 e.sol=Iif(open,SOL.HALF,SOL.NOT)
end

function BehDashInit(e)
 assert(EntHasBeh(e,BE.MOVE))
 e.origAnim=e.anim
 e.origMoveDen=e.moveDen
end

function BehDash(e)
 local dashing=e.cdd<e.ddur
 e.cdd=(e.cdd+1)%e.cdur
 if dashing then
  e.anim=e.dashAnim or e.origAnim
  e.moveDen=e.origMoveDen
 else
  e.anim=e.origAnim
  e.moveDen=99999  -- don't move
 end
end

function BehSignInit(e)
 e.msg=MetaVal(FetchEntTag(e),0)
end

function BehSignColl(e)
 Plr.signMsg=e.msg
 -- if starting to read sign, lock player
 -- for a short while
 if Plr.signC==0 then
  Plr.locked=100
 end
 -- increase cycle counter by 2 because
 -- it gets decreased by 1 every frame
 Plr.signC=Min(Plr.signC+2,
   SIGN_C_MAX)
end

function BehOneUp(e)
 e.dead=true
 Plr.lives=Plr.lives+1
 Snd(SND.ONEUP)
end

function BehFlag(e)
 local rx=e.x+C
 if Plr.respX<rx then
  Plr.respX=rx
  Plr.respY=e.y
 end
 Snd(SND.PWUP)
 EntRepl(e,EID.FLAG_T)
end

function BehReplOnGnd(e)
 if e.grounded then
  EntRepl(e,e.replEid,e.replData)
 end
end

function BehPop(e)
 e.dead=true
 SpawnParts(PFX.POP,e.x+4,e.y+4,e.clr)
end

function BehBoardPlane(e)
 e.dead=true
 Plr.plane=PLANE.START_FUEL
 Plr.y=e.y-3*C
 Snd(SND.PLANE)
end

function BehFuel(e)
 e.dead=true
 Plr.plane=Plr.plane+PLANE.FUEL_INC
 Snd(SND.PWUP)
end

---------------------------------------
-- ENTITY BEHAVIORS
---------------------------------------
BE={
 MOVE={
  data={
   -- move denominator (moves every
   -- this many frames)
   moveDen=5,
   moveNum=0, -- numerator, counts up
   -- 1=moving right, -1=moving left
   moveDx=-1,
   moveDy=0,
   moveHitMode=MOVE_HIT.BOUNCE,
   -- if >0, waits until player is less
   -- than this dist away to start motion
   moveWaitPlr=0,
   -- if >=0, how many ticks to move
   -- for (after that, stop).
   moveT=-1,
  },
  update=BehMove,
 },
 FALL={
  data={grounded=false,jmp=0},
  update=BehFall,
 },
 FLIP={
  data={flipNum=0,flipDen=20},
  update=BehFlip,
 },
 FACEPLR={update=BehFacePlr},
 JUMP={
  data={jmp=0,jmpNum=0,jmpDen=50},
  update=BehJump,
 },
 VULN={ -- can be damaged by player
  data={hp=1,
   -- damage types that can hurt this.
   dtypes={DMG.MELEE,DMG.FIRE,DMG.PLANE_FIRE},
   -- loot drop probability (0-100)
   lootp=0,
   -- possible loot to drop (EIDs)
   loot={EID.FOOD.A},
  },
  dmg=BehTakeDmg,
 },
 SHOOT={
  data={shootNum=0,shootDen=100,
   aim=AIM.NONE},
  init=BehShootInit,
  update=BehShoot,
 },
 UPDOWN={
  -- yamp is amplitude of y movement
  data={yamp=16,dy=-1,yden=3,ynum=0},
  init=BehUpDownInit,
  update=BehUpDown,
 },
 POINTS={
  data={value=50},
  coll=BehPoints,
 },
 HURT={ -- can hurt player
  coll=BehHurt
 },
 LIFT={
  data={liftNum=0,liftDen=3},
  init=BehLiftInit,
  update=BehLift,
  coll=BehLiftColl,
 },
 CRUMBLE={
  -- cd: countdown to crumble
  data={cd=50,coll=CR.FULL,crumbling=false},
  update=BehCrumble,
 },
 TTL={  -- time to live (auto destroy)
  data={ttl=150},
  update=BehTtl,
 },
 DMG_ENEMY={ -- damage enemies
  update=BehDmgEnemy,
 },
 GRANT_FIRE={
  coll=BehGrantFirePwupColl,
 },
 REPLACE={
 -- replaces by another ent when plr near
 -- replDist: distance from player
 -- replEid: EID to replace by
  data={replDist=50,replEid=EID.LEAF},
  update=BehReplace,
 },
 CHEST={
  init=BehChestInit,
  dmg=BehChestDmg,
 },
 TPLAF={
  init=BehTplafInit,
  update=BehTplaf,
 },
 DASH={
  data={
   ddur=20, -- dash duration
   cdur=60, -- full cycle duration
   cdd=0, -- cycle counter
  },
  init=BehDashInit,
  update=BehDash,
 },
 GRANT_SUPER={
  coll=BehGrantSuperPwupColl,
 },
 SIGN={
  init=BehSignInit,
  coll=BehSignColl
 },
 ONEUP={coll=BehOneUp},
 FLAG={coll=BehFlag},
 REPL_ON_GND={
  -- replace EID when grounded
  -- replData -- extra data to add to
  data={replEid=EID.LEAF},
  update=BehReplOnGnd
 },
 POP={update=BehPop},
 PLANE={coll=BehBoardPlane},
 FUEL={coll=BehFuel},
}

---------------------------------------
-- ENTITY BEHAVIOR TABLE
---------------------------------------
EBT={
 [EID.EN.SLIME]={
  data={
    hp=1,moveDen=3,clr=11,noFall=true,
    lootp=20,loot={EID.FOOD.A},
  },
  beh={BE.MOVE,BE.FALL,BE.VULN,BE.HURT},
 },

 [EID.EN.HSLIME]={
  data={replDist=50,replEid=EID.EN.SLIME},
  beh={BE.REPLACE},
 },

 [EID.EN.A]={
  data={
    hp=1,moveDen=5,clr=14,flipDen=120,
    lootp=30,
    loot={EID.FOOD.A,EID.FOOD.B},
  },
  beh={BE.MOVE,BE.JUMP,BE.FALL,BE.VULN,
   BE.HURT,BE.FLIP},
 },
 
 [EID.EN.B]={
  data={
    hp=1,moveDen=5,clr=13,
    lootp=30,
    loot={EID.FOOD.A,EID.FOOD.B,
      EID.FOOD.C},
  },
  beh={BE.JUMP,BE.FALL,BE.VULN,BE.HURT,
    BE.FACEPLR},
 },

 [EID.EN.DEMON]={
  data={hp=1,moveDen=5,clr=7,
   aim=AIM.HORIZ,
   shootEid=EID.FIREBALL,
   shootSpr=S.EN.DEMON_THROW,
   lootp=60,
   loot={EID.FOOD.C,EID.FOOD.D}},
  beh={BE.JUMP,BE.FALL,BE.SHOOT,
   BE.HURT,BE.FACEPLR,BE.VULN},
 },

 [EID.EN.SDEMON]={
  data={hp=1,moveDen=5,clr=7,
   flipDen=50,
   shootEid=EID.SNOWBALL,
   shootSpr=S.EN.SDEMON_THROW,
   aim=AIM.HORIZ,
   lootp=75,
   loot={EID.FOOD.C,EID.FOOD.D}},
  beh={BE.JUMP,BE.FALL,BE.SHOOT,
   BE.MOVE,BE.FLIP,BE.VULN,BE.HURT},
 },

 [EID.EN.PDEMON]={
  data={hp=1,clr=11,flipDen=50,
   shootEid=EID.PLASMA,
   shootSpr=S.EN.PDEMON_THROW,
   aim=AIM.FULL,
   lootp=80,
   loot={EID.FOOD.D}},
  beh={BE.JUMP,BE.FALL,BE.SHOOT,
   BE.FLIP,BE.VULN,BE.HURT},
 },

 [EID.EN.BAT]={
  data={hp=1,moveDen=2,clr=9,flipDen=60,
    lootp=40,
    loot={EID.FOOD.A,EID.FOOD.B}},
  beh={BE.MOVE,BE.FLIP,BE.VULN,BE.HURT},
 },
 
 [EID.EN.FISH]={
  data={
    hp=1,moveDen=3,clr=9,flipDen=120,
    lootp=40,
    loot={EID.FOOD.A,EID.FOOD.B},
  },
  beh={BE.MOVE,BE.FLIP,BE.VULN,
   BE.HURT},
 },
  
 [EID.EN.FISH2]={
  data={hp=1,clr=12,moveDen=1,
   lootp=60,
   loot={EID.FOOD.B,EID.FOOD.C}},
  beh={BE.MOVE,BE.DASH,BE.VULN,BE.HURT},
 },

 [EID.FIREBALL]={
  data={hp=1,moveDen=2,clr=7,
    coll=CR.BALL,
    moveHitMode=MOVE_HIT.DIE},
  beh={BE.MOVE,BE.HURT,BE.TTL},
 },

 [EID.PLASMA]={
  data={hp=1,moveDen=2,clr=7,
    moveDx=2,
    coll=CR.BALL,
    moveHitMode=MOVE_HIT.NONE},
  beh={BE.MOVE,BE.HURT,BE.TTL},
 },

 [EID.SNOWBALL]={
  data={hp=1,moveDen=1,clr=15,
    coll=CR.BALL,
    moveHitMode=MOVE_HIT.DIE},
  beh={BE.MOVE,BE.FALL,BE.VULN,BE.HURT},
 },

 [EID.LIFT]={
  data={sol=SOL.FULL},
  beh={BE.LIFT},
 },

 [EID.CRUMBLE]={
  data={
   sol=SOL.FULL,clr=14,
   -- only take melee and plane fire dmg
   dtypes={DMG.MELEE,DMG.PLANE_FIRE},
  },
  beh={BE.CRUMBLE,BE.VULN},
 },

 [EID.PFIRE]={
  data={
   moveDx=1,moveDen=1,ttl=80,
   moveHitMode=MOVE_HIT.DIE,
   coll=FIRE.COLL,
  },
  beh={BE.MOVE,BE.TTL,BE.DMG_ENEMY},
 },

 [EID.FIRE_PWUP]={
  beh={BE.GRANT_FIRE},
 },

 [EID.SPIKE]={
  data={coll=CR.FULL},
  beh={BE.HURT},
 },
 
 [EID.CHEST]={
  data={coll=CR.FULL,
   sol=SOL.FULL},
  beh={BE.CHEST},
 },

 [EID.TPLAF]={
  data={sol=SOL.HALF,
   coll=CR.TOP},
  beh={BE.TPLAF},
 },
 
 [EID.EN.DASHER]={
  data={hp=1,clr=12,moveDen=1,noFall=true,
   dashAnim={S.EN.DASHER,315},
   lootp=60,
   loot={EID.FOOD.B,EID.FOOD.C}},
  beh={BE.MOVE,BE.DASH,BE.VULN,BE.HURT},
 },
 
 [EID.EN.VBAT]={
  data={hp=1,clr=14,yden=2,
    lootp=40,
    loot={EID.FOOD.B,EID.FOOD.C}},
  beh={BE.UPDOWN,BE.VULN,BE.HURT},
 },

 [EID.SUPER_PWUP]={beh={BE.GRANT_SUPER}},
 [EID.SIGN]={beh={BE.SIGN}},
 [EID.FLAG]={beh={BE.FLAG}},
 
 [EID.ICICLE]={
  data={replEid=EID.ICICLE_F,replDist=8},
  beh={BE.REPLACE},
 },

 [EID.ICICLE_F]={
  data={replEid=EID.POP,replData={clr=15}},
  beh={BE.FALL,BE.HURT,BE.REPL_ON_GND}
 },

 [EID.SICICLE]={
  data={replEid=EID.SICICLE_F,replDist=8},
  beh={BE.REPLACE},
 },

 [EID.SICICLE_F]={
  data={replEid=EID.POP,replData={clr=14}},
  beh={BE.FALL,BE.HURT,BE.REPL_ON_GND}
 },

 [EID.POP]={beh={BE.POP}},
 [EID.PLANE]={beh={BE.PLANE}},
 [EID.FUEL]={beh={BE.FUEL}},
 
 [EID.FOOD.LEAF]={
   data={value=50,coll=CR.FOOD},
   beh={BE.POINTS}},
 [EID.FOOD.A]={
   data={value=100,coll=CR.FOOD},
   beh={BE.POINTS}},
 [EID.FOOD.B]={
   data={value=200,coll=CR.FOOD},
   beh={BE.POINTS}},
 [EID.FOOD.C]={
   data={value=500,coll=CR.FOOD},
   beh={BE.POINTS}},
 [EID.FOOD.D]={
   data={value=1000,coll=CR.FOOD},
   beh={BE.POINTS}}, 
}

---------------------------------------
-- DEBUG MENU
---------------------------------------
function DbgTic()
 if Plr.dbgResp then
  cls(1)
  print(Plr.dbgResp)
  if btnp(4) then
   Plr.dbgResp=nil
  end
  return
 end

 Game.dbglvl=Game.dbglvl or 1

 if btnp(3) then
  Game.dbglvl=Iif(Game.dbglvl+1>#LVL,1,Game.dbglvl+1)
 elseif btnp(2) then
  Game.dbglvl=Iif(Game.dbglvl>1,Game.dbglvl-1,#LVL)
 end

 local menu={
  {t="(Close)",f=DbgClose},
  {t="Warp to test lvl",f=DbgWarpTest}, 
  {t="Warp to L"..Game.dbglvl,f=DbgWarp},
  {t="End lvl",f=DbgEndLvl},
  {t="Grant super pwup",f=DbgSuper},
  {t="Fly mode "..
    Iif(Plr.dbgFly,"OFF","ON"),f=DbgFly},
  {t="Invuln mode "..
    Iif(Plr.invuln and Plr.invuln>0,
        "OFF","ON"),
    f=DbgInvuln},
  {t="Unpack L"..Game.dbglvl,f=DbgUnpack},
  {t="Pack L"..Game.dbglvl,f=DbgPack},
  {t="Clear PMEM",f=DbgPmem},
  {t="Win the game",f=DbgWin}, 
  {t="Lose the game",f=DbgLose}, 
 }
 cls(5)
 print("DEBUG")

 rect(110,0,140,16,11)
 print("DBG LVL:",120,4,3)
 print(LVL[Game.dbglvl].name,170,4)

 Plr.dbgSel=Plr.dbgSel or 1
 for i=1,#menu do
  print(menu[i].t,10,10+i*10,
   Plr.dbgSel==i and 15 or 0)
 end
 if btnp(0) then
  Plr.dbgSel=Iif(Plr.dbgSel>1,
   Plr.dbgSel-1,#menu)
 elseif btnp(1) then
  Plr.dbgSel=Iif(Plr.dbgSel<#menu,
   Plr.dbgSel+1,1)
 elseif btnp(4) then
  (menu[Plr.dbgSel].f)()
 end
end

function DbgClose() Plr.dbg=false end

function DbgSuper() Plr.super=true end

function DbgEndLvl()
 EndLvl()
 Plr.dbg=false
end

function DbgPmem() pmem(0,0) end

function DbgWarp()
 StartLvl(Game.dbglvl)
end

function DbgWarpNext()
 StartLvl(Game.lvlNo+1)
end

function DbgWarpTest()
 StartLvl(#LVL)
end

function DbgUnpack()
 UnpackLvl(Game.dbglvl,UMODE.EDIT)
 sync()
 Plr.dbgResp="Unpacked & synced L"..Game.dbglvl
end

function DbgPack()
 local succ=PackLvl(Game.dbglvl)
 --MapClear(0,0,LVL_LEN,ROWS)
 sync()
 Plr.dbgResp=Iif(succ,
   "Packed & synced L"..Game.dbglvl,
   "** ERROR packing L"..Game.dbglvl)
end

function DbgFly()
 Plr.dbgFly=not Plr.dbgFly
 Plr.dbgResp="Fly mode "..Iif(Plr.dbgFly,
  "ON","OFF")
end

function DbgInvuln()
 Plr.invuln=Iif(Plr.invuln>0,0,9999999)
 Plr.dbgResp="Invuln mode "..Iif(
  Plr.invuln>0,"ON","OFF")
end

function DbgWin()
 SetMode(M.WIN)
 Plr.dbg=false
end

function DbgLose()
 SetMode(M.GAMEOVER)
 Plr.dbg=false
end

---------------------------------------
-- UTILITIES
---------------------------------------
function Iif(cond,t,f)
 if cond then return t else return f end
end

function Iif2(cond,t,cond2,t2,f2)
 if cond then return t end
 return Iif(cond2,t2,f2)
end

function Iif3(cond,t,cond2,t2,cond3,t3,f3)
 if cond then return t end
 return Iif2(cond2,t2,cond3,t3,f3)
end

function Iif4(cond,t,cond2,t2,cond3,t3,
   cond4,t4,f4)
 if cond then return t end
 return Iif3(cond2,t2,cond3,t3,cond4,t4,f4)
end

function ArrayContains(a,val)
 for i=1,#a do
  if a[i]==val then return true end
 end
 return false
end

function Lpad(value, width)
 local s=value..""
 while string.len(s) < width do
  s="0"..s
 end
 return s
end

function RectXLate(r,dx,dy)
 return {x=r.x+dx,y=r.y+dy,w=r.w,h=r.h}
end

-- rects have x,y,w,h
function RectIsct(r1,r2)
 return
  r1.x+r1.w>r2.x and r2.x+r2.w>r1.x and
  r1.y+r1.h>r2.y and r2.y+r2.h>r1.y
end

function DeepCopy(t)
 if type(t)~="table" then return t end
 local r={}
 for k,v in pairs(t) do
  if type(v)=="table" then
   r[k]=DeepCopy(v)
  else
   r[k]=v
  end
 end
 return r
end

-- if preserve, fields that already exist
-- in the target won't be overwritten
function ShallowMerge(target,src,
  preserve)
 if not src then return end
 for k,v in pairs(src) do
  if not preserve or not target[k] then
   target[k]=DeepCopy(src[k])
  end
 end
end

function MapCopy(sc,sr,dc,dr,w,h)
 for r=0,h-1 do
  for c=0,w-1 do
   mset(dc+c,dr+r,mget(sc+c,sr+r))
  end
 end
end

function MapClear(dc,dr,w,h)
 for r=0,h-1 do
  for c=0,w-1 do
   mset(dc+c,dr+r,0)
  end
 end
end

function MapColsEqual(c1,c2,r)
 for i=0,ROWS-1 do
  if mget(c1,r+i)~=mget(c2,r+i) then
   return false
  end
 end
 return true
end

function MetaVal(t,deflt)
 return Iif(
  t>=T.META_NUM_0 and t<=T.META_NUM_0+12,
  t-T.META_NUM_0,deflt)
end

-- finds marker m on column c of level
-- return row of marker, -1 if not found
function FetchTile(m,c,nowarn)
 for r=0,ROWS-1 do
  if LvlTile(c,r)==m then
   if erase then SetLvlTile(c,r,0) end
   return r
  end
 end
 if not nowarn then
  trace("Marker not found "..m.." @"..c)
 end
 return -1
end

-- Gets the entity's "tag marker",
-- that is the marker tile that's sitting
-- just above it. Also erases it.
-- If no marker found, returns 0
function FetchEntTag(e)
 local t=mget(e.x//C,e.y//C-1)
 if t>=T.FIRST_META then
  mset(e.x//C,e.y//C-1,0)
  return t
 else
  return 0
 end
end

function Max(x,y) return math.max(x,y) end
function Min(x,y) return math.min(x,y) end
function Abs(x,y) return math.abs(x,y) end
function Rnd(lo,hi) return math.random(lo,hi) end
function Rnd01() return math.random() end
function RndSeed(s) return math.randomseed(s) end
function Ins(tbl,e) return table.insert(tbl,e) end
function Rem(tbl,e) return table.remove(tbl,e) end
function Sin(a) return math.sin(a) end
function Cos(a) return math.cos(a) end

