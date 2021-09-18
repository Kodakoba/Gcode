setfenv(1, _G)

local NOOOOO_MY_GARBAGE_COLLECTION = { type = '2D' }

function cam.Start2D()
	return cam.Start(NOOOOO_MY_GARBAGE_COLLECTION)
end

local NOOOOO_MY_GARBAGE_COLLECTION_3d = { type = '3D' }

function cam.Start3D( pos, ang, fov, x, y, w, h, znear, zfar )
	local tab = NOOOOO_MY_GARBAGE_COLLECTION_3d

	tab.origin = pos
	tab.angles = ang
	tab.fov = fov
	tab.x			= x
	tab.y			= y
	tab.w			= w
	tab.h			= h
	tab.aspect		= w and h and ( w / h ) or nil
	tab.znear	= znear
	tab.zfar	= zfar

	return cam.Start( tab )
end