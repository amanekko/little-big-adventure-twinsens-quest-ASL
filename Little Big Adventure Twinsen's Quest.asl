state("LittleBigAdventureTwinsensQuest")
{
}

startup
{       
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.GameName = "Little Big Adventure - Twinsen's Quest";
}

init
{
    vars.oldScene = "";
    vars.currentScene = "";
    vars.introFadeCount = 0; // Tracks the number of fades during the intro
    vars.inIntro = false; // Tracks if the game is in intro


	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
        vars.Helper["m_sceneID"] = mono.Make<int>("GameHandler", 1, "s_instance", "m_state", "m_sceneID");
        vars.Helper["m_playIntro"] = mono.Make<bool>("SceneHandler", 1, "s_instance", "m_playIntro");
        vars.Helper["m_fadeEndTime"] = mono.Make<float>("SceneHandler", 1, "s_instance", "m_fadeEndTime");
        
	    return true;
	});
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    vars.oldScene = vars.currentScene;
    vars.currentScene = vars.Helper.Scenes.Active.Name == null ? "" : vars.Helper.Scenes.Active.Name;

    if (vars.currentScene != vars.oldScene)
    {       
        print("[LBA TQ Autosplitter] Scene name: " + vars.currentScene);
    } 

    // increment intro fade counter (when the screen fades out and back in)
    if(current.m_fadeEndTime > 0 && old.m_fadeEndTime == 0 && vars.inIntro == true)
    {
        vars.introFadeCount++;
        print("[LBA TQ Autosplitter] Intro Fade Count: " + vars.introFadeCount);
    } 
    // reset intro fade counter 
    if(current.m_playIntro == true && old.m_playIntro == false)
    {
        vars.inIntro = true;        
        vars.introFadeCount = 0;
    }
    // end intro when fade count reaches 2 (the 2nd fade has completed)
    if (vars.introFadeCount == 2)
    {
        vars.inIntro = false;
    }
}

split
{
    // stop the timer on fade time no longer 0 when we were in last scene (not ideal condition)
    if(current.m_fadeEndTime > 0 && old.m_fadeEndTime == 0 && current.m_sceneID == 113 && old.m_sceneID == 113)
    {
        print("[LBA TQ Autosplitter] END");
        return true;
    } 
}

start
{
    // Start on the EXACT moment the 2nd fade sequence ENDS (goes from > 0 back to 0)
    if (vars.introFadeCount == 2)
    {        
        vars.introFadeCount = 0;
        print("[LBA TQ Autosplitter] START");
        return true;
    }
}

reset
{
    // Reset the timer and the fade counter ONLY when we just entered the intro 
    // (Prevents the timer from instantly resetting if m_playIntro is still true when starting)
    if(current.m_playIntro == true && old.m_playIntro == false)
    {
        print("[LBA TQ Autosplitter] RESET");
        return true;
    }
}
