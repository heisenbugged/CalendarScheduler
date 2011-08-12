package com.etherpros.business {
	import com.etherpros.events.JobAssignmentEvent;
	import com.etherpros.model.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	

	[Bindable]
	public class DataManager extends EventDispatcher {
		private var dispatcher:IEventDispatcher;
		
		public var clients:DataModelCollection;
		public var projects:DataModelCollection;
		public var rigs:DataModelCollection;
		public var contractors:DataModelCollection;
		public var jobs:DataModelCollection = new DataModelCollection();
		
		public function DataManager(dispatcher:IEventDispatcher) {
			this.dispatcher = dispatcher;		
		}
		
		public function loadClients(clients:DataModelCollection):void {
			this.clients = clients;
		}
		
		public function loadProjects(projects:DataModelCollection):void {
			this.projects = projects;
		}
		
		public function loadRigs(rigs:DataModelCollection):void {
			this.rigs = rigs;
		}
		
		public function loadContractors(contractors:DataModelCollection):void {
			this.contractors = contractors;
		}
		
		public function loadJobs(assignments:DataModelCollection):void {
			for each (var assignment:Assignment in assignments) {
				trace( (clients.getByID(assignment.Client_ID) as Client).ClientName);
				var job:Job = new Job();
				job.AssignmentID 	= assignment.AssignmentID;
				
				job.client = clients.getByID(assignment.Client_ID) as Client;
				job.project = projects.getByID(assignment.Project_ID) as Project;
				job.contractor = contractors.getByID(assignment.Contractor_ID) as Contractor;
				job.rig = rigs.getByID(assignment.Rig_ID) as Rig;

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