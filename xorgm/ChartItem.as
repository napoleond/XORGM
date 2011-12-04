package xorgm {
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.filters.*;
	
	class ChartItem extends Item {
		//define extra vars on top of Item
		private var _title:String;
		private var _top:Number;
		private var _left:Number;
		private var _bg:uint;
		private var back:MovieClip;
		public var t:TextField;
		internal static var select:Array;
		private var tempX:Number;
		private var tempY:Number;
		
		public function ChartItem():void {
			//instantiate properties
			title=new String();
			top=new Number();
			left=new Number();
			bg=new uint;
		}
		
		//add to drag function
		internal function drag():void {
			//initial mouse x and y from object
			if (this is Piece) {
				tempX = this.mouseX;
				tempY = this.mouseY;
			} else if (this is Arrow) {
				var temp:Point = ChartWindow(stage.nativeWindow).workFrame.whiteBoard.globalToLocal(new Point(stage.mouseX,stage.mouseY));
				tempX = temp.x-this.x-((this.parent.parent is Piece)?this.parent.parent.x:0);
				tempY = temp.y-this.y-((this.parent.parent is Piece)?this.parent.parent.y:0);
			}
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		internal function eDrag(goat:Boolean = false):void {
			if (!goat) {
				//stopDrag
				this.x = this.x;
				this.y = this.y;
						
				//reset item coordinates
				this.left = this.x;
				this.top = this.y;
				if (this is Piece) {
					this.buildChartItem();
					if (this.stage.nativeWindow is ChartWindow) ChartWindow(this.stage.nativeWindow).buildLinks();
				} else {
					if (scaleY == -1) {
						scaleY *= -1;
						t.scaleY *= -1;
						t.y *= -1;
						if (shapeStyle.indexOf("flip") < 0) shapeStyle.push("flip");
					}
					var temp:Point = this.localToGlobal(new Point(Arrow(this).handles[2].x,Arrow(this).handles[2].y));
					Arrow(this).bottom = temp.y-top-((this.parent.parent is Piece)?this.parent.parent.y:0);
					Arrow(this).right = temp.x-left-((this.parent.parent is Piece)?this.parent.parent.x:0);
					if (shapeStyle.indexOf("flip") >= 0) {
						scaleY *= -1;
						t.scaleY *= -1;
						t.y *= -1;
					}
				}
				if (this.parent.parent is Piece) {
					Piece(this.parent.parent).left = this.parent.parent.x;
					Piece(this.parent.parent).top = this.parent.parent.y;
				}
			}
					
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
		//update piece info on enter frame
		private function update(e:Event):void {
			var gridX:Number = 0;
			var gridY:Number = 0;
			//grid calculations
			if (ChartWindow(this.stage.nativeWindow).grid) {
				gridX = -(ChartWindow(stage.nativeWindow).workFrame.whiteBoard.mouseX-tempX)%10;
				gridY = -(ChartWindow(stage.nativeWindow).workFrame.whiteBoard.mouseY-tempY)%10;
			}
			//startDrag
			e.currentTarget.x = ChartWindow(stage.nativeWindow).workFrame.whiteBoard.mouseX-tempX+gridX-((e.currentTarget.parent.parent is Piece)?e.currentTarget.parent.parent.x:0);
			e.currentTarget.y = ChartWindow(stage.nativeWindow).workFrame.whiteBoard.mouseY-tempY+gridY-((e.currentTarget.parent.parent is Piece)?e.currentTarget.parent.parent.y:0);
			if (e.currentTarget is Piece && e.currentTarget.parent is Chart) {
				e.currentTarget.buildChartItem();
				e.currentTarget.stage.nativeWindow.buildLinks();
			}
			if (e.currentTarget.parent.parent is Piece) {
				e.currentTarget.parent.parent.buildChartItem();
			}
		}
		//toggle which piece is selected
		internal static function toggleSelect(which:Object):void {
			if (main.texting && (which is Piece || which is Arrow)) {
				if (!select) select = new Array();
				if (select.indexOf(which) < 0) {
					select.push(which);
				}
			} else {
				if (main.linking && which is Piece) {
					for each (o in main.linking) {
						if (o!=which) {
							var temp:String = main.mainObj.newID();
							Piece(o).links[temp] = new Link();
							Piece(o).links[temp].target = Piece(which).id;
							Piece(o).links[temp].relation = main.linkRel;
							Piece(o).links[temp].type = main.linkType.split(", ");
							Item.parseType(Piece(o).links[temp]);
							o.parent.addChild(Piece(o).links[temp]);
						}
					}
				}
				if (which is Piece || which is Arrow) {
					if (which is Piece && which.stage.nativeWindow is ChartWindow) {
						main.toolBar.linkBtn.enable();
						main.toolBar.bevelC.enabled = true;
						main.toolBar.debossC.enabled = true;
						main.toolBar.shadowC.enabled = true;
						main.toolBar.strokeC.enabled = true;
					} else {
						main.toolBar.linkBtn.disable();
						main.toolBar.relCB.enabled = false;
						main.toolBar.styleCB.enabled = false;
						main.toolBar.bevelC.enabled = false;
						main.toolBar.debossC.enabled = false;
						main.toolBar.shadowC.enabled = false;
						main.toolBar.strokeC.enabled = false;
					}
					if (!select) select = new Array();
					which.transform.colorTransform = new ColorTransform(1,1,1,1,0,155,0,0);
					if (!main.shifting && select.indexOf(which) < 0) {
						for each (o in select) {
							if (o is Arrow) {
								Arrow(o).handles[1].visible = false;
								Arrow(o).handles[2].visible = false;
								main.toolBar.flipBtn.disable();
								main.toolBar.bevelC.enabled = false;
								main.toolBar.debossC.enabled = false;
								main.toolBar.shadowC.enabled = false;
								main.toolBar.strokeC.enabled = false;
							}
							o.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
							o.eDrag();
						}
						if (which is Arrow && !main.toolSelect) {
							Arrow(which).handles[1].visible = true;
							Arrow(which).handles[2].visible = true;
							main.toolBar.flipBtn.enable();
							main.toolBar.bevelC.enabled = true;
							main.toolBar.debossC.enabled = true;
							main.toolBar.shadowC.enabled = true;
							main.toolBar.strokeC.enabled = true;
						}
						select = new Array(which);
					} else if (main.shifting && select.indexOf(which) < 0) {
						select.push(which);
					}
					if (main.toolBar.bevelC.enabled) {
						main.toolBar.bevelC.selected = (which.filterStyle.indexOf("bevel") >= 0);
						main.toolBar.debossC.selected = (which.filterStyle.indexOf("emboss") >= 0);
						main.toolBar.shadowC.selected = (which.filterStyle.indexOf("shadow") >= 0);
						main.toolBar.strokeC.selected = (which.filterStyle.indexOf("stroke") >= 0);
					}
				} else {
					for each (var o:ChartItem in select) {
						if (o is Arrow) {
							Arrow(o).handles[1].visible = false;
							Arrow(o).handles[2].visible = false;
						}
						o.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
						o.title = o.t.text;
						o.t.type = TextFieldType.DYNAMIC;
						o.t.selectable = false;
					}
					select = null;
					main.toolBar.linkBtn.disable();
					main.toolBar.flipBtn.disable();
					main.toolBar.relCB.enabled = false;
					main.toolBar.styleCB.enabled = false;
					main.toolBar.bevelC.enabled = false;
					main.toolBar.debossC.enabled = false;
					main.toolBar.shadowC.enabled = false;
					main.toolBar.strokeC.enabled = false;
				}
			}
		}
		
		//overrides Item's fromXorgM
		public override function fromXorgM(xChartItem:XML):void {
			//define extra properties
			title=xChartItem.title;
			top=xChartItem.@top;
			left=xChartItem.@left;
			bg=Item.colorConvert(xChartItem.@bg);
			
			//call to Item's fromXorgM
			super.fromXorgM(xChartItem);
			
			if (isNaN(color)) color=0xFFFFFF;
			if (isNaN(bg)) bg=0x000000;
			
			//set this object's position according to xml
			this.x = left;
			this.y = top;
			
		}
		
		//build
		public function buildChartItem(wide:Number=150, high:Number=20.95):void {
			var origin:Point;
			//clear graphics
			this.graphics.clear();
			origin = new Point(0,0);
			var w:Number = 0;
			var h:Number = 0;
			//custom stuff for pieces with inner chart
			if(t && this is Piece && this.stage.nativeWindow is ChartWindow && ChartWindow(this.stage.nativeWindow).charts[Piece(this).id]) {
				t.width = 10;
				var chBounds:Rectangle = ChartWindow(this.stage.nativeWindow).charts[Piece(this).id].getBounds(this);
				origin = new Point(chBounds.x-10,chBounds.y-40);
				w = (chBounds.width>150)?chBounds.width:150;
				h = chBounds.height+30;
			}
			//add node title
			if(!t) t = new TextField();
			t.autoSize = TextFieldAutoSize.CENTER;
			t.wordWrap = (shape == "circle")?false:true;
			t.embedFonts = true;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.selectable = false;
			t.width = (shape == "circle")?10:((w<wide)?wide:w);
			t.x = 10+origin.x;
			t.y = 10+origin.y;
			t.text = title;
			//style text
			var tf:TextFormat = new TextFormat();
			tf.font = main.tehFont.fontName;
			tf.letterSpacing = 0.5;
			tf.size = 14;
			tf.color = color;
			tf.align = TextFormatAlign.CENTER;
			t.setTextFormat(tf);
			t.height = (high<t.height)?t.height:high;
			this.addChild(t);
			if (w==0) {
				w = t.width;
				h = (t.height>10)?t.height:high;
			}
			//if no custom style is defined start stylin
			if (!customStyle) {
				this.graphics.beginFill(bg);
				switch (shape) {
					case "circle":
						t.y = ((t.width>20)?t.width:20)/2+10-t.height/2;
						this.graphics.drawCircle(((t.width>20)?t.width:20)/2+10, ((t.width>20)?t.width:20)/2+10, ((t.width>20)?t.width:20)/2+10);
						t.x = 10;
						break;
					case "rect":
						if (shapeStyle.indexOf("round") >= 0) {
							this.graphics.drawRoundRect(origin.x, origin.y, w+20, h+20, 15);
						} else {
							this.graphics.drawRect(origin.x, origin.y, w+20, h+20);
						}
						break;
					case "arrow":
						if (shapeStyle.indexOf("fat") >= 0) {
							//FAT ARROWS
							if (shapeStyle.indexOf("angle") >= 0) {
								//FAT ANGLE ARROW
								if (back) this.removeChild(back);
								back = new mcFatAngle();
								shapeStyle.push("angle");
							} else if (shapeStyle.indexOf("curve") >= 0) {
								//FAT CURVE ARROW
								if (back) this.removeChild(back);
								back = new mcFatCurve();
							} else {
								//FAT STRAIGHT ARROW
								if (back) this.removeChild(back);
								back = new mcFatStraight();
							}
						} else if (shapeStyle.indexOf("swish") >= 0) {
							//SWISH ARROW
							if (back) this.removeChild(back);
							back = new mcSwish();
						} else {
							//THIN ARROWS
							if (shapeStyle.indexOf("angle") >= 0) {
								//ANGLE ARROW
								if (back) this.removeChild(back);
								back = new mcAngle();
								shapeStyle.push("angle");
							} else {
								//STRAIGHT ARROW
								if (back) this.removeChild(back);
								back = new mcStraight();
							}
						}
						back.width = w;
						back.y = -back.height/2;
						t.width = w;
						t.y = -t.height/2;
						t.x=0;
						var bgColor:ColorTransform = back.transform.colorTransform;
						bgColor.color = bg;
						back.transform.colorTransform = bgColor;
						this.addChildAt(back,0);
						this.setChildIndex(t,1);
						break;
					default:
						trace(shape + " is not a defined shape.");
						break;
				}
				this.graphics.endFill();
			}
			setFilters();
		}
		
		public function setFilters():void {
			var X:Object = this;
			var temp = new Array();
			filterStyle.forEach(function (e:String, i:int, a:Array) {
																   switch (e) {
																	   case "bevel":
																			temp.push(new BevelFilter(10,90,0xFFFFFFF,0.8,0x000000,0.34,20,20,0.86,BitmapFilterQuality.LOW,BitmapFilterType.INNER,false));
																			break;
																		case "shadow":
																			temp.push(new DropShadowFilter(4,120,0,1,3,3,0.75,BitmapFilterQuality.LOW));
																			break;
																		case "emboss":
																			temp.push(new BevelFilter(2,270,0xFFFFFFF,1,0x000000,1,2,2,0.52,BitmapFilterQuality.LOW,BitmapFilterType.OUTER,false));
																			temp.push(new BevelFilter(-8,270,0xFFFFFFF,1,0x000000,1,2,2,0.1,BitmapFilterQuality.LOW,BitmapFilterType.INNER,false));
																			temp.push(new DropShadowFilter(2,90,0,1,2,2,1,BitmapFilterQuality.LOW, true));
																			break;
																		case "stroke":
																			if(X.stroke) {
																				temp.push(new GlowFilter(X.stroke,1,5,5,10));
																			}
																			break;
																		
																		default:
																			trace(e + " is not a defined filter");
																			break;
																   }
																   });
			this.filters = temp;
		}
		
		//extends Item's toXorgM
		public override function toXorgM():XML {
			var cItem:XML = super.toXorgM();
			//add chartitem attributes
			cItem.@top=top;
			cItem.@left=left;
			cItem.@stroke=Item.colorXorgM(stroke);
			cItem.@bg=Item.colorXorgM(bg);
			//add title
			cItem.appendChild("<title>" + title + "</title>");			
			return cItem;
		}
		
		//GET AND SET METHODS
		
		public function get title():String {
			return _title;
		}
		
		public function set title(value:String):void {
			_title = value;
		}
		
		public function get top():Number {
			return _top;
		}
		
		public function set top(value:Number):void {
			_top = value;
		}
		
		public function get left():Number {
			return _left;
		}
		
		public function set left(value:Number):void {
			_left = value;
		}
		
		public function get bg():uint {
			return _bg;
		}
		
		public function set bg(value:uint):void {
			_bg = value;
		}
		
	}
	
}