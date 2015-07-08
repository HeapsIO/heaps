
macroScript XtraExport Category:"Shiro" tooltip:"Add Extra Infos" buttontext:"XTRA"
(

	fn setProp m p v = (
		local buf = substituteString (substituteString (getUserPropBuffer m) "\r\n" "\n") "\r" "\n"
		local props = filterString buf "\n"
		local found = false
		for pid in 1 to props.count do (		
			local pname = substituteString ((filterString (props[pid]) "=")[1]) " " ""
			if pname == p then (
				found = true
				if v == undefined then props[pid] = "" else props[pid] = p+"="+v
			)
		)
		if (not found) and v != undefined then append props (p+"="+v)	
		buf = ""
		for i in 1 to props.count do (
			if props[i] == "" then continue
			buf = buf + props[i]+"\r\n"
		)
		setUserPropBuffer m buf
	)

	fn unsetProp m p = (
		setProp m p undefined
	)

	local somethingDone = false

	local tcount = FrameTagManager.GetTagCount()
	
	if tcount > 0 then (
		for m in Geometry do unsetProp m "Events"
		local evData = "<el>"
		for i = 1 to tcount do (
			local tid = FrameTagManager.GetTagID i
			local ttime = FrameTagManager.GetTimeByID tid
			local tname = FrameTagManager.GetNameByID tid
			evData = evData + "<e>"+(ttime as string)+" "+tname+"</e>";
		)
		setProp Geometry[1] "Events" (evData + "</el>")
		somethingDone = true
	)
	
	for m in Geometry do (
		unsetProp m "UV"
		if m.material == undefined then continue
		local diffuse = undefined
		try diffuse = m.material.diffuseMap catch ()
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
		if hasUVAnim then setProp m "UV" (uvData+"</uv>")
	)
	if not somethingDone then (
		messageBox "No XTRA info has been found"
	)
)


