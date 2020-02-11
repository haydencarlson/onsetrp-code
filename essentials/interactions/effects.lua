rapeon = false
function AidsOn(player)
    if (AidsOff) then
        AidsOn = true
		SetPostEffect("ImageEffects", "VignetteIntensity", 1.0)
		SetPostEffect("Chromatic", "Intensity", 5.0)
		SetPostEffect("Chromatic", "StartOffset", 0.1)
		SetPostEffect("MotionBlur", "Amount", 0.05)
		SetPostEffect("MotionWhiteBalanceBlur", "Temp", 7000)
		SetCameraShakeRotation(0.0, 0.0, 1.0, 5.0, 0.0, 0.0)
		SetCameraShakeFOV(2.0, 2.0)
        PlayCameraShake(50000.0, 2.0, 1.0, 1.1)
        CallEvent("clientdmg", player)
    end
end
AddRemoteEvent("AidsOn", AidsOn, player)

function AidsOff(player)
if (AidsOn) then
    AidsOn = false
    rapeon = false
    SetPostEffect("ImageEffects", "VignetteIntensity", 0.25)
    SetPostEffect("Chromatic", "Intensity", 0.0)
    SetPostEffect("Chromatic", "StartOffset", 0.0)
    SetPostEffect("MotionBlur", "Amount", 0.0)
    SetPostEffect("MotionWhiteBalanceBlur", "Temp", 6500)
    StopCameraShake(false)
    StartCameraFade(0, 0, 0, RGB(255, 0, 0))
    DestroyTimer(rapefct)
    end
end
AddRemoteEvent("AidsOff", AidsOff, player)

function Playerdmg(player)
    StartCameraFade(0.1, 0, 4.5, RGB(255, 0, 0))
   rapefct = CreateTimer(function(player)
    rapeon = true
        StartCameraFade(0, 0.1, 2.5, RGB(255, 0, 0))
       Delay(2000, function(player)
        if rapeon == true then
            StartCameraFade(0.1, 0, 2, RGB(255, 0, 0))
        else
            end
        end)
    end, 5000, player)
end
AddEvent("clientdmg", Playerdmg)