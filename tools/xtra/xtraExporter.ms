macroScript XtraExport Category:"Shiro" tooltip:"Xtra Export" buttontext:"XTRA"
(

fn f_URLEncode _STR =
(
dotnet.loadassembly "System.Web"
dotnet.loadassembly "System.Text"
local httpUtility = dotnetClass "System.Web.HttpUtility"
local enc = dotnetClass "System.Text.Encoding"
local urlEncodedString = httpUtility.UrlEncode _STR enc.UTF8
return urlEncodedString
)

	function export file = (
		format "Exporting %\n" file
		deleteFile file
		local f = createFile file
		local somethingDone = false
		format "<xtra>\n" to:f
		local sel = getCurrentSelection()
		if sel.count == 0 then sel = Geometry
		for m in sel do (
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
			for frame = animationRange.start to animationRange.end do (
				at time frame (			
					if curU != coords.U_offset or curV != coords.V_offset then (
						if not hasUVAnim then (
							somethingDone = true
							hasUVAnim = true
							local name = f_URLEncode(m.name)
							format "<uv name='%'>\n" name to:f
							if timeVal != frame.ticks then format "<f>% % %</f>\n" timeVal curU curV to:f
						)
						timeVal = frame.ticks
						curU = coords.U_offset * flip
						curV = coords.V_offset	* flip
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
