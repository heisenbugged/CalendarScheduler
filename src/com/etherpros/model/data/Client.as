package com.etherpros.model.data
{
	import com.etherpros.events.DataModelEvent;
	
	import flash.events.EventDispatcher;

	[Bindable]
	public class Client extends DataModel
	{
		private var _ClientID:String;
		private var _ClientName:String;
		private var _persisted:Boolean;
		
		public function Client() {
			// pass abstract check
			super(this);
		}
		
		override public function get uniqueID():String {
			return _ClientID;
		}
		
		override public function set uniqueID(value:String):void {
			_ClientID = value;
		}

		public function get ClientID():String
		{
			return _ClientID;
		}

		public function set ClientID(value:String):void
		{
			_ClientID = value;
		}

		public function get ClientName():String
		{
			return _ClientName;
		}

		public function set ClientName(value:String):void
		{
			_ClientName = value;
		}


	}
}