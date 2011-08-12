package com.etherpros.model
{
	public class Rig implements IDataModel
	{
		private var _RigID:String;
		private var _RigName:String;
		private var _persisted:Boolean;

		public function get uniqueID():String {
			return _RigID;
		}
		
		public function get persisted():Boolean {
			return _persisted;
		}
		
		public function set persisted(value:Boolean):void {
			_persisted = value;
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