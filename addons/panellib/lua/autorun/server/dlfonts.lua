
for k,v in pairs(file.Find("addons/panellib/resource/fonts/*.ttf", "GAME")) do 
	print("added", "resource/fonts/" .. v)
	resource.AddSingleFile("resource/fonts/" .. v)
end