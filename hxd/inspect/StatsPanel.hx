package hxd.inspect;

class StatsPanel extends Panel {

	public function new() {
		super("stats", "Statistics");
	}

	override function initContent() {
		super.initContent();
		j.html('
			<table>
				<tr>
					<th class="title" colspan="2">Renderer</th>
				</tr>
				<tr>
					<th>Framerate</th>
					<td id="fps">0</td>
				</tr>
				<tr>
					<th>Draw Calls</th>
					<td id="calls">0</td>
				</tr>
				<tr>
					<th>Drawn Triangles</th>
					<td id="tris">0</td>
				</tr>

				<tr>
					<th class="title" colspan="2">Memory</th>
				</tr>
				<tr>
					<th>
						<span>Total</span>
						<span id="totMemCount"></span>
					</th>
					<td id="totMem"></td>
				</tr>
				<tr>
					<th class="button hidden">
						<i class="fa fa-arrow-right"/>
						<span id="bufMemTitle">Buffers</span>
						<span id="bufMemCount"></span>
					</th>
					<td id="bufMem"></td>
				</tr>
				<tr>
					<th class="button hidden">
						<i class="fa fa-arrow-right"/>
						<span id="texMemTitle">Textures</span>
						<span id="texMemCount"></span>
					</th>
					<td id="texMem"></td>
				</tr>
			</table>
		');

		for( b in j.find("th.button").elements() ) {
			b.click(function(_) {
				b.toggleClass("hidden");
				var i = b.children("i");
				i.toggleClass("fa-arrow-right");
				i.toggleClass("fa-arrow-down");
			});
		}
	}

	function showMemoryDetails( button : vdom.JQuery ) {
		var id = button.find("span").getAttr("id");
		button.parent().parent().find(".detail_" + id).remove();

		#if !debug
			if(!button.hasClass("hidden")) {
				var newElement = j.query("<tr>");
				newElement.addClass("detail_" + id);
				newElement.html("<th class='debug' colspan='2'>(Debug mode only)</th>");
				newElement.insertAfter(button.parent());
			}
		#else
			if(!button.hasClass("hidden")) {
				var engine = h3d.Engine.getCurrent();
				var m = new Map();
				@:privateAccess switch(id) {
					case "bufMemTitle":
						for( b in engine.mem.buffers ) {
							var b = b;
							while( b != null ) {
								var buf = b.allocHead;
								while( buf != null ) {
									var mem = buf.buffer.stride * buf.vertices * 4;
									var name = buf.allocPos.className + ":" + buf.allocPos.lineNumber;
									var p = m.get(name);
									if( p == null ) {
										p = { count : 0, mem : 0, name : name };
										m.set(name, p);
									}
									p.count++;
									p.mem += mem;
									buf = buf.allocNext;
								}
								b = b.next;
							}
						}
					case "texMemTitle":
						for( t in engine.mem.textures ) {
							var mem = t.width * t.height * 4;
							var name = t.allocPos.fileName + ":" + t.allocPos.lineNumber;
							var p = m.get(name);
							if( p == null ) {
								p = { count : 0, mem : 0, name : name };
								m.set(name, p);
							}
							p.count++;
							p.mem += mem;
						}
					default: null;
				}

				var elements = [for( k in m ) k];
				elements.sort(function(e1, e2) return e1.mem - e2.mem);
				for( e in elements) {
					var newElement = j.query("<tr>");
					newElement.addClass("subMem");
					newElement.addClass("detail_" + id);
					newElement.html("<th>" + e.name + "<span>[" + e.count + "]</span></th><td>" + fmtSize(e.mem) + "</td>");
					newElement.insertAfter(button.parent());
				}
			}
		#end
	}

	function fmtSize( size : Float ) {
		size /= 1024;
		return size > 1024 ? Math.fmt(size / 1024) + " MB" : Math.ceil(size) + " KB";
	}

	inline function numberFormat(v : Int) {
		var tmp = Std.string(v);
		var n = Math.ceil(tmp.length / 3);
		var str = "";
		for( i in 0...n) {
			if(str != "") str = " " + str;
			var start = tmp.length - 3 * (i + 1);
			str = Std.string(tmp.substring(Math.imax(0, start), start + 3)) + str;
		}
		return Std.string(str);
	}

	override function sync() {
		var engine = h3d.Engine.getCurrent();
		var p = j;

		p.find("#fps").text(Std.string(engine.fps));
		p.find("#calls").text(numberFormat(engine.drawCalls));
		p.find("#tris").text(numberFormat(engine.drawTriangles));

		var bufMem = p.find("#bufMem");
		var texMem = p.find("#texMem");
		var totMem = p.find("#totMem");
		var bufMemTitle = p.find("#bufMemTitle");
		var texMemTitle = p.find("#texMemTitle");
		var bufMemCount = p.find("#bufMemCount");
		var texMemCount = p.find("#texMemCount");
		var totMemCount = p.find("#totMemCount");

		var stats = engine.mem.stats();
		var idx = (stats.totalMemory - (stats.textureMemory + stats.managedMemory));
		var sum : Float = idx + stats.managedMemory;
		var freeMem : Float = stats.freeManagedMemory;
		var totTex : Float = stats.textureMemory;
		var totalMem : Float = stats.totalMemory;

		bufMem.text(fmtSize(sum) + " (" + fmtSize(freeMem) + " free)");
		texMem.text(fmtSize(totTex));
		totMem.text(fmtSize(totalMem));
		bufMemTitle.text("Buffers");
		bufMemCount.text("[" + Std.string(stats.bufferCount) + "]");
		texMemTitle.text("Textures");
		texMemCount.text("[" + Std.string(stats.textureCount) + "]");
		totMemCount.text("[" + Std.string(stats.bufferCount + stats.textureCount) + "]");

		for( b in p.find("th.button").elements() )
			showMemoryDetails(b);
	}

}