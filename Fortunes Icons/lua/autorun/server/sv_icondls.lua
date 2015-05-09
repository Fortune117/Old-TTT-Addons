
function AddDir(directory)
	local files, folders = file.Find(directory.."/*", "GAME")
	for _, dir in pairs(folders) do
		if dir != ".svn" then
			AddDir(directory.."/"..dir)
		end
	end
	for k,v in pairs(files) do
		resource.AddFile(directory.."/"..v)
	end
end

AddDir( "materials/vgui/ttt/icons" )