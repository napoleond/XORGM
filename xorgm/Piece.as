package xorgm {
	
	import flash.display.*;
	
	class Piece extends ChartItem {
		//extra Piece properties
		private var _id:String;
		private var _links:Object;
		
		public function Piece ():void {
			id=new String();
			//instantiate links object
			links = new Object;
		}
		
		//overrides ChartItem's fromXorgM
		public override function fromXorgM(xPiece:XML):void {
			id=xPiece.@id;
			
			//call to ChartItem's fromXorgM
			super.fromXorgM(xPiece);
			
			if (!shape) shape="rect";
			
			//loop through and add links
			for each (var link:XML in xPiece.link) {
				try {
					links[link.@target] = new Link();
					parent.addChild(links[link.@target]);
					links[link.@target].fromXorgM(link);
				} catch (err:Error) {
					trace("error adding link to " + id + ": " + err);
				}
			}
			
		}
		
		//overrides ChartItem's toXorgM
		public override function toXorgM():XML {
			var xPiece:XML = super.toXorgM();
			xPiece.@id=id;
			//add link nodes
			for each (var link:Link in links) {
				xPiece.appendChild(link.toXorgM());
			}
			return xPiece;
		}
		
		//GET / SET
		
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
		public function get links ():Object {
			return _links;
		}
		
		public function set links (value:Object):void {
			_links = value;
		}
		
	}
	
}