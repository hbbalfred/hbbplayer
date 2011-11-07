package  
{
	
	/**
	 * ...
	 * @author hbb
parameters
 source=x.flv
 skin=link
 loop=0|1 (default:0)
 autoPlay=0|1 (default:1)
 autoRewind=0|1 (default:1)
 scaleMode=exactFit|maintainAspectRatio|noScale (default:exactFit)
 skinAutoHide=0|1 (default:1)
 skinBackgroundAlpha=(0.0~1.0) (default:0.8)
 skinBackgroundColor=(0x000000~0xFFFFFF) (default:0x333333)
 skinFadeTime=(0~INFINITY) (default:500,  unit:ms)
 skinUnder=0|1 (default:0)
 volume=(0.0~1.0) (default:1.0)
 debug=0|1 (default:0)
	 */
	public class ExternalParams 
	{
		private var _src:Object;
		public function ExternalParams(src:Object) 
		{
			_src = src;
		}
		
		public function get source():String
		{
			if ('source' in _src) return _src.source;
			else return '';
		}
		
		public function get skin():String
		{
			if ('skin' in _src) return _src.skin;
			else return '';
		}
		
		public function get loop():Boolean
		{
			if ('loop' in _src) return _src.loop == '1';
			else return false;
		}
		
		public function get autoPlay():Boolean
		{
			if ('autoPlay' in _src) return _src.autoPlay == '1';
			else return true;
		}
		
		public function get autoRewind():Boolean
		{
			if ('autoRewind' in _src) return _src.autoRewind == '1';
			else return true;
		}
		
		public function get scaleMode():String
		{
			if ('scaleMode' in _src) return _src.scaleMode;
			else return 'exactFit';
		}
		
		public function get skinAutoHide():Boolean
		{
			if ('skinAutoHide' in _src) return _src.skinAutoHide == '1';
			else return true;
		}
		
		public function get skinBackgroundAlpha():Number
		{
			if ('skinBackgroundAlpha' in _src) return parseFloat(_src.skinBackgroundAlpha);
			else return 0.8;
		}
		
		public function get skinBackgroundColor():int
		{
			if ('skinBackgroundColor' in _src) return parseInt(_src.skinBackgroundColor);
			else return 0x333333;
		}
		
		public function get skinFadeTime():int
		{
			if ('skinFadeTime' in _src) return parseInt(_src.skinFadeTime);
			else return 500;
		}
		
		public function get skinUnder():Boolean
		{
			if ('skinUnder' in _src) return _src.skinUnder == '1';
			else return false;
		}
		
		public function get volume():Number
		{
			if ('volume' in _src) return parseFloat(_src.volume);
			else return 1.0;
		}
		
		public function get reloadForSame():Boolean
		{
			if ('reloadForSame' in _src) return _src.reloadForSame == '1';
			else return false;
		}
		
		public function get loadDelayTime():int
		{
			if ('loadDelayTime' in _src) return parseInt(_src.loadDelayTime);
			else return 1000;
		}
		
		public function get debug():Boolean
		{
			if ('debug' in _src) return _src.debug == '1';
			else return false;
		}
		
		public function get preview():String
		{
			if ('preview' in _src) return _src.preview;
			else return '';
		}
		
		public function toString():String
		{
			return '[Params' +
					'\n source:' + source +
					'\n skin:' + skin +
					'\n loop:' + loop +
					'\n autoPlay:' + autoPlay +
					'\n autoRewindsource:' + autoRewind +
					'\n scaleMode:' + scaleMode +
					'\n skinAutoHide:' + skinAutoHide +
					'\n skinBackgroundAlpha:' + skinBackgroundAlpha +
					'\n skinBackgroundColor:' + '0x' + skinBackgroundColor.toString(16) +
					'\n skinFadeTime:' + skinFadeTime +
					'\n volume:' + volume +
					'\n reloadForSame:' + reloadForSame +
					'\n loadDelayTime:' + loadDelayTime +
					'\n debug:' + debug +
					']'
					
		}
		
	}
	
}