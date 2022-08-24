# PostsDemoApp

1. Sample Post application
2. Makes a get call to fetch users and posts and collectively show UI.
Notes:
* There is a modular service layer which always checks for API key before making any server call.
* If key is invalid, then it calls auth API to get the required API key to continue with sever call.
* The service layer is extendable to any future api calls.
