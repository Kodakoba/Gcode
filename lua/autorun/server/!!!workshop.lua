

--require("serversecure.core")
--[[
print("<---- required serversecure! ---->")
serversecure.EnableInfoCache(true)
serversecure.SetFakeMaxPlayerCount(96)
serversecure.SetFakePlayerCount(69)
serversecure.EnablePacketValidation(true)   --fakeplayer will not work without this
serversecure.EnablePlayerInfoCache(true)


print("fake player count on refresh:", serversecure.RefreshInfoCache())

]]
/*
print('requiring sourcenet')

require("sourcenet")
EnableLuaFileValidation(true)

print('required sourcenet')

--
hook.Add("SendLuaFileToClient", "UhOh", function(clnum, clstr, fileid, fn)
    print("doing for:", clnum, clstr, fileid, fn)
	if fn:find("basicpanels") then 
        print('found em boy')
		--return false, "fuckwits.lua"
	end 

end)

*/

local debuggingDownloads = false


local TTTaddons = {
    534491717,
    921953443,
    121287462,
    307624986,
    423895566,
    802015788,
    935770059,
    1291233400,
}
local Desaddons = {
    966444856

}
local Sandaddons={
    922947756
}

local BWAddons={
    160250458, --wire
    922947756, --synths
    349050451, --CW2.0
    358608166, --extra CW
    359830105, --unoff. extra CW
    354842171, --hk416 CW
    707343339, --cw melee
    404394772, --ppsh
    414514472, --sako
    296828130, --bw evocity
    506283460, --csgo kneivs
    546392647, --media players
    284266415,
    507707748, --whitesnow attachment pack
    757604550, --wos anim base
    876487668, --tfa ksg
    434019312, --bf4 #2
    852242061, --bf4 atts
    433547942, --bf4 #1
    415143062, --tfa base
    1597122290, --ak12 covertible
    1099499798, --scar l
    526188110, --scorpion evo,
    157621500, --pdw
    157173896, --mp5k
    605564693, --acr-e

    --TESTING NEW WEAPONS:
    374453458, --honey badger
    374790957, --aug
    631698506, --mk18
    657241323, --insurgency 2
    1166282010, --sg552
    838920776, --bullpup arsenal
    1106736515, --khris hcar
    255763250, --kriss vector
}




local subdirs = 0

local function indent(t)
    return string.rep("    ", t)
end

local function DownloadFolder(str, mask)
    local files, folders=file.Find(str .. (mask and "/" .. mask or "/*"),"MOD","namedesc")

    local root = false 

    if subdirs == 0 and debuggingDownloads then 
        root = true
        MsgC(Color(150, 150, 230), "Adding root folder: ", Color(200, 200, 200), str, "\n")
        subdirs = subdirs + 1
    end 

    for k,v in pairs(files) do

        if not string.find(v, "ztmp") then 
            resource.AddSingleFile(str .. "/" .. v)
            if debuggingDownloads then
                MsgC(Color(160, 230, 80), indent(subdirs), "Added file: ", Color(220, 220, 220), str .. "/" .. v .. "\n")
            end
        end

    end

    if not table.IsEmpty(folders) then 

        for k,v in pairs(folders) do

            if debuggingDownloads then
                MsgC("\n", indent(subdirs), Color(200, 250, 90),"Added folder: ", Color(220, 220, 220), str .. "/" .. v .. "\n")
                subdirs = subdirs+1
            end

            DownloadFolder(str .. "/" .. v)
            
            subdirs = subdirs - 1
        end

    end

    if root and debuggingDownloads then 
        subdirs = subdirs - 1 
        print("\n")
    end
end

timer.Simple(0, function()

    if gmod.GetGamemode().FolderName == "terrortown" then

        for i=1,#TTTaddons do
        resource.AddWorkshop(tostring(TTTaddons[i]))
        end

    print("TTT Workshop Loaded.")

    end

    if gmod.GetGamemode().FolderName == "deception" then

        for i=1,#Desaddons do
        resource.AddWorkshop(tostring(Desaddons[i]))
        end

    print("Deception Workshop Loaded.")
    end

    if gmod.GetGamemode().FolderName == "sandbox" then

        for i=1,#Sandaddons do
        resource.AddWorkshop(tostring(Sandaddons[i]))
        end

    print("Sandbox Workshop Loaded.")
    end


    if gmod.GetGamemode().FolderName:find("basewars") then

        for i=1,#BWAddons do
        resource.AddWorkshop(tostring(BWAddons[i]))
        end

        DownloadFolder("sound/gachi")

        DownloadFolder("sound/dash")

        DownloadFolder('sound/snds')

        DownloadFolder('sound/playsound')

        DownloadFolder("materials/vgui/prestige")

        DownloadFolder("materials/vgui/runes")

        DownloadFolder("materials/vgui/misc")

        DownloadFolder("models/player/wiltos")

        DownloadFolder("materials/grp")
        DownloadFolder("materials/zerochain")
        DownloadFolder("materials/models/props/computers")

        DownloadFolder("models/grp")
        DownloadFolder("models/zerochain")

        DownloadFolder("resource/fonts", "*.ttf")

        DownloadFolder("sound/mus")
        
        DownloadFolder("sound/vgui")
    end
end)


