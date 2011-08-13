package com.etherpros.model.data
{
	import com.etherpros.events.DataModelEvent;
	
	import flash.events.EventDispatcher;

	public class Rig extends DataModel {
		private var _RigID:String;
		private var _RigName:String;

		public function Rig() {
			// pass abstract check
			super(this);
		}
		
		override public function get uniqueID():String {
			return _RigID;
		}
		
		override public function set uniqueID(value:String):void {
			_RigID = value;
		}
				
		[Bindable]
		public function get RigID():String
		{
			return _RigID;
		}

		public function set RigID(value:String):void
		{
			_RigID = value;
		}

		[Bindable]
		public function get RigName():String
		{
			return _RigName;
		}

		public function set RigName(value:String):void
		{
			_RigName = value;
		}


	}
}