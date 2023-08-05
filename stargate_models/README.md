# Stargate models script

This script prepares and loads all models required by stargate gamemode. All texture, model and collision files are made by their respecive author from **STARGATE: Horizon of the universe V2.0 mod**. Script is also using 'stargate.IDE' file (for assigning each .DFF, .TXD and .COL file properly), which was created by these author/s too. 

# Integration with other stargate resources

- every element which requires some model must have set these values when created:
    - any model ID (e.g. some default ID, 1337 for objects, aka trash bin object model)
    - element data-attribute "element_model_data" set to string representing the model it will get assigned
- after client joins:
    - all models will be loaded
    - every element with "element_model_data" attribute set will be assigned proper model ID

# Element model data

String value, which is stored inside models data table (which is stored in player). This string represents name of model used in Stargate: Horizon of the universe V2.0 mod and from this string, you can obtain proper model ID via *models_getObjectID(...)* function.
- function *models_getObjectID(...)* requires player element as first parameter (because model data are stored in player)
- player can generate XML file containing table used for translation of 'element_model_data' into 'model ID' via command '/outputmodels' (stored in resource root on client-side)