function customDistance(distance)
    distanceS=''
 if distance < 1000 then
                     distanceS = ''..string.format('%0.0f', distance)..' m'
                   elseif distance < 100000 then
                     distanceS = ''..string.format('%0.1f', distance/1000)..' km'
                   else
                    distanceS = ''..string.format('%0.2f', distance/200000)..' su' 
                    end
    return distanceS
    end

                function getClosestPlanet(wp)
                    --trouve la planete la plus proche d'une WorldPos
                    local ClosestPlanet={}
                    ClosestPlanet.distance=999999999999
                    for BodyId in pairs(atlas[0]) do
                        local planet=atlas[0][BodyId]
                        local distance=(vec3(planet.center)-wp):len()
                        if math.min(ClosestPlanet.distance,distance)==distance then
                            ClosestPlanet.name=planet.name[1]
                            ClosestPlanet.distance=distance
                        end
                    end
                    return ClosestPlanet.name,ClosestPlanet.distance
                end

                function getClosestPipe(wp,startLocation)                
                    --trouve le pipe le plus proche d'une WorldPos partant de startLocation
                    local ClosestPlanet={}
                    ClosestPlanet.pipedistance=999999999999
                    for BodyId in pairs(atlas[0]) do
                        local stopLocation=atlas[0][BodyId]
                        local pipe=vec3(startLocation.center) - vec3(stopLocation.center)
                        local pipedistance=(wp - vec3(startLocation.center)):project_on_plane(pipe):len()
                        if math.min(ClosestPlanet.pipedistance,pipedistance)==pipedistance and (vec3(startLocation.center)-wp):len()<pipe:len() and (vec3(stopLocation.center)-wp):len()<pipe:len() then
                            ClosestPlanet.pipename=stopLocation.name[1]
                            ClosestPlanet.pipedistance=pipedistance
                        end
                    end
                    return ClosestPlanet.pipename, ClosestPlanet.pipedistance
                end

                function getSafeZoneDistance(wp)
                    --calcule la distance vers la safe zone (negative=into safe zone)
                    local CenterSafeZone = vec3(13771471, 7435803, -128971)
                    local distance=math.floor(((wp-CenterSafeZone):len()-18000000))
                    return distance
                end

function zeroConvertToWorldCoordinates(pos,system) -- Many thanks to SilverZero for this.
                    local num  = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
                    local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'    
                    local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern)
                
                if systemId==nil or bodyId==nil or latitude==nil or longitude==nil or altitude==nil then
                        system.print("POS неверный!")
                        destination_bm=""
                        return vec3()
                end
                    
                    if (systemId == "0" and bodyId == "0") then
                        --convert space bm
                        return vec3(latitude,
                                    longitude,
                                    altitude)
                    end
                    longitude = math.rad(longitude)
                    latitude = math.rad(latitude)
                    local planet = atlas[tonumber(systemId)][tonumber(bodyId)]  
                    local xproj = math.cos(latitude);   
                    local planetxyz = vec3(xproj*math.cos(longitude),
                                          xproj*math.sin(longitude),
                                             math.sin(latitude));
                    return vec3(planet.center) + (planet.radius + altitude) * planetxyz
                end

function zeroConvertToWorldCoordinatesG(pos,system) -- Many thanks to SilverZero for this.
                    local num  = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
                    local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'    
                    local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern)
                
                if systemId==nil or bodyId==nil or latitude==nil or longitude==nil or altitude==nil then
                        system.print("POS неверный!")
                        return {0, 0, 0}
                end
                    
                    if (systemId == "0" and bodyId == "0") then
                        --convert space bm
                        return {tonumber(latitude), tonumber(longitude), tonumber(altitude)}
                    end
                    longitude = math.rad(longitude)
                    latitude = math.rad(latitude)
                    local planet = atlas[tonumber(systemId)][tonumber(bodyId)]  
                    local xproj = math.cos(latitude);   
                    local planetxyz = vec3(xproj*math.cos(longitude),
                                          xproj*math.sin(longitude),
                                             math.sin(latitude));
                    return {(planet.center + (planet.radius + altitude) * planetxyz):unpack()}
                end