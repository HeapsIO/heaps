
class Video extends hxd.App {

	var video : h2d.Video;
	var tf : h2d.Text;

	override function init() {
		tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		video = new h2d.Video(s2d);
		video.onError = function(e) {
			tf.text = e;
			tf.textColor = 0xFF0000;
		};
		function start() {
			#if hl
			video.load("testVideo.avi");
			#elseif js
			video.load("testVideo.mp4");
			#end
		}
		video.onEnd = start;
		start();
	}

	override function update(dt:Float) {
		if( video.videoWidth != 0 && video.videoHeight != 0 ) {
			tf.text = (Std.int(video.time*10)/10)+"s";
			var scale = hxd.Math.min(s2d.width / video.videoWidth, s2d.height / video.videoHeight);
			video.setScale(scale);
			video.x = Std.int((s2d.width - video.videoWidth * scale) * 0.5);
			video.y = Std.int((s2d.height - video.videoHeight * scale) * 0.5);
		}
	}

	static function main() {
		new Video();
	}

}