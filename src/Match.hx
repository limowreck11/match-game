package;

import haxegon.*;

/**
 * A matching game.
 * 
 * @author limowreck11
 */
class Match {

	static var border_width:Int = 32;
	static var border_height:Int = 32;
	static var max_tiles_horizontal:Int = 4;
	static var max_tiles_vertical:Int = 3;
	static var default_tile_width:Int = 64;
	static var default_tile_height:Int = 64;
	static var num_tiles:Int = 12;
	static var freeze_frame_limit:Int = 20;
	static var images:Array<String> = ["bear", "cat", "chicken", "dog", "duck", "elephant", "fox", "mouse", "penguin", "pig", "rabbit", "tiger"];
	
	var tiles:Array<Tile>;
	var selected_tiles:Array<Tile>;
	var freeze_frames:Int;
	var num_solved_tiles:Int;
	
	function init() {
		if (num_tiles > (max_tiles_horizontal * max_tiles_vertical)) {
			throw "Too many tiles";
		}
		
		if (num_tiles % 2 > 0) {
			throw "Odd number of tiles";
		}
		
		var screen_width_minus_border:Int = Gfx.screenwidth - (border_width * 2);
		var screen_height_minus_border:Int = Gfx.screenheight - (border_width * 2);
		
		var pad_x:Float = screen_width_minus_border / Geom.min(num_tiles, max_tiles_horizontal);
		var pad_y:Float = screen_height_minus_border / Geom.min((num_tiles / max_tiles_horizontal), max_tiles_vertical);
		
		var image_pool:Array<String> = [];
		image_pool = image_pool.concat(images.copy().splice(0, Convert.toint(num_tiles / 2)));
		image_pool = image_pool.concat(images.copy().splice(0, Convert.toint(num_tiles / 2)));
		Random.shuffle(image_pool);
		tiles = [];
		for (i in 0 ... num_tiles) {
			var tile_x_pos:Int = i % max_tiles_horizontal;
			var tile_y_pos:Int = Convert.toint(Geom.floor((Convert.tofloat(i) / max_tiles_horizontal)));
			var tile_x:Float = border_width + (tile_x_pos * (pad_x + 1));
			var tile_y:Float = border_height + (tile_y_pos * (pad_y + 1));
			var im:String = image_pool.pop();
			var tile_image:String = im;
			var tile:Tile = new Tile(tile_x, tile_y, default_tile_width, default_tile_height, tile_image);
			tiles.push(tile);
		}
		
		selected_tiles = [];
		freeze_frames = 0;
		num_solved_tiles = 0;
	}
	
	function update() {
		if (num_solved_tiles == tiles.length) {
			Scene.change(MatchWin);
			init();
		}
		
		Gfx.clearscreen(Col.rgb(0, 0, 128));
		
		if (Mouse.leftclick() && freeze_frames <= 0) {
			for (tile in tiles) {
				if (Mouse.x > tile.x && Mouse.y > tile.y 
				&& Mouse.x < tile.x + tile.width 
				&& Mouse.y < tile.y + tile.height
				&& !tile.solved && !Lambda.has(selected_tiles, tile)) {
					tile.flipped = true;
					selected_tiles.push(tile);
				}
			}
		}
		
		if (selected_tiles.length >= 2) {
			if (freeze_frames >= freeze_frame_limit) {
				if (selected_tiles[0].image == selected_tiles[1].image) {
					Gfx.clearscreen(Col.rgb(0, 128, 0));
					selected_tiles[0].solved = true;
					num_solved_tiles++;
					selected_tiles[1].solved = true;
					num_solved_tiles++;
				} else {
					Gfx.clearscreen(Col.rgb(128, 0, 0));
				}
				selected_tiles[0].flipped = false;
				selected_tiles[1].flipped = false;
				selected_tiles = [];
				freeze_frames = 0;
			} else {
				freeze_frames++;
			}
		}
		
		for (i in 0 ... num_tiles) {
			tiles[i].draw();
		}
	}
}

class Tile {
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public var image:String;
	public var flipped:Bool;
	public var solved:Bool;
	
	public function new(x, y, width, height, image) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.image = image;
		this.flipped = false;
		this.solved = false;
	}
	
	public function draw() {
		if (flipped || solved) {
			Gfx.fillbox(x, y, width, height, Col.WHITE);
			Gfx.scale(Geom.min(width, height) / 256);
			Gfx.drawimage(x, y, image);
		} else {
			Gfx.fillbox(x, y, width, height, Col.WHITE);
		}
	}
	
	public function toString() {
		return "Tile(" + x + "," + y 
			+ "," + width + "," + height 
			+ "," + image + ")";
	}
}