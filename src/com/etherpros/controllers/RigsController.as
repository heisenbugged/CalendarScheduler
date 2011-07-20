package com.etherpros.controllers
{
	import com.etherpros.components.RigSprite;
	import com.etherpros.components.RigView;
	import com.etherpros.events.RigEvent;
	import com.etherpros.model.RigDetail;
	import com.etherpros.model.Staff;
	import com.etherpros.model.Week;
	import com.etherpros.model.WeekDay;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.IContainer;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
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

		private var container:IVisualElementContainer;
		
		public function RigsController(container:IVisualElementContainer) {
			this.container = container;
			_rigViewsByMonth = new Array();
			_rigViews = new ArrayCollection();
		}
		
		public static function setCalendarDimensions(width:int, height:int):void {
			CALENDAR_WIDTH = width;
			DAY_WIDTH = CALENDAR_WIDTH/7; //7 columns, one per day of week.
			
			CALENDAR_HEIGHT = height;
			DAY_HEIGHT = CALENDAR_HEIGHT/6; //6 weeks in datagrid.
			trace(DAY_HEIGHT);
		}
		
		public function addRigByMonth(monthKey:String, rigList:Array):void{
			_rigViewsByMonth[monthKey] = rigList;
		}
		
		public function getRigByMonth(monthKey:String):Array{
			return this._rigViewsByMonth[monthKey] as Array;
		}

		public function set weeks(arr:ArrayCollection):void {
			_weeks = arr;
			
			// since month has changed, clear all existing rigs.
			// clearRigs();
		}
		public function get weeks():ArrayCollection {
			return this._weeks;
		}
		
		public function addRig(rigDetail:RigDetail = null):RigView {
			var RIG_HEIGHT:Number = 15;
			
			// calculate view position based on day clicked.
			// dayIndex is column and weekIndex is row.
			var x:int = ( rigDetail.startDay.dayIndex * DAY_WIDTH );
			var y:int = ( rigDetail.startDay.weekIndex * DAY_HEIGHT  )  + ( (RIG_HEIGHT+RIG_VERTICAL_PADDING) * getYPosition(rigDetail.startDay) + 1 ) + 15;
			
			var view:RigView = new RigView(rigDetail ,DAY_WIDTH, RIG_HEIGHT, x, y);			
			view.x = xOffset;
			view.y = yOffset
			
			container.addElement(view);
			_rigViews.addItem(view);
			
			view.addEventListener(RigEvent.RIG_RESIZED, rigResized);
			
			return view;
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
			event.view.rigDetail.startDay = startDay;
			event.view.rigDetail.endDay = endDay;
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
				if ( _ringView.rigDetail.startDay.dayNumber == _weekDay.dayNumber ){
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