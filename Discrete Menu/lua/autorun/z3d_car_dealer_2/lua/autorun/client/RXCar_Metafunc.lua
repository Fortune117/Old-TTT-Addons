local meta = FindMetaTable("Panel")
function meta:DrawBoarder(width,col)
	width = width or 1
	col = col or Color(0,125,255,255)
	
	surface.SetDrawColor( col )
	surface.DrawRect( 0, 0, self:GetWide(), width )
	surface.DrawRect( 0, self:GetTall()-width, self:GetWide(), width )
	surface.DrawRect( 0, 0, width, self:GetTall() )
	surface.DrawRect( self:GetWide()-width, 0, width, self:GetTall() )
end

function meta:RXCAR_PaintListBarC(bCol,iCol)
	local bCol = bCol or Color(100,100,100,255)
	local bCol2 = Color(150,150,150,255)
	
	self.VBar.btnDown.Paint = function(selfk)
		surface.SetDrawColor( bCol2.r,bCol2.g,bCol2.b,255 )
		surface.DrawRect( 0, 0, selfk:GetWide(), selfk:GetTall() )
	end
	self.VBar.btnUp.Paint = function(selfk)
		surface.SetDrawColor( bCol2.r,bCol2.g,bCol2.b,255 )
		surface.DrawRect( 0, 0, selfk:GetWide(), selfk:GetTall() )
	end
	self.VBar.btnGrip.Paint = function(selfk)
		surface.SetDrawColor( bCol.r,bCol.g,bCol.b,255 )
		surface.DrawRect( 0, 0, selfk:GetWide(), selfk:GetTall() )
	end
	self.VBar.Paint = function(selfk)
	end
end



	function String_Wrap(str,sizeX,font,data)
		local Result = data or {}
		surface.SetFont(font)
		-- 길이 체크
		local EntireWidth, Height = surface.GetTextSize(str)
		local EntireLength = string.len(str)
		

			for LengthCheck1 = 1, EntireLength do
				local ScanStr = string.Left(str,LengthCheck1)
				local ScanWidth,_ = surface.GetTextSize(ScanStr)
				if ScanWidth >= sizeX then
					local PreviousWord = string.Left(str,LengthCheck1 -1)
					local LastWord = string.Right(str,EntireLength - LengthCheck1+1)
					table.insert(Result,PreviousWord)
					return String_Wrap(LastWord,sizeX,font,Result)
				end
				if string.find(ScanStr,"!n") then
					local PreviousWord = string.Left(str,LengthCheck1)
					PreviousWord = string.gsub(PreviousWord,"!n","")
					local LastWord = string.Right(str,EntireLength - LengthCheck1)
					table.insert(Result,PreviousWord)
					return String_Wrap(LastWord,sizeX,font,Result)
				end
				
			end
			
			table.insert(Result,str)
			return Result
		
	end