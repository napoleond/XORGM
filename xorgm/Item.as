package xorgm {
	
	import flash.display.*;
	
	public class Item extends MovieClip {
		//define variable each item has
		private var _type:Array;
		private var _color:uint;
		private var _stroke:uint;
		private var _customStyle:String;
		private var _shape:String;
		private var _shapeStyle:Array;
		private var _filters:Array;
		
		public function Item ():void {
			//instantiate variable objects
			type = new Array();
			color=new uint;
			stroke=new uint;
			customStyle=new String();
			shape=new String();
			shapeStyle=new Array();
			filterStyle=new Array();
		}
		
		//this is the root of fromXorgM, overridden in each included class
		public function fromXorgM(xItem:XML):void {
			color=colorConvert(xItem.@color);
			stroke=colorConvert(xItem.@stroke);
			type = xItem.@type.split(", ");
			parseType(this);
		}
		
		//this is the root of toXorgM for all items in chart
		public function toXorgM():XML {
			//get tag name from data type
			var tag:String = this.toString().split(" ")[1];
			tag = tag.substring(0,tag.length-1).toLowerCase();
			var temp:XML =
				<{tag}>
				</{tag}>
			temp.@color=Item.colorXorgM(color);
			if (stroke as Boolean === true) {
				temp.@stroke=Item.colorXorgM(stroke);
			}
			//create type list for type attribute
			type = new Array();
			if (customStyle) type.push(customStyle);
			if (shape) type.push(shape);
			for each (var sst:String in shapeStyle) {
				type.push(sst);
			}
			for each (var fst:String in filterStyle) {
				type.push(fst);
			}
			temp.@type=type.join(", ");
			
			return temp;
		}
		
		//parse type array for any item
		public static function parseType(mc:Item) {
			for each (var style:String in mc.type) {
				switch (style) {
					//CUSTOM STYLE
					case "rock":
						mc.customStyle = style;
						break;
					
					//SHAPE
					case "arrow":
					case "rect":
					case "circle":
					case "line":
						mc.shape = style;
						break;
					
					//SHAPESTYLE
					case "round":
					case "bubble":
					case "dotted":
					case "dashed":
					case "fat":
					case "angle":
					case "curve":
					case "swish":
					case "flip":
						mc.shapeStyle.push(style);
						break;
					
					//FILTERS
					case "bevel":
					case "shadow":
					case "emboss":
						mc.filterStyle.push(style);
						break;
					case "stroke":
						if(mc.stroke) {
							mc.filterStyle.push(style);
						}
						break;
					
					default:
						trace(style + " is not a defined type");
						break;
				}
			}
		}
		
		//GET AND SET FUNCTIONS
		
		public function get type ():Array {
			return _type;
		}
		
		public function set type (value:Array):void {
			_type = value;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
		}
		
		public function get stroke():uint {
			return _stroke;
		}
		
		public function set stroke(value:uint):void {
			_stroke = value;
		}
		
		public function get customStyle():String {
			return _customStyle;
		}
		
		public function set customStyle(value:String):void {
			_customStyle = value;
		}
		
		public function get shape():String {
			return _shape;
		}
		
		public function set shape(value:String):void {
			_shape = value;
		}
		
		public function get shapeStyle():Array {
			return _shapeStyle;
		}
		
		public function set shapeStyle(value:Array):void {
			_shapeStyle = value;
		}
		
		public function get filterStyle():Array {
			return _filters;
		}
		
		public function set filterStyle(value:Array):void {
			_filters = value;
		}
		
		//converts "#FFFFFF" color code to "0xFFFFFF"
		public static function colorConvert (cStr:String):uint {
			return uint("0x"+cStr.substring(1));
		}
		
		//converts "0xFFFFFF" color code to "#FFFFFF"
		public static function colorXorgM (cInt:uint):String {
			return "#" + cInt.toString(16);
		}
		
	}
}