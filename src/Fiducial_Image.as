package  
{
	/**
	 * ...
	 * @author John-Mark Collins
	 */
	
	import away3d.stereo.methods.InterleavedStereoRenderMethod;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.TouchManager;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.TouchEvent;
	import flash.text.ime.CompositionAttributeRange;
	import flash.utils.Dictionary;
	import flash.display.Sprite;
	import flash.text.engine.*; 
	
	[SWF(width="1220",height="930",backgroundColor="0x000000",frameRate="30")]

	public class Fiducial_Image extends GestureWorks
	{
		private var activePoints:Dictionary = new Dictionary(true);
		private var overlay:TouchSprite;
		private var eventList:Vector.<TouchEvent> = new Vector.<TouchEvent>();
		var str:String;
		var format:ElementFormat = new ElementFormat();
        var textElement:TextElement = new TextElement(str, format); 
        var textBlock:TextBlock = new TextBlock(); 
        var textLine1:TextLine; 

		public function Fiducial_Image():void
		{
			super();
			gml = "library/gml/gestures.gml";
			cml = "library/cml/fiducial.cml";
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
		}
		
		private function cmlInit(event:Event):void
		{
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);
			//addEventListener(Event.ENTER_FRAME, checkObject);
			trace("cmlInit()");
			
			GestureWorks.application.addEventListener(TouchEvent.TOUCH_BEGIN, onPoint);
			GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onPoint);
			GestureWorks.application.addEventListener(TouchEvent.TOUCH_END, onPoint);
		}
		
		private function onPoint(event:TouchEvent):void
		{
			trace("\nPoint Data Received");
			
			eventList.push(event);
		    processEvents();
			var avgX:int;
			var avgY:int;
			var totalX:int = 0;
			var totalY:int = 0;
			var length:int = eventList.length;
			for each (var point:TouchEvent in eventList)
			{
				totalX += point.localX;
				totalY += point.localY;
			}
			avgX = totalX / length;
			avgY = totalY / length;
			if (eventList.length == 4)
			{
				addFiducial_1(avgX, avgY);
			}
			else if (eventList.length == 3)
			{
				addFiducial_2(avgX, avgY);
			}
			else if ( getChildByName("textLine1") ) removeFiducial();
		    eventList = new Vector.<TouchEvent>();
		}
		
		private function processEvents():void 
		{
			for each (var point:TouchEvent in eventList)
			{
				trace("point.type:" + point.type, "point.touchPointID:" + point.touchPointID, 
					  "point.localX:" + point.localX, "point.localY:" + point.localY);
				
				switch (point.type) 
				{
					case "touchBegin": 
						createRing(point.touchPointID, point.localX, point.localY);
					break;
					case "touchMove": 
						moveRing(point.touchPointID, point.localX, point.localY);
					break;	
					case "touchEnd": 
						deleteRing(point.touchPointID);
					break;	
				}
			}
			createLines();
		}
		
		private function createRing(id:int, x:int, y:int):void 
		{
			var innerRing:Sprite = new Sprite;
			innerRing.graphics.lineStyle(5, 0x333399);	
            innerRing.graphics.drawCircle(0, 0, 40);

			var outerRing:Sprite = new Sprite;
			outerRing.graphics.lineStyle(0, 0, 0);
            outerRing.graphics.beginFill(0x333399);
            outerRing.graphics.drawCircle(0, 0, 30);
            outerRing.graphics.endFill();		
			
			outerRing.addChild(innerRing);
			
			outerRing.x = x;
			outerRing.y = y;
			addChild(outerRing);
			
			activePoints[id] = outerRing;
		}
		
		private function createLines():void 
		{   
			var counter:int = 0;
			var previousPoint:Sprite = new Sprite;
			for each (var point:TouchEvent in eventList)
			{
	            if (counter == 0)
				{
					previousPoint.x = point.localX;
					previousPoint.y = point.localY; 
				}
				else if (counter <= eventList.length - 2)
				{
					var line:Sprite = new Sprite;
					line.graphics.lineStyle(5, 0x333399);	
					line.graphics.beginFill(0x333399);
					line.graphics.moveTo(previousPoint[0], previousPoint[1]);
					line.graphics.lineTo(point.localX, point.localY);
					previousPoint.x = point.localX;
					previousPoint.y = point.localY; 
					addChild(line);
				}
				counter++;
			}
		}
		
		private function moveRing(id:int, x:int, y:int):void 
		{
			activePoints[id].x = x;
			activePoints[id].y = y;
		}	
		
		private function deleteRing(id:int):void 
		{
			activePoints[id].removeChildAt(0);
			removeChild(activePoints[id]);
			delete activePoints[id];
		}	
		
		private function addFiducial_1( blobX:int,  blobY:int):void 
		{
			str = "Fiducial with 4 points"; 
			format.color = 0xFF0000;
			textBlock.content = textElement; 
            textLine1 = textBlock.createTextLine(null, 300); 
            addChild(textLine1); 
            textLine1.x = blobX; 
            textLine1.y = blobY; 
		}
            
		private function addFiducial_2(blobX:int, blobY:int):void  
		{
			str = "Fiducial with 3 points"; 
			format.color = 0xFF0000;
			textBlock.content = textElement; 
            textLine1 = textBlock.createTextLine(null, 300); 
            addChild(textLine1); 
            textLine1.x = blobX; 
            textLine1.y = blobY; 
		}

		private function removeFiducial():void 
		{
			removeChild(textLine1);
		}
	}
}