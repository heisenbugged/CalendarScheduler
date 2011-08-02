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
		public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT;
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
			//var urlRequest:URLRequest = new URLRequest(URL);
			//var urlLoader:URLLoader = new URLLoader(urlRequest);
			//urlLoader.addEventListener(Event.COMPLETE,jobAssignmentCompleated);
		}
		
		public function jobAssignmentCompleated(event:Event):void{
			
		}
	}
}