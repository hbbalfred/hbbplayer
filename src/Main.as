package 
{
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import flash.display.DisplayObject;
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
	public class Main extends Sprite 
	{
		
		private var params:ExternalParams;
		private var player:FLVPlayback;
		private var _preview:Preview;
		private var _currPath:String;
		private var _timer:Timer;
		private const _cover:Sprite = new Sprite();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			params = new ExternalParams(stage.loaderInfo.parameters);
			//params = new ExternalParams({skin:'skin/Martell2010PlayerSkin.swf', debug:'0', source:'test.flv', skinAutoHide:'0', skinUnder:'1', autoPlay:'0', preview:'preview.jpg'});
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
			player.addEventListener(VideoEvent.SKIN_LOADED, __onSkinLoaded);
		}
		private function __initPlayer():void
		{
			_timer = new Timer(params.loadDelayTime, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, __onTimeToPlayVideo);
			
			player = new FLVPlayback();
			addChild(player);
			if (params.source) __playVideo(params.source);
			player.autoPlay = params.autoPlay;
			player.autoRewind = params.autoRewind;
			player.scaleMode = params.scaleMode;
			player.skin = params.skin;
			player.skinAutoHide = params.skinAutoHide;
			player.skinBackgroundAlpha = params.skinBackgroundAlpha;
			player.skinBackgroundColor = params.skinBackgroundColor;
			player.skinFadeTime = params.skinFadeTime;
			player.volume = params.volume;
			
			if (params.preview)
			{
				player.autoPlay = false;
				player.addEventListener(VideoEvent.COMPLETE, __onVideoComplete);
				addChild(_preview = new Preview(params.preview));
				_preview.addEventListener(MouseEvent.CLICK, __onMouseClick);
			}
		}
		
		private function __initJSCall():void
		{
			if (!ExternalInterface.available) return;
			
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
		
		private function __onVideoComplete(e:VideoEvent):void 
		{
			if (_preview) __showPreview();
		}
		
		private function __showPreview():void
		{
			if (_preview) { addChild(_preview); __onResize(null); }
		}
		
		private function __hidePreview():void
		{
			if (_preview && _preview.parent) _preview.parent.removeChild(_preview);
		}
		
		private function __onMouseClick(e:MouseEvent):void
		{
			debug('mouse click target: ' + e.target);
			
			switch(e.target)
			{
				case _preview:
					__playVideo();
					__hidePreview();
					break;
				default:
			}
		}
		
		private function __onMouseLeave(e:Event):void 
		{
			if (!params.skinAutoHide) return;
			
			debug('mouse leave stage');
			
			try {
				stage.addEventListener(MouseEvent.MOUSE_OVER, __onMouseOver);
				player.skinFadeTime = 0;
				player.skinAutoHide = false;
				__playerSkin().visible = false;
			}catch(er:Error){}
			
			__createAlphaCover();
		}
		
		private function __onMouseOver(e:MouseEvent):void 
		{
			if (!params.skinAutoHide) return;
			
			debug('mouse over stage');
			
			try {
				stage.removeEventListener(MouseEvent.MOUSE_OVER, __onMouseOver);
				player.skinFadeTime = params.skinFadeTime;
				player.skinAutoHide = params.skinAutoHide;
			}catch (er:Error) { }
			
			__removeAlphaCover();
		}
		private function __removeAlphaCover():void
		{
			_cover.graphics.clear();
			if(_cover.parent) removeChild(_cover);
		}
		private function __createAlphaCover():void
		{
			_cover.graphics.clear();
			_cover.graphics.beginFill(0);
			_cover.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_cover.graphics.endFill();
			_cover.alpha = 0;
			addChild(_cover);
		}
		
		private function __playerSkin():Sprite
		{
			var s:Sprite;
			try {
				s = player.getChildAt( params.skinAutoHide ? 2 : 1 ) as Sprite;
			}catch (er:Error) {
				s = new Sprite();
			}
			return s;
		}
		
		private function __onSkinLoaded(e:VideoEvent):void 
		{
			__onResize(null);
		}
		
		private function __onResize(e:Event):void 
		{
			if (stage.displayState == StageDisplayState.FULL_SCREEN)
				return;
			
			debug('Player resize(stageWidth: ' + stage.stageWidth + ', stageHeight: ' + stage.stageHeight);
			
			try{
				player.x = 0;
				player.y = 0;
				
				var offsetH:Number = params.skinUnder ? __playerSkin().getChildAt(0).height : 0;
				player.setSize(stage.stageWidth, stage.stageHeight - offsetH);
			}catch (er:Error) {
				player.setSize(stage.stageWidth, stage.stageHeight);
			}
			
			if (_preview && _preview.parent)
			{
				_preview.x = player.width * .5;
				_preview.y = player.height * .5;
			}
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