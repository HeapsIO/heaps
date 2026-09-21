package h3d.pass;

class RectangleShadowMap extends ProjectedShadowMap {

	override function targetName() : String {
		return "rectangleShadowMap";
	}

	override function updateCamera() {
		var absPos = light.getAbsPos();
		var rectangleLight = cast(light, h3d.scene.pbr.RectangleLight);
		var ldir = absPos.front();
		lightCamera.pos.set(absPos.tx, absPos.ty, absPos.tz);
		lightCamera.target.set(absPos.tx + ldir.x, absPos.ty + ldir.y, absPos.tz + ldir.z);

		inline function axisLen(x : Float, y : Float, z : Float) : Float {
			return Math.sqrt(x * x + y * y + z * z);
		}

		var range = rectangleLight.range;
		var halfWidth = rectangleLight.width * 0.5 * axisLen(absPos._21, absPos._22, absPos._23);
		var halfHeight = rectangleLight.height * 0.5 * axisLen(absPos._31, absPos._32, absPos._33);
		var tanX = (halfWidth + rectangleLight.getSpread(rectangleLight.horizontalAngle)) / range;
		var tanY = (halfHeight + rectangleLight.getSpread(rectangleLight.verticalAngle)) / range;

		lightCamera.fovY = hxd.Math.radToDeg(2 * Math.atan(tanY));
		lightCamera.screenRatio = tanX / tanY;
		lightCamera.zNear = range * 0.05;
		lightCamera.zFar = range;
		lightCamera.update();
	}
}
