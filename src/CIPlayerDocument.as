package  
{
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author hbb
	 */
	public class CIPlayerDocument extends Sprite
	{
		
		private var params:ExternalParams;
		private var player:FLVPlayback;
		private var _currPath:String;
		private var _timer:Timer;
		
		public function CIPlayerDocument() 
		{
			super();
			
			__init();
		}
		
		private function __init():void
		{
			params = new ExternalParams(stage.loaderInfo.parameters);
			//params = new ExternalParams({skin:'SkinOverPlayStopSeekFullVol.swf', debug:'1', source:'nonmember-event.flv'});
			debug(params.toString());
			
			__initStage();
			__initJSCall();
			__initPlayer();
			__initListeners();
			__onResize(null);
			
			debug('Player inited');
		}
		
		private function __initListeners():void
		{
			stage.addEventListener(Event.MOUSE_LEAVE, __onMouseLeave);
			stage.addEventListener(Event.RESIZE, __onResize);
			player.addEventListener(VideoEvent.COMPLETE, __onComplete);
		}
		private function __initPlayer():void
		{
			player = new FLVPlayback();
			addChild(player);
			player.autoPlay = params.autoPlay;
			player.autoRewind = params.autoRewind;
			player.scaleMode = params.scaleMode;
			player.skin = params.skin;
			player.skinAutoHide = params.skinAutoHide;
			player.skinBackgroundAlpha = params.skinBackgroundAlpha;
			player.skinBackgroundColor = params.skinBackgroundColor;
			player.skinFadeTime = params.skinFadeTime;
			player.volume = params.volume;
			if (params.source) __playVideo(params.source);
			
			_timer = new Timer(params.loadDelayTime, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, __onTimeToPlayVideo);
		}
		private function __initJSCall():void
		{
			ExternalInterface.addCallback('playVideo', playVideo);
			ExternalInterface.addCallback('stopVideo', stopVideo);
			ExternalInterface.addCallback('pauseVideo', pauseVideo);
			ExternalInterface.addCallback('resumeVideo', resumeVideo);
		}
		
		private function __initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
		}
		
		private function __onMouseLeave(e:Event):void 
		{
			debug('mouse leave stage');
			try {
				stage.addEventListener(MouseEvent.MOUSE_OVER, __onMouseOver);
				player.skinFadeTime = 0;
				player.skinAutoHide = false;
				player.getChildAt(2).visible = false;
			}catch(er:Error){}
			
			__createAlphaCover();
		}
		
		private function __onMouseOver(e:MouseEvent):void 
		{
			debug('mouse over stage');
			try {
				stage.removeEventListener(MouseEvent.MOUSE_OVER, __onMouseOver);
				player.skinFadeTime = params.skinFadeTime;
				player.skinAutoHide = params.skinAutoHide;
				player.getChildAt(2).visible = true;
			}catch (er:Error) { }
			
			__removeAlphaCover();
		}
		private function __removeAlphaCover():void
		{
			var s:Sprite = getChildByName('alphaCover') as Sprite;
			if (null == s) return;
			removeChild(s);
		}
		private function __createAlphaCover():void
		{
			__removeAlphaCover();
			var s:Sprite = getChildByName('alphaCover') as Sprite;
			if (null == s) s = new Sprite();
			s.name = 'alphaCover';
			s.graphics.clear();
			s.graphics.beginFill(0);
			s.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			s.graphics.endFill();
			s.alpha = 0;
			addChild(s);
		}
		
		private function __onResize(e:Event):void 
		{
			if (stage.displayState == StageDisplayState.FULL_SCREEN)
				return;
			
			debug('Player resize(stageWidth: ' + stage.stageWidth + ', stageHeight: ' + stage.stageHeight);
			try{
				player.x = 0;
				player.y = 0;
				player.setSize(stage.stageWidth, stage.stageHeight);
				
			}catch (er:Error) { }
		}
		
		private function __onComplete(e:VideoEvent):void 
		{
			debug('Player complete');
			if (params.loop)
			{
				__playVideo();
			}
		}
		public function resumeVideo():void
		{
			debug('Player resume');
			__playVideo();
		}
		
		public function pauseVideo():void
		{
			debug('Player pause');
			player.pause();
		}
		
		public function stopVideo():void
		{
			debug('Player stop');
			player.stop();
		}
		
		public function playVideo(path:String):void
		{
			if (!params.reloadForSame && _currPath == path)
				return;
			stopVideo();
			_currPath = path;
			_timer.reset();
			_timer.start();
			
			debug('Player hold to play: [' + path + ']');
			//__playVideo(path);
		}
		
		private function __playVideo(source:String = ''):void
		{
			try{
				if (source == '' || player.source == source)
					player.play();
				else
					player.play(source);
			}catch (er:Error) {
				debug('Player error: [' + er.toString() + ']');
			}
		}
		
		private function __onTimeToPlayVideo(e:TimerEvent):void 
		{
			debug('Player play: [' + _currPath + ']');
			__playVideo(_currPath);
		}
		
		private function debug(msg:String):void
		{
			if (!params.debug) return;
			
			var tf:TextField = __createDebugArea();
			tf.appendText(msg + '\n');
			tf.scrollV = tf.maxScrollV;
		}
		
		private function __createDebugArea():TextField
		{
			var tf:TextField = getChildByName('debug') as TextField;
			if (null == tf)	tf = new TextField();
			addChild(tf);
			tf.name = 'debug';
			tf.border = true;
			tf.borderColor = 0x000000;
			tf.background = true;
			tf.backgroundColor = 0xFFFFFF;
			tf.textColor = 0x333333;
			tf.width = stage.stageWidth * .8;
			tf.height = stage.stageHeight * .8;
			return tf;
		}
		
	}
	
}
