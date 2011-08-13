package com.etherpros.model.data
{
	import com.etherpros.events.DataModelEvent;
	
	import flash.events.EventDispatcher;

	[Bindable]
	public class Contractor extends DataModel
	{
		private var _ContractorID:String;
		private var _FirstName:String;
		private var _LastName:String;	

		public function Contractor() {
			// pass abstract check
			super(this);
		}
		
		override public function get uniqueID():String {
			return _ContractorID;
		}
		
		override public function set uniqueID(value:String):void {
			_ContractorID = value;
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