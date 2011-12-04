package xorgm {
	
	//import goodies
	import flash.display.*;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	class Arrow extends ChartItem {
		//arrow properties
		private var _bottom:Number;
		private var _right:Number;
		private var _handles:Object;
		
		public function Arrow ():void {
			//instantiate property objects
			bottom=new Number();
			right=new Number();
		}
		
		//overrides ChartItem's fromXorgM
		public override function fromXorgM(xArrow:XML):void {
			//define properties
			bottom=xArrow.@bottom;
			right=xArrow.@right;
			
			//call ChartItem's fromXorgM
			super.fromXorgM(xArrow);
			
			//set shape string if necessary
			if (!shape) shape="arrow";
		}
		
		//overrides ChartItem's toXorgM
		public override function toXorgM():XML {
			//flip to normal for saving if necessary
			if (scaleY == -1) {
				scaleY *= -1;
				t.scaleY *= -1;
				t.y *= -1;
				if (shapeStyle.indexOf("flip") < 0) shapeStyle.push("flip");
			}
			var xArrow:XML = super.toXorgM();
			//adds extra arrow attributes
			var temp:Point = this.localToGlobal(new Point(this.handles[2].x,this.handles[2].y));
			bottom = temp.y-top-ChartWindow(this.stage.nativeWindow).workFrame.whiteBoard.y-((this.parent.parent is Piece)?this.parent.parent.y:0);
			right = temp.x-left-ChartWindow(this.stage.nativeWindow).workFrame.whiteBoard.x-((this.parent.parent is Piece)?this.parent.parent.x:0);
			xArrow.@bottom=bottom;
			xArrow.@right=right;
			for (var nameTest:String in Chart(this.parent).arrows) {
				if (this == Chart(this.parent).arrows[nameTest]) xArrow.@id = nameTest;
			}
			//flip back
			if (shapeStyle.indexOf("flip") >= 0) {
				scaleY *= -1;
				t.scaleY *= -1;
				t.y *= -1;
			}
			return xArrow;
		}
		
		//override chartitem buildchartitem
		public override function buildChartItem(wide:Number=150, high:Number=20.95):void {
			super.buildChartItem(wide, high);
			
			this.x = left;
			this.y = top;
			
			//if bottom and right are not set, set them
			if (isNaN(bottom) || isNaN(right)) {
				var temp:Point = new Point((shapeStyle.indexOf("angle") >= 0)?(this.width-50):this.width,(shapeStyle.indexOf("angle") >= 0)?(-this.height+21.55):0);
				bottom = temp.y;
				right = temp.x;
			}
			//if not angled arrow, set width as hypotenuse of bottom right
			if (shapeStyle.indexOf("angle") < 0) {
				var c:Number = Math.sqrt((bottom)*(bottom)+(right)*(right));
				this.getChildAt(0).width = c;
				t.width = c;
			} else {
				//set arrow size appropriately based on bottom right position
				if (bottom < 0 && right < 0) {
					this.getChildAt(0).width = Math.abs(bottom)+50;
					this.getChildAt(0).height = Math.abs(right);
					this.getChildAt(0).y = -Math.abs(right);
					t.width = Math.abs(bottom)+50;
				} else if (bottom < 0 && right >= 0) {
					this.getChildAt(0).width = Math.abs(right)+50;
					this.getChildAt(0).height = Math.abs(bottom);
					this.getChildAt(0).y = -Math.abs(bottom);
					t.width = Math.abs(right)+50;
				} else if (bottom >= 0 && right < 0) {
					this.getChildAt(0).width = Math.abs(right)+50;
					this.getChildAt(0).height = Math.abs(bottom);
					this.getChildAt(0).y = -Math.abs(bottom);
					t.width = Math.abs(right)+50;
				} else {
					this.getChildAt(0).width = Math.abs(bottom)+50;
					this.getChildAt(0).height = Math.abs(right);
					this.getChildAt(0).y = -Math.abs(right);
					t.width = Math.abs(bottom)+50;
				}
			}
			
			//if the handles aren't added, make them
			if (!handles) {
				handles = new Object();
				handles[1] = new MovieClip();
				handles[1].graphics.lineStyle(1);
				handles[1].graphics.beginFill(0xFFFFFF);
				handles[1].graphics.drawCircle(0,0,6);
				handles[1].graphics.endFill();
				handles[1].x = 0;
				handles[1].y = 0;
				this.addChild(handles[1]);
				handles[2] = new MovieClip();
				handles[2].graphics.lineStyle(1);
				handles[2].graphics.beginFill(0xFFFFFF);
				handles[2].graphics.drawCircle(0,0,6);
				handles[2].graphics.endFill();
				handles[2].x = (shapeStyle.indexOf("angle") >= 0)?(this.width-50):this.width;
				handles[2].y = (shapeStyle.indexOf("angle") >= 0)?-this.height+21.55:0;
				this.addChild(handles[2]);
			}
			handles[1].visible = false;
			handles[2].visible = false;
			
			//if angled arrow, rotate appropriately according to bottom, right positions
			if (shapeStyle.indexOf("angle") >= 0) {
				if (bottom < 0 && right < 0) {
					this.rotation = -90;
				} else if (bottom < 0 && right >= 0) {
					this.rotation = 0;
				} else if (bottom >= 0 && right < 0) {
					this.rotation = 180;
				} else {
					this.rotation = 90;
				}
			} else {
				//rotate arrow based on trigoooo
				this.rotation = Math.atan2((bottom),(right))*180/Math.PI;
			}
			
			//flip if necessary
			if (shapeStyle.indexOf("flip") >= 0) {
				scaleY = -1;
			}
			
			//rotate text appropriately
			if (Math.abs(this.rotation)>90) {
				t.scaleY = -1*scaleY;
				t.y = t.height/2*scaleY;
				t.scaleX = -1;
				t.x = handles[2].x;
				if (shapeStyle.indexOf("angle") >= 0) t.x = handles[2].x + 50;
			} else {
				t.scaleY = 1*scaleY;
				t.y = -t.height/2*scaleY;
				t.scaleX = 1;
				t.x = 0;
			}
		}
		
		//this function deals with the 2nd arrow being dragged
		internal static function handleBarMoustache(tangle:Event):void {
			tangle.currentTarget.parent.eDrag();
			
			//calculate arrow end points
			var from:Point = tangle.currentTarget.parent.localToGlobal(new Point(tangle.currentTarget.parent.handles[1].x,tangle.currentTarget.parent.handles[1].y));
			var to:Point = new Point(tangle.currentTarget.stage.stage.mouseX, tangle.currentTarget.stage.mouseY);
			
			//if angle, drag in 90 degree increments
			if (tangle.currentTarget.parent.shapeStyle.indexOf("angle") >= 0) {
				var acheck:Number = Math.atan2((to.y-from.y),(to.x-from.x))*180/Math.PI;
				if (acheck < -90) tangle.currentTarget.parent.rotation = -90;
				else if (acheck < 0) tangle.currentTarget.parent.rotation = 0;
				else if (acheck < 90) tangle.currentTarget.parent.rotation = 90;
				else tangle.currentTarget.parent.rotation = 180;
				if (tangle.currentTarget.parent.scaleY == -1) tangle.currentTarget.parent.rotation -= 90;
				var gridX:Number = 0;
				var gridY:Number = 0;
				//grid calculations
				if (ChartWindow(tangle.currentTarget.stage.nativeWindow).grid) {
					gridX = (to.x%10 >5)?10-to.x%10:-to.x%10;
					gridY = (to.y%10 >5)?10-to.y%10:-to.y%10;
				}
				var spot:Point = tangle.currentTarget.parent.globalToLocal(new Point(to.x+gridX,to.y+gridY));
				tangle.currentTarget.x = (spot.x>70)?spot.x:70;
				tangle.currentTarget.y = (spot.y<-100)?spot.y:-100;
				tangle.currentTarget.parent.getChildAt(0).width = tangle.currentTarget.x+50;
				tangle.currentTarget.parent.getChildAt(0).height = Math.abs(tangle.currentTarget.y)+21.55;
				tangle.currentTarget.parent.getChildAt(0).y = tangle.currentTarget.y;
				tangle.currentTarget.parent.getChildAt(1).width = tangle.currentTarget.x+50;
			} else {
				//rotate and stretch appropriately
				tangle.currentTarget.parent.rotation = Math.atan2((to.y-from.y),(to.x-from.x))*180/Math.PI;
				var temp:Number = 0;
				if (ChartWindow(tangle.currentTarget.stage.nativeWindow).grid) temp = Math.sqrt((to.y-from.y)*(to.y-from.y)+(to.x-from.x)*(to.x-from.x))%10;
				if (Math.sqrt((to.y-from.y)*(to.y-from.y)+(to.x-from.x)*(to.x-from.x))>70) {
					tangle.currentTarget.x = Math.sqrt((to.y-from.y)*(to.y-from.y)+(to.x-from.x)*(to.x-from.x))+((temp>5)?(10-temp):(-temp));
				} else {
					tangle.currentTarget.x = 70;
				}
				tangle.currentTarget.parent.getChildAt(0).width = tangle.currentTarget.x;
				tangle.currentTarget.parent.getChildAt(1).width = tangle.currentTarget.x;
			}
			
			//rotate and place text appropriately
			if (Math.abs(tangle.currentTarget.parent.rotation)>90) {
				tangle.currentTarget.parent.getChildAt(1).scaleY = -1*tangle.currentTarget.parent.scaleY;
				tangle.currentTarget.parent.getChildAt(1).y = tangle.currentTarget.parent.getChildAt(1).height/2*tangle.currentTarget.parent.scaleY;
				tangle.currentTarget.parent.getChildAt(1).scaleX = -1;
				tangle.currentTarget.parent.getChildAt(1).x = tangle.currentTarget.x;
				if (Arrow(tangle.currentTarget.parent).shapeStyle.indexOf("angle") >= 0) tangle.currentTarget.parent.getChildAt(1).x = tangle.currentTarget.x + 50;
			} else {
				tangle.currentTarget.parent.getChildAt(1).scaleY = 1*tangle.currentTarget.parent.scaleY;
				tangle.currentTarget.parent.getChildAt(1).y = -tangle.currentTarget.parent.getChildAt(1).height/2*tangle.currentTarget.parent.scaleY;
				tangle.currentTarget.parent.getChildAt(1).scaleX = 1;
				tangle.currentTarget.parent.getChildAt(1).x = 0;
			}
			
			//build parent piece if necessary
			if (tangle.currentTarget.parent.parent.parent is Piece) {
				tangle.currentTarget.parent.parent.parent.buildChartItem();
			}
		}
		
		//GET AND SET METHODS
		
		public function get bottom():Number {
			return _bottom;
		}
		
		public function set bottom(value:Number):void {
			_bottom = value;
		}
		
		public function get right():Number {
			return _right;
		}
		
		public function set right(value:Number):void {
			_right = value;
		}
		
		public function get handles():Object {
			return _handles;
		}
		
		public function set handles(value:Object):void {
			_handles = value;
		}
		
	}
	
}