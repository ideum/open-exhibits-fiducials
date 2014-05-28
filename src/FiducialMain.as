package  
{
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.RadialSlider;
	import com.gestureworks.cml.elements.Video;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	
	import flash.display.Sprite;
	import com.gestureworks.events.*;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	import flash.utils.Timer;
	import flash.events.Event;
	
	// Includes for ModestMaps
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.ModestMap;
	import com.gestureworks.cml.elements.ModestMapMarker;
	import com.modestmaps.mapproviders.*;
	import com.modestmaps.mapproviders.microsoft.*;
	import com.modestmaps.mapproviders.yahoo.*;
	
	import flash.geom.Point;

	/**
	 * ...
	 * @author John-Mark Collins
	 */
	
	public class FiducialMain extends Sprite
	{	
		// import ui elements from cml
		private var point_dial:Container = document.getElementById("point_dial");
		private var rotationGraphic:Image = document.getElementById("rotation_graphic");
		private var bar:Container = document.getElementById("bar");
		private var viewWindow:Container = document.getElementById("viewWindow");
		private var info_overlay:Image = document.getElementById("info_overlay");
		private var info_screen:Container = document.getElementById("info_screen");
		private var info_screen_exit:Image = document.getElementById("info_screen_icon");
		
		// State of the UI element for various NY images
		private var barState:int = 4;
		private var mapSwitch:Boolean = false;
		private var barChange:int = 0;
		
		// State of the UI element for secondary control
		private var dialValue:Number = 0.0;
		
		// create a main touchable screen
		private var mainScreen:TouchSprite = new TouchSprite();
		
		// Text for screen
		private var secTimer:Timer = new Timer(1000, 1);
		
		// Map 
		private var map1:ModestMap = new ModestMap;
		
		// Add mapp providers
		private var provider1:IMapProvider = new OpenStreetMapProvider;
		private var provider2:IMapProvider = new MicrosoftHybridMapProvider;
		private var provider3:IMapProvider = new MicrosoftAerialMapProvider;
		private var provider4:IMapProvider = new YahooHybridMapProvider;
		private var provider5:IMapProvider = new YahooRoadMapProvider;
		
		private var providers:Array = [provider1, provider2, provider3, provider4, provider5];
		
		private var starbucksLocations:Array = document.getElementsByClassName("starbucks");
		private var targetLocations:Array = document.getElementsByClassName("target");
		private var teslaLocations:Array = document.getElementsByClassName("tesla");
		private var museumLocations:Array = document.getElementsByClassName("museum");
		
		public function FiducialMain(stage:Stage = null)
		{ 
			super();
			
			// setup main touch environment for map
			stage.addChild(mainScreen);
			
			// size and location of map (on screen)
			map1.x = 0;
			map1.y = 0;
			map1.height = stage.height;
			map1.width = stage.width;
			map1.scaleFactor = 3;
			
			//Las Vegas
			map1.latitude = 36.1208;
			map1.longitude = -115.1722;
			
			// initial map zoom level
			map1.zoom = 12;
			map1.mapprovider = "MicrosoftAerialMapProvider";
			var i:int = 0;
			
			// grab all of the map markers for addition later
			for (i = 0; i < starbucksLocations.length; i++)
			{
			  starbucksLocations[i].visible = false;
			  map1.addChild(starbucksLocations[i]);
			}
			
			for (i = 0; i < targetLocations.length; i++)
			{
			  targetLocations[i].visible = false;
			  map1.addChild(targetLocations[i]);
			}
			  
			for (i = 0;  i < teslaLocations.length; i++)
			{
			  teslaLocations[i].visible = false;
			  map1.addChild(teslaLocations[i]);
			}
			  
			for (i = 0; i < museumLocations.length; i++)
			{
			  museumLocations[i].visible = false;
			  map1.addChild(museumLocations[i]);
			}
			
			// make all graphics transparent until needed
			fade(point_dial, "out");
			fade(viewWindow, "out");
			fade(bar, "out");
			
			// add touch sprites to display list
			stage.addChild(mainScreen);

			// add map to main screen
			mainScreen.addChild(map1);
			map1.init();
			
			mainScreen.addChild(info_overlay);
			
			// add child gestures
			mainScreen.mouseChildren = true;
			mainScreen.clusterBubbling = true;
					   
			// add events 
			mainScreen.gestureList = { 	"n-double-tap": true,
										"n-tap": true,
										"n-rotate": true,
										"n-drag": true, 
										"n-scale": true,
										"n-hold": true };
									   
			//mainScreen.addEventListener(GWGestureEvent.TAP, onTap);
			mainScreen.addEventListener(GWGestureEvent.DRAG, onDrag);
			mainScreen.addEventListener(GWGestureEvent.HOLD, onHold);
			mainScreen.addEventListener(GWGestureEvent.ROTATE, onRotate);
			mainScreen.addEventListener(GWGestureEvent.RELEASE, clear);

			document.getElementById("info_overlay").addEventListener(GWGestureEvent.TAP, onInfoTap);
			document.getElementById("info_screen_icon").addEventListener(GWGestureEvent.TAP, onInfoTapExit);
			
			secTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerFunction);
			
			// add event listener to every frame for animations
			stage.addEventListener( Event.ENTER_FRAME, this._onUpdate );
		} 

		// frame update function for constatnt animations
		private function _onUpdate( e:Event ):void
		{
			// rotate dial
			//dialValue = dialValue + 4.0;
			//if (dialValue == 360) dialValue = 0.0;
			//point_dial.rotationZ = dialValue;
		}
		
		private function timerFunction(e:Event = null):void
		{
			if(mainScreen.contains(info_screen)) mainScreen.removeChild(info_screen);
		}
		
		private function onTap(e:GWGestureEvent):void
		{
			trace("tapping...");
		}
		
		private function onInfoTap(e:GWGestureEvent):void
		{
			info_screen.alpha = 0;
			if (info_screen.visible == false) info_screen.visible = true;
			if (!mainScreen.contains(info_screen)) mainScreen.addChild(info_screen);
			fade(info_screen, "in");
		}
			
		private function onInfoTapExit(e:GWGestureEvent):void
		{
			fade(info_screen, "out");
			secTimer.start();
		}

		private function onRotate(e:GWGestureEvent):void
		{
			var x:int;
			var y:int; 
			
			if (e.value.n == 5)
			{
				if (!mainScreen.contains(point_dial)) mainScreen.addChild(point_dial);
				if (point_dial.visible == false) point_dial.visible = true;
				var imageScale:Number = e.target.cO.width / rotationGraphic.width;
				
				x = e.value.localX;
				y = e.value.localY;
				point_dial.x = x;
				point_dial.y = y;

				rotationGraphic.scaleX = imageScale*2;
				rotationGraphic.scaleY = imageScale * 2;
				rotationGraphic.x = -250*(imageScale*2);
				rotationGraphic.y = -250*(imageScale*2);
				
				var scaleFactor:Number = .4;
				if (e.value.rotate_dtheta < 0)
				{
					scaleFactor = 2.0;
				}
				trace("Rotation = " + e.value.rotate_dtheta);
				fade(point_dial, "in");
				
				// scale variable for adjusting amount of zoom per rotation
				var scaleFactor:Number = .8;
				var zoom:Number = e.value.rotate_dtheta * scaleFactor;
				trace("zoom = " + zoom);
				if((zoom < -1.0) || (zoom > 1.0))
				{
					map1.map.zoomByAbout(zoom, new Point(e.value.localX, e.value.localY));
				}
			}
			else if (e.value.n == 6)
			{
				if (mapSwitch == false)
				{
				  x = e.value.localX;
				  y = e.value.localY;
				  bar.x = x;
				  bar.y = y;
				  fade(bar, "in");
				  mapSwitch = true;
				}
			}
			else if (e.value.n == 8)
			{
				if (!mainScreen.contains(viewWindow)) mainScreen.addChild(viewWindow);
				if (viewWindow.visible == false) viewWindow.visible = true;
			
				x = e.value.localX;
				y = e.value.localY;
				viewWindow.x = x;
				viewWindow.y = y;
				fade(viewWindow, "in");
			}
			else
			{
				clear();
				mapSwitch = false;
			}
		}
		

		private function onHold(e:GWGestureEvent):void
		{
			var i:int; 
			// add markers to screen for various fiducial markers
			if (e.value.n == 3)
			{
				for (i = 0; i < teslaLocations.length; i++)
				{
					teslaLocations[i].visible = true;
				}
			}
			else if (e.value.n == 4)
			{
				for (i = 0; i < starbucksLocations.length; i++)
				{
					starbucksLocations[i].visible = true;
				}
			}
			else if (e.value.n == 7)
			{
				for (i = 0; i < targetLocations.length; i++)
				{
					targetLocations[i].visible = true;
				}	
			}
			else if (e.value.n == 9)
			{
				for (i = 0; i < museumLocations.length; i++)
				{
					museumLocations[i].visible = true;
				}
			}
			else
			{
				clear();
				
			}
		}
		
		private function onDrag(e:GWGestureEvent):void
		{
			var x:int;
			var y:int;
			
			if (e.value.n == 5)
			{
				if (!mainScreen.contains(point_dial)) mainScreen.addChild(point_dial);
				if (point_dial.visible == false) point_dial.visible = true;
				
				x = e.value.localX;
				y = e.value.localY;
				point_dial.x = x;
				point_dial.y = y;
				fade(point_dial, "in");
			}
			else if (e.value.n == 6)
			{
				if (!mainScreen.contains(bar)) mainScreen.addChild(bar);
				if (bar.visible == false) bar.visible = true;

				fade(bar, "in");
				
				var dx:int = e.value.drag_dx as int;
				barChange += dx;
					
				if (barChange > 20)
				{
					trace("Switching map right");
					barState += 1;
					if (barState > 4) barState = 4;	
					else map1.map.setMapProvider(providers[barState]);
					trace("map provider = " + map1.mapprovider);
					trace("map index = " + barState);
					barChange = 0;
					
					// swap out images for 
					/*for (var i:int = 0; i < 5; i++)
					{
						if (i == barState)
						{
							//map1.mapprovider = "BlueMarbleMapProvider";
							bar.getChildAt(i).visible = true;
							//cities.getChildAt(i).visible = true;
							//clearOthers();
							//trace("setting " + i + "true");
						}
						else 
						{
							bar.getChildAt(i).visible = false;
							//cities.getChildAt(i).visible = false;
							//trace("setting " + i + "false");
						}
					}*/
				}
				else if (barChange < -20)
				{
					trace("Switching map back");
					barState -= 1;
					if (barState < 0) barState = 0;	
					else map1.map.setMapProvider(providers[barState]);
					trace("map provider = " + map1.mapprovider);
					trace("map index = " + barState);
					barChange = 0;
					/*barState = barState + 1;
					//trace("dx = " + event.value.drag_dx);
					//trace("Negative Drag");
					//trace("barState = " + barState);
					if (barState > 4) barState = 4;
					map1.switchMapProvider(barState);

					for (var i:int = 0; i < 5; i++)
					{
						if (i == barState)
						{
							bar.getChildAt(i).visible = true;
							//cities.getChildAt(i).visible = true;
							//clearOthers();
							dialValue = 0;
							//trace("setting " + i + "true");
						}
						else 
						{
							bar.getChildAt(i).visible = false;
							//cities.getChildAt(i).visible = false;
							//trace("setting " + i + "false");
						}
					}*/
				}
				
			}
			else if (e.value.n == 8)
			{
				if (!mainScreen.contains(viewWindow)) mainScreen.addChild(viewWindow);
				if (viewWindow.visible == false) viewWindow.visible = true;
				
				x = e.value.localX;
				y = e.value.localY;
				viewWindow.x = x;
				viewWindow.y = y;
				fade(viewWindow, "in");
			}
			else 
			{
			  clear();
			  mapSwitch = false;
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
		
		private function fade(item: Container, direction:String):void 
		{
			if (direction == "in")
			{
				if (item.visible == false) item.visible = true;
				TweenLite.to(item, 1, { alpha:1} );
			}
			else
			{
				TweenLite.to(item, 1, { alpha:0 } );	
				if (item.visible == false) item.visible = true;
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
		
		private function setMouseFalse():void
		{
			if (info_screen.mouseEnabled == true) info_screen.mouseEnabled = false;
			if (viewWindow.mouseEnabled == true) viewWindow.mouseEnabled = false;
			if (bar.mouseEnabled == true) bar.mouseEnabled = false;
			if (point_dial.mouseEnabled == true) bar.mouseEnabled = false;
		}
		
		private function clear(e:GWGestureEvent=null):void
		{
			var i:int;
			for (i = 0; i < starbucksLocations.length; i++)
			{
				starbucksLocations[i].visible = false;
			}
			for (i = 0; i < targetLocations.length; i++)
			{
				targetLocations[i].visible = false;
			}
			for (i = 0; i < museumLocations.length; i++)
			{
				museumLocations[i].visible = false;
			}
			for (i = 0; i < teslaLocations.length; i++)
			{
				teslaLocations[i].visible = false;
			}
			fade(bar, "out");
			fade(point_dial, "out");
			fade(viewWindow, "out");
			setMouseFalse();
		}
		
	}
}