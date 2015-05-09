-- For RocketMania's stuff
/*
if D3DCarFontInstalled then return end
D3DCarFontInstalled = true
*/

local Fonts = {}
	Fonts["RXCarFont_CoolV"] = "coolvetica"
	Fonts["RXCarFont_Treb"] = "Trebuchet MS"
	Fonts["RXCarFont_Cour"] = "Courier New"
	Fonts["RXCarFont_Verd"] = "Verdana"
	Fonts["RXCarFont_Ari"] = "Arial"
	Fonts["RXCarFont_Taho"] = "Tahoma"
	Fonts["RXCarFont_Luci"] = "Lucida Console"
	
	
for a,b in pairs(Fonts) do
	for k=10,70 do
		surface.CreateFont( a .. "LW_S"..k,{font = b,size = k,weight = 1,antialias = true})
		surface.CreateFont( a .. "LWOut_S"..k,{font = b,size = k,weight = 1,antialias = true,outline = true})
		
		surface.CreateFont( a .. "_S"..k,{font = b,size = k,weight = 700,antialias = true})
		surface.CreateFont( a .. "Out_S"..k,{font = b,size = k,weight = 700,antialias = true,outline = true})
	end
end