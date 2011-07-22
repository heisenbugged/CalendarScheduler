package com.etherpros.controllers
{
	import com.etherpros.components.*;
	import com.etherpros.events.RigCreationEvent;
	import com.etherpros.events.RigEvent;
	import com.etherpros.model.*;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.IContainer;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import spark.components.Group;

	public class RigsController
	{
		public var xOffset:int;
		public var yOffset:int;
		
		public static var RIG_HEIGHT:int = 15;
		public static var DAY_WIDTH:int;
		public static var DAY_HEIGHT:int;
		public static var CALENDAR_WIDTH:int;
		public static var CALENDAR_HEIGHT:int;
		public static const RIG_VERTICAL_PADDING:int = 5;		
		// number of miliseconds in a day.
		private const MS_IN_DAY:Number = 86400000;
		
		// day range being viewed on the calendar.
		private var _dayRange:DayRange;
		// list of rig views.
		private var _rigViews:ArrayCollection;
		// all rig models loaded
		public var rigs:ArrayCollection;
		
		private var container:CalendarForm
		
		public function RigsController(container:CalendarForm) {
			this.container = container;
			rigViews = new ArrayCollection();
			rigs = new ArrayCollection();
			
			// view event listeners
			container.addEventListener(RigCreationEvent.ADD_NEW_RIG, createRig);
		}
		
		public static function setCalendarDimensions(width:int, height:int):void {
			CALENDAR_WIDTH = width;
			DAY_WIDTH = CALENDAR_WIDTH/7; //7 columns, one per day of week.
			
			CALENDAR_HEIGHT = height;
			DAY_HEIGHT = CALENDAR_HEIGHT/6; //6 weeks in datagrid.
		}

		

		/**
		 * Draws an existing Rig and positions it on the stage.
		 */
		public function drawRigView(model:Rig = null):void {			
			var view:RigView = addRigView(model);
			// find the difference in days between the start day and end day.
			var dayLength:int = ( (model.endDay.date.getTime() - model.startDay.date.getTime()) / MS_IN_DAY) + 1;
			var column:int = view.columnIndex;
			// if rig starts outside of the viewable range
			if(view.startPos == null) {
				// cut off the difference from the start day and the viewable range start day				
				dayLength += (model.startDay.date.getTime() - dayRange.startDay.date.getTime()) / MS_IN_DAY;
			}
			
			// if rig finishes outside of viewable range
			if(view.endPos == null) {
				// cut off the difference from the end day and the viewable range end day
				dayLength += (dayRange.endDay.date.getTime() - model.endDay.date.getTime() ) / MS_IN_DAY;
			}
			
			view.paint(dayLength, column);
		}

		/*
		protected function addRigView(event:RigCreationEvent):void {
			// if dragging into a valid week.
			if ( event.weekDay && event.weekDay.dayNumber != -1 ) {
				
				var rigDetail:Rig = new Rig();					
				rigDetail.contractor = event.contractorRig;
				rigDetail.startDay = event.weekDay;
				rigsController.createRig(rigDetail);
				
			}				
		}
		*/
		
		/** Creates a new rig, traditionally done on drag and drop to the calendar. **/
		public function createRig(event:RigCreationEvent):void {
			// if dragging into a valid week
			if(event.weekDay && event.weekDay.dayNumber != -1) {
				var model:Rig = new Rig();
				model.contractor = event.contractorRig;
				model.startDay = event.weekDay;
				rigs.addItem(model);
				
				addRigView(model);
			}			
		}		
		
		/** Creates a new rig view, positions it and adds it to the stage **/
		public function addRigView(model:Rig):RigView {
			var view:RigView = new RigView(model, DAY_WIDTH, RIG_HEIGHT);
			
			// get row and column positions of the start and end day of this rig.
			var startPos:Point = dayRange.getDateRowAndColumn(model.startDay.date);
			var endPos:Point = dayRange.getDateRowAndColumn(model.endDay.date);
			
			// if the start day of this rig is outside the viewable date range.
			if(startPos == null) {				
				// disable dragging from left side since the
				// true corner of the rig extends past the
				// viewable range.
				view.leftDraggable = false;
			}
			
			if(endPos == null) {
				// disable dragging from right side since the
				// true corner of the rig extends past the
				// viewable range.				
				view.rightDraggable = false;
			}
			
			// set positioning.
			view.x = xOffset;
			view.y = yOffset;
			view.startPos = startPos;
			view.endPos = endPos;			
			positionRigView(startPos, view);
			
			// add to containers
			container.gridContainer.addElement(view);
			rigViews.addItem(view);
			
			// add event listeners
			view.addEventListener(RigEvent.RIG_RESIZED, rigResized, false, 0, true);
			view.addEventListener(RigEvent.ADD_RIG_SPRITE, addRigRow, false, 0, true);
						
			return view;			
		}
		
		/** Converts a row/column point into X and Y coordinates.
		 *  On the calendar. **/
		private function positionRigView(pos:Point, rig:RigView):void {
			// if the position is null, use 0,0 instead.
			if(pos == null) {
				pos = new Point();
			}
			
			var x:int = ( pos.x * DAY_WIDTH );
			var y:int = ( pos.y * DAY_HEIGHT) + ( (RIG_HEIGHT + RIG_VERTICAL_PADDING) * getYPosition(rig.model.startDay) + 1) + 15;
			rig.position(x, y);
		}
			
		
		public function clearRigViews():void {			
			var rigModels:Array = new Array();		
			for each(var rigView:RigView in rigViews) {									
				rigModels.push(rigView.model);
				
				// clear out view elements from stage
				rigView.destroy();
				rigView.removeEventListener(RigEvent.RIG_RESIZED, rigResized);
				rigView.removeEventListener(RigEvent.ADD_RIG_SPRITE, addRigRow);
				
				container.gridContainer.removeElement(rigView);				
			}
			
			// clear out rig views array
			rigViews = new ArrayCollection();
		}
		
		/** Draws all rigs based on the current dayRange **/
		public function draw():void {
			var rigs:ArrayCollection = getRigsInRange();
			for each(var rig:Rig in rigs) {
				drawRigView(rig);
			}
		}
		
		/** Gets all rig models that enter the active dayRange. **/
		public function getRigsInRange():ArrayCollection {
			
			var rigsInRange:ArrayCollection = new ArrayCollection();
			for each(var rig:Rig in rigs) {
				var rigStart:Number = rig.startDay.date.getTime();
				var rigEnd:Number = rig.endDay.date.getTime();
				
				var rangeStart:Number = dayRange.startDay.date.getTime();
				var rangeEnd:Number = dayRange.endDay.date.getTime();
				// if the rig fits inside the current date range, add it to the active rigs array.
				if(rigStart <= rangeEnd && rigEnd >= rangeStart) {
					rigsInRange.addItem(rig);
				}
			}
			return rigsInRange;
		}
		
		
		private function rigResized(event:RigEvent):void {
			// since drag has finished, must re-compute start and end day range
			// based on new width positions.			
			var sprite:RigSprite = event.view.firstRow;
			var startDay:Day = getDayByColumnAndRow(getColumnIndex(sprite.x), getRowIndex(sprite.y));
			sprite = event.view.lastRow;
			// -2 to shave off a few pixels of borders and padding
			var endDay:Day = getDayByColumnAndRow(getColumnIndex(sprite.x+sprite.width-2), getRowIndex(sprite.y));
			
			// set the right startDay and endDay to the view.
			if(event.view.leftDraggable) {
				event.model.startDay = startDay;
			}
			
			if(event.view.rightDraggable) {
				event.model.endDay = endDay;
			}
		}
		
		/** Adds a new sprite row. **/
		public function addRigRow(rigEvent:RigEvent):void {
			var view:RigView = rigEvent.view;
			var RIG_HEIGHT:Number = 15;
			
			var weekIndex:int = view.rowIndex + rigEvent.view.numRows;
			// week that row will be added to.
			var nextWeek:Week = dayRange.weeks[weekIndex] as Week;
			// instantiate an empty sprite row
			var row:UIComponent = view.createEmptySprite();			
			
			
			// if the row being added is not past the 6 week calendar limit.
			if ( nextWeek != null ) {				
				var nextDay:Day  = nextWeek.getDayByIndex(0);					
				row.y = ( weekIndex * DAY_HEIGHT  )  + ( (RIG_HEIGHT+RIG_VERTICAL_PADDING) * getYPosition(nextDay, rigEvent.model) + 1 ) + 15;				
			}
			
		}
		
		private function getDayByColumnAndRow(column:int, row:int):Day {
			var week:Week = dayRange.weeks[row];
			return week.getDayByIndex(column);
		}
		
		private function getRowIndex(y:int):int {
			return Math.floor(y/RigsController.DAY_HEIGHT);
		}
		
		private function getColumnIndex(x:int):int {
			return Math.floor(x/RigsController.DAY_WIDTH);
		}		
		
		/** 
		 * Determines how many RingViews have been added in a particular day 
		 * When a rig is passed in, it is excluded from any position calculations.
		 * 
		 **/
		
		private function getYPosition( day:Day, rig:Rig=null):int {
			var dayPosition:Point = dayRange.getDateRowAndColumn(day.date);
			var dayTime:Number = day.date.getTime();			
			var rigCounter:int = 0;
			
			for each(var view:RigView in rigViews) {
				if(view.model != rig) {
					// get the time range of the rig we're checking.
					var startTime:Number = view.model.startDay.date.getTime();
					var endTime:Number = view.model.endDay.date.getTime();
					
					// if our date falls within the rig of the rig being checked
					if(startTime <= dayTime && endTime >= dayTime) {
					// add one to the number of rigs present inside this date.
						rigCounter++;
						
					// if the date is part of the same week as this rig, then
					// we also add one to the stacking.					
					} else if(dayPosition.y == view.rowIndex || dayPosition.y == view.endRow) {
						rigCounter++;
					}
				}
			}
			
			return rigCounter;
		}
		
		public function setOffset(x:int, y:int):void {
			xOffset = x;
			yOffset = y;
		}
		
		// -------------------
		// Getters and Setters
		// -------------------
		
		public function set dayRange(value:DayRange):void {
			_dayRange = value;			
			// clear all old rig views since week range was changed.
			clearRigViews();
			// re draw rigs based on new day range
			draw();
		}
		
		public function get dayRange():DayRange {
			return _dayRange;
		}
		
		public function get rigViews():ArrayCollection {
			return _rigViews;
		}
		
		public function set rigViews(value:ArrayCollection):void {
			_rigViews = value;
		}
		
	}
}