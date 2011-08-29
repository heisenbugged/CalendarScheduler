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
		private var _Title:String;
		private var _Tel:String;
		private var _Email:String;
		private var _Fax:String;
		private var _Cell:String;
		private var _Password:String;

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

		public function get Title():String
		{
			return _Title;
		}

		public function set Title(value:String):void
		{
			_Title = value;
		}

		public function get Tel():String
		{
			return _Tel;
		}

		public function set Tel(value:String):void
		{
			_Tel = value;
		}

		public function get Email():String
		{
			return _Email;
		}

		public function set Email(value:String):void
		{
			_Email = value;
		}

		public function get Fax():String
		{
			return _Fax;
		}

		public function set Fax(value:String):void
		{
			_Fax = value;
		}

		public function get Cell():String
		{
			return _Cell;
		}

		public function set Cell(value:String):void
		{
			_Cell = value;
		}

		public function get Password():String
		{
			return _Password;
		}

		public function set Password(value:String):void
		{
			_Password = value;
		}


	}
}