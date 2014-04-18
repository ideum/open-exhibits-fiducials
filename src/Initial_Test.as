package  
{
	/**
	 * ...
	 * @author John-Mark Collins
	 */
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.RadialSlider;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.core.GestureWorks; 
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.utils.ExampleTemplate;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[SWF(width="1280",height="720",backgroundColor="0x000000",frameRate="60")]
	
	public class Initial_Test extends GestureWorks
	{
		public function Initial_Test():void
		{
			gml = "library/gml/gestures.gml";
			cml = "library/cml/fiducial.cml";
		}
		
		override protected function gestureworksInit():void
		{	
			// create a touchable sprite 
			var mainScreen:TouchSprite = new TouchSprite();
		
			// draw a simple graphic
			mainScreen.graphics.beginFill(0x000000);
			mainScreen.graphics.drawRect(0, 0, 1280, 720);
			mainScreen.graphics.endFill();
			
			// align graphic
			//mainScreen.x = ((stage.stageWidth - 200) / 2) + 150;
			//mainScreen.y = ((stage.stageHeight - 200) / 2) - 50;
			
			// add touch sprite to display list 
			addChild(mainScreen);

			// add events 
			mainScreen.gestureList = { "tap": true,
									   "n-rotate": true,
									   "n-drag": true };
									   
			mainScreen.addEventListener(GWGestureEvent.TAP, onTap);
			mainScreen.addEventListener(GWGestureEvent.ROTATE, onRotate);
			mainScreen.addEventListener(GWGestureEvent.DRAG, onDrag);
			
			function onTap(event:GWGestureEvent):void
			{
				if (event.value.n == 2)
				{
					trace("tap");
					trace("tap_n:", event.value.n);
					trace("tap_x:", event.value.x);
					trace("tap_y:", event.value.y);
				
					var c:ColorTransform = event.target.transform.colorTransform;
					c.color = Math.random() * 0xFFFFFF;
					event.target.transform.colorTransform = c;
				}
			}
			
			function onRotate(event:GWGestureEvent):void
			{
				if (event.value.n == 3)
				{
					trace("Rotating");
				}
			}
		
			function onDrag(event:GWGestureEvent):void
			{
				if (event.value.n == 4)
				{
					trace("Dragging");
				}
			}
		}
	}
}