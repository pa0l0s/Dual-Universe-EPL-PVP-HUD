local numFormat = {}

function numFormat.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
end

function numFormat.distanceFormat(distance, custom, showSU)
	local formattedDistance = {}
	if custom ~= nil then
		if distance >= 100000 and showSU then
			formattedDistance.number = numFormat.round(distance / 1000 / 200 , 2)
			formattedDistance.unit = 'SU'
		elseif distance >= custom then
			formattedDistance.number = numFormat.round(distance / 1000, 2)
			formattedDistance.unit = 'KM'
		else
			formattedDistance.number = math.ceil(distance)
			formattedDistance.unit = 'M'
		end
	else
		if distance >= 100000 then
			formattedDistance.number = numFormat.round(distance / 1000 / 200 , 2)
			formattedDistance.unit = 'SU'
		elseif distance > 1000 then
			formattedDistance.number = numFormat.round(distance / 1000, 2)
			formattedDistance.unit = 'KM'
		else
			formattedDistance.number = math.ceil(distance)
			formattedDistance.unit = 'M'
		end
	end
	return formattedDistance
end

function numFormat.speedFormat(speed)
	local formattedSpeed = {}
	formattedSpeed.number = math.ceil(speed * 3.6)
	formattedSpeed.unit = 'KM/h'
	return formattedSpeed
end

function numFormat.volumeFormat(quantity, noreduce)
	local formattedQuantity = {}
	if noreduce == 1 then
		formattedQuantity.number = numFormat.round(quantity / 1000, 2)
		formattedQuantity.unit = 'kL'
	else
		if quantity > 1000 then
			formattedQuantity.number = numFormat.round(quantity / 1000, 2)
			formattedQuantity.unit = 'kL'
		else
			formattedQuantity.number = math.ceil(quantity)
			formattedQuantity.unit = 'L'
		end
	end
	return formattedQuantity
end

function numFormat.massFormat(quantity)
	local formattedQuantity = {}
	if quantity > 1000000 then
		formattedQuantity.number = numFormat.round(quantity / 1000 / 1000, 2)
		formattedQuantity.unit = 'kt'
	elseif quantity > 1000 then
		formattedQuantity.number = numFormat.round(quantity / 1000, 2)
		formattedQuantity.unit = 't'
	else
		formattedQuantity.number = math.ceil(quantity)
		formattedQuantity.unit = 'kg'
	end
	return formattedQuantity
end

function numFormat.forceFormat(quantity)
	local formattedQuantity = {}
	formattedQuantity.number = numFormat.round(quantity / 1000, 2)
	formattedQuantity.unit = 'kN'
	return formattedQuantity
end

function numFormat.fuelFormat(seconds)
	local formattedFuel = {}
	if seconds == 'n/a' then
		formattedFuel.number = 'n/a'
		formattedFuel.unit = ''
	elseif seconds > 356400 then
		formattedFuel.number = 99
		formattedFuel.unit = 'h'
	elseif seconds >= 36000 then
		formattedFuel.number = math.floor(seconds / 3600)
		formattedFuel.unit = 'h'
	elseif seconds >= 3600 then
		formattedFuel.number = numFormat.round(seconds / 3600, 1)
		formattedFuel.unit = 'h'
	elseif seconds >= 60 then
		formattedFuel.number = numFormat.round(seconds / 60, 1)
		formattedFuel.unit = 'm'
	else
		formattedFuel.number = math.floor(seconds)
		formattedFuel.unit = 's'
	end
	return formattedFuel
end

return numFormat