// CELESTE Classic Autosplitter

// Desktop app
state("celeste_asl"){ 
    int level : 0x4345BC;
    string8 time : 0x4345C2; 
}

state("pico8"){}

init{
    print("init");
    refreshRate = 30;
   
    var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);
    var target = new SigScanTarget(3, "0F B6 80 ?? ?? ?? ?? C3 90 90 90 90"); // Find function that reads RAM
    
    IntPtr ptr_lvl = scanner.Scan(target);
    ptr_lvl = game.ReadPointer(ptr_lvl);

    var ptr_time = ptr_lvl + 5;

    vars.watcher_lvl = new MemoryWatcher<int>(ptr_lvl);
    vars.watcher_time = new StringWatcher(ptr_time, 8);
    

}

startup{vars.timerModel = new TimerModel {CurrentState = timer};}

gameTime{
    // Get exact IGT for splits   
    if (vars.watcher_lvl.Old != vars.watcher_lvl.Current){
        string[] igt = vars.watcher_time.Current.Split(':','.');
        
        int minutes = Int32.Parse(igt[0]);
        int seconds = Int32.Parse(igt[1]);
        int milliseconds = (Int32.Parse(igt[2]))*10;

        TimeSpan interval = new TimeSpan(0, 0, minutes, seconds, milliseconds);
        return interval;
    }
}

update{
    vars.watcher_lvl.Update(game);
    vars.watcher_time.Update(game);

    // Thanks to Ero from LiveSplit
    if (vars.watcher_lvl.Old != 0 && vars.watcher_lvl.Current == 0 && settings.ResetEnabled) vars.timerModel.Reset();

}

start{if (vars.watcher_lvl.Current == 1) return true;}



split{
    // Split on level change
    if (vars.watcher_lvl.Old != vars.watcher_lvl.Current){
        vars.watcher_lvl.Old = vars.watcher_lvl.Current;
        print(vars.watcher_time.Current.ToString());
        return true;    
    }
}

reset{return false;} // Make the reset box in the settings avaliable

exit{if (settings.ResetEnabled) vars.timerModel.Reset();}
