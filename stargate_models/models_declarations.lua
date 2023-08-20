-- declarations.lua: Variable declarations for models script; shared

LAST_RESERVED_OBJECT_MODEL = 0      -- may not be needed ?
PATH_TXD = "textures/"              -- root path of texture files
PATH_DFF = "models/"                -- root path of model files
PATH_COL = "collisions/"            -- root path of collision files

VM_RECOMMENDED_MB = 512		-- recommended amount of GPU Video Memory [MB]
VM_MINIMUM_MB = 256			-- minimum amount of GPU Video Memory for (somehow) smooth gameplay experience [MB]
VM_LOW_WARNING_MB = 128		-- low free GPU Video Memory warning [MB]
VM_LOW_WARNING_REPS = 5		-- how much times (seconds) it will take for another VM_LOW_WARNING to appear 
VM_DESTROY_THRESHOLD = 32	-- treshold for extreme low GPU Video Memory actions (to prevent game crash) [MB] 

BIG_FILE = 1000000*15	-- in bytes what is considered as big (texture) files   -- may not be needed ?
MODEL_LOAD_TIME = 10	-- delay between loading one object model [ms]
						-- note: preventing game crash at client side and lags