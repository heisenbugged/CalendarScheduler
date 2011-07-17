package com.etherpros.components
{
	import com.etherpros.events.RigCreationEvent;
	import com.etherpros.model.WeekDay;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	public class RigView extends Group
	{ 
	
		private const LEFT:Number = 0;
		private const RIGHT:Number = 1;
		
		private var s:Sprite = new Sprite();
		private var g:Graphics;
		
		private var _width:Number;
		private var _height:Number;
		//Previews and next Rig bar for making a linked list
		private var _previousRigView:RigView;
		private var _nextRigView:RigView;
		//The week's day where the ring view starts
		private var _startDay:WeekDay;
		//The week's day where the ring view ends
		private var _endDay:WeekDay;
		// Can either be LEFT or RIGHT.
		// Is used when resizing a component to determine how it is being resized.
		private var dragDirection:Number;
		//Limit used for the drag and drop functionallity, the limit is related with the grid with
		private var dragAndDropLimit:Number = -1;
		private  var calendarGridWith:Number = 0;
		private var originalWidth:Number = 0;
		
		// Used for determining the difference in mouse position when dragging.
		private var originalMousePos:Point;
		
		private var mousePositionX:int = 0;
		
		private var widthChange:Number = 0;
		
		public function RigView(day:WeekDay, width:Number=300, height:Number=100, _calendarGridWith:Number  = 600 ) {
			var spriteContainer:UIComponent = new UIComponent();			
			spriteContainer.addChild(s);
			
			// add sprite with graphics to this group.
			addElement(spriteContainer);
			
			g = s.graphics;
			
			// add rig view label (test)
			var rigName:Label = new Label();
			rigName.setStyle('color', '#ffffff');
			rigName.setStyle('fontWeight', 'bold');
			rigName.setStyle('fontSize', '11');
			rigName.text = "Test Rig";
			rigName.x = 10;
			addElement(rigName);			
			// set width and height variables.
			this.width = width;
			this.height = height;			
			this._startDay = day;
			this.calendarGridWith	= _calendarGridWith;
			this.originalWidth = width;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);			

		}

		public function get startDay():WeekDay
		{
			return _startDay;
		}

		public function set startDay(value:WeekDay):void
		{
			_startDay = value;
		}

		private function init(event:Event=null):void {
			// draw view
			draw();			
		}

		/** Used for starting a drag operation when either 
		 *  the left or right corner of the component is clicked **/		
		private function mouseDown(event:Event=null):void {
			var mouseX:Number = s.mouseX;
			var mouseY:Number = s.mouseY;
			
			//left-drag
			if(mouseX < 15) {
				dragDirection = LEFT;
				beginDrag();
			// right-drag	
			}else if(mouseX > s.width-15) {
				dragDirection = RIGHT;				
				beginDrag();
			} else { 
				// no drag direction.
				dragDirection = -1;
			}
		}
		
		
		private function beginDrag(event:Event=null):void {
			// record position of mouse before drag to determine differences
			originalMousePos = new Point(stage.mouseX, stage.mouseY);
			if ( this.dragAndDropLimit == -1 ){
				this.dragAndDropLimit = calendarGridWith - originalMousePos.x + this.originalWidth ;
			}else{
				this.dragAndDropLimit = calendarGridWith - originalMousePos.x + this.width;				
			}
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
			this.widthChange = mousePos.x - originalMousePos.x; 
			mousePositionX  = 	mousePos.x;			
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
		public function draw(event:Event=null):void {
			// clear out old graphics.			
			g.clear();				
			//re-paint
			g.beginFill(Math.random() * 0xFFFFFF);
			g.drawRoundRect(0,0,width,height,15);
			g.endFill();			
		}
		
		public override function set height(height:Number):void {
			super.height = height;
			_height = height;
			draw();
		}
		
		public override function set width(width:Number):void {
			super.width = width;
			_width = width;
			if ( (this.width < dragAndDropLimit  && this.width < this.calendarGridWith) 
				|| (dragAndDropLimit == -1) ){
				draw();
			}else if ( dragAndDropLimit != -1 ){
				var  rigCreationEvent:RigCreationEvent = new RigCreationEvent(RigCreationEvent.REACHED_WEEK_LIMIT,this,true);
				if ( this.nextRigView == null ){
					dispatchEvent(rigCreationEvent);
				}
			}
			
		}

		public function get nextRigView():RigView
		{
			return _nextRigView;
		}

		public function set nextRigView(value:RigView):void
		{
			_nextRigView = value;
		}

		public function get previousRigView():RigView
		{
			return _previousRigView;
		}

		public function set previousRigView(value:RigView):void
		{
			_previousRigView = value;
		}

		
	}
}