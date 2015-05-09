D3DCarConfig = D3DCarConfig or {}

//================ IMPORTANT

D3DCarConfig.DarkRPIs2_5_0 = true
-- if u using DarkRP 2.5.0 ( or higher ) set this to ' true '
-- if not, Set this to 'false' 



//================ CAR DEALERS

D3DCarConfig.CarSpawnRange = 500
D3DCarConfig.CarStoreRange = 500
-- Spawn and Store Range.

D3DCarConfig.EnterTheCarAfterSpawn = true
-- Ride your car instantly.

D3DCarConfig.LockCarAfterSpawn = true
-- Prevent your cars be stealed.
-- This will not work if the EnterTheCarAfterSpawn is set to true.

D3DCarConfig.PlayerCanPickupVehicles = false -- ' true ' or ' false '
-- So. if you set this to ' false ' , player can't pickup cars with physics gun.

D3DCarConfig.PlayerMaxCarAmount = 1
-- People can spawn Only 1 car in your server. if they spawn more cars, other car will be removed(saved) and new car will be spawned.

D3DCarConfig.Check_Remove_JobOnlyCars = true
-- if this set to true, this prevent player getting police cars even if they are not police.
-- if they change job to something from police, police car will be removed.

function D3DCarConfig:IsAdmin(ply)
	local ULXGroups = {"superadmin","owner","admin"} -- LOWERCASE.
	
	if table.HasValue(ULXGroups,ply:GetNWString("usergroup")) then
		return true
	end
end
-- Define Admin. admin can save car dealer position and can pickup other player's cars with their physicsgun


//======= Spawn Mode ========//
D3DCarConfig.SpawnMode = 1
	-- Top-View placer : 1
	-- Spot based place : 2
	
D3DCarConfig.SpotDistanceCheck = 150 -- if there are cars or players in 150 range, ( in spot ) the spot can't be used as a place to spawn cars.
D3DCarConfig.SpawnSpots = {}
	-- spawns car at these position. system will choose random spot where is empty. if these spots are full, will not spawned
	table.insert(D3DCarConfig.SpawnSpots,Vector(271.71505737305,2.7288997173309,-12287.96875))
	table.insert(D3DCarConfig.SpawnSpots,Vector(197.9947052002,-337.36456298828,-12287.96875))
	table.insert(D3DCarConfig.SpawnSpots,Vector(610.94775390625,-486.03530883789,-12287.96875))
	
//======= Spawn Mode ========//

D3DCarConfig.Sort = 2
	-- 1 : Z ~ A
	-- 2 : A ~ Z