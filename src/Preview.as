package  
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author seer.chen
	 */
	public class Preview extends Sprite
	{
		private var ldr:Loader;
		
		public function Preview( url:String ) 
		{
			mouseChildren = false;
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			ldr.load( new URLRequest(url) );
			
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect( -500, -500, 1000, 1000);
			graphics.endFill();
		}
		
		private function onLoadComplete(e:Event):void 
		{
			addChild(ldr.content);
			ldr.content.x = -ldr.content.width * .5;
			ldr.content.y = -ldr.content.height * .5;
			ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			ldr = null;
		}
		
	}

}