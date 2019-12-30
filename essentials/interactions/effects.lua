function AidsOn(player)
    if (AidsOff) then
        AidsOn = true
		SetPostEffect("ImageEffects", "VignetteIntensity", 1.0)
		SetPostEffect("Chromatic", "Intensity", 5.0)
		SetPostEffect("Chromatic", "StartOffset", 0.1)
		SetPostEffect("MotionBlur", "Amount", 0.05)
		SetPostEffect("MotionWhiteBalanceBlur", "Temp", 7000)
		SetCameraShakeRotation(0.0, 0.0, 1.0, 10.0, 0.0, 0.0)
		SetCameraShakeFOV(5.0, 5.0)
        PlayCameraShake(100000.0, 2.0, 1.0, 1.1)
    end
end
AddRemoteEvent("AidsOn", AidsOn, player)

function AidsOff()
if (AidsOn) then
    AidsOn = false
    SetPostEffect("ImageEffects", "VignetteIntensity", 0.25)
    SetPostEffect("Chromatic", "Intensity", 0.0)
    SetPostEffect("Chromatic", "StartOffset", 0.0)
    SetPostEffect("MotionBlur", "Amount", 0.0)
    SetPostEffect("MotionWhiteBalanceBlur", "Temp", 6500)
    StopCameraShake(false)
    end
end
AddRemoteEvent("AidsOff", AidsOff)
