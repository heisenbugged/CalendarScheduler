package com.etherpros.components
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class RigView extends UIComponent
	{
		private const LEFT:Number = 0;
		private const RIGHT:Number = 1;
		
		private var s:Arrow = new Arrow();
		private var g:Graphics;
		
		private var _width:Number;
		private var _height:Number;
		
		// Can either be LEFT or RIGHT.
		// Is used when resizing a component to determine how it is being resized.
		private var dragDirection:Number;
		
		// Used for determining the difference in mouse position when dragging.
		private var originalMousePos:Point;
		
		public function RigView(width:Number=300, height:Number=100) {
			// add sprite with graphics to uicomponent container.
			addChild(s);			
			g = s.graphics;
			
			// set width and height variables.
			//_width = width;
			//_height = height;
			
			// draw view
			draw();
			
			s.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}

		/** Used for starting a drag operation when either 
		 *  the left or right corner of the component is clicked **/		
		private function mouseDown(event:Event=null):void {
			var mouseX:Number = s.mouseX;
			var mouseY:Number = s.mouseY;
			
			//left-drag
			if(mouseX < 15) {
				dragDirection = LEFT;
				// trace("Dragging from left!");
				beginDrag();
			// right-drag	
			}else if(mouseX > s.width-15) {
				dragDirection = RIGHT;				
				// trace("Dragging from right!");
				beginDrag();
			} else { 
				// no drag direction.
				dragDirection = -1;
			}
		}
		
		
		private function beginDrag(event:Event=null):void {
			// record position of mouse before drag to determine differences
			originalMousePos = new Point(stage.mouseX, stage.mouseY);
			
			// create event listener that listens for mouse movements to 
			// determine when to resize the component.
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resize);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
		}
		
		private function endDrag(event:Event=null):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, resize);
		}
		
		/** Resizes the width of our event based on the change in mouse position from the drag. **/
		private function resize(event:Event=null):void {
			var mousePos:Point = new Point(this.stage.mouseX, this.stage.mouseY);			
			var widthChange:Number = mousePos.x - originalMousePos.x; 
		
			if(dragDirection == LEFT) {
				// change width based on new difference between the original mouse
				// position recorded before drag and the new mouse position.
				this.width -= widthChange;	
				
				// if the direction of the drag is LEFT, then we must also offset the 
				// change in width through the x position.				
				this.x += widthChange;
			} else {
				
				this.width += widthChange;				
			}
			
			originalMousePos = mousePos;
		}
		
		/** Redraws the graphics of the rig. Used for updating the view
		 *  with changes to the width or height of the component **/
		private function draw():void {			
			// clear out old graphics.
			//g.clear();
			
			//re-paint
			//g.beginFill(0xFF0000);
			//g.drawRoundRect(0,0,width,height,15);
			//g.endFill();
		}
		
		public override function set height(height:Number):void {
			super.height = height;
			_height = height;
			draw();
		}
		
		public override function set width(width:Number):void {
			super.width = width;
			_width = width;			
			draw();
		}
		
	}
}