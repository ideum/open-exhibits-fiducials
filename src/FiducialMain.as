package  
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.elements.Magnifier;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import flash.display.Sprite;
	import com.gestureworks.events.*;
	import flash.display.Stage;
	import flash.geom.ColorTransform;

	/**
	 * ...
	 * @author John-Mark Collins
	 */
	
	public class FiducialMain extends Sprite
	{	
		// import ui elements from cml
		private var dial = document.getElementById("dial");
		private var bar = document.getElementById("bar");
		private var viewWindow = document.getElementById("viewWindow");
		private var cities = document.getElementById("cities");
		private var nyc = document.getElementById("nyc");
		private var sf = document.getElementById("sf");
		
		// get NYC images
		private var nyCity:Image = document.getElementById("nyCity");
		private var nySubway:Image = document.getElementById("nySubway");
		private var nyHistorical:Image = document.getElementById("nyHistorical");
		
		// get SF images
		private var sfCity:Image = document.getElementById("sfCity");
		private var sfSubway:Image = document.getElementById("sfSubway");
		private var sfHistorical:Image = document.getElementById("sfHistorical");
		private var sfBikes:Image = document.getElementById("sfBikes");
		private var sfRoads:Image = document.getElementById("sfRoads");
		
		// State of the UI element for various NY images
		private var barState:int = 4;
		
		// State of the UI element for secondary control
		private var dialState:int = 3;
		
		// create a main touchable screen
		private var mainScreen:TouchSprite = new TouchSprite();
		var magnifier:Magnifier = new Magnifier();
		
		public function FiducialMain(stage:Stage = null)
		{
			super();

			// fill background
			mainScreen.graphics.beginFill(0x000000);
			mainScreen.graphics.drawRect(0, 0, 1920, 1080);
			mainScreen.graphics.endFill();
			
			// add touch sprite to display list 
			stage.addChild(mainScreen);
			mainScreen.addChild(cities);
			mainScreen.addChild(nyc);
			mainScreen.addChild(sf);
			
			// add child gestures
			mainScreen.mouseChildren = true;
			mainScreen.clusterBubbling = true;
			
			// add events 
			mainScreen.gestureList = { "tap": true,
									   "n-rotate": true,
									   "n-drag": true };
									   
			mainScreen.addEventListener(GWGestureEvent.TAP, onTap);
			mainScreen.addEventListener(GWGestureEvent.ROTATE, onRotate);
			mainScreen.addEventListener(GWGestureEvent.DRAG, onDrag);
			
			document.getElementById("viewWindow").addEventListener(GWGestureEvent.HOLD, onViewerHold);
			document.getElementById("viewWindow").addEventListener(GWGestureEvent.ROTATE, onViewerRotate);
			document.getElementById("viewWindow").addEventListener(GWGestureEvent.DRAG, onViewerDrag);
			
			document.getElementById("option1left").addEventListener(GWGestureEvent.TAP, onLeftOption1Tap);
			document.getElementById("option2left").addEventListener(GWGestureEvent.TAP, onLeftOption2Tap);
			document.getElementById("option3left").addEventListener(GWGestureEvent.TAP, onLeftOption3Tap);
			document.getElementById("option1right").addEventListener(GWGestureEvent.TAP, onRightOption1Tap);
			document.getElementById("option2right").addEventListener(GWGestureEvent.TAP, onRightOption2Tap);
			//document.getElementById("option3right").addEventListener(GWGestureEvent.TAP, onRightOption3Tap);
			//document.getElementById("test").addEventListener(GWGestureEvent.TAP, onTap2);
			
			//Now add the magnifier.
			magnifier.radius = 167;
			magnifier.magnification = 2;
			magnifier.distortionRadius = 40;
			magnifier.graphic = "none";
			mainScreen.addChild(magnifier);
			magnifier.init();
			magnifier.visible = false;
		}
		
		function onLeftOption1Tap(event:GWGestureEvent):void
		{
			if (event.value.n == 1 && barState == 4)
			{
				trace("city screen");
				nyHistorical.visible = false;
				nyCity.visible = true;
				nySubway.visible = false;
			}
			
			if (event.value.n == 1 && barState == 3)
			{
				trace("city screen");
				sfHistorical.visible = false;
				sfCity.visible = true;
				sfSubway.visible = false;
				sfRoads.visible = false;
				sfBikes.visible = false;
			}
		}
		
		function onLeftOption2Tap(event:GWGestureEvent):void
		{
			if (event.value.n == 1 && barState == 4)
			{
				trace("subway screen");
				nyHistorical.visible = false;
				nyCity.visible = false;
				nySubway.visible = true;
			}
			
			if (event.value.n == 1 && barState == 3)
			{
				trace("subway screen");
				sfHistorical.visible = false;
				sfCity.visible = false;
				sfSubway.visible = true;
				sfRoads.visible = false;
				sfBikes.visible = false;
			}
		}
		
		function onLeftOption3Tap(event:GWGestureEvent):void
		{
			if (event.value.n == 1 && barState == 4)
			{
				trace("historical screen");
				nyHistorical.visible = true;
				nyCity.visible = false;
				nySubway.visible = false;
			}
			
			if (event.value.n == 1 && barState == 3)
			{
				trace("historical screen");
				sfHistorical.visible = true;
				sfCity.visible = false;
				sfSubway.visible = false;
				sfRoads.visible = false;
				sfBikes.visible = false;
			}
		}
		
		function onRightOption1Tap(event:GWGestureEvent):void
		{
			if (event.value.n == 1 && barState == 3)
			{
				trace("bikes screen");
				sfHistorical.visible = false;
				sfCity.visible = false;
				sfSubway.visible = false;
				sfBikes.visible = true;
				sfRoads.visible = false;
			}
		}
		
		function onRightOption2Tap(event:GWGestureEvent):void
		{
			if (event.value.n == 1 && barState == 3)
			{
				trace("roads screen");
				sfHistorical.visible = false;
				sfCity.visible = false;
				sfSubway.visible = false;
				sfBikes.visible = false;
				sfRoads.visible = true;
			}
		}
		
		function onRightOption3Tap(event:GWGestureEvent):void
		{
			if (event.value.n == 1)
			{
				trace("undetermined screen");
			}
		}
		
		function onViewerHold(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				//trace("viewer hold");
			}
		}
		
		function onViewerDrag(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				//trace("viewer drag");
			}
		}
		
		function onViewerRotate(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				//trace("viewer rotate");
			}
		}
		
		function onTap(event:GWGestureEvent):void
		{
			if (event.value.n == 5)
			{
				//trace("Displaying Dial");
				//trace("tap");
				//trace("tap_n:", event.value.n);
				//trace("tap_x:", event.value.x);
				//trace("tap_y:", event.value.y);
					
				mainScreen.addChild(dial);
			}
		}
			
		function onRotate(event:GWGestureEvent):void
		{
			if (event.value.n == 5)
			{
				//trace("Rotating");
				//trace("Rotation = " + event.value.rotate_dtheta);
				//trace("Displaying Bar");
				
				if (event.value.rotate_dtheta > 2)
				{
					dialState = dialState - 1;
				
					trace("dialState = " + dialState);
					if (dialState < 0) dialState = 0;	
				
					for (var i:int = 0; i < 4; i++)
					{
						if (i == dialState)
						{
							dial.getChildAt(i).visible = true;
							//var currentGallery:Container = galleries.getChildAt(dialState);
							//currentGallery.getChildAt(i).visible = true;
							//trace("setting " + i + "true");
						}
						else 
						{
							dial.getChildAt(i).visible = false;
							//var currentGallery:Container = galleries.getChildAt(dialState);
							//currentGallery.getChildAt(i) = false;
							//trace("setting " + i + "false");
						}
					}
					
					if (barState == 3)
					{
						sfHistorical.alpha = (0.25) * dialState;
						sfCity.alpha = (0.25) * dialState;
						sfSubway.alpha = (0.25) * dialState;
						sfBikes.alpha = (0.25) * dialState;
						sfRoads.alpha = (0.25) * dialState;
					}
					if (barState == 4)
					{
						nyHistorical.alpha = (0.25) * dialState;
						nyCity.alpha = (0.25) * dialState;
						nySubway.alpha = (0.25) * dialState;
					}
					
				}
				if (event.value.rotate_dtheta < -2)
				{
					dialState = dialState + 1;
					//trace("dialState = " + dialState);
					if (dialState > 3) dialState = 3;		

					for (var i:int = 0; i < 4; i++)
					{
						if (i == dialState)
						{
							dial.getChildAt(i).visible = true;
							//trace("setting " + i + "true");
						}
						else 
						{
							dial.getChildAt(i).visible = false;
							//trace("setting " + i + "false");
						}
					}
					
					if (barState == 3)
					{
						sfHistorical.alpha = (0.25) * dialState;
						sfCity.alpha = (0.25) * dialState;
						sfSubway.alpha = (0.25) * dialState;
						sfBikes.alpha = (0.25) * dialState;
						sfRoads.alpha = (0.25) * dialState;
					}
					if (barState == 4)
					{
						nyHistorical.alpha = (0.25) * dialState;
						nyCity.alpha = (0.25) * dialState;
						nySubway.alpha = (0.25) * dialState;
					}
				}
		
				mainScreen.addChild(dial);
			}
			else if (mainScreen.contains(dial))
			{
				mainScreen.removeChild(dial);
			}
		}
		
		function onDrag(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				var x:int = event.value.localX;
				var y:int = event.value.localY;
				viewWindow.x = x;
				viewWindow.y = y;
				magnifier.x = x;
				magnifier.y = y;
				magnifier.visible = true;
				mainScreen.addChild(viewWindow);
			}

			
			if (event.value.n == 4)
			{
				//trace("Displaying Bar");
				//trace("tap");
				//trace("tap_n:", event.value.n);
				//trace("tap_x:", event.value.x);
				//trace("tap_y:", event.value.y);
				
				var dx:int = event.value.drag_dx as int;
					
				if (dx > 10)
				{
					barState = barState - 1;
					//trace("dx = " + event.value.drag_dx);
					//trace("Positive Drag");
					//trace("barState = " + barState);
					if (barState < 0) barState = 0;		
					//setBarVisible(barState);
					for (var i:int = 0; i < 5; i++)
					{
						if (i == barState)
						{
							bar.getChildAt(i).visible = true;
							cities.getChildAt(i).visible = true;
							//trace("setting " + i + "true");
						}
						else 
						{
							bar.getChildAt(i).visible = false;
							cities.getChildAt(i).visible = false;
							//trace("setting " + i + "false");
						}
					}
				}
				else if (dx < -10)
				{
					barState = barState + 1;
					//trace("dx = " + event.value.drag_dx);
					//trace("Negative Drag");
					//trace("barState = " + barState);
					if (barState > 4) barState = 4;

					//setBarVisible(barState);
					for (var i:int = 0; i < 5; i++)
					{
						if (i == barState)
						{
							bar.getChildAt(i).visible = true;
							cities.getChildAt(i).visible = true;
							//trace("setting " + i + "true");
						}
						else 
						{
							bar.getChildAt(i).visible = false;
							cities.getChildAt(i).visible = false;
							//trace("setting " + i + "false");
						}
					}
				}
				mainScreen.addChild(bar);
			}
			else if (mainScreen.contains(bar))
			{
				mainScreen.removeChild(bar);
			}
		}
		
		function setBarVisible(state:int):void
		{
			for (var i:int = 0; i < bar.length; i++)
			{
			   if (i == state)
			   {
				   bar.getChildAt(i).visible = true;
				   //trace("setting " + i + "true");
			   }
			   else 
			   {
				   bar.getChildAt(i).visible = false;
				   //trace("setting " + i + "false");
			   }
			}
		}
		
		function setDialVisible(state:int):void
		{
			for (var i:int = 0; i < dial.length; i++)
			{
			   if (i == state)
			   {
				   dial.getChildAt(i).visible = true;
			   }
			   else dial.getChildAt(i).visible = false;
			}
		}
		
		/*function clearOthers(state:int, city:int):void
		{
			for (var i:int = 0; i < dial.length; i++)
			{
			   if (i == city && i == state)
			   {
				   dial.getChildAt(i).visible = true;
			   }
			   else dial.getChildAt(i).visible = false;
			}
		}*/
	}
}