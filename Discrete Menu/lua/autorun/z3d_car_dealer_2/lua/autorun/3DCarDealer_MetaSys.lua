local meta = FindMetaTable("Player")
D3DCar_Meta = {}

if SERVER then
	function D3DCar_Meta:Notify(ply,text)
		if D3DCarConfig.DarkRPIs2_5_0 then
			DarkRP.notify( ply, 2,5, text)
		else
			GAMEMODE:Notify( ply, 2,5, text)
		end
		ply:ChatPrint(text)
	end
	function meta:RXCarNotify(text)
		D3DCar_Meta:Notify(self,text)
	end
	
	function D3DCar_Meta:AddMoney(ply,amount)
		if D3DCarConfig.DarkRPIs2_5_0 then
			ply:addMoney(amount)
		else
			ply:AddMoney(amount)
		end
	end
	function D3DCar_Meta:OwnCar(ply,carent)
		if D3DCarConfig.DarkRPIs2_5_0 then
			carent:CPPISetOwner(ply)
			carent:keysOwn(ply)
		else
			carent:Own(ply)
		end
	end
end


function D3DCar_Meta:GetMoney(ply)
	return (ply.DarkRPVars.money or 0)
end