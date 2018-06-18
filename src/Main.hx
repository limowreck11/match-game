import haxegon.*;

class Main {
	
	function init() {
		Gfx.resizescreen(768, 480);
		Text.font = "c64";
	}

	function update() {
		if (Mouse.leftclick()) {
			Scene.change(Match);
		}
        
		Text.size = 4;
		Text.align = Text.LEFT;
		Text.display(Text.CENTER, Gfx.screenheightmid - 30, "MATCH GAME", Col.WHITE);
		Text.size = 2;
		Text.display(Text.CENTER, Gfx.screenheightmid + 10, "LEFT CLICK TO START", Col.WHITE);
	}
}