package com.etherpros.business
{
	import com.etherpros.model.Job;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;

	public class JobAssignmentDAO extends BaseDAO
	{
		public static var LAYOUT:String = "Assignments";
		public static var STATUS_NEW:String = "new";
		public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT;
		//public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT+"&Site_ID=S1&-new";
		[Bindable]
		private var _jobAssignment:Job;
		[Bindable]
		private var dispatcher:IEventDispatcher;
		public function JobAssignmentDAO(dispatcher:IEventDispatcher)
		{
			super();
			this.dispatcher = dispatcher;
		}
		
		public function createJobAssignment( job:Job ):void{
			trace(job.rig.RigName);
			var strURL:String = new String();
			strURL = URL + "&Contractor_ID="+job.contractor.ContractorID + "&Site_ID=S1" + "&Project_ID="+job.project.ProjectID + "&StartDate=" + format(job.startDay.date);
			strURL += "&FinishDate=" + format(job.endDay.date)+ "&Rig_ID="+ job.rig.RigID ;
			strURL += "&-new";
			var urlRequest:URLRequest = new URLRequest(strURL);
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,jobAssignmentCompleated);
		}
		
		public function jobAssignmentCompleated(event:Event):void{
			trace(event.toString());
		}
	}
}