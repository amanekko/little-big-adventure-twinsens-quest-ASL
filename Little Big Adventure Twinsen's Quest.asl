// LBA Twinsen's Quest 
// Tested with 1.1.2 #debb500

state("LittleBigAdventureTwinsensQuest")
{ 
    int location: "UnityPlayer.dll", 0x1D205C0, 0x1F0, 0x168,  0x0,  0x78,  0x30,  0x8, 0x48;
}
 
 
// Called on splitter loading
init
{
    vars.oldReset = 9;
    vars.reset = 0;
    vars.start = 6;
    vars.oldEnd = 5;
    vars.end = 0;
}

// Game start, triggered after the intro cinematic when entering Twinsen's house scene
start
{    
   if (old.location == vars.reset && current.location == vars.start)
    { 
        print("Start");        
        return true;
    }      
}
 
 
// Will reset the timer on the start of the intro cinematic (maybe change this in the future)
reset
{
    if (old.location == vars.oldReset && current.location == vars.reset)
    {
        print("Reset");
        return true;
    } 
}
 
// AutoSplits
split
{
    // Split end
    if (old.location == vars.oldEnd && current.location == vars.end)
    {
        print("End");
        return true;
    }

    return false;     
}
 
// Will print every location changes
update
{         
    if (current.location != old.location)
    {
        print("location: " + current.location);
    }
}

