package com.etherpros.events
{
	import com.etherpros.components.RigView;
	import com.etherpros.model.Contractor;
	import com.etherpros.model.Day;
	
	import flash.events.Event;
	
	public class RigCreationEvent extends Event
	{
		public static const REACHED_WEEK_LIMIT:String = "reachedWeekLimit";
		public static const ADD_NEW_RIG:String ="addNewRig";
		
		private var _rigView:RigView;
		private var _contractorRig:Contractor;
		private var _weekDay:Day;
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

		public function get weekDay():Day
		{
			return _weekDay;
		}

		public function set weekDay(value:Day):void
		{
			_weekDay = value;
		}

		public function get contractorRig():Contractor
		{
			return _contractorRig;
		}

		public function set contractorRig(value:Contractor):void
		{
			_contractorRig = value;
		}


	}
}