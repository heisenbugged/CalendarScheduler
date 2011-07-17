package com.etherpros.controllers
{
	import com.etherpros.components.RigView;
	import com.etherpros.components.RingBar;
	import com.etherpros.model.WeekDay;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;

	public class RigsController
	{
		public var xOffset:int;
		public var yOffset:int;
		
		public static var DAY_WIDTH:int = 84;
		public static var DAY_HEIGHT:int = 59;
		
		// list of rig views.
		private var rigViews:ArrayCollection;
		
		private var _weeks:ArrayCollection;		
		private var container:Group;
		//Grid with to help stablish limit in drag and drop function
		private var _calendarGridWidth:int;		
		
		public function RigsController(container:Group) {
			this.container = container;
			rigViews = new ArrayCollection();
		}
		
		public function set weeks(arr:ArrayCollection):void {
			_weeks = arr;
			
			// since month has changed, clear all existing rigs.
			// clearRigs();
		}
		public function get weeks():ArrayCollection {
			return this._weeks;
		}
		
		public function addRig(weekDay:WeekDay, _previousRig:RigView = null):RigView {
			var view:RigView = new RigView(weekDay,100, 15, _calendarGridWidth,_previousRig);
			// calculate view position based on day clicked.
			// dayIndex is column and weekIndex is row.
			view.x = ( weekDay.dayIndex * DAY_WIDTH ) + xOffset;
			view.y = ( weekDay.weekIndex * DAY_HEIGHT  ) +  yOffset + ( view.height * getYPosition(weekDay) + 1 );
			container.addElement(view);
			rigViews.addItem(view);
			return view;
		}
		
		//Function that determines how many RingViews have been added in a day		
		private function getYPosition( _weekDay:WeekDay ):int{
			var ringCounter:int = 0;
			for each  (var _ringView:RigView in rigViews) {
				if ( _ringView.startDay.dayNumber == _weekDay.dayNumber ){
					ringCounter++;
				}
			}
			return ringCounter ;
		}
		
		public function setOffset(x:int, y:int):void {
			xOffset = x;
			yOffset = y;
		}

		public function get calendarGridWidth():int
		{
			return _calendarGridWidth;
		}

		public function set calendarGridWidth(value:int):void
		{
			_calendarGridWidth = value;
		}

		
	}
}