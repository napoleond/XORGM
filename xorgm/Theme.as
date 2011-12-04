package xorgm {
	class Theme {
		//declare static constant theme names as strings
		internal static const LEAD:String = "Leadership";
		internal static const MGMT:String = "Management";
		internal static const OPS:String = "Operations";
		internal static const COMS:String = "Communications";
		
		//default theme = leadership
		public static var current:String = LEAD;
		
		//arrow styles and piece styles as hash objects
		public static var arrowStyles:Object = new Object();
		public static var pieceStyles:Object = new Object();
		
		//color, background and stroke arrays
		public static var colors:Array = new Array();
		public static var bgs:Array = new Array();
		public static var strokes:Array = new Array();
		
		//default line shape and color
		public static var lineShape:String = "line";
		public static var lineColor:uint = 0;
		
		//initialize xml objects for piece and arrow
		private static var pStyle:XML;
		private static var aStyle:XML;
		
		//this function is called when the theme is initialized or changed
		internal static function remake ():void {
			
			//sets available object values depending on current theme
			switch(current) {
				case LEAD:
				
					colors = [0x000000, 0xFFFFFF];
					bgs = [0x000000, 0x808080, 0xCCCCCC, 0xFFFFFF, 0x741112, 0x8B2800, 0xD13C00, 0xF55D20, 0x463912, 0xAE8E2C, 0xF4C73E, 0xF8DC86, 0x320E00, 0x631D00, 0x853D20, 0xA87460];
					strokes = [0x631D00, 0xF55D20];
					
					pStyle =
						<piece>
						</piece>
					pieceStyles[current] = pStyle;
					pieceStyles[current].@color = Item.colorXorgM(colors[1]);
					pieceStyles[current].@bg = Item.colorXorgM(bgs[8]);
					pieceStyles[current].@stroke = Item.colorXorgM(strokes[1]);
					pieceStyles[current].@type = "rect, round, bevel";
					
					aStyle =
						<arrow>
						</arrow>
					arrowStyles[current] = aStyle;
					arrowStyles[current].@color = Item.colorXorgM(colors[1]);
					arrowStyles[current].@bg = Item.colorXorgM(bgs[4]);
					arrowStyles[current].@stroke = Item.colorXorgM(strokes[1]);
					arrowStyles[current].@type = "arrow, bevel";
					
					break;
				case MGMT:
					
					colors = [0x000000, 0xFFFFFF];
					bgs = [0x000000, 0x808080, 0xCCCCCC, 0xFFFFFF, 0x431645, 0x5E1F61, 0x76277A, 0xA537AB, 0x223C6A, 0x234F9C, 0x5E84C9, 0xAEC2E4, 0x613502, 0xAB5E04, 0xF7931E, 0xFBB03B];
					strokes = [0xAB5E04, 0xA537AB];
					
					pStyle =
						<piece>
						</piece>
					pieceStyles[current] = pStyle;
					pieceStyles[current].@color = Item.colorXorgM(colors[1]);
					pieceStyles[current].@bg = Item.colorXorgM(bgs[8]);
					pieceStyles[current].@stroke = Item.colorXorgM(strokes[1]);
					pieceStyles[current].@type = "rect, round, bevel";
					
					aStyle =
						<arrow>
						</arrow>
					arrowStyles[current] = aStyle;
					arrowStyles[current].@color = Item.colorXorgM(colors[1]);
					arrowStyles[current].@bg = Item.colorXorgM(bgs[4]);
					arrowStyles[current].@stroke = Item.colorXorgM(strokes[1]);
					arrowStyles[current].@type = "arrow, bevel";
					
					break;
				case OPS:
					
					colors = [0x000000, 0xFFFFFF];
					bgs = [0x000000, 0x808080, 0xCCCCCC, 0xFFFFFF, 0x182D44, 0x47709C, 0x7594B5, 0xBAC9DA, 0x2D1024, 0x441837, 0x7B5570, 0xBDAAB7, 0x613502, 0xAB5E04, 0xF7931E, 0xFBB03B];
					strokes = [0xAB5E04, 0xBAC9DA];
					
					pStyle =
						<piece>
						</piece>
					pieceStyles[current] = pStyle;
					pieceStyles[current].@color = Item.colorXorgM(colors[1]);
					pieceStyles[current].@bg = Item.colorXorgM(bgs[8]);
					pieceStyles[current].@stroke = Item.colorXorgM(strokes[1]);
					pieceStyles[current].@type = "rect, round, bevel";
					
					aStyle =
						<arrow>
						</arrow>
					arrowStyles[current] = aStyle;
					arrowStyles[current].@color = Item.colorXorgM(colors[1]);
					arrowStyles[current].@bg = Item.colorXorgM(bgs[4]);
					arrowStyles[current].@stroke = Item.colorXorgM(strokes[1]);
					arrowStyles[current].@type = "arrow, bevel";
					
					break;
				case COMS:
					
					colors = [0x000000, 0xFFFFFF];
					bgs = [0x000000, 0x808080, 0xCCCCCC, 0xFFFFFF, 0x2A3A04, 0x537507, 0x759727, 0x9CB565, 0x00033A, 0x000575, 0x4044A6, 0x9FA2D3, 0x3A0800, 0x751100, 0x973120, 0xA64E40];
					strokes = [0x751100, 0x9CB565];
					
					pStyle =
						<piece>
						</piece>
					pieceStyles[current] = pStyle;
					pieceStyles[current].@color = Item.colorXorgM(colors[1]);
					pieceStyles[current].@bg = Item.colorXorgM(bgs[8]);
					pieceStyles[current].@stroke = Item.colorXorgM(strokes[1]);
					pieceStyles[current].@type = "rect, round, bevel";
					
					aStyle =
						<arrow>
						</arrow>
					arrowStyles[current] = aStyle;
					arrowStyles[current].@color = Item.colorXorgM(colors[1]);
					arrowStyles[current].@bg = Item.colorXorgM(bgs[4]);
					arrowStyles[current].@stroke = Item.colorXorgM(strokes[1]);
					arrowStyles[current].@type = "arrow, bevel";
					
					break;
				default:
					trace(current + "is not a defined theme");
					break;
			}
			
		}
	}
}