VFS.Root:CreateFolder (GAuth.GetSystemId (), "Admins",
	function (returnCode, folder)
		folder:SetDeletable (false)
		folder:GetPermissionBlock ():SetInheritPermissions (GAuth.GetSystemId (), false)
		folder:GetPermissionBlock ():SetGroupPermission (GAuth.GetSystemId (), "Administrators", "Read",        GAuth.Access.Allow)
		folder:GetPermissionBlock ():SetGroupPermission (GAuth.GetSystemId (), "Administrators", "View Folder", GAuth.Access.Allow)
		
		local mountPaths =
		{
			"crashlogs",
			"logs",
			"data/asslog",
			"data/cadmin/logs",
			"data/DarkRP_logs",
			"data/ev_logs",
			"data/exsto/logs",
			"data/FAdmin_logs",
			"data/sv_logs",
			"data/ulx_logs"
		}
		local mountNames = {}
		mountNames ["data/cadmin/logs"] = "cadmin_logs"
		mountNames ["data/exsto/logs" ] = "exsto_logs"
		for _, realPath in ipairs (mountPaths) do
			VFS.RealRoot:GetChild (GAuth.GetSystemId (), realPath,
				function (returnCode, node)
					if returnCode ~= VFS.ReturnCode.Success then return end
					
					local name = mountNames [realPath] or ""
					if name == "" then name = node:GetName () end
					folder:Mount (name, node, name)
				end
			)
		end
		
		folder:CreateFolder (GAuth.GetSystemId (), "shared",
			function (returnCode, folder)
				folder:SetDeletable (false)
				folder:GetPermissionBlock ():SetGroupPermission (GAuth.GetSystemId (), "Administrators", "Create Folder", GAuth.Access.Allow)
				folder:GetPermissionBlock ():SetGroupPermission (GAuth.GetSystemId (), "Administrators", "Delete",        GAuth.Access.Allow)
				folder:GetPermissionBlock ():SetGroupPermission (GAuth.GetSystemId (), "Administrators", "Rename",        GAuth.Access.Allow)
				folder:GetPermissionBlock ():SetGroupPermission (GAuth.GetSystemId (), "Administrators", "Write",         GAuth.Access.Allow)
			end
		)
	end
)