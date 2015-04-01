macroScript XtraExport Category:"Shiro" tooltip:"Xtra Export" buttontext:"XTRA"
(
	function export file = (
		format "Exporting %" file
		deleteFile file
		local f = createFile file
		local somethingDone = false
		format "<xtra>\n" to:f
		for m in Geometry do (
			if m.material == undefined then continue
			local diffuse = m.material.diffuseMap
			if diffuse == undefined then continue
			local coords = diffuse.coords
			local hasUVAnim = false
			local curU = 0.
			local curV = 0.	
			local timeVal = animationRange.start.ticks
			for frame = animationRange.start to animationRange.end do (
				at time frame (			
					if curU != coords.U_offset or curV != coords.V_offset then (
						if not hasUVAnim then (
							somethingDone = true
							hasUVAnim = true
							format "<uv name='%'>\n" m.name to:f
							if timeVal != frame.ticks then format "<f>% % %</f>\n" timeVal curU curV to:f
						)
						timeVal = frame.ticks
						curU = coords.U_offset
						curV = coords.V_offset				
						format "<f>% % %</f>\n" timeVal curU curV to:f
					)
				)
			)
			if hasUVAnim then format "</uv>\n" to:f
		)
		format "</xtra>" to:f
		close f
		if not somethingDone then (
			messageBox "No UV animation has been found"
			deleteFile file
		)
	)

	local fileName = getSaveFileName caption:"Save XTRA to:" types:"Xtra file(*.xtra)|*.xtra" filename:(substituteString maxFileName ".max" ".xtra")
	if fileName != undefined then export fileName
)
