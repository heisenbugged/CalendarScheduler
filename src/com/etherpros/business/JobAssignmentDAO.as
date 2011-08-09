package com.etherpros.business
{
	import com.etherpros.events.JobAssignmentEvent;
	import com.etherpros.model.Assignment;
	import com.etherpros.model.Client;
	import com.etherpros.model.Contractor;
	import com.etherpros.model.Job;
	import com.etherpros.model.Project;
	import com.etherpros.model.Rig;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	
	import mx.collections.ArrayCollection;

	public class JobAssignmentDAO extends BaseDAO
	{
		public static var LAYOUT:String = "Assignments";
		public static var STATUS_NEW:String = "new";
		public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT;
		//public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT+"&Site_ID=S1&-new";
		[Bindable]
		private var _jobAssignment:Job;
		[Bindable]
		public  var assignments:ArrayCollection;
		private var _assignmentList:ArrayCollection;
		private var isLoaded:Boolean = false;
		
		[Bindable]
		private var dispatcher:IEventDispatcher;
		public function JobAssignmentDAO(dispatcher:IEventDispatcher)
		{
			super();
			this.dispatcher = dispatcher;
		}
		
		public function findAll():void{
			var strURL:String = URL +  "&StartDate=08/01/2011&StartDate.op=gt&-find";
			var urlRequest:URLRequest = new URLRequest(strURL);
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,assignmentsLoaded);
		}
		
		private function assignmentsLoaded(event:Event):void{
			this._assignmentList  = new ArrayCollection();			
			var xml:XML = new XML(event.target.data);			
			if (xml.namespace("") != undefined) { default xml namespace = xml.namespace(""); }
			
			for each(var result:XML in xml.resultset.record) {				
				var assignment:Assignment = new Assignment();
				for each(var field:XML in result.field) {
					
					if(field.@name == "AssignmentID") {
						assignment.AssignmentID = field.data.toString();
					}
					if(field.@name == "Client_ID") {
						assignment.Client_ID = field.data.toString();
					}
					if(field.@name == "ClientName") {
						assignment.ClientName = field.data.toString();
					}
					if(field.@name == "Contractor_ID") {
						assignment.Contractor_ID = field.data.toString();
					}
					if(field.@name == "FirstName") {
						assignment.FirstName = field.data.toString();
					}
					if(field.@name == "LastName") {
						assignment.LastName = field.data.toString();
					}
					if(field.@name == "Project_ID") {
						assignment.Project_ID = field.data.toString();
					}
					if(field.@name == "ProjName") {
						assignment.ProjectName = field.data.toString();
					}
					if(field.@name == "Rig_ID") {
						assignment.Rig_ID = field.data.toString();
					}
					if(field.@name == "RigName") {
						assignment.RigName = field.data.toString();
					}
					if(field.@name == "StartDate") {
						assignment.StartDate = new Date( Date.parse(field.data.toString()) );
					}
					if(field.@name == "StartTime") {
						assignment.StartTime = field.data.toString();
					}
					if(field.@name == "FinishDate") {
						assignment.FinishDate = new Date( Date.parse(field.data.toString()) );
					}
					if(field.@name == "FinishTime") {
						assignment.FinishTime = field.data.toString();
					}
					if(field.@name == "Status") {
						assignment.Status = field.data.toString();
					}
				}
				assignment.Client_ID
				this._assignmentList.addItem(assignment);
			}
			isLoaded = true;
			checkIfFullyLoaded();
			default xml namespace = new Namespace("");
		}
		
		private function checkIfFullyLoaded():void {
			if(isLoaded) {
				this.assignments = this._assignmentList;
				var clientEvent:JobAssignmentEvent = new JobAssignmentEvent(JobAssignmentEvent.FIND_ALL_DONE,true);
				dispatcher.dispatchEvent(clientEvent);
			}
		}	
		
		public function createJobAssignment( job:Job ):void{
			trace(job.rig.RigName);
			var strURL:String = new String();
			strURL = URL + "&Contractor_ID="+job.contractor.ContractorID + "&Site_ID=S1" + "&Project_ID="+job.project.ProjectID + "&Client_ID=" +job.client.ClientID;
			strURL += "&StartDate=" + format(job.startDay.date) + "&FinishDate=" + format(job.endDay.date)+ "&Rig_ID="+ job.rig.RigID ;
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