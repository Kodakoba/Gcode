local function includec(file) 
    AddCSLuaFile(file) 
    if CLIENT then 
    	include(file)
    end
end

includec("cl_unimenu.lua")