package com.etherpros.model.data
{
	import com.etherpros.events.DataModelEvent;
	
	import flash.events.EventDispatcher;

	public class Project extends DataModel
	{
		[Bindable]
		private var _ProjectID:String;
		[Bindable]
		private var _ProjName:String;
		[Bindable]
		private var _ClientID:String;
		[Bindable]
		private var _ContactID:String;
		[Bindable]
		private var _ProjStatus:String;
		[Bindable]
		private var _ClientName:String;

		public function Project() {
			// pass abstract check
			super(this);			
		}
			
		override public function get uniqueID():String {
			return _ProjectID;
		}
		
		override public function set uniqueID(value:String):void {
			_ProjectID = value;
		}
		
		public function get ProjectID():String
		{
			return _ProjectID;
		}

		public function set ProjectID(value:String):void
		{
			_ProjectID = value;
		}
		
		public function get ProjName():String
		{
			return _ProjName;
		}

		public function set ProjName(value:String):void
		{
			_ProjName = value;
		}
		
		public function get ClientID():String
		{
			return _ClientID;
		}

		public function set ClientID(value:String):void
		{
			_ClientID = value;
		}
	
		public function get ContactID():String
		{
			return _ContactID;
		}

		public function set ContactID(value:String):void
		{
			_ContactID = value;
		}
		
		public function get ProjStatus():String
		{
			return _ProjStatus;
		}

		public function set ProjStatus(value:String):void
		{
			_ProjStatus = value;
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