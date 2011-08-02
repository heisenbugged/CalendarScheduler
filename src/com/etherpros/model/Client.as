package com.etherpros.model
{
	public class Client
	{
		private var _ClientID:String;
		private var _ClientName:String;
		
		public function Client()
		{
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