local scrollCount = 0
local bombCount = 0
local mineCount = 0

local elapsedTime = 0

local spottedCounter = 0
local detectedKills = 0
local stealthKills = 0

while true do
	scrollCount = memory.readbytesigned(0x00010419)
	bombCount = memory.readbytesigned(0x00010410)
	mineCount = memory.readbytesigned(0x00010412)

	elapsedTime = memory.readdwordsigned(0x000944C0)

	spottedCounter = memory.readbytesigned(0x0009591A)
	detectedKills = memory.readbytesigned(0x0009591C)
	stealthKills = memory.readbytesigned(0x00095918)	
	--Left info
	gui.text(5, 25, string.format("Rerecord: %d", movie.rerecordcount()))	
	gui.text(5, 75, string.format("Elapsed Time: %.3f", elapsedTime / 60))
	
	--Right info
	gui.text(250, 25, string.format("Scrolls: %d\nBombs: %d\nMines: %d",scrollCount,bombCount,mineCount))
	gui.text(250, 55,string.format("Spotted: %d\nDetected Kills: %d\nStealth Kills: %d", spottedCounter, detectedKills, stealthKills))
	emu.frameadvance()
end