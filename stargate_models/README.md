# STARGATE: Models

This script prepares and loads all models required by stargate gamemode (identified as HOTU models, HOTU objects). All texture, model and collision files are made by their respecive author from **STARGATE: Horizon of the universe V2.0 mod**. Script is also using 'stargate.IDE' file (for assigning each .DFF, .TXD and .COL file properly), which was created by these author/s too. 

# User commands

- /outputmodels
    - Outputs all players HOTU model data into XML file at client-side (development purposes mostly)
- /loadModels [range]
    - Unloads all loaded models and loads all HOTU custom object models in range of player (development purposes mostly)
- /txdquality [level]
    - Sets players texture quality level to specified value
    - Note: this quality level is set automatically when player joins (client resource starts)

# Model script description

Resource is client-side, which means, that this resource starts the moment player (client) joins the server and loads (or downloads) all required models, textures and other files.

After the resource starts, it will open stargate.IDE file and save all required data into player (such as model name, its texture file, etc.). Script will also request new custom model ID from engine (but won't use it yet) - this may cause *slight* lag (as script will request more than 500 model IDs at once).

Models are **not loaded after client joins the server**. Instead, they are loaded dynamically, depending on demand - when they are needed.

## Dynamic model loading

Is implemented due to Stargate Gamemode heavy resource requirements regarding many custom models (and textures). You may have noticed, that total size of this branch - gamemode is over 1 GB. That is due to this script, because all models, textures and required files for custom models take **1.4 GB of disk space**.

If all models would be loaded into memory at once, **1.4 GB of GPU Video Memory would be used** (just for custom models!), which would increase the system requirements for just playing this gamemode to minimum 1.75 GB GPU VM (base game needs some memory too) *if only all models and textures would be loaded once*. And I'm not mentioning the great lag that would happen when player would join and load all of the models (including high possiblity of game crash).

Instead, models are loaded dynamically, depending on **players occupied planet** (see stargate_planets resource). This way, there is no need to load all of the models, but just a small fraction of them.

## Models and their textures

This script and Stargate gamemode is using created textures from **STARGATE:Horizon Of The Universe V2.0** (made by their author). The models are fine (and incredible!), but the texture files are:
- Too big (24 TXD files are greater than 10 MB; 4 of them greater above 30 MB in size)
- Uneffective for MTA:SA Texture loading (textures are needed to be loaded multiple times into memory)
    - They need to be loaded every time new model is replaced/used (even the model is using the exact same texture file); it is possible to "reuse" already loaded texture, but it will cause the texture to be applied on that model incorrectly

Because of issues listed above (and limited GPU Video Memory on clients side), some textures may be loaded incorrectly, because the **script has upper limit for loading the same texture file over and over** (because mostly the greater texture means that it needs to be loaded more times) - the limit is 50 times. This limit has proved to be great balance in terms of 99% of textures loading correctly and not using infinite amount of GPU VM.

## System requirements

Same as GTA: San Andreas or MTA: San Andreas. The only difference could be on required GPU Video Memory, which is:
- recommended 3 GB and more for best experience
- minimum is 512 MB (going below this may cause gamemode to be unplayable aka models won't be loaded correctly in some places)
    - Note: minimum value is derived from resource heaviest place known in the gamemode in best quality set (Atlantis map), other places may not be as that resource demanding and use less memory (for example SGC map, Destiny map - both use around 900 MB when loaded separately)

## Quality settings and crash protection

If client has not met the recommended value for GPU Video Memory, lower quality setting will be applied. This lower quality settig is nothing else than reducing the amount of duplicate textures that can be loaded into clients GPU memory. As mentioned above, textures need to be loaded many times because if they are "reused", they will be applied incorrectly in the model.

However, I don't believe, that some (few) incorrectly loaded textures should prevent some player to play this gamemode. Due to this, there are implemented texture quality levels:
- Maximum
    - User has recommended value of GPU VM or more (or slightly less)
- Medium
    - GPU VM is more than 2 GB (but less than recommended value)
- Low
    - GPU VM is between 1 GB and 2 GB
- Minimum
    - GPU VM is less than 1 GB
    - For users with VM capacity less than 512 MB: even this setting won't help you

All these settings do are lower the threshold of loading the same texture into video memory. The lower the setting is, less times can the same texture be loaded in memory.

## Anti-crash system and GPU memory warnings

Script has automatic warnings and anti-crash system:
    - **tested: unloading does not work on AMD GPUs (dxGetStatus function returns invalid values)**
    - warns user if he has lower than minimum/recommended GPU VM capacity (and if texture quality has been changed)
    - unloads all models and textures if remaining free VM reaches treshold