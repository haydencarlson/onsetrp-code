local added = false
local added2 = false
local added3 = false

function OnPackageStart()
    local newmat = LoadPak("newmat", "/newmat/", "../../../OnsetModding/Plugins/newmat/Content")
    AddPlayerChat(tostring(onemat))
    local PakName = "newmat"
    AddPlayerChat("Pak exists: ".. tostring(DoesPakExist(PakName)) and "True" or "False" .. ".")
    for k, v in pairs(GetAllFilesInPak(PakName)) do
    AddPlayerChat("Pak file: ".. tostring(v) .. "")
    end
end
AddEvent("OnPackageStart", OnPackageStart)

function OnKeyPress(key)
    if key == "J" then
        added = not added
        if added then
          local poste = AddPostProcessMaterial("pmats", UMaterialInterface.LoadFromAsset("/newmat/CelShader/Materials/CelShaderForward"))
          AddPlayerChat(tostring(poste))
        else
            RemovePostProcessMaterial("pmats")
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function OnPackageStart()
    local posteffects = LoadPak("posteffects", "/posteffects/", "../../../OnsetModding/Plugins/posteffects/Content")
    AddPlayerChat(tostring(onemat))
    local PakName = "posteffects"
    AddPlayerChat("Pak exists: ".. tostring(DoesPakExist(PakName)) and "True" or "False" .. ".")
    for k, v in pairs(GetAllFilesInPak(PakName)) do
    AddPlayerChat("Pak file: ".. tostring(v) .. "")
    end
end
AddEvent("OnPackageStart", OnPackageStart)

function OnKeyPress(key)
    if key == "H" then
        added2 = not added2
        if added2 then
          local posted = AddPostProcessMaterial("pe", UMaterialInterface.LoadFromAsset("/posteffects/PostProcess/PPM_TS_Pixelize"))
          AddPlayerChat(tostring(posted))
        else
            RemovePostProcessMaterial("pe")
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function OnKeyPress(key)
    if key == "N" then
        added3 = not added3
        if added3 then
          local postedi = AddPostProcessMaterial("pei", UMaterialInterface.LoadFromAsset("/posteffects/PostProcess/Instances/PPM_TS_Pixelize_CrossStitch"))
          AddPlayerChat(tostring(postedi))
        else
            RemovePostProcessMaterial("pei")
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)
