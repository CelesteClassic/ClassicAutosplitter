state("pico8"){ // PICO-8 executable name
    int level : 0x45DB9C;
    string8 time : 0x45DBA1; 
}

startup{ // Celeste runs at 30fps, no need to check more often 
    refreshRate = 30;
    vars.timerModel = new TimerModel { CurrentState = timer };
}

gameTime{   
    if (old.level != current.level){ // We only need the exact IGT for splits, to eliminate variables like lag
        string[] igt = current.time.Split(':','.');
        
        int minutes = Int32.Parse(igt[0]);
        int seconds = Int32.Parse(igt[1]);
        int milliseconds = Int32.Parse(igt[2]);

        TimeSpan interval = new TimeSpan(0, 0, minutes, seconds, milliseconds*10);
        return interval;
    }
}

start{ // Start the timer if on 100m
    if (current.level == 1) {
        return true;
    }
}

update{ // Reset the timer if on the Main Menu || Thank you Ero from the Speedrun Tool Dev server for the code
    if (old.level != 0 && current.level == 0 && settings.ResetEnabled) // Using this instead of reset{} as this allows 
        vars.timerModel.Reset(); // for resetting automatically when the run has ended
}

split{ // If the last value of level differs from the current value, split
    if (old.level != current.level){
        old.level = current.level;
        return true;    
    }
}

reset{return false;} // Make the reset box in the settings avaliable