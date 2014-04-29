package 
{
	import com.gestureworks.cml.elements.Text;
    import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.cml.core.CMLParser;
	import flash.text.engine.*;
	import flash.events.*;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John-Mark Collins
	 */
	
	public class Main extends GestureWorks
	{	
		public function Main() 
		{ 		
			super();
			
			//CMLParser.debug = true;
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
			
			fullscreen = true;
			
			gml = "library/gml/gestures.gml";
			cml = "library/cml/main.cml";
		}
	
		override protected function gestureworksInit():void 
		{
			trace("gestureWorksInit()");
		}
		
		private function cmlInit(e:Event):void 
		{
			trace("cmlInit()");
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);
			
			var fiducial:FiducialMain = new FiducialMain(stage);
			
			if (CONFIG::debug == true) 
			{
				//addChild(new FrameRate());
			}
		}
		
	}
	
}