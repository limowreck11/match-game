package;

import haxegon.*;

/**
 * ...
 * @author limowreck11
 */
class MatchWin {

	function init() {
		Text.font = "c64";
	}
	
	public function update() {
		if (Mouse.leftclick()) {
			Scene.change(Match);
		}
        
		Text.size = 4;
		Text.align = Text.LEFT;
		Text.display(Text.CENTER, Gfx.screenheightmid - 30, "YOU WIN!", Col.WHITE);
		Text.size = 2;
		Text.display(Text.CENTER, Gfx.screenheightmid + 10, "LEFT CLICK TO RESTART", Col.WHITE);
	}
	
}