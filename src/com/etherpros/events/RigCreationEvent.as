package com.etherpros.events
{
	import com.etherpros.components.RigView;
	
	import flash.events.Event;
	
	public class RigCreationEvent extends Event
	{
		public static const REACHED_WEEK_LIMIT:String = "reachedWeekLimit";
		private var _rigView:RigView;
		public function RigCreationEvent(type:String,rigView:RigView,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._rigView = rigView;
		}

		public function get rigView():RigView
		{
			return _rigView;
		}

		public function set rigView(value:RigView):void
		{
			_rigView = value;
		}

	}
}