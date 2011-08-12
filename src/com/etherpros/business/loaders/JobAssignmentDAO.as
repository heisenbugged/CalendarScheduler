package com.etherpros.business.loaders
{
	import com.etherpros.events.JobAssignmentEvent;
	import com.etherpros.model.Assignment;
	import com.etherpros.model.Client;
	import com.etherpros.model.Contractor;
	import com.etherpros.model.DataModelCollection;
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
		private var assignments:DataModelCollection;
		private var isLoaded:Boolean = false;
		
		[Bindable]
		private var dispatcher:IEventDispatcher;
		public function JobAssignmentDAO(dispatcher:IEventDispatcher)
		{
			super();
			this.dispatcher = dispatcher;
		}
		
		public function findAll(startDate:Date, endDate:Date):void{
			var strURL:String = URL +  "&StartDate=" + ( startDate.month + 1) + "/" + startDate.date + "/" + startDate.fullYear
								+ "&StartDate.op=gte&-find";
			
			strURL += "&FinishDate="+ ( endDate.month + 1)  + "/" + endDate.date + "/" + endDate.fullYear + "&FinishDate.op=lte&-find";
			var urlRequest:URLRequest = new URLRequest(strURL);
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,assignmentsLoaded);
		}
		
		private function assignmentsLoaded(event:Event):void{
			assignments = new DataModelCollection();			
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
					if(field.@name == "Contractor 4 Assignment::FirstName") {
						assignment.FirstName = field.data.toString();
					}
					if(field.@name == "Contractor 4 Assignment::LastName") {
						assignment.LastName = field.data.toString();
					}
					if(field.@name == "Project_ID") {
						assignment.Project_ID = field.data.toString();
					}
					if(field.@name == "Project 4 Assignment::ClientName") {
						assignment.ProjectName = field.data.toString();
					}
					if(field.@name == "Rig_ID") {
						assignment.Rig_ID = field.data.toString();
					}
					if(field.@name == "Rigs 4 Assignment::RigName") {
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
				assignments.addItem(assignment);
			}
			isLoaded = true;
			checkIfFullyLoaded();
			default xml namespace = new Namespace("");
		}
		
		private function checkIfFullyLoaded():void {
			if(isLoaded) {			
				var doneEvent:JobAssignmentEvent = new JobAssignmentEvent(JobAssignmentEvent.FIND_ALL_DONE,true);
				doneEvent.jobs = assignments;
				dispatcher.dispatchEvent(doneEvent);
			}
		}	
		
		public function createJobAssignment( job:Job ):void{
			trace(job.rig.RigName);
			var strURL:String = new String();
			
			//New job is saved
			if ( job.AssignmentID == null || job.AssignmentID <= 0) {
				strURL = URL + "&Contractor_ID="+job.contractor.ContractorID + "&Site_ID=S1" + "&Project_ID="+job.project.ProjectID + "&Client_ID=" +job.client.ClientID;
				strURL += "&StartDate=" + format(job.startDay.date) + "&FinishDate=" + format(job.endDay.date)+ "&Rig_ID="+ job.rig.RigID ;
				strURL += "&-new";
			}else{
				//Edition option
				var recordId:String = job.AssignmentID.toString().substring(1);
				strURL = URL + "&-recid="+ recordId  +"&Contractor_ID="+job.contractor.ContractorID + "&Site_ID=S1" + "&Project_ID="+job.project.ProjectID + "&Client_ID=" +job.client.ClientID;
				strURL += "&StartDate=" + format(job.startDay.date) + "&FinishDate=" + format(job.endDay.date)+ "&Rig_ID="+ job.rig.RigID ;
				strURL += "&-edit";
			}
			var urlRequest:URLRequest = new URLRequest(strURL);
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE, jobAssignmentCompleated);
		}
		
		public function jobAssignmentCompleated(event:Event):void{
			trace(event.toString());
		}
	}
}