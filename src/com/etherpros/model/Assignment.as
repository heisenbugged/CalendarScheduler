package com.etherpros.model {
	import com.etherpros.model.data.DataModel;	
	import flash.events.EventDispatcher;

	[Bindable]
	public class Assignment extends DataModel
	{
		private var _AssignmentID:String;
		private var _Client_ID:String;
		private var _ClientName:String;
		private var _Contractor_ID:String;
		private var _ConFullName:String;
		private var _FirstName:String;//Contractor
		private var _LastName:String;//Contractor
		private var _Site_ID:String;
		private var _SiteName:String;
		private var _Project_ID:String;
		private var _ProjectName:String;
		private var _Rig_ID:String;
		private var _RigName:String;
		
		private var _StartDate:Date;
		private var _StartTime:String;
		private var _FinishDate:Date;
		private var _FinishTime:String;
		private var _Status:String;
		private var _ConCode:String;		
		private var _Details:String;
		private var _CurrDate:Date;
		
		public function Assignment() {
			// pass abstract check
			super(this);
		}

		
		override public function get uniqueID():String {
			return _AssignmentID;
		}
		
		override public function set uniqueID(value:String):void {
			_AssignmentID = value;
		}
		
		public function get AssignmentID():String
		{
			return _AssignmentID;
		}

		public function set AssignmentID(value:String):void
		{
			_AssignmentID = value;
		}

		public function get Client_ID():String
		{
			return _Client_ID;
		}

		public function set Client_ID(value:String):void
		{
			_Client_ID = value;
		}

		public function get ClientName():String
		{
			return _ClientName;
		}

		public function set ClientName(value:String):void
		{
			_ClientName = value;
		}

		public function get Contractor_ID():String
		{
			return _Contractor_ID;
		}

		public function set Contractor_ID(value:String):void
		{
			_Contractor_ID = value;
		}

		public function get ConFullName():String
		{
			return _ConFullName;
		}

		public function set ConFullName(value:String):void
		{
			_ConFullName = value;
		}

		public function get Site_ID():String
		{
			return _Site_ID;
		}

		public function set Site_ID(value:String):void
		{
			_Site_ID = value;
		}

		public function get SiteName():String
		{
			return _SiteName;
		}

		public function set SiteName(value:String):void
		{
			_SiteName = value;
		}

		public function get Project_ID():String
		{
			return _Project_ID;
		}

		public function set Project_ID(value:String):void
		{
			_Project_ID = value;
		}

		public function get ProjectName():String
		{
			return _ProjectName;
		}

		public function set ProjectName(value:String):void
		{
			_ProjectName = value;
		}

		public function get Rig_ID():String
		{
			return _Rig_ID;
		}

		public function set Rig_ID(value:String):void
		{
			_Rig_ID = value;
		}

		public function get RigName():String
		{
			return _RigName;
		}

		public function set RigName(value:String):void
		{
			_RigName = value;
		}

		public function get StartDate():Date
		{
			return _StartDate;
		}

		public function set StartDate(value:Date):void
		{
			_StartDate = value;
		}

		public function get StartTime():String
		{
			return _StartTime;
		}

		public function set StartTime(value:String):void
		{
			_StartTime = value;
		}

		public function get FinishDate():Date
		{
			return _FinishDate;
		}

		public function set FinishDate(value:Date):void
		{
			_FinishDate = value;
		}

		public function get FinishTime():String
		{
			return _FinishTime;
		}

		public function set FinishTime(value:String):void
		{
			_FinishTime = value;
		}

		public function get Status():String
		{
			return _Status;
		}

		public function set Status(value:String):void
		{
			_Status = value;
		}

		public function get ConCode():String
		{
			return _ConCode;
		}

		public function set ConCode(value:String):void
		{
			_ConCode = value;
		}

		public function get Details():String
		{
			return _Details;
		}

		public function set Details(value:String):void
		{
			_Details = value;
		}

		public function get CurrDate():Date
		{
			return _CurrDate;
		}

		public function set CurrDate(value:Date):void
		{
			_CurrDate = value;
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


	}
}