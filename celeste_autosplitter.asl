// CELESTE Classic Autosplitter

// Determine which verison of the game is running
state("celeste_asl"){ 
    int level : 0x4345BC;
    string8 time : 0x4345C2; 
}

state("pico8","0.2.3"){ 
    int level : 0x45DB9C;
    string8 time : 0x45DBA1; 
}

state("pico8","0.2.4"){
    int level : 0x475188;
    string8 time : 0x47518D; 
}

state("pico8","0.2.4b"){ 
    int level : 0x4761A8;
    string8 time : 0x4761AD; 
}

state("pico8","0.2.4c"){ 
    int level : 0x479A20;
    string8 time : 0x479A25; 
}

init{ 
    refreshRate = 30;

    // If pico8 is being used, check which version
    switch (modules.First().ModuleMemorySize) {
        case 5206016: version = "0.2.3"; break;
        case 5300224: version = "0.2.4"; break;
        case 5304320: version = "0.2.4b"; break;
        case 5320704: version = "0.2.4c"; break;
        default: version = "Unknown!"; break;
    }
}

startup{vars.timerModel = new TimerModel {CurrentState = timer};} // Variable to control timer

gameTime{
    // Get exact IGT for splits   
    if (old.level != current.level){
        string[] igt = current.time.Split(':','.');
        
        int minutes = Int32.Parse(igt[0]);
        int seconds = Int32.Parse(igt[1]);
        int milliseconds = (Int32.Parse(igt[2]))*10;

        TimeSpan interval = new TimeSpan(0, 0, minutes, seconds, milliseconds);
        return interval;
    }
}

start{if (current.level == 1) return true;} // Start the timer if on 100m

// Using this instead of reset{} as this allows for resetting even when the run has ended
// Credit/thanks to Ero from LiveSplit
update{if (old.level != 0 && current.level == 0 && settings.ResetEnabled) vars.timerModel.Reset();}

split{
    // Split on level change
    if (old.level != current.level){
        old.level = current.level;
        return true;    
    }
}

reset{return false;} // Make the reset box in the settings avaliable

exit{if (settings.ResetEnabled) vars.timerModel.Reset();} // Reset on game exit
