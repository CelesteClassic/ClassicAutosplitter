state("celeste_asl"){ // Desktop executable name
    int level : 0x4345BC;
    string8 time : 0x4345C2; 
}

state("pico8","0.2.3"){ // PICO-8 executable name
    int level : 0x45DB9C;
    string8 time : 0x45DBA1; 
}

state("pico8","0.2.4"){ // PICO-8 executable name
    int level : 0x475188;
    string8 time : 0x47518E; 
}


init{ 
    refreshRate = 30; // Celeste runs at 30fps, no need to check more often 
    
    if (modules.First().ModuleMemorySize == 5300224) // Detect which version of PICO-8 is being used
        version = "0.2.4";
    else 

    if (modules.First().ModuleMemorySize == 5206016)
            version = "0.2.3";
}

startup{ vars.timerModel = new TimerModel { CurrentState = timer };} // A variable to control the timer

gameTime{   
    if (old.level != current.level){ // We only need the exact IGT for splits, to eliminate variables like lag
        string[] igt = current.time.Split(':','.');
        
        int minutes = Int32.Parse(igt[0]);
        int seconds = Int32.Parse(igt[1]);
        int milliseconds = (Int32.Parse(igt[2]))*10;

        TimeSpan interval = new TimeSpan(0, 0, minutes, seconds, milliseconds);
        return interval;
    }
}

start{if (current.level == 1) return true;} // Start the timer if on 100m

update{if (old.level != 0 && current.level == 0 && settings.ResetEnabled) vars.timerModel.Reset(); 
// Using this instead of reset{} as this allows 
// for resetting automatically when the run has ended
// Thank you Ero from LiveSplit for this code
}

split{ // If the last value of level differs from the current value, split
    if (old.level != current.level){
        old.level = current.level;
        return true;    
    }
}

reset{return false;} // Make the reset box in the settings avaliable

exit{if (settings.ResetEnabled) vars.timerModel.Reset();} // Reset on game exit