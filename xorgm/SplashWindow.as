package xorgm {
	
	import flash.display.*;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	class SplashWindow extends NativeWindow {
		public function SplashWindow(options:NativeWindowInitOptions):void {
			super(options);
			this.activate();
			main.backWin.activate();
			main.shapesWin.activate();
			main.toolWin.activate();
			main.topWin.activate();
			this.bounds = new Rectangle(Capabilities.screenResolutionX/2-400,Capabilities.screenResolutionY/2-369,800,800);
			this.alwaysInFront = true;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			var splash = new mcSplash();
			this.stage.addChild(splash);
			var timer = new Timer(2500,1);
			timer.addEventListener(TimerEvent.TIMER,function (e:TimerEvent) {
																		   main.toolBar.selBtn.gotoAndStop(3);
																		   main.splashWin.visible = false;
																  });
			timer.start();
		}
	}
}