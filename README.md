# Classsic Autosplitter
This allows you to setup autosplitting for Celeste Classic in Linux/Mac/Windows using LiveSplit/LiveSplitOne.

## Using LiveSplit


# Windows
Windows users can simply download either the pico-8 cart or the standalone from the `autosplitter-windows` folder, and then use the built in autosplitter function in Livesplit. (Edit splits > Enable)

You can modify the cartridge and it will still work, however if exporting back to standalone make sure you export it with the name `celeste_asl`. Any other name will not work.

# Using another OS
You'll need to install the LiveSplit Server component, see steps here: https://github.com/LiveSplit/LiveSplit.Server#install

- Open LiveSplit and edit your layout, click on the + button and go to Control -> LiveSplit Server.
- Press OK to save your changes and start the server by right clicking and going to Control -> Start Server (you'll need to do this every time you start LiveSplit)
- Run the autosplitter python script
- After Pico-8 opens, run the autosplitter cart (or do nothing if you're using the standalones)

## Using LiveSplitOne
- Run the autosplitter python script and input "y" to say you're using LiveSplitOne
- Open https://one.livesplit.org/ in your browser, click the Connect to Server button and type `ws://localhost:5000`
-  After Pico-8 opens, run the autosplitter cart (or do nothing if you're using the standalones)


### Accuracy/Is this thing even working correctly
The python script and the Windows-only cart print all splits to the console, you can compare those times with the times the autosplitter gives (remember to check Game Time, NOT Real Time!)
