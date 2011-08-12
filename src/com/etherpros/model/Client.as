package com.etherpros.model
{
	[Bindable]
	public class Client implements IDataModel
	{
		private var _ClientID:String;
		private var _ClientName:String;
		private var _persisted:Boolean;
		
		public function Client()
		{
		}

		public function get persisted():Boolean {
			return _persisted;
		}
		
		public function set persisted(value:Boolean):void {
			_persisted = value;
		}
		
		public function get uniqueID():String {
			return _ClientID;
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