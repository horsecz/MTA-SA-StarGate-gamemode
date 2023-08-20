-- declarations.lua: Variable declarations for models script; shared

LAST_RESERVED_OBJECT_MODEL = 0      -- may not be needed ?
PATH_TXD = "textures/"              -- root path of texture files
PATH_DFF = "models/"                -- root path of model files
PATH_COL = "collisions/"            -- root path of collision files

VM_RECOMMENDED_MB = 3084		-- recommended amount of GPU Video Memory [MB]
VM_MINIMUM_MB = 2560			-- minimum amount of GPU Video Memory for (somehow) smooth gameplay experience [MB]
VM_LOW_WARNING_MB = 128		-- low free GPU Video Memory warning [MB]
VM_LOW_WARNING_REPS = 5		-- how much times (seconds) it will take for another VM_LOW_WARNING to appear 
VM_DESTROY_THRESHOLD = 64	-- treshold for extreme low GPU Video Memory actions (to prevent game crash) [MB] 

BIG_FILE = 1000000*15	-- in bytes what is considered as big (texture) files   -- may not be needed ?
MODEL_LOAD_TIME = 10	-- delay between loading one object model [ms]
						-- note: preventing game crash at client side and lags
DUPE_TXD_LOAD_MAX = 50	-- maximum amount of textures that can be loaded duplicately into memory

VM_MINIMUM_MB_L3 = 2048	-- minimum amount of GPU VM required for gameplay; lowspec detection; level 3
VM_MINIMUM_MB_L2 = 1024 -- minimum amount of GPU VM required for gameplay; lowspec detection; level 2
VM_MINIMUM_MB_L1 = 512 -- minimum amount of GPU VM required for gameplay; lowspec detection; level 1

DUPE_TXD_LOAD_MAX_DEFAULT = 50		-- level 4: default (min. 2.5 GB)
DUPE_TXD_LOAD_MAX_LOWSPEC_1 = 25	-- level 3: minimum 2 GB
DUPE_TXD_LOAD_MAX_LOWSPEC_2 = 10	-- level 2: minimum 1 GB
DUPE_TXD_LOAD_MAX_LOWSPEC_3 = 1		-- level 1: minimum 512 MB
