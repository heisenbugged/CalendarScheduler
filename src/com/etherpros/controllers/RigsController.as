package com.etherpros.controllers
{
	import com.etherpros.components.*;
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
		
		public static var DAY_WIDTH:int;
		public static var DAY_HEIGHT:int;
		public static var CALENDAR_WIDTH:int;
		public static var CALENDAR_HEIGHT:int;
		public static const RIG_VERTICAL_PADDING:int = 5;
		
		// list of rig views.
		private var _rigViews:ArrayCollection;
		// all rig models loaded
		public var rigs:ArrayCollection;
		private var _dayRange:DayRange;
		

		private var container:CalendarForm
		
		public function RigsController(container:CalendarForm) {
			this.container = container;
			rigViews = new ArrayCollection();
			rigs = new ArrayCollection();
		}
		
		public static function setCalendarDimensions(width:int, height:int):void {
			CALENDAR_WIDTH = width;
			DAY_WIDTH = CALENDAR_WIDTH/7; //7 columns, one per day of week.
			
			CALENDAR_HEIGHT = height;
			DAY_HEIGHT = CALENDAR_HEIGHT/6; //6 weeks in datagrid.
		}

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

		/**
		 * Draws an existing Rig
		 * */
		
		// number of miliseconds in a day.
		private const MS_IN_DAY:Number = 86400000;
		public function drawRigView(model:Rig = null):void {			
			var view:RigView = addRigView(model);
			var startPosition:Point = dayRange.getDateRowAndColumn(model.startDay.date);
			var endPosition:Point = dayRange.getDateRowAndColumn(model.endDay.date);
				
			var dayLength:int = ( (model.endDay.date.getTime() - model.startDay.date.getTime()) / MS_IN_DAY) + 1;
			// if rig starts outside of the viewable range
			if(startPosition == null) {
				// cut off the difference from the start day and the viewable range start day				
				dayLength += (model.startDay.date.getTime() - dayRange.startDay.date.getTime()) / MS_IN_DAY;
			}
			
			// if rig finishes outside of viewable range
			if(endPosition == null) {
				// cut off the difference from the end day and the viewable range end day
				dayLength += (dayRange.endDay.date.getTime() - model.endDay.date.getTime() ) / MS_IN_DAY;
			}

			var week:Week =  dayRange.weeks.getItemAt(view.startRow) as Week;
			var dayIndex:int = view.startColumn;			
			view.paint(dayLength, dayIndex);
		}
		
		public function addRigView(model:Rig):RigView {
			var view:RigView = initRig(	model );			
			container.gridContainer.addElement(view);
			rigViews.addItem(view);			
			view.addEventListener(RigEvent.RIG_RESIZED, rigResized, false, 0, true);
			view.addEventListener(RigEvent.ADD_RIG_SPRITE, addRigRow, false, 0, true);
			
			return view;			
		}
		
		public function createRig(model:Rig = null):void {			
			rigs.addItem(model);
			addRigView(model);
		}
		
		/** Creates a new empty rig view. Maybe should be in a factory? **/
		private function initRig(model:Rig):RigView {
			var RIG_HEIGHT:Number = 15;
			
			var startPos:Point = dayRange.getDateRowAndColumn(model.startDay.date);
			var endPos:Point = dayRange.getDateRowAndColumn(model.endDay.date);
			// calculate view position based on day clicked.
			// dayIndex is column and weekIndex is row.
			var x:int = 0;
			var y:int = 0;
			
			// if the start of the rig goes outside the calendar
			// set the start to zero instead and disable left dragging
			// since the left side is beyond the bounds of the current
			// viewport.
			if(startPos) {
				x = ( startPos.x * DAY_WIDTH );
				y = ( startPos.y * DAY_HEIGHT  )  + ( (RIG_HEIGHT+RIG_VERTICAL_PADDING) * getYPosition(model.startDay) + 1 ) + 15;
			} else {
				y = ( (RIG_HEIGHT+RIG_VERTICAL_PADDING) * getYPosition(model.startDay) + 1 ) + 15;
			}
			
			var view:RigView = new RigView(model, DAY_WIDTH, RIG_HEIGHT, x, y);
			
			if(startPos) {
				view.startRow = startPos.y;
				view.startColumn = startPos.x;
			} else {
				view.startRow = 0;
				view.startColumn = 0;
				view.leftDraggable = false;
			}
			
			// if the view ends outside the viewable range
			// disable dragging from right hand side.
			if(endPos == null) {
				view.rightDraggable = false;
			}
			
			view.x = xOffset;
			view.y = yOffset
			return view;
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
			
			// save rig model objects.
			// var monthKey:String = container.currentYearSelected + "-" + container.currentMonthSelected;
			// addRigByMonth(monthKey, rigModels);
			
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
			
			var weekIndex:int = view.startRow + rigEvent.view.numRows;
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
					} else if(dayPosition.y == view.startRow || dayPosition.y == view.endRow) {
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
		
		public function get rigViews():ArrayCollection
		{
			return _rigViews;
		}
		
		public function set rigViews(value:ArrayCollection):void
		{
			_rigViews = value;
		}
		
	}
}