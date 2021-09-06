
chat._state = not not chat._state

hook.Add("StartChat", "Tracker", function() chat._state = true end)
hook.Add("FinishChat", "Tracker", function() chat._state = false end)

function chat.IsOpen()
	return chat._state
end