package  
{
    /**
	 * ...
	 * @author John-Mark Collins
	 */
		
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.managers.TouchManager;
	import flash.events.Event;
	
	[SWF(width="1220",height="930",backgroundColor="0x000000",frameRate="30")]

	public class Fiducial_Gesture_Test extends GestureWorks 
	{
		private var overlay:TouchSprite; 
		
		public function Fiducial_Gesture_Test(cmlPath:String=null) 
		{
			super();
			gml = "library/gml/gestures.gml";
			cml = "library/cml/fiducial.cml";
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlParseComplete);
		}
		
		private function cmlParseComplete(e:Event):void 
		{
			overlay = new TouchSprite();
			overlay.gestureList = { "n-drag":true };
			overlay.addEventListener(GWGestureEvent.DRAG, onDrag);
			TouchManager.overlays.push(overlay);
			//CMLParser.removeEventListener(CMLParser.COMPLETE, cmlParseComplete);
		}
		
		private function onDrag(e:GWGestureEvent):void 
		{
			trace("Dragging...");
		}
	}
}