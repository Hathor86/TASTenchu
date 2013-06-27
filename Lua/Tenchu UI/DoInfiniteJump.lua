local buttons = {circle=nil, square=nil, x=nil, up=nil, select=nil, right=nil, left=nil, triangle=nil, l2=nil, l3=nil, r2=nil, l1=nil, start=nil, r1=nil, down=nil, r3=nil}

local jumpCount = 3

function WaitForFrames(n)

	for i=0,n do
		joypad.set(1, buttons)
		emu.frameadvance()
	end

end

function DoJump(n)

	buttons["up"] = 1
	WaitForFrames(2)
	
	buttons["up"] = nil
	WaitForFrames(2)
	
	buttons["up"] = 1
	WaitForFrames(2)
	
	buttons["x"] = 1
	WaitForFrames(2)
	
	buttons["x"] = nil
	buttons["up"] = nil
	
	WaitForFrames(70)
	
	buttons["x"] = 1
	WaitForFrames(2)
	
	for i=0,n do
		buttons["x"] = nil
		WaitForFrames(70)
		buttons["x"] = 1
		WaitForFrames(2)
	end

end

DoJump(10)
emu.pause()
