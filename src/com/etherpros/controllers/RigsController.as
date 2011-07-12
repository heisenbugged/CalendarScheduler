package com.etherpros.controllers
{
	import com.etherpros.components.RigView;
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
		
		public function RigsController(container:Group) {
			this.container = container;
		}
		
		public function set weeks(arr:ArrayCollection):void {
			_weeks = arr;
			
			// since month has changed, clear all existing rigs.
			// clearRigs();
		}
		
		public function addRig(weekDay:WeekDay):void {
			var view:RigView = new RigView(100, 15);
			// calculate view position based on day clicked.
			// dayIndex is column and weekIndex is row.
			view.x = (weekDay.dayIndex * DAY_WIDTH) + xOffset;
			view.y = (weekDay.weekIndex * DAY_HEIGHT) + yOffset;
			container.addElement(view);			
		}
		
		public function setOffset(x:int, y:int):void {
			xOffset = x;
			yOffset = y;
		}
		
	}
}