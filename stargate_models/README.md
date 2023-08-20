# STARGATE: Models

This script prepares and loads all models required by stargate gamemode (identified as HOTU models, HOTU objects). All texture, model and collision files are made by their respecive author from **STARGATE: Horizon of the universe V2.0 mod**. Script is also using 'stargate.IDE' file (for assigning each .DFF, .TXD and .COL file properly), which was created by these author/s too. 

# Model script description

Resource is client-side, which means, that this resource starts the moment player (client) joins the server and loads (or downloads) all required models, textures and other files.

After the resource starts, it will open stargate.IDE file and save all required data into player (such as model name, its texture file, etc.). Script will also request new custom model ID from engine (but won't use it yet) - this may cause *slight* lag (as script will request more than 500 model IDs at once).

Models are **not loaded after client joins the server**. Instead, they are loaded dynamically, depending on demand - when they are needed.

## Dynamic model loading

Is implemented due to Stargate Gamemode heavy resource requirements regarding many custom models (and textures). You may have noticed, that total size of this branch - gamemode is over 1 GB. That is due to this script, because all models, textures and required files for custom models take **1.4 GB of disk space**.

If all models would be loaded into memory at once, **1.4 GB of GPU Video Memory would be used** (just for custom models!), which would increase the system requirements for just playing this gamemode to minimum 1.75 GB GPU VM (base game needs some memory too). And I'm not mentioning the great lag that would happen when player would join and load all of the models (including high possiblity of game crash).

Instead, models are loaded dynamically, depending on **players occupied planet** (see stargate_planets resource). This way, there is no need to load all of the models, but just a small fraction of them (hence the minimum system requirement of 256 MB GPU VM). Also the loading process, gameplay is more smooth, almost instant and almost without any lags.

## System requirements and anti-crash protection

Same as GTA: San Andreas or MTA: San Andreas. The only difference could be on required GPU Video Memory, which is:
- recommended 512 MB and more for best experience
- minimum is 256 MB (going below this may cause gamemode to be unplayable)
- script has automatic warnings and anti-crash system:
    - warning on start when detected GPU Video Memory is less than recommended or minimum value
    - periodical warning when remaining free GPU Video Memory is less than certain amount (1/2 of minimum recommended value, 128 MB)
    - automatic unload of all textures and models when remaining Video Memory is less than certain - very low value (32 MB)
        - this prevents game crash on client-side
        - use-case is not only on low-spec systems - if model loading somehow fails and starts to bloat video memory, this will prevent crash that would happen if model loading would continue
        - unloads only custom textures and models loaded by this script
        - cannot unload base GTA:SA models or models from other scripts - if one of these will fill client's memory, there is nothing this script can do
        - moves player to San Andreas planet
        - unload and player teleport is performed immediately when treshold (<32 MB) is hit
        - detection is happening once in short period (100 ms), so "memory overflow" can get undetected in this short window (overflow causes game to crash)