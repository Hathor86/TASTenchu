LibHex = {}

local Vars = {}
Vars["char"] = ""
Vars["value"] = ""

Vars["ExponentOffset"] = 0
Vars["sign"] = 0
Vars["exponent"] = 0
Vars["mantissa"] = 0

Vars["integerPart"] = 0
Vars["decimalPart"] = 0

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

LibHex.ComputeIntegerBinary = function (binaryString)

	local value = 0
	for i = 1, string.len(binaryString) do
		value = value + tonumber(string.sub(binaryString,i , i)) * math.pow(2, string.len(binaryString) - i)
	end

	return value

end

LibHex.ComputeSignedIntegerBinary = function (binaryString)

	local value = 0
	local newBinaryString = ""

	if(string.sub(binaryString, 1 , 1) == "0") then

		value = LibHex.ComputeIntegerBinary(binaryString)

	else

		for i=1, string.len(binaryString) do

			if(tonumber(string.sub(binaryString, i , i)) == 0) then
				newBinaryString = newBinaryString .. "1"
			else
				newBinaryString = newBinaryString .. "0"
			end

		end
		value = LibHex.ComputeIntegerBinary(newBinaryString) * -1 -1

	end
	
	return value
end

LibHex.ComputeDecimalBinary = function (binaryString)

	local value = 0

	for i = 1, string.len(binaryString) do
		value = value + tonumber(string.sub(binaryString, i, i)) * math.pow(2, i * -1)
	end

	return value

end

LibHex.BinToFloat = function (binaryString)

	Vars["ExponentOffset"] = 127
	
	Vars["exponent"] = 0
	Vars["mantissa"] = 1
	
	if(string.sub(binaryString, 1, 1) == "0") then
		Vars["sign"] = 1
	else
		Vars["sign"] = -1
	end	
	
	Vars["exponent"] = LibHex.ComputeBinary(string.sub(binaryString, 2, 9))	
	Vars["exponent"] = Vars["exponent"] - Vars["ExponentOffset"]
	
	if(Vars["exponent"] == Vars["ExponentOffset"] * -1) then --denormalized number
		Vars["exponent"] = -126
		Vars["mantissa"] = 0
	end
	
	Vars["mantissa"] = ComputeDecimalBinary(string.sub(binaryString, 10))
	
	if(Vars["exponent"] == Vars["ExponentOffset"]) then
		if(Vars["mantissa"] == 0) then
			return math.huge --Infinity
		else
			return math.huge * 0 --NaN (Not a Number)
		end
	end
	
	return Vars["sign"] * math.pow(2, Vars["exponent"]) * Vars["mantissa"]
end

LibHex.BinToFixedPoint = function(binaryString, integerPart)
	
	Vars["integerPart"] = LibHex.ComputeSignedIntegerBinary(string.sub(binaryString, 1, integerPart))
	Vars["decimalPart"] = LibHex.ComputeDecimalBinary(string.sub(binaryString, integerPart + 1, string.len(binaryString)))
	
	return Vars["integerPart"] + Vars["decimalPart"]

end

LibHex.ToFloat = function (hexString)
	return LibHex.BinToFloat(LibHex.ToBin(hexString))
end

LibHex.ToFixedPoint = function (hexString, integerPart)
	return LibHex.BinToFixedPoint(LibHex.ToBin(hexString), integerPart)
end