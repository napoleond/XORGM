package xorgm {
	
	import flash.display.*;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	public class Link extends Item {
		//extra Link properties
		private var _rel:String;
		private var _tget:String;
		private var head:MovieClip;
		
		public function Link ():void {
			//instantiate variable objects
			relation = new String();
			target = new String();
			color = Theme.lineColor;
			shape = Theme.lineShape;
		}
		
		//adds to Item's fromXorgM
		public override function fromXorgM(xLink:XML):void {
			relation = xLink.@rel?xLink.@rel:"child";
			target = xLink.@target;
			//call to item's fromXorgM
			super.fromXorgM(xLink);
			if (!shape) shape="line";
			if (!color) color=0x000000;
		}
		
		//overrides Item's toXorgM
		public override function toXorgM():XML {
			var link:XML = super.toXorgM();
			//adds link attributes
			link.@rel = relation;
			link.@target = target;
			return link;
		}
		
		//line types
		private function line(stX:Number, stY:Number, endX:Number, endY:Number) {
			var lineLength:Number = Math.sqrt((endX-stX)*(endX-stX)+(endY-stY)*(endY-stY));
			var dashLength:Number = 0;
			if (shapeStyle.indexOf("dotted") >= 0) {
				dashLength = 2;
			} else if (shapeStyle.indexOf("dashed") >= 0) {
				dashLength = 5;
			} else {
				dashLength = lineLength;
			}
			dashLength*=2;
			for (var i:uint = 0; i <= uint(lineLength/dashLength); i++) {
				this.graphics.moveTo(stX+(endX-stX)*i*dashLength/lineLength,stY+(endY-stY)*i*dashLength/lineLength);
				this.graphics.lineTo(stX+(endX-stX)*(i+0.5)*dashLength/lineLength,stY+(endY-stY)*(i+0.5)*dashLength/lineLength);
			}
		}
		
		//make link
		public function make(owner:Piece):void {
			//clear lines
			this.graphics.clear();
			//define start and end points
			var st:Point = globalToLocal(new Point(owner.x+owner.width/2+ChartWindow(owner.stage.nativeWindow).workFrame.whiteBoard.x,owner.y+owner.height/2+ChartWindow(owner.stage.nativeWindow).workFrame.whiteBoard.y));
			var end:Point = globalToLocal(new Point(Chart(owner.parent).pieces[target].x+Chart(owner.parent).pieces[target].width/2+ChartWindow(owner.stage.nativeWindow).workFrame.whiteBoard.x,Chart(owner.parent).pieces[target].y+Chart(owner.parent).pieces[target].height/2+ChartWindow(owner.stage.nativeWindow).workFrame.whiteBoard.y));
			if(ChartWindow(owner.stage.nativeWindow).charts[owner.id]) {
				var chBounds:Rectangle = owner.getBounds(ChartWindow(owner.stage.nativeWindow).charts[owner.id]);
				st = new Point(chBounds.x+chBounds.width/2+owner.x,chBounds.y+chBounds.height/2+owner.y);
			}
			if(ChartWindow(owner.stage.nativeWindow).charts[target]) {
				chBounds = Chart(owner.parent).pieces[target].getBounds(ChartWindow(owner.stage.nativeWindow).charts[target]);
				end = new Point(chBounds.x+chBounds.width/2+Chart(owner.parent).pieces[target].x,chBounds.y+chBounds.height/2+Chart(owner.parent).pieces[target].y);
			}
				
			//line thickness
			this.graphics.lineStyle(1,color);
			if (shapeStyle.indexOf("fat") >= 0) {
				this.graphics.lineStyle(10,color);
			}
			//link types
			switch (relation) {
				case "sib":
					this.line(st.x,st.y,end.x,end.y);
					if (shape == "arrow") {
						if (!head) head = new mcArrowHead();
						var theta:Number = Math.atan2(end.y-st.y,end.x-st.x);
						head.rotation = theta*180/Math.PI;
						head.scaleX = 0.12;
						head.scaleY = 0.12;
						if (Chart(owner.parent).pieces[target].shape == "circle") {
							head.x = end.x - Chart(owner.parent).pieces[target].width/2*Math.cos(theta);
							head.y = end.y - Chart(owner.parent).pieces[target].width/2*Math.sin(theta);
						} else if ( Math.abs(theta) <= Math.atan2(Chart(owner.parent).pieces[target].height,Chart(owner.parent).pieces[target].width) || Math.abs(Math.PI-Math.abs(theta)) < Math.atan2(Chart(owner.parent).pieces[target].height,Chart(owner.parent).pieces[target].width) ) {
							if (end.x>st.x) {
								head.x = end.x - Chart(owner.parent).pieces[target].width/2;
							} else {
								head.x = end.x + Chart(owner.parent).pieces[target].width/2;
							}
							head.y = end.y - (Chart(owner.parent).pieces[target].width/2)*(end.y-st.y)/Math.abs(end.x-st.x);
						} else {
							head.x = end.x - (Chart(owner.parent).pieces[target].height/2)*(end.x-st.x)/Math.abs(end.y-st.y);
							if (end.y>st.y) {
								head.y = end.y - Chart(owner.parent).pieces[target].height/2;
							} else {
								head.y = end.y + Chart(owner.parent).pieces[target].height/2;
							}
						}
						this.addChild(head);
					}
					this.parent.setChildIndex(this, 0);
					break;
				case "sub":
					this.line(st.x,st.y,st.x,end.y);
					this.line(st.x,end.y,end.x,end.y);
					if (shape == "arrow") {
						if (st.x<end.x) {
							if (!head) head = new mcArrowHead();
							head.rotation = 0;
							head.scaleX = 0.12;
							head.scaleY = 0.12;
							head.x = end.x - Chart(owner.parent).pieces[target].width/2;
							head.y = end.y;
							this.addChild(head);
						} else {
							if (!head) head = new mcArrowHead();
							head.rotation = 180;
							head.scaleX = 0.12;
							head.scaleY = 0.12;
							head.x = end.x + Chart(owner.parent).pieces[target].width/2;
							head.y = end.y;
							this.addChild(head);
						}
					}
					this.parent.setChildIndex(this, 0);
					break;
				case "child":
					this.line(st.x,st.y,st.x,(st.y+end.y)/2);
					this.line(st.x,(st.y+end.y)/2, end.x,(st.y+end.y)/2);
					this.line(end.x,(st.y+end.y)/2, end.x,end.y);
					if (shape == "arrow") {
						if (!head) head = new mcArrowHead();
						head.rotation = 90;
						head.scaleX = 0.12;
						head.scaleY = 0.12;
						head.x = end.x;
						head.y = end.y - Chart(owner.parent).pieces[target].height/2;
						this.addChild(head);
					}
					this.parent.setChildIndex(this, 0);
					break;
				default:
					trace(relation + "is not a valid link relation type");
					break;
			}
			if (head) {
				var lColor:ColorTransform = head.transform.colorTransform;
				lColor.color = color;
				head.transform.colorTransform = lColor;
			}
		}
		
		//GET AND SET FUNCTIONS
		
		public function get relation ():String {
			return _rel;
		}
		
		public function set relation (value:String):void {
			_rel = value;
		}
		
		public function get target ():String {
			return _tget;
		}
		
		public function set target (value:String):void {
			_tget = value;
		}
		
	}
}