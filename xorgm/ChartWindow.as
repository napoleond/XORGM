package xorgm {
	
	import flash.display.*;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import fl.events.ColorPickerEvent;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.text.TextFieldType;
	
	class ChartWindow extends NativeWindow {
		
		internal var charts:Object = new Object;
		internal var grid:Boolean = true;
		internal var workFrame:MovieClip = new mcWorkArea;
		private var selRectO:Point = new Point;
		private var selBox:Sprite;
		internal static var texted:Array = new Array();
		internal var history:Array = new Array;
		internal var mark:uint = 0;
		internal var goat:Object;
		
		public function ChartWindow(options:NativeWindowInitOptions, id:String):void {
			
			super(options);
			history[0] = main.toXorgM(this);
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.orderInBackOf(main.toolWin);
			this.stage.addChild(workFrame);
			this.addEventListener(Event.CLOSING, main.onWinClose);
			
			workFrame.whiteBoard.addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			workFrame.whiteBoard.addEventListener(MouseEvent.ROLL_OVER, onMOver);
			workFrame.whiteBoard.addEventListener(MouseEvent.ROLL_OUT, onMOut);
			workFrame.whiteBoard.addEventListener(MouseEvent.MOUSE_UP, onMUp);
			workFrame.addEventListener(MouseEvent.MOUSE_DOWN, moveWin);
			function moveWin (e:MouseEvent):void {
				if (e.target is workback || e.target == workFrame.titBar) {
					e.currentTarget.stage.nativeWindow.startMove();
					main.toolSelect = false;
					ChartItem.toggleSelect(e.currentTarget.stage);
				}
			}
			workFrame.addEventListener(MouseEvent.MOUSE_UP, function(e:Event) {
																			 if (e.target is workback) {
																			 	main.shapeTools.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
																			 }
																			 });
			workFrame.close.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
																						if (e.target == e.currentTarget) {
																							e.currentTarget.stage.nativeWindow.dispatchEvent(new Event(Event.CLOSING));
																						}
																					});
			
			//on mouse down
			function onMDown (e:MouseEvent):void {
				
				//if toolbar palette selected
				if(main.toolSelect) {
					var target:Object;
					var id:String = main.mainObj.newID();
					var etarg:Object = e.target;
					//figure out which chart to add to
					if (etarg is mcWorkStage) {
						target = (grid)?e.currentTarget.getChildAt(2):e.currentTarget.getChildAt(1);
					} else if (etarg is Chart) {
						target = etarg;
					} else if (etarg is Piece) {
						if (etarg.parent.parent is Piece) {
							target = etarg.parent;
						} else if (etarg.getChildAt(0) is Chart) {
							target = etarg.getChildAt(0);
						} else if (etarg.parent.numChildren > 1 && etarg.parent.getChildAt(1) is Chart) {
							target = etarg.getChildAt(1);
						} else {
							if (etarg.shape != "circle"){
								var temp:String = etarg.id;
								charts[temp] = new Chart();
								charts[temp].id = temp;
								etarg.addChild(charts[temp]);
								target = charts[temp];
							} else {
								target = (grid)?e.currentTarget.getChildAt(2):e.currentTarget.getChildAt(1);
							}
						}
					} else if (etarg.parent is Piece) {
						if (etarg.parent.parent.parent is Piece) {
							target = etarg.parent.parent;
						} else if (etarg.parent.getChildAt(0) is Chart) {
							target = etarg.parent.getChildAt(0);
						} else if (etarg.parent.numChildren > 1 && etarg.parent.getChildAt(1) is Chart) {
							target = etarg.parent.getChildAt(1);
						} else {
							if (etarg.parent.shape != "circle"){
								temp = etarg.parent.id;
								charts[temp] = new Chart();
								charts[temp].id = temp;
								etarg.parent.addChild(charts[temp]);
								target = charts[temp];
							} else {
								target = (grid)?e.currentTarget.getChildAt(2):e.currentTarget.getChildAt(1);
							}
						}
					} else if (etarg is Sprite) {
						if (etarg.parent is Chart) target = etarg.parent;
						else target = (grid)?e.currentTarget.getChildAt(2):e.currentTarget.getChildAt(1);
					}
					
					//try making chart item
					try {
						if (ChartItem.select[0] is Arrow && target) {
							//add arrow
							Chart(target).arrows[id] = new Arrow;
							Chart(target).addChild(Chart(target).arrows[id]);
							Chart(target).arrows[id].color = main.mainObj.sampleArrow.color;
							Chart(target).arrows[id].stroke = main.mainObj.sampleArrow.stroke;
							Chart(target).arrows[id].bg = main.mainObj.sampleArrow.bg;
							Chart(target).arrows[id].shape = main.mainObj.sampleArrow.shape;
							Chart(target).arrows[id].shapeStyle = main.mainObj.sampleArrow.shapeStyle.slice();
							Chart(target).arrows[id].customStyle = main.mainObj.sampleArrow.customStyle;
							Chart(target).arrows[id].filterStyle = main.mainObj.sampleArrow.filterStyle.slice();
							Chart(target).arrows[id].title = main.mainObj.sampleArrow.title;
							Chart(target).arrows[id].top=goat.y-((target.parent is Piece)?target.parent.y:0);
							Chart(target).arrows[id].left=goat.x-((target.parent is Piece)?target.parent.x:0);
							Chart(target).arrows[id].bottom=NaN;
							Chart(target).arrows[id].buildChartItem();
							if (target.parent is Piece) {
								var timer:Timer = new Timer(100,1);
								timer.addEventListener(TimerEvent.TIMER, buildPiece);
								timer.start();
								function buildPiece(e:TimerEvent):void {
									target.parent.buildChartItem();
								}
							}
						} else if (ChartItem.select[0] is Piece && target) {
							//add piece
							Chart(target).pieces[id] = new Piece();
							Chart(target).addChild(Chart(target).pieces[id]);
							Chart(target).pieces[id].color = main.mainObj.samplePiece.color;
							Chart(target).pieces[id].stroke = main.mainObj.samplePiece.stroke;
							Chart(target).pieces[id].bg = main.mainObj.samplePiece.bg;
							Chart(target).pieces[id].shape = main.mainObj.samplePiece.shape;
							Chart(target).pieces[id].shapeStyle = main.mainObj.samplePiece.shapeStyle.slice();
							Chart(target).pieces[id].customStyle = main.mainObj.samplePiece.customStyle;
							Chart(target).pieces[id].filterStyle = main.mainObj.samplePiece.filterStyle.slice();
							Chart(target).pieces[id].id = id;
							Chart(target).pieces[id].title = main.mainObj.samplePiece.title;
							Chart(target).pieces[id].x=0;
							Chart(target).pieces[id].y=0;
							Chart(target).pieces[id].buildChartItem();
							Chart(target).pieces[id].top=goat.y-((target.parent is Piece)?target.parent.y:0);
							Chart(target).pieces[id].left=goat.x-((target.parent is Piece)?target.parent.x:0);
							Chart(target).pieces[id].x=Chart(target).pieces[id].left;
							Chart(target).pieces[id].y=Chart(target).pieces[id].top;
							if (target.parent is Piece) {
								target.parent.buildChartItem();
							}
						}
					} catch (err:Error) {
						trace("Error adding Chart Item: " + err);
					}
				} else {
					//find nearest chart item and drag it
					var dingle:Object;
					var dingles:Array = e.currentTarget.getObjectsUnderPoint(new Point(stage.mouseX,stage.mouseY));
					dingles.forEach(dingleBot);
					
					function dingleBot(e:Object, i:int, a:Array):void {
						if (e is Sprite && e.parent is mcWorkStage || e is mcWorkStage) {
						} else if (e is ChartItem) {
							dingle = e;
						} else if (e.parent is ChartItem) {
							dingle = e.parent;
						} else if (e.parent.parent is Arrow) {
							dingle = e.parent.parent;
						} else if (e.parent.parent.parent is Arrow) {
							dingle = e.parent.parent.parent;
						} else if (e.parent.parent.parent.parent is Arrow) {
							dingle = e.parent.parent.parent.parent;
						}
					}
					
					if (main.filling) {
						ChartItem.toggleSelect(dingle);
						if (dingle) main.toolBar.bgCP.dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE, main.mainObj.samplePiece.bg));
						ChartItem.toggleSelect(stage);
					} else if (main.texting) {
						if (dingle) {
							ChartItem(dingle).t.selectable = true;
							ChartItem(dingle).t.type = TextFieldType.INPUT;
							if (ChartItem(dingle).shape == "circle") {
								ChartItem(dingle).t.addEventListener(Event.CHANGE, circleJerk);
							}
							texted.push(dingle);
						} else {
							buildLinks();
						}
					} else if(dingle) {
						if (!main.linking) dingle.drag();
						if (ChartItem.select) ChartItem.select.forEach(drag);
						ChartItem.toggleSelect(dingle);
						if (dingle is Arrow && e.target == Arrow(dingle).handles[2]) Arrow(dingle).handles[2].addEventListener(Event.ENTER_FRAME,Arrow.handleBarMoustache);
					} else {
						main.shifting = true;
						selRectO.x = workFrame.whiteBoard.mouseX;
						selRectO.y = workFrame.whiteBoard.mouseY;
						ChartItem.toggleSelect(e.currentTarget);
						e.currentTarget.addEventListener(Event.ENTER_FRAME, selRect);
					}
					
					function drag(element:ChartItem, index:int, arr:Array) {
						element.drag();
					}
					
					function circleJerk (evt:Event) {
						ChartItem(evt.currentTarget.parent).graphics.clear();
						ChartItem(evt.currentTarget.parent).graphics.beginFill(ChartItem(evt.currentTarget.parent).bg);
						ChartItem(evt.currentTarget.parent).graphics.drawCircle(((evt.currentTarget.width>20)?evt.currentTarget.width:20)/2+10, ((evt.currentTarget.width>20)?evt.currentTarget.width:20)/2+10, ((evt.currentTarget.width>20)?evt.currentTarget.width:20)/2+10);
						ChartItem(evt.currentTarget.parent).graphics.endFill();
						evt.currentTarget.y = ((evt.currentTarget.width>20)?evt.currentTarget.width:20)/2+10-evt.currentTarget.height/2;
						evt.currentTarget.x = 10;
					}
				}
			}
						
			function selRect(evt:Event) {
				if (!selBox) selBox = new Sprite;
				selBox.graphics.clear();
				if (main.linking) selBox.graphics.lineStyle(1,0x0000FF,0.6);
				else selBox.graphics.lineStyle(1,0xFF0000,0.6);
				selBox.graphics.drawRect(selRectO.x, selRectO.y, workFrame.whiteBoard.mouseX-selRectO.x, workFrame.whiteBoard.mouseY-selRectO.y);
				evt.currentTarget.addChild(selBox);
				var temp:Chart;
				if (evt.currentTarget.getChildAt(1) is Chart) {
					temp = evt.currentTarget.getChildAt(1);
				} else if (evt.currentTarget.numChildren > 2 && evt.currentTarget.getChildAt(2) is Chart) {
					temp = evt.currentTarget.getChildAt(2);
				}
				for (var i:uint = 0; i<temp.numChildren; i++) {
					if (temp.getChildAt(i) is ChartItem) {
						if (selBox.getBounds(selBox).intersects(temp.getChildAt(i).getBounds(selBox))) {
							ChartItem.toggleSelect(temp.getChildAt(i));
						} else if (ChartItem.select && ChartItem.select.indexOf(temp.getChildAt(i)) >= 0) {
							temp.getChildAt(i).transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
							ChartItem.select.splice(ChartItem.select.indexOf(temp.getChildAt(i)),1);
						}
					}
				}
			}
			
			function onMOver (e:MouseEvent):void {
				if(main.toolSelect && ChartItem.select) {
					//draw translucent item
					if (ChartItem.select[0] is Arrow) {
						//add arrow
						goat = new Arrow;
						e.currentTarget.addChild(goat);
						goat.color = main.mainObj.sampleArrow.color;
						goat.stroke = main.mainObj.sampleArrow.stroke;
						goat.bg = main.mainObj.sampleArrow.bg;
						goat.shape = main.mainObj.sampleArrow.shape;
						goat.shapeStyle = main.mainObj.sampleArrow.shapeStyle.slice();
						goat.customStyle = main.mainObj.sampleArrow.customStyle;
						goat.filterStyle = main.mainObj.sampleArrow.filterStyle.slice();
						goat.title = main.mainObj.sampleArrow.title;
						goat.top=e.currentTarget.mouseY;
						goat.left=e.currentTarget.mouseX-(ChartItem.select[0].width-19.5)/2;
						goat.bottom=NaN;
						goat.buildChartItem();
					} else if (ChartItem.select[0] is Piece) {
						//add piece
						goat = new Piece();
						e.currentTarget.addChild(goat);
						goat.color = main.mainObj.samplePiece.color;
						goat.stroke = main.mainObj.samplePiece.stroke;
						goat.bg = main.mainObj.samplePiece.bg;
						goat.shape = main.mainObj.samplePiece.shape;
						goat.shapeStyle = main.mainObj.samplePiece.shapeStyle.slice();
						goat.customStyle = main.mainObj.samplePiece.customStyle;
						goat.filterStyle = main.mainObj.samplePiece.filterStyle.slice();
						goat.id = id;
						goat.title = main.mainObj.samplePiece.title;
						goat.x=0;
						goat.y=0;
						goat.buildChartItem();
						goat.top=e.currentTarget.mouseY-goat.height/2;
						goat.left=e.currentTarget.mouseX-goat.width/2;
						goat.x=goat.left;
						goat.y=goat.top;
					}
					//drag it
					MovieClip(goat).alpha = 0.5;
					MovieClip(goat).mouseEnabled = false;
					MovieClip(goat).mouseChildren = false;
					goat.drag();
				}
			}
			
			function onMOut (e:MouseEvent):void {
				if (goat != null) {
					//end drag
					goat.eDrag(true);
					//delete translucent object
					e.currentTarget.removeChild(goat);
					goat = null;
				}
			}
			
			//on mouse up
			function onMUp (e:MouseEvent):void {
				var target:Object;
				if (e.target is ChartItem) target = e.target;
				else if (e.target.parent is ChartItem) target = e.target.parent;
				if (target) {
					//stop drag
					if (ChartItem.select) ChartItem.select.forEach(eDrag);
					if (target is Arrow) {
						main.linking = null;
						Arrow(target).handles[2].removeEventListener(Event.ENTER_FRAME,Arrow.handleBarMoustache);
					}
					history.splice(mark+1);
					history.push(main.toXorgM(e.target.stage.nativeWindow));
					mark = history.length-1;
				} else {
					if (ChartItem.select) ChartItem.select.forEach(eDrag);
					e.currentTarget.removeEventListener(Event.ENTER_FRAME, selRect);
					if (selBox) {
						main.shifting = false;
						selBox.parent.removeChild(selBox);
						selBox = null;
						buildLinks();
					}
					main.linking = null;
				}
			}
					
			function eDrag(element:ChartItem, index:int, arr:Array) {
				element.eDrag();
				if (element is Arrow) {
					main.linking = null;
					Arrow(element).handles[2].removeEventListener(Event.ENTER_FRAME,Arrow.handleBarMoustache);
				}
			}
					
			//build chart menu
			//----------------------------
			//export button
			workFrame.exportBtn.txt.text = "Export PNG";
			workFrame.exportBtn.addEventListener(MouseEvent.CLICK, main.makePNG);
			workFrame.exportBtn.enable();
			//xorgm button
			workFrame.saveBtn.txt.text = "Save";
			workFrame.saveBtn.addEventListener(MouseEvent.CLICK, main.makeXorgM);
			workFrame.saveBtn.enable();
			//toggle grid tool
			workFrame.gridBtn.txt.text = "Toggle Grid";
			workFrame.gridBtn.addEventListener(MouseEvent.CLICK, toggleGrid);
			workFrame.gridBtn.enable();
			//undo button
			workFrame.undoBtn.txt.text = "Undo";
			workFrame.undoBtn.addEventListener(MouseEvent.CLICK, undo);
			workFrame.undoBtn.enable();
			//redo button
			workFrame.redoBtn.txt.text = "Redo";
			workFrame.redoBtn.addEventListener(MouseEvent.CLICK, redo);
			workFrame.redoBtn.enable();
			
			
			if (grid) {
				drawGrid();
			}
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyOn);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyOff);
			
			function onKeyOn(evt:KeyboardEvent) {
				
				if (evt.shiftKey) {
					main.shifting = true;
				}
				if (evt.ctrlKey) {
					if (evt.keyCode == 90) {
						undo();
					} else if (evt.keyCode == 89) {
						redo();
					}
				}
				if (main.texting && evt.keyCode == 13) {
					if(texted && texted[texted.length-2] is Piece) {
						Piece(texted[texted.length-2]).t.replaceSelectedText("\n");
					}
				} else if (ChartItem.select) {
					if (evt.keyCode == 46) {
						ChartItem.select.forEach(function (o:*,i:int,arr:Array) {
							if (o is ChartItem) {
								var empty:Boolean = true;
								if (o is Piece) {
									delete Chart(o.parent).pieces[Piece(o).id];
									
									for each(var p:Link in Piece(o).links) {
										if (p.parent) p.parent.removeChild(p);
									}
								}
								if(o is Arrow) {
									//delete arrows[arrowid]
									for (var l:String in Chart(o.parent).arrows) {
										if (Chart(o.parent).arrows[l] === o) delete Chart(o.parent).arrows[l];
									}
								}
								for (var d:String in Chart(o.parent).pieces) {
									empty = false;
									if (o is Piece) {
										for (var e:String in Chart(o.parent).pieces[d].links) {
											if (Chart(o.parent).pieces[d].links[e].target == Piece(o).id) {
												o.parent.removeChild(Chart(o.parent).pieces[d].links[e]);
											}
										}
									}
								}
								for (d in Chart(o.parent).arrows) {
									empty = false;
								}
								if (o.parent.parent is Piece) var temp:Piece = o.parent.parent;
								var theName:String = Chart(o.parent).id;
								o.parent.removeChild(o);
								if (temp) {
									if (empty) {
										temp.removeChild(charts[theName]);
										delete charts[theName];
									}
									temp.buildChartItem();
								}
							}
						});
						ChartItem.select = null;
					} else if (evt.keyCode == 37) {
						ChartItem.select.forEach(function (e:*,i:int,arr:Array) {
																			   if (e is ChartItem) {
																				   if (grid) {
																					   e.left -= 10;
																					   if (e is Arrow) e.right -=10;
																				   } else {
																					   e.left--;
																					   if (e is Arrow) e.right--;
																				   }
																				   e.x = e.left;
																			   }
																			   });
						buildLinks();
					} else if (evt.keyCode == 38) {
						ChartItem.select.forEach(function (e:*,i:int,arr:Array) {
																			   if (e is ChartItem) {
																				   if (grid) {
																					   e.top -= 10;
																					   if (e is Arrow) e.bottom -=10;
																				   } else {
																					   e.top--;
																					   if (e is Arrow) e.bottom--;
																				   }
																				   e.y = e.top;
																			   }
																			   });
						buildLinks();
					} else if (evt.keyCode == 39) {
						ChartItem.select.forEach(function (e:*,i:int,arr:Array) {
																			   if (e is ChartItem) {
																				   if (grid) {
																					   e.left += 10;
																					   if (e is Arrow) e.right +=10;
																				   } else {
																					   e.left++;
																					   if (e is Arrow) e.right++;
																				   }
																				   e.x = e.left;
																			   }
																			   });
						buildLinks();
					} else if (evt.keyCode == 40) {
						ChartItem.select.forEach(function (e:*,i:int,arr:Array) {
																			   if (e is ChartItem) {
																				   if (grid) {
																					   e.top += 10;
																					   if (e is Arrow) e.bottom +=10;
																				   } else {
																					   e.top++;
																					   if (e is Arrow) e.bottom++;
																				   }
																				   e.y = e.top;
																			   }
																			   });
						buildLinks();
					}
				}
			}
			
			function onKeyOff(evt:KeyboardEvent) {
				if (evt.keyCode == 16) {
					main.shifting = false;
				} else if (evt.keyCode == 46 || evt.keyCode == 37 || evt.keyCode == 38 || evt.keyCode == 39 || evt.keyCode == 40) {
					history.splice(mark+1);
					history.push(main.toXorgM(evt.currentTarget.stage.nativeWindow));
					mark = history.length-1;
				}
			}
		}
		
		//called after all charts are built, loops through all pieces to build, places charts in pieces where necessary
		public function buildPieces():void {
			for (var t:String in charts) {
				for (var u:String in charts[t].pieces) {
					for (var t2:String in charts) {
						//if chart id matches piece id, put chart IN piece
						if (t2 == u) {
							charts[t].pieces[u].addChild(charts[t2]);
							charts[t].pieces[u].buildChartItem();
						}
					}
				}
			}
		}
		//called after all charts are built, loops through all links to make connections
		public function buildLinks():void {
			var test:Boolean = false;
			for (var t:String in charts) {
				for (var u:String in charts[t].pieces) {
					for (var v:String in charts[t].pieces[u].links) {
						if(charts[t].pieces[charts[t].pieces[u].links[v].target]) {
							//make link
							charts[t].pieces[u].links[v].make(charts[t].pieces[u]);
						}
					}
				}
			}
		}
		//toggle grid
		internal function toggleGrid(e:Event):void {
			if (grid) {
				grid = false;
				workFrame.whiteBoard.removeChildAt(1);
			} else {
				grid = true;
				drawGrid();
			}
		}
		//draw grid
		public function drawGrid():void {
			var gridLines:Sprite = new Sprite();
			var box:MovieClip = this.workFrame.whiteBoard;
			gridLines.graphics.lineStyle(1,0,0.1);
			for (var i:int=-1; i<box.width; i+=10) {
				gridLines.graphics.moveTo(i,0);
				gridLines.graphics.lineTo(i,box.height);
			}
			for (i=-1; i<box.height; i+=10) {
				gridLines.graphics.moveTo(0,i);
				gridLines.graphics.lineTo(box.width,i);
			}
			gridLines.x=0;
			gridLines.y=0;
			workFrame.whiteBoard.addChildAt(gridLines,1);
		}
		
		private function undo(evt:MouseEvent = null):void {
			main.shapeTools.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			if (mark > 0) mark--;
			for (var i=0;i<workFrame.whiteBoard.numChildren;i++) {
				if (workFrame.whiteBoard.getChildAt(i) is Chart) workFrame.whiteBoard.removeChildAt(i);
			}
			charts = new Object;
			var test:Boolean = false;
			for each (var chart:XML in history[mark].chart) {
				try {
					//make new chart object
					charts[chart.@id] = new Chart();
					charts[chart.@id].build(chart);
					if (!test) {
						workFrame.whiteBoard.addChild(charts[chart.@id]);
						test=true;
					}
				} catch (e:Error) {
					trace("Error adding chart " + chart.@id + ":" + e);
				}
			}
			if (!test) {
				var ID = main.mainObj.newID();
				charts[ID] = new Chart();
				charts[ID].id = ID;
				workFrame.whiteBoard.addChild(charts[ID]);
			}
			buildPieces();
			buildLinks();
		}
		
		private function redo(evt:MouseEvent = null):void {
			main.shapeTools.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			if (mark < history.length-1) mark++;
			for (var i=0;i<workFrame.whiteBoard.numChildren;i++) {
				if (workFrame.whiteBoard.getChildAt(i) is Chart) workFrame.whiteBoard.removeChildAt(i);
			}
			charts = new Object;
			var test:Boolean = false;
			for each (var chart:XML in history[mark].chart) {
				try {
					//make new chart object
					charts[chart.@id] = new Chart();
					charts[chart.@id].build(chart);
					if (!test) {
						workFrame.whiteBoard.addChild(charts[chart.@id]);
						test=true;
					}
				} catch (e:Error) {
					trace("Error adding chart " + chart.@id + ":" + e);
				}
			}
			buildPieces();
			buildLinks();
		}
	}
}