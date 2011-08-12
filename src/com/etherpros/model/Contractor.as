package com.etherpros.model
{
	import flash.events.EventDispatcher;

	[Bindable]
	public class Contractor implements IDataModel
	{
		private var _ContractorID:String;
		private var _FirstName:String;
		private var _LastName:String;	
		
		private var _persisted:Boolean;
		public function Contractor() {
		}
		
		public function get persisted():Boolean {
			return _persisted;
		}
		
		public function set persisted(value:Boolean):void {
			_persisted = value;
		}
		
		public function get uniqueID():String {
			return _ContractorID;
		}
		
		[Bindable]
		public function get FullName():String {
			return this.FirstName + " " + this.LastName;
		}

		public function get FirstName():String
		{
			return _FirstName;
		}

		public function set FirstName(value:String):void
		{
			_FirstName = value;
		}

		public function get LastName():String
		{
			return _LastName;
		}

		public function set LastName(value:String):void
		{
			_LastName = value;
		}

		public function get ContractorID():String
		{
			return _ContractorID;
		}

		public function set ContractorID(value:String):void
		{
			_ContractorID = value;
		}


	}
}