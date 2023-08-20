# Release 0.4 preview

## txdlevel_def

- preview of default texture quality (Map: Earth - SGC)
- this will be used when your total GPU Video Memory is 3 GB and more (or slightly less)*
- this scene (map) is using around 800 MB of GPU VM

## txdlevel_min

- preview of the same place (SGC) as txdlevel_def but with the lowest texture quality
- this texture quality setting will be used when your GPU Video Memory is less than 1 GB*
- currenct scene (map) is using about 150 MB of GPU VM

*May change in further releases. As you can tell, this map - scene is using 800 MB at default (maximum) quality, so you need half of the memory (default game models, operating system need memory too). But currently the quality level requirements are based on the most resource demanding scene (map), which is Atlantis (this map uses 2.1 GB, hence the 3 GB requirement).
