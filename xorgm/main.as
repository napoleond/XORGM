package xorgm {
	
	import flash.display.*;
	import flash.filesystem.*;
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.FileListEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.desktop.NativeApplication;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.*;
	import fl.controls.ComboBox;
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;
	import xorgm.images.PNGEncoder;
	
	//constructor
	public class main extends Sprite {
		
		private static const WMAX:uint = 1040;
		private static const HMAX:uint = 502;
		public static const isMac:Boolean = Capabilities.os.indexOf("Mac") == 0;
		internal static var mainObj:main;
		internal static var shapeTools:mcShapes = new mcShapes();
		internal static var topTools:mcTop = new mcTop();
		internal static var toolBar:mcToolBar = new mcToolBar();
		internal static var backdrop:mcBackDrop = new mcBackDrop();
		internal static var toolSelect:Boolean = false;
		internal static var shifting:Boolean = false;
		internal static var filling:Boolean = false;
		internal static var texting:Boolean = false;
		internal static var linking:Array;
		internal static var linkRel:String = "child";
		internal static var linkType:String = "line";
		internal static var shapesWin:NativeWindow;
		internal static var splashWin:NativeWindow;
		internal static var topWin:NativeWindow;
		internal static var backWin:NativeWindow;
		internal static var toolWin:NativeWindow;
		
		internal var fMenu:NativeMenu;
		internal var parentWindow:NativeWindow;
		internal var windows:Object = new Object;
		internal var xwin:uint = 0;
		internal var ywin:uint = 0;
		internal var uID:String = "aaa111";
		internal var themeSelect:ComboBox;
		internal var colorSelect:ColorPicker;
		internal var bgSelect:ColorPicker;
		internal var linkRelSelect:ComboBox;
		internal var linkTypeSelect:ComboBox;
		internal var samplePiece:Piece;
		internal var sampleArrow:Arrow;
		internal var titleText:TextField;
		internal var makeLink:TextField;
		internal var flipArrow:TextField;
		internal static var tehFont:Font = new XORGMfont();
		
		public function main():void {
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
			
			buildMenu();
			addTools(null);
			
		}
		
		private function invokeHandler(evt:InvokeEvent):void {
			var args:Array = evt.arguments as Array;
			args.forEach( function (e:*, i:int, a:Array) {
														build(new File(String(e)));
														});
		}
		
		private function shapeToolHandle(evt:MouseEvent):void {
			var targ:Object;
			if (evt.target == evt.currentTarget) {
				targ = evt.target;
			} else {
				targ = (evt.target.parent==shapeTools)?evt.target:evt.target.parent;
			}
			switch (targ) {
				case evt.currentTarget:
					toolSelect = false;
					ChartItem.toggleSelect(stage);
					linking = null;
					evt.currentTarget.stage.nativeWindow.startMove();
					break;
				case shapeTools.roundRect:
					samplePiece.shape = "rect";
					samplePiece.shapeStyle = new Array("round");
					samplePiece.buildChartItem();
					toolSelect = true;
					ChartItem.toggleSelect(samplePiece);
					break;
				case shapeTools.Rect:
					samplePiece.shape = "rect";
					samplePiece.shapeStyle = new Array();
					samplePiece.buildChartItem();
					toolSelect = true;
					ChartItem.toggleSelect(samplePiece);
					break;
				case shapeTools.circ:
					samplePiece.shape = "circle";
					samplePiece.shapeStyle = new Array();
					samplePiece.buildChartItem();
					toolSelect = true;
					ChartItem.toggleSelect(samplePiece);
					break;
				case shapeTools.stFat:
					sampleArrow.shape = "arrow";
					sampleArrow.shapeStyle = new Array("fat");
					sampleArrow.top=250;
					sampleArrow.left=20;
					sampleArrow.bottom = NaN;
					sampleArrow.buildChartItem();
					sampleArrow.y=sampleArrow.top;
					sampleArrow.x=sampleArrow.left;
					toolSelect = true;
					ChartItem.toggleSelect(sampleArrow);
					break;
				case shapeTools.swish:
					sampleArrow.shape = "arrow";
					sampleArrow.shapeStyle = new Array("swish");
					sampleArrow.top=250;
					sampleArrow.left=20;
					sampleArrow.bottom = NaN;
					sampleArrow.buildChartItem();
					sampleArrow.y=sampleArrow.top;
					sampleArrow.x=sampleArrow.left;
					toolSelect = true;
					ChartItem.toggleSelect(sampleArrow);
					break;
				case shapeTools.fatAngle:
					sampleArrow.shape = "arrow";
					sampleArrow.shapeStyle = new Array("fat","angle");
					sampleArrow.top=250;
					sampleArrow.left=20;
					sampleArrow.bottom = NaN;
					sampleArrow.buildChartItem();
					sampleArrow.y=sampleArrow.top;
					sampleArrow.x=sampleArrow.left;
					toolSelect = true;
					ChartItem.toggleSelect(sampleArrow);
					break;
				case shapeTools.curve:
					sampleArrow.shape = "arrow";
					sampleArrow.shapeStyle = new Array("fat","curve");
					sampleArrow.top=250;
					sampleArrow.left=20;
					sampleArrow.bottom = NaN;
					sampleArrow.buildChartItem();
					sampleArrow.y=sampleArrow.top;
					sampleArrow.x=sampleArrow.left;
					toolSelect = true;
					ChartItem.toggleSelect(sampleArrow);
					break;
				case shapeTools.straight:
					sampleArrow.shape = "arrow";
					sampleArrow.shapeStyle = new Array();
					sampleArrow.top=250;
					sampleArrow.left=20;
					sampleArrow.bottom = NaN;
					sampleArrow.buildChartItem();
					sampleArrow.y=sampleArrow.top;
					sampleArrow.x=sampleArrow.left;
					toolSelect = true;
					ChartItem.toggleSelect(sampleArrow);
					break;
				case shapeTools.Angle:
					sampleArrow.shape = "arrow";
					sampleArrow.shapeStyle = new Array("angle");
					sampleArrow.top=250;
					sampleArrow.left=20;
					sampleArrow.bottom = NaN;
					sampleArrow.buildChartItem();
					sampleArrow.y=sampleArrow.top;
					sampleArrow.x=sampleArrow.left;
					toolSelect = true;
					ChartItem.toggleSelect(sampleArrow);
					break;
			}
			toolBar.selBtn.removeEventListener(MouseEvent.MOUSE_OUT, toolBar.selBtn.mo);
			toolBar.selBtn.removeEventListener(MouseEvent.MOUSE_UP, toolBar.selBtn.m);
			toolBar.selBtn.removeEventListener(MouseEvent.MOUSE_OVER, toolBar.selBtn.m);
			toolBar.selBtn.gotoAndStop(3);
			toolBar.fillBtn.addEventListener(MouseEvent.MOUSE_OUT, toolBar.fillBtn.mo);
			toolBar.fillBtn.addEventListener(MouseEvent.MOUSE_UP, toolBar.fillBtn.m);
			toolBar.fillBtn.addEventListener(MouseEvent.MOUSE_OVER, toolBar.fillBtn.m);
			toolBar.fillBtn.gotoAndStop(1);
			toolBar.textBtn.addEventListener(MouseEvent.MOUSE_OUT, toolBar.textBtn.mo);
			toolBar.textBtn.addEventListener(MouseEvent.MOUSE_UP, toolBar.textBtn.m);
			toolBar.textBtn.addEventListener(MouseEvent.MOUSE_OVER, toolBar.textBtn.m);
			toolBar.textBtn.gotoAndStop(1);
			filling = false;
			if (main.texting) {
				ChartWindow.texted.forEach(function (e:Object, i:int, a:Array) {
																  ChartItem.toggleSelect(e);
																  });
				ChartItem.toggleSelect(stage);
				ChartWindow.texted = new Array();
			}
			texting = false;
			for (var i:int; i < shapeTools.numChildren; i++) {
				if (shapeTools.getChildAt(i) is MovieClip) {
					if (shapeTools.getChildAt(i) == targ) {
						shapeTools.getChildAt(i).removeEventListener(MouseEvent.MOUSE_OUT, MovieClip(shapeTools.getChildAt(i)).mo);
						shapeTools.getChildAt(i).removeEventListener(MouseEvent.MOUSE_UP, MovieClip(shapeTools.getChildAt(i)).m);
						shapeTools.getChildAt(i).removeEventListener(MouseEvent.MOUSE_OVER, MovieClip(shapeTools.getChildAt(i)).m);
						MovieClip(shapeTools.getChildAt(i)).gotoAndStop(3);
						toolBar.selBtn.addEventListener(MouseEvent.MOUSE_OUT, toolBar.selBtn.mo);
						toolBar.selBtn.addEventListener(MouseEvent.MOUSE_UP, toolBar.selBtn.m);
						toolBar.selBtn.addEventListener(MouseEvent.MOUSE_OVER, toolBar.selBtn.m);
						toolBar.selBtn.gotoAndStop(1);
					} else {
						shapeTools.getChildAt(i).addEventListener(MouseEvent.MOUSE_OUT, MovieClip(shapeTools.getChildAt(i)).mo);
						shapeTools.getChildAt(i).addEventListener(MouseEvent.MOUSE_UP, MovieClip(shapeTools.getChildAt(i)).m);
						shapeTools.getChildAt(i).addEventListener(MouseEvent.MOUSE_OVER, MovieClip(shapeTools.getChildAt(i)).m);
						MovieClip(shapeTools.getChildAt(i)).gotoAndStop(1);
					}
				}
			}
		}
		
		private function toolBarHandle(evt:MouseEvent):void {
			topWin.orderToFront();
			toolWin.orderInBackOf(shapesWin);
			backWin.orderInBackOf(toolWin);
			for (var s:String in windows) {
				windows[s].orderInBackOf(toolWin);
			}
			
			var targ:Object;
			if (evt.target.parent == toolBar.fillBtn || evt.target.parent == toolBar.textBtn || evt.target.parent == toolBar.selBtn || evt.target.parent == toolBar.flipBtn || evt.target.parent == toolBar.linkBtn) {
				targ = evt.target.parent;
			} else {
				targ = evt.target;
			}
			
			switch (targ) {
				case toolBar.fillBtn:
					//add event listeners to selBtn, set fillBtn active
					shapeTools.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					toolBar.selBtn.addEventListener(MouseEvent.MOUSE_OUT, toolBar.selBtn.mo);
					toolBar.selBtn.addEventListener(MouseEvent.MOUSE_UP, toolBar.selBtn.m);
					toolBar.selBtn.addEventListener(MouseEvent.MOUSE_OVER, toolBar.selBtn.m);
					toolBar.selBtn.gotoAndStop(1);
					toolBar.textBtn.addEventListener(MouseEvent.MOUSE_OUT, toolBar.textBtn.mo);
					toolBar.textBtn.addEventListener(MouseEvent.MOUSE_UP, toolBar.textBtn.m);
					toolBar.textBtn.addEventListener(MouseEvent.MOUSE_OVER, toolBar.textBtn.m);
					toolBar.textBtn.gotoAndStop(1);
					toolBar.fillBtn.removeEventListener(MouseEvent.MOUSE_OUT, toolBar.fillBtn.mo);
					toolBar.fillBtn.removeEventListener(MouseEvent.MOUSE_UP, toolBar.fillBtn.m);
					toolBar.fillBtn.removeEventListener(MouseEvent.MOUSE_OVER, toolBar.fillBtn.m);
					toolBar.fillBtn.gotoAndStop(3);
					filling = true;
					break;
				case toolBar.textBtn:
					//add event listeners to selBtn, set textBtn active
					shapeTools.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					toolBar.fillBtn.addEventListener(MouseEvent.MOUSE_OUT, toolBar.fillBtn.mo);
					toolBar.fillBtn.addEventListener(MouseEvent.MOUSE_UP, toolBar.fillBtn.m);
					toolBar.fillBtn.addEventListener(MouseEvent.MOUSE_OVER, toolBar.fillBtn.m);
					toolBar.fillBtn.gotoAndStop(1);
					toolBar.selBtn.addEventListener(MouseEvent.MOUSE_OUT, toolBar.selBtn.mo);
					toolBar.selBtn.addEventListener(MouseEvent.MOUSE_UP, toolBar.selBtn.m);
					toolBar.selBtn.addEventListener(MouseEvent.MOUSE_OVER, toolBar.selBtn.m);
					toolBar.selBtn.gotoAndStop(1);
					toolBar.textBtn.removeEventListener(MouseEvent.MOUSE_OUT, toolBar.textBtn.mo);
					toolBar.textBtn.removeEventListener(MouseEvent.MOUSE_UP, toolBar.textBtn.m);
					toolBar.textBtn.removeEventListener(MouseEvent.MOUSE_OVER, toolBar.textBtn.m);
					toolBar.textBtn.gotoAndStop(3);
					texting = true;
					break;
				case toolBar.flipBtn:
					break;
				case toolBar.linkBtn:
					if (toolBar.linkBtn.alpha == 1) makeLink.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case toolBar:
				case toolBar.selBtn:
					toolSelect = false;
					ChartItem.toggleSelect(stage);
					linking = null;
					evt.currentTarget.stage.nativeWindow.startMove();
			}
		}
		
		//build main application menu
		private function buildMenu():void {
			
			//add shape toolbar
			var windowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			windowOptions.systemChrome = NativeWindowSystemChrome.NONE;
			windowOptions.type = NativeWindowType.LIGHTWEIGHT;
			windowOptions.transparent = true;
			
			backWin = new NativeWindow(windowOptions);
			backWin.bounds = new Rectangle(0,0,Capabilities.screenResolutionX,Capabilities.screenResolutionY-40);
			backWin.stage.scaleMode = StageScaleMode.NO_SCALE;
			backWin.stage.align = StageAlign.TOP_LEFT;
			backdrop.addEventListener(MouseEvent.MOUSE_DOWN, function (e:Event) {
																			   topWin.orderToFront();
																			   toolWin.orderInBackOf(shapesWin);
																			   backWin.orderInBackOf(toolWin);
																			   for (var s:String in windows) {
																				   windows[s].orderInBackOf(toolWin);
																			   }
																			  });
			backWin.stage.addChild(backdrop);
			backdrop.x = 0;
			backdrop.y = 0;
			backdrop.width = Capabilities.screenResolutionX;
			backdrop.height = Capabilities.screenResolutionY;
			
			shapesWin = new NativeWindow(windowOptions);
			shapesWin.bounds = new Rectangle(0,49,80,800);
			shapesWin.stage.scaleMode = StageScaleMode.NO_SCALE;
			shapesWin.stage.align = StageAlign.TOP_LEFT;
			shapesWin.stage.addChild(shapeTools);
			shapeTools.addEventListener(MouseEvent.MOUSE_DOWN, shapeToolHandle);
			
			toolWin = new NativeWindow(windowOptions);
			toolWin.bounds = new Rectangle(Capabilities.screenResolutionX-189,49,189,800);
			toolWin.stage.scaleMode = StageScaleMode.NO_SCALE;
			toolWin.stage.align = StageAlign.TOP_LEFT;
			toolWin.stage.addChild(toolBar);
			toolBar.addEventListener(MouseEvent.MOUSE_DOWN, toolBarHandle);
			toolBar.addEventListener(MouseEvent.MOUSE_UP, function(e:Event) {
																		   if (e.target == toolBar || e.target == toolBar.selBtn || e.target.parent == toolBar.selBtn) {
																		   		shapeTools.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
																		   }
																		   });
			toolBar.flipBtn.txt.text = "Flip Arrow";
			toolBar.flipBtn.disable();
			toolBar.linkBtn.txt.text = "Make Link";
			toolBar.linkBtn.disable();
			toolBar.relCB.enabled = false;
			toolBar.styleCB.enabled = false;
			
			toolBar.textCP.showTextField = false;
			toolBar.strokeCP.showTextField = false;
			toolBar.textCP.addEventListener(ColorPickerEvent.CHANGE, makeColor);
			toolBar.bgCP.addEventListener(ColorPickerEvent.CHANGE, makeBG);
			toolBar.strokeCP.addEventListener(ColorPickerEvent.CHANGE, makeStroke);
			
			//style text
			var tf:TextFormat = new TextFormat();
			tf.font = "Lucida Sans";
			tf.bold = true;
			tf.size = 11;
			tf.color = 0xFFFFFF;
			toolBar.themeCB.textField.setStyle("textFormat",tf);
			toolBar.themeCB.dropdown.setRendererStyle("textFormat",new TextFormat());
			
			toolBar.relCB.addItem({label:"Child", data:"child"});
			toolBar.relCB.addItem({label:"Sibling", data:"sib"});
			toolBar.relCB.addItem({label:"Subordinate", data:"sub"});
			toolBar.styleCB.addItem({label:"Line", data:"line"});
			toolBar.styleCB.addItem({label:"Arrow", data:"arrow"});
			toolBar.styleCB.addItem({label:"Dashed Line", data:"line, dashed"});
			toolBar.styleCB.addItem({label:"Dashed Arrow", data:"arrow, dashed"});
			toolBar.styleCB.addItem({label:"Dotted Line", data:"line, dotted"});
			toolBar.styleCB.addItem({label:"Dotted Arrow", data:"arrow, dotted"});
			
			//theme selector
			toolBar.themeCB.addItem({label:"Leadership", data:Theme.LEAD});
			toolBar.themeCB.addItem({label:"Management", data:Theme.MGMT});
			toolBar.themeCB.addItem({label:"Operations", data:Theme.OPS});
			toolBar.themeCB.addItem({label:"Communications", data:Theme.COMS});
			toolBar.themeCB.addEventListener(Event.CHANGE, addTools);
			
			toolBar.bevelC.setStyle("textFormat",tf);
			toolBar.debossC.setStyle("textFormat",tf);
			toolBar.shadowC.setStyle("textFormat",tf);
			toolBar.strokeC.setStyle("textFormat",tf);
			toolBar.bevelC.label = "Bevel";
			toolBar.debossC.label = "Deboss";
			toolBar.shadowC.label = "Drop Shadow";
			toolBar.strokeC.label = "Stroke";
			toolBar.bevelC.enabled = false;
			toolBar.debossC.enabled = false;
			toolBar.shadowC.enabled = false;
			toolBar.strokeC.enabled = false;
			
			topWin = this.stage.nativeWindow;
			topWin.bounds = new Rectangle(0,0,Capabilities.screenResolutionX,300);
			topWin.stage.scaleMode = StageScaleMode.NO_SCALE;
			topWin.stage.align = StageAlign.TOP_LEFT;
			topWin.stage.addChild(topTools);
			topWin.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, function (evt:Event) {
																											   backWin.visible = (backWin.visible)?false:true;
																											   backWin.orderToFront();
																											  shapesWin.visible = (shapesWin.visible)?false:true;
																											   shapesWin.orderToFront();
																											   toolWin.visible = (toolWin.visible)?false:true;
																											   toolWin.orderToFront();
																											   for (var s:String in windows) {
																												   windows[s].visible = (windows[s].visible)?false:true;
																											   		windows[s].orderToFront();
																											   }
																											  });
			topTools.addEventListener(MouseEvent.MOUSE_OVER, function(e:Event) {
																			  topWin.orderToFront();
																			  });
			topTools.back.width = Capabilities.screenResolutionX+2;
			topTools.back.x = 0;
			topTools.btClose.x = Capabilities.screenResolutionX - 25;
			topTools.btMin.x = Capabilities.screenResolutionX - 50;
			
			mainObj = this;
			
			//make new file button
			topTools.fileMenu.nBtn.addEventListener(MouseEvent.CLICK, nBtnC);
			//import button
			topTools.fileMenu.oBtn.addEventListener(MouseEvent.CLICK, iBtnC);
			//xorgm button
			var xmBtn:NativeMenuItem = new NativeMenuItem("Save All");
			//pass window reference to event listener as data
			xmBtn.data = this;
			xmBtn.addEventListener(Event.SELECT, main.makeXorgM);
			topTools.fileMenu.sBtn.addEventListener(MouseEvent.CLICK, function (e:Event) {
																						xmBtn.dispatchEvent(new Event(Event.SELECT));
																						});
			topTools.fileMenu.eBtn.addEventListener(MouseEvent.CLICK, function (e:Event) {
																						topTools.btClose.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
																						});
			stage.nativeWindow.title = "XORGM";
			stage.nativeWindow.x = 0;
			stage.nativeWindow.y = 0;
			
			//import button clicked
			function iBtnC(e:Event) {
				userOpen();
			}
			
			//new chart button clicked
			function nBtnC(e:Event) {
				
				var ID:String = newID();
				
				var windowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
				windowOptions.systemChrome = NativeWindowSystemChrome.NONE;
				windowOptions.type = NativeWindowType.LIGHTWEIGHT;
				windowOptions.transparent = true;
						
				//make new window for chart
				windows[ID] = new ChartWindow(windowOptions, ID);
				windows[ID].bounds = new Rectangle(62+30*xwin++, 39+30*ywin++, WMAX, HMAX);
				windows[ID].workFrame.titBar.text = "New Org Chart";
				
				if (xwin>15) {
					xwin=0;
					ywin=0;
				}
				
				try {
					//make new chart object
					windows[ID].charts[ID] = new Chart();
					windows[ID].charts[ID].id = ID;
					windows[ID].workFrame.whiteBoard.addChild(windows[ID].charts[ID]);
				} catch (e:Error) {
					trace("Error adding chart " + ID + ":" + e);
				}
				
				//build pieces and links
				windows[ID].buildPieces();
				windows[ID].buildLinks();
				
				//activate window
				windows[ID].activate();
				
				windowOptions = null;
			}
			
			//add event listener on close
			parentWindow = topWin;
			parentWindow.addEventListener(Event.CLOSING, onWinClose);
			
			splashWin = new SplashWindow(windowOptions);
		}
		
		//add tools for chart drawing
		private function addTools(evt:Event):void {
			//refresh theme info
			if (evt) Theme.current = evt.currentTarget.selectedItem.data;
			Theme.remake();
			
			//style checkboxes
			toolBar.bevelC.addEventListener(Event.CHANGE,editStyle);
			toolBar.debossC.addEventListener(Event.CHANGE,editStyle);
			toolBar.shadowC.addEventListener(Event.CHANGE,editStyle);
			toolBar.strokeC.addEventListener(Event.CHANGE,editStyle);
			
			function editStyle(e:Event):void {
				
				var whichStyle:String = new String();
				switch (e.currentTarget) {
					case toolBar.bevelC:
						whichStyle = "bevel";
						break;
					case toolBar.debossC:
						whichStyle = "emboss";
						break;
					case toolBar.shadowC:
						whichStyle = "shadow";
						break;
					case toolBar.strokeC:
						whichStyle = "stroke";
						break;
				}
				if (whichStyle) {
					for each (var ci:ChartItem in ChartItem.select) {
						if (e.currentTarget.selected) {
							if (ci.filterStyle.indexOf(whichStyle) < 0) ci.filterStyle.push(whichStyle);
						} else {
							if (ci.filterStyle.indexOf(whichStyle) >= 0) ci.filterStyle.splice(ci.filterStyle.indexOf(whichStyle),1);
						}
						ci.setFilters();
						ChartWindow(ci.stage.nativeWindow).history.splice(ChartWindow(ci.stage.nativeWindow).mark+1);
						ChartWindow(ci.stage.nativeWindow).history.push(main.toXorgM(ChartWindow(ci.stage.nativeWindow)));
						ChartWindow(ci.stage.nativeWindow).mark = ChartWindow(ci.stage.nativeWindow).history.length-1;
					}
					if (e.currentTarget.selected) {
						if (samplePiece.filterStyle.indexOf(whichStyle) < 0) samplePiece.filterStyle.push(whichStyle);
						if (sampleArrow.filterStyle.indexOf(whichStyle) < 0) sampleArrow.filterStyle.push(whichStyle);
					} else {
						if (samplePiece.filterStyle.indexOf(whichStyle) >= 0) samplePiece.filterStyle.splice(samplePiece.filterStyle.indexOf(whichStyle),1);
						if (sampleArrow.filterStyle.indexOf(whichStyle) >= 0) sampleArrow.filterStyle.splice(sampleArrow.filterStyle.indexOf(whichStyle),1);
					}
					samplePiece.setFilters();
					sampleArrow.setFilters();
				}
			}
			
			//style text
			var tf:TextFormat = new TextFormat();
			tf.font = "Lucida Sans";
			tf.bold = true;
			tf.size = 11;
			tf.color = 0xFFFFFF;
			toolBar.themeCB.textField.setStyle("textFormat",tf);
			toolBar.themeCB.dropdown.setRendererStyle("textFormat",new TextFormat());
			
			//piece palette
			if (samplePiece) samplePiece = null;
			samplePiece = new Piece();
			stage.addChild(samplePiece);
			samplePiece.fromXorgM(Theme.pieceStyles[Theme.current]);
			samplePiece.id = newID();
			samplePiece.title = "New Piece";
			samplePiece.top=50;
			samplePiece.left=20;
			samplePiece.buildChartItem();
			samplePiece.x=samplePiece.left;
			samplePiece.y=samplePiece.top;
			samplePiece.visible = false;
			
			//arrow palette
			if (sampleArrow) sampleArrow = null;
			sampleArrow = new Arrow();
			stage.addChild(sampleArrow);
			sampleArrow.fromXorgM(Theme.arrowStyles[Theme.current]);
			sampleArrow.title = "New Arrow";
			sampleArrow.top=250;
			sampleArrow.left=20;
			sampleArrow.bottom = NaN;
			sampleArrow.buildChartItem();
			sampleArrow.y=sampleArrow.top;
			sampleArrow.x=sampleArrow.left;
			sampleArrow.visible = false;
			
			toolBar.textCP.colors = Theme.colors;
			toolBar.textCP.selectedColor = Theme.colors[1];
			toolBar.strokeCP.colors = Theme.strokes;
			toolBar.strokeCP.selectedColor = Theme.strokes[1];
			toolBar.bgCP.setColors(Theme.bgs);
			
			//make link
			if (!makeLink) makeLink = new TextField;
			makeLink.visible = false;
			makeLink.addEventListener(MouseEvent.CLICK, linkTo);
			stage.addChild(makeLink);
			
			function linkTo (evt:MouseEvent) {
				linking = ChartItem.select.slice();
				toolBar.relCB.enabled = true;
				toolBar.styleCB.enabled = true;
				toolBar.relCB.textField.setStyle("textFormat",tf);
				toolBar.relCB.dropdown.setRendererStyle("textFormat",new TextFormat());
				toolBar.styleCB.textField.setStyle("textFormat",tf);
				toolBar.styleCB.dropdown.setRendererStyle("textFormat",new TextFormat());
			}
			
			//make link
			toolBar.flipBtn.addEventListener(MouseEvent.CLICK, flipIt);
			
			function flipIt (evt:MouseEvent) {
				if (evt.currentTarget.alpha == 1) {
					ChartItem.select.forEach(function (e:Object, i:int, a:Array) {
																				
																					if (e is Arrow) {
																						e.scaleY *= -1;
																						e.t.scaleY *= -1;
																						e.t.y *= -1;
																						if (Arrow(e).shapeStyle.indexOf("flip") >= 0) Arrow(e).shapeStyle.splice(Arrow(e).shapeStyle.indexOf("flip"),1);
																					}
																				
																				});
				}
			}
			
			//link rel selector
			toolBar.relCB.addEventListener(Event.CHANGE, makeLinkRel);
			
			function makeLinkRel (evt:Event) {
				linkRel = evt.currentTarget.selectedItem.data;
			}
			
			//link type selector
			toolBar.styleCB.addEventListener(Event.CHANGE, makeLinkType);
			
			function makeLinkType (evt:Event) {
				linkType = evt.currentTarget.selectedItem.data;
			}
			
		}
		
		internal function makeColor (evt:ColorPickerEvent) {
			var tColor:ColorTransform = sampleArrow.t.transform.colorTransform;
			tColor.color = evt.color;
			for each (var ci:ChartItem in ChartItem.select) {
				if (ci is Piece) {
					ci.color = evt.color;
					ci.buildChartItem();
				}
				if (ci is Arrow) {
					ci.color = evt.color;
					ci.t.transform.colorTransform = tColor;
				}
			}
			Theme.pieceStyles[Theme.current].@color =  Item.colorXorgM(evt.color);
			Theme.arrowStyles[Theme.current].@color =  Item.colorXorgM(evt.color);
			samplePiece.color = evt.color;
			samplePiece.buildChartItem();
			sampleArrow.color = evt.color;
			sampleArrow.t.transform.colorTransform = tColor;
		}
		
		internal function makeBG (evt:ColorPickerEvent) {
			var tColor:ColorTransform = sampleArrow.t.transform.colorTransform;
			tColor.color = evt.color;
			for each (var ci:ChartItem in ChartItem.select) {
				if (ci is Piece) {
					ci.bg = evt.color;
					ci.buildChartItem();
				}
				if (ci is Arrow) {
					ci.bg = evt.color;
					ci.getChildAt(0).transform.colorTransform = tColor;
				}
			}
			Theme.pieceStyles[Theme.current].@bg =  Item.colorXorgM(evt.color);
			Theme.arrowStyles[Theme.current].@bg =  Item.colorXorgM(evt.color);
			samplePiece.bg = evt.color;
			samplePiece.buildChartItem();
			sampleArrow.bg = evt.color;
			sampleArrow.getChildAt(0).transform.colorTransform = tColor;
		}
		
		internal function makeStroke (evt:ColorPickerEvent) {
			for each (var ci:ChartItem in ChartItem.select) {
				ci.stroke = evt.color;
				ci.setFilters();
			}
			Theme.pieceStyles[Theme.current].@stroke =  Item.colorXorgM(evt.color);
			Theme.arrowStyles[Theme.current].@stroke =  Item.colorXorgM(evt.color);
			samplePiece.stroke = evt.color;
			samplePiece.setFilters();
			sampleArrow.stroke = evt.color;
			sampleArrow.setFilters();
		}
		
		//prompts user to select one or more xml files to build with
		private function userOpen():void {
			
			var docsDir:File = File.documentsDirectory;
			try
			{
				var xmlFilter:FileFilter = new FileFilter("Org Charts (.xorgm)", "*.xorgm");
				docsDir.browseForOpenMultiple("Select Files", [xmlFilter]);
				docsDir.addEventListener(FileListEvent.SELECT_MULTIPLE, filesSelected);
			}
			catch (error:Error)
			{
				trace("Error selecting file:", error.message);
			}
			
			function filesSelected(event:FileListEvent):void 
			{
				for (var i:uint = 0; i < event.files.length; i++) 
				{
					try {
						build(event.files[i]);
					}
					catch (e:Error) {
						trace("Error building org chart with " + event.files[i].nativePath + ": " + e);
					}
				}
			}
		}
		
		//open individual XorgM, construct charts as needed (in new window)
		private function build(filepath:File):void {
			try {
				var fs:FileStream = new FileStream();
				fs.open(filepath, FileMode.READ);
				var chartData = new XML(fs.readUTFBytes(fs.bytesAvailable));
				fs.close();
			} catch(err:Error) {
				trace("error in main.build reading XML file " + err);
			}
			
			//creates a list of charts in XorgM file
			var chartList:XMLList = chartData.chart;
		
			var windowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			windowOptions.systemChrome = NativeWindowSystemChrome.NONE;
			windowOptions.type = NativeWindowType.LIGHTWEIGHT;
			windowOptions.transparent = true;
					
			//make new window for chart
			windows[filepath.nativePath] = new ChartWindow(windowOptions, chartList[0].@id);
			windows[filepath.nativePath].bounds = new Rectangle(62+30*xwin++, 39+30*ywin++, WMAX, HMAX);
			windows[filepath.nativePath].workFrame.titBar.text = filepath.nativePath;
			
			var test:Boolean = false;
			//for each chart in the XorgM file
			for each (var chart:XML in chartList) {
				
				try {
					//make new chart object
					windows[filepath.nativePath].charts[chart.@id] = new Chart();
					windows[filepath.nativePath].charts[chart.@id].build(chart);
					//if no chart has been added to stage, add one
					if (!test) {
						windows[filepath.nativePath].workFrame.whiteBoard.addChild(windows[filepath.nativePath].charts[chart.@id]);
						test=true;
					}
				} catch (e:Error) {
					trace("Error adding chart " + chart.@id + ":" + e);
				}
				
				if (xwin>15) {
					xwin=0;
					ywin=0;
				}
								
			}
			
			//build pieces and links
			windows[filepath.nativePath].buildPieces();
			windows[filepath.nativePath].buildLinks();
			
			//activate window
			windows[filepath.nativePath].activate();
			
			chartList = null;
			windowOptions = null;
			
		}
		
		
		//get unique id
		public function newID():String {
			for (var a:String in windows) {
				if (a == uID) {
					uID = (uint("0x"+uID)+1).toString(16);
					return newID();
				}
				for (var b:String in windows[a].charts) {
					if (b == uID) {
						uID = (uint("0x"+uID)+1).toString(16);
						return newID();
					}
					for(var c:String in windows[a].charts[b].pieces) {
						if (c == uID) {
							uID = (uint("0x"+uID)+1).toString(16);
							return newID();
						}
						for(var d:String in windows[a].charts[b].pieces[c].links) {
							if (d == uID) {
								uID = (uint("0x"+uID)+1).toString(16);
								return newID();
							}
						}
					}
					for(c in windows[a].charts[b].arrows) {
						if (c == uID) {
							uID = (uint("0x"+uID)+1).toString(16);
							return newID();
						}
					}
				}
			}
			return uID;
		}
		
		
		//save png
		public static function makePNG(e:Event):void {
			
			//pull chart movieclip from event
			var mc:MovieClip = (ChartWindow(e.target.stage.nativeWindow).workFrame.whiteBoard.getChildAt(1) is Chart)?ChartWindow(e.target.stage.nativeWindow).workFrame.whiteBoard.getChildAt(1):ChartWindow(e.target.stage.nativeWindow).workFrame.whiteBoard.getChildAt(2);
			
			try {
				
				ChartItem.toggleSelect(ChartWindow(e.target.stage.nativeWindow).workFrame.whiteBoard);
				
				//find the bounds of mc (chart)
				var region:Rectangle = new Rectangle();
				region = mc.getBounds(mc);
				
				//define transform matrix for drawing bitmap
				var mat:Matrix = new Matrix(1,0,0,1, 20-region.x, 20-region.y);
				//creat and draw bmd using mc and transformation
				var bmd:BitmapData = new BitmapData(region.width+40, region.height+40, false, 0xFFFFFF);
				bmd.draw(mc,mat);
				
				//encode as png and save to file
				var ba:ByteArray = PNGEncoder.encode(bmd);
				
				//prompt user for where to save
				var docsDir:File = File.documentsDirectory;
				try
				{
					docsDir.browseForSave("Save As");
					docsDir.addEventListener(Event.SELECT, savePNG);
				}
				catch (error:Error)
				{
					trace("Error saving PNG:", error.message);
				}
				
				//save to user specified file
				function savePNG(event:Event):void 
				{
					var file:File = event.target as File;
					if (file.nativePath.split(".")[file.nativePath.split(".").length-1] != "png") {
						file.nativePath += ".png";
					}
					var fs:FileStream = new FileStream();
					fs.open(file, FileMode.WRITE);
					fs.writeBytes(ba);
					fs.close();
				}
				
			} catch (e:Error) {
				trace ("Error encoding PNG: " + e);
			}
		
		}
		
		//make XorgM file
		public static function makeXorgM(e:Event):void {
			//if called from parent window
			if (e.target is NativeMenuItem) {
				//loop through each window and save xorgm chart
				for (var i:String in e.target.data.windows) {
					var org:XML = toXorgM(e.target.data.windows[i]);
					if (org.chart[0]) {
						var file:File = File.documentsDirectory.resolvePath(org.chart[0].@id + ".xorgm");
						var fs:FileStream = new FileStream();
						fs.open(file, FileMode.WRITE);
						fs.writeUTFBytes('<?xml version="1.0" encoding="utf-8"?>\n' + org.toXMLString());
						fs.close();
					}
				}
			} else { //called from chart window
				org = toXorgM(e.target.stage.nativeWindow);
				//prompt user for where to save
				var docsDir:File = File.documentsDirectory;
				try
				{
					docsDir.browseForSave("Save As");
					docsDir.addEventListener(Event.SELECT, saveXorgM);
				}
				catch (error:Error)
				{
					trace("Error saving XorgM:", error.message);
				}
				
				//save to user specified file
				function saveXorgM(event:Event):void 
				{
					var file:File = event.target as File;
					if (file.nativePath.split(".")[file.nativePath.split(".").length-1] != "xorgm") {
						file.nativePath += ".xorgm";
					}
					var fs:FileStream = new FileStream();
					fs.open(file, FileMode.WRITE);
					fs.writeUTFBytes('<?xml version="1.0" encoding="utf-8"?>\n' + org.toXMLString());
					fs.close();
					ChartWindow(e.target.stage.nativeWindow).workFrame.titBar.text = file.nativePath;
				}
			}
		}
		
		//main toXorgM method, returns XML from ChartWindow
		internal static function toXorgM(win:ChartWindow):XML {
			//make org XML obj
			var org:XML =
				<org xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="XorgM.xsd">
				</org>
			//loop through and add chart objects in selected window
			for (var i:String in win.charts) {
				org.appendChild(win.charts[i].toXorgM());
			}
			return org;
		}
		
		//on window close
		internal static function onWinClose (evt:Event) {
			
			var pWindow:NativeWindow = main.mainObj.parentWindow;
			
			//prevent window from closing
			evt.preventDefault();
			
			//window options for alert window
			var alertOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			alertOptions.type = NativeWindowType.LIGHTWEIGHT;
			alertOptions.systemChrome = NativeWindowSystemChrome.NONE;
			alertOptions.transparent = true;
			
			//make "window closing, do you want to save" alert
			var closeAlert:NativeWindow = new NativeWindow(alertOptions);
			closeAlert.alwaysInFront = true;
			closeAlert.bounds = (new Rectangle(Capabilities.screenResolutionX/2-200,Capabilities.screenResolutionY/2-100,400,200));
			closeAlert.stage.scaleMode = StageScaleMode.NO_SCALE;
			closeAlert.stage.align = StageAlign.TOP_LEFT;
			var alert:mcAlert = new mcAlert();
			alert.yes.addEventListener(MouseEvent.MOUSE_DOWN, close);
			alert.no.addEventListener(MouseEvent.MOUSE_DOWN, leaveIt);
			alert.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN, leaveIt);
			closeAlert.stage.addChild(alert);
			closeAlert.activate();
			
			//close window or application
			function close (e:Event) {
				try {
					e.currentTarget.stage.nativeWindow.close();
					if (evt.currentTarget == pWindow) {
						NativeApplication.nativeApplication.exit();
					} else {
						ChartWindow(evt.currentTarget).charts = null;
						evt.currentTarget.close();
						ChartItem.select = null;
					}
				} catch (err:Error) {
					trace("error closing window "+evt.currentTarget + " , " + err);
				}
			}
			
			function leaveIt (e:Event) {
				e.currentTarget.stage.nativeWindow.close();
			}
			
		}
	}
}