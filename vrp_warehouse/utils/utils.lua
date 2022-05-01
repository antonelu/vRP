function DrawText3D(x,y,z, text, scl, font)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z);
    local px,py,pz = table.unpack(GetGameplayCamCoords());
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1);

    local scale = (1/dist)*scl;
    local fov = (1/GetGameplayCamFov()) * 100;
    local scale = scale*fov;
    
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end