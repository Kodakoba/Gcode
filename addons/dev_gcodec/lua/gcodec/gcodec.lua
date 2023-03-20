if GCodec then return end
GCodec = GCodec or {}

include ("glib/glib.lua")
include ("gooey/gooey.lua")
pcall (include, "gcompute/gcompute.lua")

GLib.Initialize ("GCodec", GCodec)
GLib.AddCSLuaPackSystem ("GCodec")
GLib.AddCSLuaPackFile ("autorun/gcodec.lua")
GLib.AddCSLuaPackFolderRecursive ("gcodec")

include ("codec.lua")

-- Resource Locators
include ("defaultresourcelocator.lua")

-- Models
include ("models/model.lua")
include ("models/modelpart.lua")
include ("models/mesh.lua")
include ("models/objreader.lua")

-- Source Engine
GCodec.Source = {}
GCodec.Source.MDL = {}
GCodec.Source.PHY = {}
GCodec.Source.VVD = {}
GCodec.Source.VTX = {}

include ("source/mdl/header.lua")
include ("source/vvd/header.lua")
include ("source/vvd/boneweightdata.lua")
include ("source/vvd/vertex.lua")
include ("source/vtx/header.lua")
include ("source/vtx/bodypart.lua")
include ("source/vtx/model.lua")
include ("source/vtx/lod.lua")
include ("source/vtx/mesh.lua")
include ("source/vtx/stripgroup.lua")
include ("source/vtx/strip.lua")
include ("source/vtx/vertex.lua")
include ("source/mdlreader.lua")

GCodec.AddReloadCommand ("gcodec/gcodec.lua", "gcodec", "GCodec")

if CLIENT then
	GCodec.IncludeDirectory ("gcodec/ui")
end