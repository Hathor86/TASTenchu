LibHex = {}

local Vars = {}
Vars["char"] = ""
Vars["value"] = ""

Vars["ExponentOffset"] = 0
Vars["sign"] = 0
Vars["exponent"] = 0
Vars["mantissa"] = 0
Vars["temp"] = ""

LibHex.ToBin = function(hexString)
	Vars["char"] = ""
	Vars["value"] = ""	
	
	if(string.len(hexString) < 8) then
		hexString = string.gsub(string.format("%8s", hexString)," ","0")
	end
	
	for i = 1, string.len(hexString) do
	
		Vars["char"] = string.sub(hexString, i, i)
		
		if(Vars["char"] == "0") then
			Vars["value"] = Vars["value"] .. "0000"
			
		elseif(Vars["char"] == "1") then
			Vars["value"] = Vars["value"] .. "0001"
			
		elseif(Vars["char"] == "2") then
			Vars["value"] = Vars["value"] .. "0010"
			
		elseif(Vars["char"] == "3") then
			Vars["value"] = Vars["value"] .. "0011"
			
		elseif(Vars["char"] == "4") then
			Vars["value"] = Vars["value"] .. "0100"
			
		elseif(Vars["char"] == "5") then
			Vars["value"] = Vars["value"] .. "0101"
			
		elseif(Vars["char"] == "6") then
			Vars["value"] = Vars["value"] .. "0110"
			
		elseif(Vars["char"] == "7") then
			Vars["value"] = Vars["value"] .. "0111"
			
		elseif(Vars["char"] == "8") then
			Vars["value"] = Vars["value"] .. "1000"
			
		elseif(Vars["char"] == "9") then
			Vars["value"] = Vars["value"] .. "1001"
			
		elseif(Vars["char"] == "A") then
			Vars["value"] = Vars["value"] .. "1010"
			
		elseif(Vars["char"] == "B") then
			Vars["value"] = Vars["value"] .. "1011"
			
		elseif(Vars["char"] == "C") then
			Vars["value"] = Vars["value"] .. "1100"
			
		elseif(Vars["char"] == "D") then
			Vars["value"] = Vars["value"] .. "1101"
			
		elseif(Vars["char"] == "E") then
			Vars["value"] = Vars["value"] .. "1110"
			
		elseif(Vars["char"] == "F") then
			Vars["value"] = Vars["value"] .. "1111"
			
		else
			Vars["value"] = error("Unrecognize")
		end
		
	end
	
	return Vars["value"]
	
end

LibHex.BinToFloat = function (binaryString)

	Vars["ExponentOffset"] = 127
	
	Vars["exponent"] = 0
	Vars["mantissa"] = 1
	Vars["temp"] = ""
	
	if(string.sub(binaryString, 1, 1) == "0") then
		Vars["sign"] = 1
	else
		Vars["sign"] = -1
	end
	
	Vars["temp"] =  string.sub(binaryString, 2, 9) --getting binary exponent value
	for i = 1,8 do --computing it
		Vars["exponent"] = Vars["exponent"] + tonumber(string.sub(Vars["temp"],i , i)) * math.pow(2,8-i)
	end
	Vars["exponent"] = Vars["exponent"] - Vars["ExponentOffset"]
	
	if(Vars["exponent"] == Vars["ExponentOffset"] * -1) then --denormalized number
		Vars["exponent"] = -126
		Vars["mantissa"] = 0
	end
	
	Vars["temp"] = string.sub(binaryString, 10) --getting binary exponent value
	for i = 1, string.len(Vars["temp"]) do --computing it
		Vars["mantissa"] = Vars["mantissa"] + tonumber(string.sub(Vars["temp"], i, i)) * math.pow(2, i * -1)
	end
	
	if(Vars["exponent"] == Vars["ExponentOffset"]) then
		if(Vars["mantissa"] == 0) then
			return math.huge --Infinity
		else
			return math.huge * 0 --NaN (Not a Number)
		end
	end
	
	return Vars["sign"] * math.pow(2, Vars["exponent"]) * Vars["mantissa"]
end

LibHex.ToFloat = function (hexString)
	return LibHex.BinToFloat(LibHex.ToBin(hexString))
end

local x

while true do

	x = memory.readdword(0xA5D62)
	x = LibHex.ToFloat(string.format("%X", x))
	gui.text(5, 25, string.format("Thing: %s", x))
	emu.frameadvance()

end