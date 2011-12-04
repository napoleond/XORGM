package xorgm {
	
	import flash.display.*;
	import flash.events.Event;
	
	class Chart extends MovieClip {
		//Chart properties
		private var _id:String;
		private var _pieces:Object = new Object();
		private var _arrows:Object = new Object();
		
		public function Chart ():void {
			_id=new String();
		}
		
		public function build(xChart:XML):void {
			
			_id=xChart.@id;
			
			//creates list of pieces in current org chart
			var pieceList:XMLList = xChart.piece;
			
			//for each piece in the current org chart
			for each (var piece:XML in pieceList) {
				//try to build piece
				try {
					pieces[piece.@id] = new Piece();
					this.addChild(pieces[piece.@id]);
					pieces[piece.@id].fromXorgM(piece);
					pieces[piece.@id].buildChartItem();
				} catch (e:Error) {
					trace("Error adding piece " + piece.@id + " : " + e);
				}
				
			}
			
			var arrowList:XMLList = xChart.arrow;
			
			//for each arrow in the current org chart
			for each (var arrow:XML in arrowList) {
				//try to build arrow
				try {
					arrows[arrow.@id] = new Arrow();
					this.addChild(arrows[arrow.@id]);
					arrows[arrow.@id].fromXorgM(arrow);
					arrows[arrow.@id].buildChartItem();
				} catch (e:Error) {
					trace("Error adding arrow " + arrow.@id + " : " + e);
				}
				
			}
			
		}
		
		//Chart's very own toXorgM function
		public function toXorgM():XML {
			var chart:XML =
				<chart id="">
				</chart>
			chart.@id=id;
			//loop through and add xml for pieces and arrows
			for each (var piece:Piece in pieces) {
				chart.appendChild(piece.toXorgM());
			}
			for each (var arrow:Arrow in arrows) {
				chart.appendChild(arrow.toXorgM());
			}
			return chart;
		}
		
		//GET id
		public function get id():String {
			return _id;
		}
		public function set id(value:String):void {
			_id = value;
		}
		
		//GET AND SET pieces and arrows
		public function get pieces():Object {
			return _pieces;
		}
		
		public function set pieces(value:Object):void {
			_pieces = value;
		}
		
		public function get arrows():Object {
			return _arrows;
		}
		
		public function set arrows(value:Object):void {
			_arrows = value;
		}
	}
	
}