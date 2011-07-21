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
		
		private var _weeks:ArrayCollection;
		private var _rigViewsByMonth:Array;

		private var container:CalendarForm
		
		public function RigsController(container:CalendarForm) {
			this.container = container;
			rigViewsByMonth = new Array();
			rigViews = new ArrayCollection();
		}
		
		public static function setCalendarDimensions(width:int, height:int):void {
			CALENDAR_WIDTH = width;
			DAY_WIDTH = CALENDAR_WIDTH/7; //7 columns, one per day of week.
			
			CALENDAR_HEIGHT = height;
			DAY_HEIGHT = CALENDAR_HEIGHT/6; //6 weeks in datagrid.
		}
		
		public function addRigByMonth(monthKey:String, rigList:Array):void{
			rigViewsByMonth[monthKey] = rigList;
		}
		
		public function getRigByMonth(monthKey:String):Array{
			return this.rigViewsByMonth[monthKey] as Array;
		}

		public function set weeks(arr:ArrayCollection):void {
			_weeks = arr;
			
			// since month has changed, clear all existing rigs.
			// clearRigs();
		}
		
		public function get weeks():ArrayCollection {
			return this._weeks;
		}
		
		public function addRig(rigDetail:Rig = null):RigView {					
			var view:RigView = initRig(	rigDetail );			
			container.gridContainer.addElement(view);
			rigViews.addItem(view);			
			view.addEventListener(RigEvent.RIG_RESIZED, rigResized, false, 0, true);
			
			return view;
		}
		
		public function clearRigs():void {			
			var rigModels:Array = new Array();		
			for each(var rigView:RigView in rigViews) {									
				rigModels.push(rigView.model);
				
				// clear out view elements from stage
				rigView.destroy();
				rigView.removeEventListener(RigEvent.RIG_RESIZED, rigResized);
				
				container.gridContainer.removeElement(rigView);				
			}
			
			// save rig model objects.
			var monthKey:String = container.currentYearSelected + "-" + container.currentMonthSelected;
			addRigByMonth(monthKey, rigModels);
			
			// clear out rig views array
			rigViews = new ArrayCollection();
		}
		
		
		
		
		private function initRig(rigDetail:Rig):RigView{
			var RIG_HEIGHT:Number = 15;
			
			// calculate view position based on day clicked.
			// dayIndex is column and weekIndex is row.
			var x:int = ( rigDetail.startDay.dayIndex * DAY_WIDTH );
			var y:int = ( rigDetail.startDay.weekIndex * DAY_HEIGHT  )  + ( (RIG_HEIGHT+RIG_VERTICAL_PADDING) * getYPosition(rigDetail.startDay) + 1 ) + 15;
			
			var view:RigView = new RigView(rigDetail ,DAY_WIDTH, RIG_HEIGHT, x, y);			
			view.x = xOffset;
			view.y = yOffset
			return view;
		}
		
		/**
		 * Draws an existing RigView
		 * */
		public function reDrawRig(rigDetail:Rig = null):void {			
			var view:RigView = addRig(rigDetail);
			
			if ( rigDetail.startDay != null && rigDetail.startDay.dayNumber != -1 
				&& rigDetail.endDay != null && rigDetail.endDay.dayNumber != -1 ){				
				var dayLenght:int = rigDetail.endDay.dayNumber - rigDetail.startDay.dayNumber;
				var _week:Week =  this.weeks.getItemAt(rigDetail.startDay.weekIndex ) as Week;
				var dayIndex:int = _week.getIndexByDay(rigDetail.startDay.dayName);				
				view.reDraw(dayLenght, dayIndex);
			}
		}
		
		private function rigResized(event:RigEvent):void {
			// since drag has finished, must re-compute start and end day range
			// based on new width positions.			
			var sprite:RigSprite = event.view.firstRow;
			var startDay:WeekDay = getDayByColumnAndRow(getColumnIndex(sprite.x), getRowIndex(sprite.y));
			sprite = event.view.lastRow;
			// -2 to shave off a few pixels of borders and padding
			var endDay:WeekDay = getDayByColumnAndRow(getColumnIndex(sprite.x+sprite.width-2), getRowIndex(sprite.y));
			
			// set the right startDay and endDay to the view.
			event.model.startDay = startDay;
			event.model.endDay = endDay;
		}
		
		public function addRigSprite(rigEvent:RigEvent):void{
			// create new row!
			var RIG_HEIGHT:Number = 15;			
			var row:UIComponent = rigEvent.view.createEmptySprite();
			var _nextWeek:Week = this.weeks[rigEvent.view.model.startDay.weekIndex + 1 ] as Week ;
			if ( _nextWeek != null ){
				var nextDay:WeekDay  = _nextWeek.getDayByIndex(0);				
				rigEvent.view.addElement(row);				
				// redraw rows.
				rigEvent.view.draw();
				if ( rigEvent.isRedraw ){
					row.y = ( nextDay.weekIndex * DAY_HEIGHT  )  + ( (RIG_HEIGHT+RIG_VERTICAL_PADDING) * getYPosition(nextDay)  ) + 15;
					row.width = Math.ceil(row.width/RigsController.DAY_WIDTH)  * RigsController.DAY_WIDTH + (rigEvent.rigTotalWidth);
				}else{
					row.y = ( nextDay.weekIndex * DAY_HEIGHT  )  + ( (RIG_HEIGHT+RIG_VERTICAL_PADDING) * getYPosition(nextDay) + 1 ) + 15;
				}
			}
			
		}
		
		private function getDayByColumnAndRow(column:int, row:int):WeekDay {
			var week:Week = weeks[row];
			return week.getDayByIndex(column);
		}
		
		private function getRowIndex(y:int):int {
			return Math.floor(y/RigsController.DAY_HEIGHT);
		}
		
		private function getColumnIndex(x:int):int {
			return Math.floor(x/RigsController.DAY_WIDTH);
		}		
		
		/** Determines how many RingViews have been added in a particular day **/		
		private function getYPosition( _weekDay:WeekDay ):int{
			var ringCounter:int = 0;
			for each  (var _ringView:RigView in _rigViews) {
				if ( (_ringView.model.startDay != null && _ringView.model.startDay.weekIndex == _weekDay.weekIndex ) 
					||  ( _ringView.model.endDay != null && _ringView.model.endDay.weekIndex == _weekDay.weekIndex ) ){
					ringCounter++;
				}
			}
			return ringCounter ;
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

		public function get rigViewsByMonth():Array
		{
			return _rigViewsByMonth;
		}

		public function set rigViewsByMonth(value:Array):void
		{
			_rigViewsByMonth = value;
		}

		
	}
}