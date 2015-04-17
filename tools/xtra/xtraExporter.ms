macroScript XtraExport Category:"Shiro" tooltip:"Add Extra Infos" buttontext:"XTRA"
(

	local somethingDone = false
	for m in Geometry do (
		if m.material == undefined then continue
		local diffuse = m.material.diffuseMap
		if diffuse == undefined then continue
		local coords = diffuse.coords
		local hasUVAnim = false
		local curU = 0.
		local curV = 0.
		local flip = 1
		/*
			when inverting faces, we have no way to tell that culling was flip and UV anim will go another way.
			Let's mark such objects with backfaceCull
		*/
		if m.backfaceCull then flip = -1
		local timeVal = animationRange.start.ticks
		local uvData = undefined
		for frame = animationRange.start to animationRange.end do (
			at time frame (			
				if curU != coords.U_offset or curV != coords.V_offset then (
					if not hasUVAnim then (
						somethingDone = true
						hasUVAnim = true
						uvData = "<uv>"					
						if timeVal != frame.ticks then uvData = uvData + "<f>"+(timeVal as string)+" "+(curU as string)+" "+(curV as string)+"</f>";
					)
					timeVal = frame.ticks
					curU = coords.U_offset * flip
					curV = coords.V_offset	* flip
					uvData = uvData + "<f>"+(timeVal as string)+" "+(curU as string)+" "+(curV as string)+"</f>";
				)
			)
		)

		if hasUVAnim then (
			setUserProp m "UV" (uvData+"</uv>");
		) else if getUserProp m "UV" != undefined then (
			local buf = getUserPropBuffer m
			setUserProp m "UV" "";
			buf = substituteString buf "UV = \r\n" ""
			setUserPropBuffer m buf
		)
	)
	if not somethingDone then (
		messageBox "No UV animation has been found"
	)
)
