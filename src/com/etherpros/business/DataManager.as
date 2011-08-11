package com.etherpros.business {
	import com.etherpros.events.JobAssignmentEvent;
	import com.etherpros.model.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class DataManager extends EventDispatcher {
		private var dispatcher:IEventDispatcher;
		
		public var clients:ArrayCollection;
		public var projects:ArrayCollection;
		public var rigs:ArrayCollection;
		public var contractors:ArrayCollection;
		public var jobs:JobsCollection = new JobsCollection();
		
		public function DataManager(dispatcher:IEventDispatcher) {
			this.dispatcher = dispatcher;		
		}
		
		public function loadClients(clients:ArrayCollection):void {
			this.clients = clients;
		}
		
		public function loadProjects(projects:ArrayCollection):void {
			this.projects = projects;
		}
		
		public function loadRigs(rigs:ArrayCollection):void {
			this.rigs = rigs;
		}
		
		public function loadContractors(contractors:ArrayCollection):void {
			this.contractors = contractors;
		}
		
		public function loadJobs(assignments:ArrayCollection):void {
			for each (var assignment:Assignment in assignments) {
				var job:Job = new Job();
				job.AssignmentID 	= assignment.AssignmentID;
				job.client = new Client();
				job.project = new Project();
				job.contractor = new Contractor();
				job.rig = new Rig();
				job.client.ClientID 	= assignment.Client_ID;
				job.client.ClientName 	= assignment.ClientName;
				job.project.ProjectID 	= assignment.Project_ID;
				job.project.ProjName	= assignment.ProjectName;
				job.contractor.ContractorID	= assignment.Contractor_ID;
				job.contractor.FirstName	= assignment.FirstName;
				job.contractor.LastName		= assignment.LastName;
				job.rig.RigID 	= assignment.Rig_ID;
				job.rig.RigName = assignment.RigName;
				job.startDay = new Day();
				job.endDay = new Day();
				job.startDay.date = assignment.StartDate;
				job.endDay.date	 = assignment.FinishDate;
				job.persisted = true;
				
				
				jobs.addItem(job);
			}
			dispatcher.dispatchEvent(new JobAssignmentEvent(JobAssignmentEvent.JOBS_LOADED));
		}
		
	}
}