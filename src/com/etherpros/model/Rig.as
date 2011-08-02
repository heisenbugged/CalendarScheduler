package com.etherpros.model
{
	public class Rig
	{
		private var _RigID:String;
		private var _RigName:String;
		public function Rig()
		{
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