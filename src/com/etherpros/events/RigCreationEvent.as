package com.etherpros.events
{
	import com.etherpros.components.RigView;
	import com.etherpros.model.Staff;
	import com.etherpros.model.WeekDay;
	
	import flash.events.Event;
	
	public class RigCreationEvent extends Event
	{
		public static const REACHED_WEEK_LIMIT:String = "reachedWeekLimit";
		public static const ADD_NEW_RIG:String ="addNewRig";
		
		private var _rigView:RigView;
		private var _staffRig:Staff;
		private var _weekDay:WeekDay;
		public function RigCreationEvent(type:String,rigView:RigView = null,  bubbles:Boolean=false, cancelable:Boolean=false)
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

		public function get staffRig():Staff
		{
			return _staffRig;
		}

		public function set staffRig(value:Staff):void
		{
			_staffRig = value;
		}

		public function get weekDay():WeekDay
		{
			return _weekDay;
		}

		public function set weekDay(value:WeekDay):void
		{
			_weekDay = value;
		}


	}
}