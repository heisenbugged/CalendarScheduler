package com.etherpros.components
{
	import com.etherpros.controllers.*;
	import com.etherpros.events.RigEvent;
	import com.etherpros.model.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.graphics.GradientBase;
	
	import spark.components.Group;
	
	public class RigView extends Group
	{ 
		private const X_PADDING:Number = 8;
		
		private const LEFT:Number = 0;
		private const RIGHT:Number = 1;
		
		
		/** width and height of new empty sprites.
		 *  this usually corresponds to the width of a single day. **/
		private var defaultWidth:Number;
		private var defaultHeight:Number;
		
		/** X and Y position of first row added **/
		private var initialX:Number;
		private var initialY:Number;

		
		/** contains all the rounded corner sprites per week (a week is a row). **/
		private var spriteRows:ArrayCollection = new ArrayCollection();
						
		// DEPRECATED Previews and next Rig bar for making a linked list
		private var _previousRigView:RigView;
		private var _nextRigView:RigView;
		
		private var _rigDetail:RigDetail;
		
		/** Selected grid row during a resize operation **/
		private var dragTarget:RigSprite;
		
		/** Can either be LEFT or RIGHT.
		 *  Is used when resizing a component to determine how it is being resized. **/			
		private var dragDirection:Number;
		/** Limit used for the drag and drop functionallity, the limit is related with the grid with **/
		private var dragAndDropLimit:Number = -1;
		
		private var originalWidth:Number = 0;		
		/** Used for determining the difference in mouse position when dragging. **/
		private var originalMousePos:Point;		
		private var mousePositionX:int = 0;			
		/** When set to false resize operations are disabled. **/
		private var dragValid:Boolean = true;
		
		private var initialSprite:RigSprite;
		
		public function RigView(rigDetail:RigDetail, width:Number=300, height:Number=100, initialX:Number=0, initialY:Number=0) {
			// initialize variables			
			this._rigDetail = rigDetail;		
			this.defaultWidth = width;
			this.defaultHeight = height;
			this.initialX = initialX;
			this.initialY = initialY;
			
			// if color hasn't been set already, assign a new random color.
			if (!this._rigDetail.rigColor) {								
				this._rigDetail.rigColor = Math.random() * 0xFFFFFF;
			}
						
			initialSprite= createEmptySprite();
			initialSprite.x = initialX;
			initialSprite.y = initialY;
			// add first sprite row.
			addElement(initialSprite);
		}
		
		/** Creates empty sprite and adds the sprite to the spriteRows array.
		 *  This function is used when a rigview jumps to a new week row. **/
		private function createEmptySprite():RigSprite {			
			var sprite:RigSprite = new RigSprite(this._rigDetail.rigColor, this._rigDetail.staff.name);
			sprite.width = defaultWidth;
			sprite.height = defaultHeight;
			sprite.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			// add sprite to sprite rows array.
			spriteRows.addItem(sprite);
			
			return sprite;
		}
					
		/** Causes rig to 'snap' to a day based on it's x position and width **/
		private function snap():void {				
			dragTarget.x = Math.floor(dragTarget.x/RigsController.DAY_WIDTH) * RigsController.DAY_WIDTH;			
			dragTarget.width = Math.ceil(dragTarget.width/RigsController.DAY_WIDTH)  * RigsController.DAY_WIDTH;			
			// if new width surpasses calendar width, snap backwards
			if( (dragTarget.width + dragTarget.x) > RigsController.CALENDAR_WIDTH) {				
				dragTarget.width = RigsController.CALENDAR_WIDTH - dragTarget.x;
			}
		}
		
		/** Used for starting a drag operation when either 
		 *  the left or right corner of the component is clicked **/		
		private function mouseDown(event:Event):void {
			var target:RigSprite = event.currentTarget as RigSprite;			
			var index:int = findSpriteIndex(target);
			var mouseX:Number = target.mouseX;
			var mouseY:Number = target.mouseY;
			
			// left-drag. Only permit left drag if the first sprite row was grabbed.
			if(mouseX < 15 && index == 0) {
				dragDirection = LEFT;
				beginDrag(target);
			// right-drag. Only permit right drag if the last sprite row was grabbed.	
			}else if(mouseX > target.width-15 && index == spriteRows.length-1) {
				dragDirection = RIGHT;				
				beginDrag(target);
			} else { 				
				// no drag direction.
				dragDirection = -1;
			}
		}
		
		private function beginDrag(target:RigSprite):void {			
			dragTarget = target;
			
			// record position of mouse before drag to determine differences
			originalMousePos = new Point(stage.mouseX, stage.mouseY);
			
			// create event listener that listens for mouse movements to 
			// determine when to resize the component.
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resize);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
		}
		
		private function endDrag(event:Event=null):void {
			dragValid = true;
			if ( stage != null ){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, resize);
			}
		
			if(spriteRows.length > 0) {
				// After a drag-drop operation, snap the rig to the correct day 
				snap();
				
				// dispatch event marking resize has finished!
				var resizedEvent:RigEvent = new RigEvent(RigEvent.RIG_RESIZED);
				resizedEvent.view = this;			
				dispatchEvent(resizedEvent);					
			}
			// define remove event
		}
				
		/** Resizes the width of the selected rig row based on the change in mouse position from the drag. **/
		private function resize(event:Event=null):void {
			var target:RigSprite = dragTarget;
			
			// exit out of function if drag has been invalidated.			
			if(!dragValid) { return; }
			
			var mousePos:Point = new Point(this.stage.mouseX, this.stage.mouseY);			
			var widthChange:int = mousePos.x - originalMousePos.x; 
			mousePositionX  = 	mousePos.x;			
			if(dragDirection == LEFT) {
				// change width based on new difference between the original mouse
				// position recorded before drag and the new mouse position.
				target.width -= widthChange;	
				
				// if the direction of the drag is LEFT, then we must also offset the 
				// change in width through the x position.				
				target.x += widthChange;
			} else {				
				target.width += widthChange;				
			}				
			originalMousePos = mousePos;
			
			// if the width of the rig row has surpassed that of our calendar
			// break the rig into a new row.					
			if( (target.width + target.x) > RigsController.CALENDAR_WIDTH) {				
				// reset width to be the same as the calendar width.
				target.width = RigsController.CALENDAR_WIDTH - target.x;
				
				// create new row!
				var row:UIComponent = createEmptySprite();
				row.y = RigsController.DAY_HEIGHT * (spriteRows.length-1) + initialY;
				addElement(row);				
				// redraw rows.
				draw();
				
				// When resizing a rig, if the rig jumps to a new
				// row when it is resized beyond its available width.
				// the current resize operation that is taking place
				// becomes no longer valid, since the rig is now placed into a new row.
				// So we invalidate the current drag-drop operation to force the user
				// to start dragging from the new row.
				dragValid = false;
				
				// TODO: Throw row added event.
			}

			// if the width of the rig row is 0, remove row from array
			if(target.width <= 0) {
				// TODO: Throw destroy event.				
				// remove rig row from rows array.
				var index:int = spriteRows.getItemIndex(target);
				// only remove sprite if it was found in the array
				if(index != -1) {
					spriteRows.removeItemAt(index);
				}
				// remove sprite row from stage
				removeElement(target);
				
				dragValid = false;
			}
		}
		
		public function reDraw(dayLengt:int):void{
			initialSprite.width = Math.ceil(initialSprite.width/RigsController.DAY_WIDTH)  * RigsController.DAY_WIDTH + (defaultWidth * dayLengt);			
			// if new width surpasses calendar width, snap backwards
			if( (initialSprite.width + initialSprite.x) > RigsController.CALENDAR_WIDTH) {				
				initialSprite.width = RigsController.CALENDAR_WIDTH - initialSprite.x;
			}
			
		}
		
		/** Redraws the graphics of the rig. Used for updating the view
		 *  with changes to the width or height of the component **/
		public function draw(event:Event=null):void {			
			// loop through all sprites in sprites array
			// and redraw their graphics.
			for each(var sprite:RigSprite in spriteRows) {
				sprite.draw();		
			}
		}
		
		/** Searches for passed in sprite in the spriteRows
		 *  array and returns the corresponding index.
		 *  If the sprite is not found in the array, -1
		 *  is returned **/
		private function findSpriteIndex(sprite:RigSprite):int {
			var i:int = 0;
			for each(var currentSprite:RigSprite in spriteRows) {
				// match found
				if(sprite == currentSprite) {
					return i;
				}
				i++;
			}
			// if no matches found, return -1
			return -1;
		}
		
		public function destroy():void{
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE,resize);
			this.removeAllElements();
		}
		
		
		// -------------------
		// Getters and Setters
		// -------------------
		
		public function get firstRow():RigSprite {
			return spriteRows[0];
		}
		
		public function get lastRow():RigSprite {
			return spriteRows[spriteRows.length-1];
		}
		
		public function get nextRigView():RigView {
			return _nextRigView;
		}

		public function set nextRigView(value:RigView):void {
			_nextRigView = value;
		}

		public function get previousRigView():RigView {
			return _previousRigView;
		}

		public function set previousRigView(value:RigView):void {
			_previousRigView = value;
		}
		
		/** Day range that the rig covers. **/
		public function get rigDetail():RigDetail
		{
			return _rigDetail;
		}

		/**
		 * @private
		 */
		public function set rigDetail(value:RigDetail):void
		{
			_rigDetail = value;
		}

	}
}