local buttons = {circle=nil, square=nil, x=nil, up=nil, select=nil, right=nil, left=nil, triangle=nil, l2=nil, l3=nil, r2=nil, l1=nil, start=nil, r1=nil, down=nil, r3=nil}

buttons["l1"] = 1

function WaitForFrames(n)

	for i=0,n do
		joypad.set(1, buttons)
		emu.frameadvance()
	end

end

function Youpie()

	local rng = math.random(5)
	
	if rng == 1 then
		buttons["up"] = 1
	elseif rng == 2 then
		buttons["down"] = 1
	elseif rng == 3 then
		buttons["left"] = 1
	elseif rng == 4 then
		buttons["right"] = 1
	else
		buttons["up"] = 1
		buttons["down"] = 1
		buttons["left"] = 1
		buttons["right"] = 1
	end
	
	WaitForFrames(2)
	
	buttons["up"] = nil
	buttons["down"] = nil
	buttons["left"] = nil
	buttons["right"] = nil
	WaitForFrames(2)	

end

while true do
	Youpie()
	emu.frameadvance()
end