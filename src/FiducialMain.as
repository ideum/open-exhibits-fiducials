package  
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.RadialSlider;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import flash.display.Sprite;
	import com.gestureworks.events.*;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import com.greensock.TweenLite;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author John-Mark Collins
	 */
	
	public class FiducialMain extends Sprite
	{	
		// import ui elements from cml
		private var point_dial = document.getElementById("point_dial");
		private var bar = document.getElementById("bar");
		private var viewWindow = document.getElementById("viewWindow");
		private var info_overlay:Image = document.getElementById("info_overlay");
		private var info_screen = document.getElementById("info_screen");
		private var info_screen_exit:Image = document.getElementById("info_screen_icon");
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
		private var dialValue:Number = 0.0;
		
		// create a main touchable screen
		private var mainScreen:TouchSprite = new TouchSprite();
		
		private var txt:Text = new Text();
		private var secTimer:Timer = new Timer(1000, 1);
		
		public function FiducialMain(stage:Stage = null)
		{
			super();

			// fill background
			mainScreen.graphics.beginFill(0x000000);
			mainScreen.graphics.drawRect(0, 0, 1920, 1080);
			mainScreen.graphics.endFill();
			
			// add touch sprites to display list 
			stage.addChild(mainScreen);
			mainScreen.addChild(cities);
			mainScreen.addChild(nyc);
			mainScreen.addChild(sf);
			mainScreen.addChild(point_dial);
			fadeInDial(false);
			mainScreen.addChild(viewWindow);
			fadeInViewer(false);
			mainScreen.addChild(bar);
			mainScreen.addChild(txt);
			
			// add child gestures
			mainScreen.mouseChildren = true;
			mainScreen.clusterBubbling = true;
			
			// add events 
			mainScreen.gestureList = { "tap": true,
									   "n-rotate": true,
									   "n-drag": true };
									   
			//mainScreen.addEventListener(GWGestureEvent.TAP, onTap);
			mainScreen.addEventListener(GWGestureEvent.ROTATE, onRotate);
			mainScreen.addEventListener(GWGestureEvent.DRAG, onDrag);
			
			// listeners for viewer options
			//document.getElementById("viewWindow").addEventListener(GWGestureEvent.HOLD, onViewerHold);
			//document.getElementById("viewWindow").addEventListener(GWGestureEvent.ROTATE, onViewerRotate);
			//document.getElementById("viewWindow").addEventListener(GWGestureEvent.DRAG, onViewerDrag);
			
			document.getElementById("option1left").addEventListener(GWGestureEvent.TAP, onLeftOption1Tap);
			document.getElementById("option2left").addEventListener(GWGestureEvent.TAP, onLeftOption2Tap);
			document.getElementById("option3left").addEventListener(GWGestureEvent.TAP, onLeftOption3Tap);
			document.getElementById("option1right").addEventListener(GWGestureEvent.TAP, onRightOption1Tap);
			document.getElementById("option2right").addEventListener(GWGestureEvent.TAP, onRightOption2Tap);
			//document.getElementById("option3right").addEventListener(GWGestureEvent.TAP, onRightOption3Tap);
			//document.getElementById("test").addEventListener(GWGestureEvent.TAP, onTap2);
			
			document.getElementById("info_overlay").addEventListener(GWGestureEvent.TAP, onInfoTap);
			document.getElementById("info_screen_icon").addEventListener(GWGestureEvent.TAP, onInfoTapExit);
			
			secTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerFunction);
			
			// Add Text
			txt.x = 200;
			txt.y = 200;
			txt.font = "OpenSansBold";
			txt.fontSize = 68;            
			txt.color = 0xFFFFFF; 
			txt.text = "0"
			mainScreen.addChild(txt);
			mainScreen.addChild(info_overlay);
			
		}
		
		private function timerFunction():void
		{
			mainScreen.removeChild(info_screen);
		}
		
		
		private function onInfoTap(event:GWGestureEvent):void
		{
			info_screen.alpha = 0;
			mainScreen.addChild(info_screen);
			if (info_screen.visible == false) info_screen.visible = true;
			fadeInInfoScreen(true);
		}
		
		private function onInfoTapExit(event:GWGestureEvent):void
		{
			fadeInInfoScreen(false);
			secTimer.start();
		}
		
		private function onLeftOption1Tap(event:GWGestureEvent):void
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
		
		private function onLeftOption2Tap(event:GWGestureEvent):void
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
		
		private function onLeftOption3Tap(event:GWGestureEvent):void
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
		
		private function onRightOption1Tap(event:GWGestureEvent):void
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
		
		private function onRightOption2Tap(event:GWGestureEvent):void
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
		
		private function onRightOption3Tap(event:GWGestureEvent):void
		{
			if (event.value.n == 1)
			{
				trace("undetermined screen");
			}
		}
		
		private function onViewerHold(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				//fadeInViewer(true);
				var x:int = event.value.localX;
				var y:int = event.value.localY;
				viewWindow.x = x;
				viewWindow.y = y;
			}
			else 
			{
				fadeInViewer(false);
			}
		}
		
		private function onViewerDrag(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				//fadeInViewer(true);
				var x:int = event.value.localX;
				var y:int = event.value.localY;
				viewWindow.x = x;
				viewWindow.y = y;
			}
			else 
			{
				fadeInViewer(false);
			}
		}
		
		private function onViewerRotate(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				//trace("viewer rotate");
			}
		}
		
		private function onDialRotate(event:GWGestureEvent):void
		{
			
		}
		
		/*function onTap(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				if (viewWindow.visible == false) viewWindow.visible = "true";
				var x:int = event.value.localX;
				var y:int = event.value.localY;
				viewWindow.x = x;
				viewWindow.y = y;
				fadeInViewer(true);
			}
			else fadeInViewer(false);
			
			if (event.value.n == 4)
			{
				animateBar(true);
			}
			else animateBar(false);
			
			if (event.value.n == 2)
			{
				var x:int = event.value.localX;
				var y:int = event.value.localY;
				point_dial.x = x;
				point_dial.y = y;
				fadeInDial(true);
			}
			else fadeInDial(false);
		}*/

		private function onRotate(event:GWGestureEvent):void
		{
			/*if (event.value.n == 3)
			{
				if (viewWindow.visible == false) viewWindow.visible = "true";
				var x:int = event.value.localX;
				var y:int = event.value.localY;
				viewWindow.x = x;
				viewWindow.y = y;
				fadeInViewer(true);
			}*/
			if (event.value.n == 2)
			{
				var x:int = event.value.localX;
				var y:int = event.value.localY;
				point_dial.x = x;
				point_dial.y = y;
				fadeInDial(true);
				
				dialValue = dialValue + event.value.rotate_dtheta;
				if (dialValue < 0.0) dialValue = 0.0;
				if (dialValue > 180.00) dialValue = 180.0;
				
				trace("dialValue = " + dialValue);
				var alphaValue:Number = map(dialValue, 0.0, 180.00, 0.0, 1.0);
				txt.text = alphaValue.toString();
				if (barState == 3)
				{
					sfHistorical.alpha = alphaValue;
					sfCity.alpha = alphaValue;
					sfSubway.alpha = alphaValue;
					sfBikes.alpha = alphaValue;
					sfRoads.alpha = alphaValue;
				}
					
				if (barState == 4)
				{
					nyHistorical.alpha = alphaValue;
					nyCity.alpha = alphaValue;
					nySubway.alpha = alphaValue;
				}
			}
			else fadeInDial(false);
		}
		
		private function onDrag(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				if (viewWindow.visible == false) viewWindow.visible = "true";
				var x:int = event.value.localX;
				var y:int = event.value.localY;
				viewWindow.x = x;
				viewWindow.y = y;
				fadeInViewer(true);
			}
			else fadeInViewer(false);
			
			if (event.value.n == 4)
			{
				animateBar(true);
				var dx:int = event.value.drag_dx as int;
					
				if (dx > 10)
				{
					barState = barState - 1;
					if (barState < 0) barState = 0;		

					for (var i:int = 0; i < 5; i++)
					{
						if (i == barState)
						{
							bar.getChildAt(i).visible = true;
							cities.getChildAt(i).visible = true;
							clearOthers();
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

					for (var i:int = 0; i < 5; i++)
					{
						if (i == barState)
						{
							bar.getChildAt(i).visible = true;
							cities.getChildAt(i).visible = true;
							clearOthers();
							dialValue = 0;
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
				
			}
			else animateBar(false);
		}
		
		private function animateBar(on:Boolean):void
		{
			if (on == true)
			{
				TweenLite.to(bar, 1, { y:0 } );
			}
			else
			{
			  TweenLite.to(bar, 1, { y:-174 } );	
			}
		}
		
		private function fadeInViewer(on:Boolean):void 
		{
			if (on == true)
			{
				TweenLite.to(viewWindow, 1, { alpha:1 } );
			}
			/*else
			{
				TweenLite.to(viewWindow, 1, { alpha:0 } );	
			}*/
		}
		
		private function fadeInDial(on:Boolean):void 
		{
			if (on == true)
			{
				TweenLite.to(point_dial, 1, { alpha:1} );
			}
			else
			{
				TweenLite.to(point_dial, 1, { alpha:0 } );	
			}
		}
		
		private function fadeInInfoScreen(on:Boolean):void 
		{
			if (on == true)
			{
				TweenLite.to(info_screen, 1, { alpha:1} );
			}
			else
			{
				TweenLite.to(info_screen, 1, { alpha:0 } );
			}
		}
			
		private function map(num:Number, min1:Number, max1:Number, min2:Number, max2:Number, round:Boolean = false, constrainMin:Boolean = true, constrainMax:Boolean = true):Number
		{
			if (constrainMin && num < min1) return min2;
			if (constrainMax && num > max1) return max2;
 
			var num1:Number = (num - min1) / (max1 - min1);
			var num2:Number = (num1 * (max2 - min2)) + min2;
			if (round) return Math.round(num2);
			return num2;
		}
		
		private function clearOthers():void
		{
			if (barState == 4)
			{
				nyc.visible = true;
				sf.visible = false;
			}
			if (barState == 3)
			{
				nyc.visible = false;
				sf.visible = true;
			}
		}
	}
}