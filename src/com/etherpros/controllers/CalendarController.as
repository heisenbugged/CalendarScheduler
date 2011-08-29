package com.etherpros.controllers
{
	import com.asfusion.mate.events.Dispatcher;
	import com.asfusion.mate.events.Listener;
	import com.etherpros.components.*;
	import com.etherpros.components.popups.EditContractorPopup;
	import com.etherpros.components.popups.EditCustomerPopup;
	import com.etherpros.components.popups.EditProjectPopup;
	import com.etherpros.components.popups.JobAssignmentPopup;
	import com.etherpros.events.*;
	import com.etherpros.model.*;
	import com.etherpros.model.data.*;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.*;
	import mx.events.CloseEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.PopUpManager;
	
	import org.flexunit.internals.matchers.Each;
	
	import spark.components.Group;
	import spark.components.TitleWindow;
	import spark.events.IndexChangeEvent;

	public class CalendarController
	{
		public static var JOB_HEIGHT:int = 15;
		public static var DAY_WIDTH:int;
		public static var DAY_HEIGHT:int;
		public static var CALENDAR_WIDTH:int;
		public static var CALENDAR_HEIGHT:int;
		public static const JOB_VERTICAL_PADDING:int = 5;	
				
		public var xOffset:int;
		public var yOffset:int;
		
		private var jobAssignmentPopup:JobAssignmentPopup = new JobAssignmentPopup();
		private var editCustomerPopup:EditCustomerPopup = new EditCustomerPopup();
		private var editContractorPopup:EditContractorPopup = new EditContractorPopup();
		private var editProjectPopup:EditProjectPopup = new EditProjectPopup();
		// View associated to this controller.
		private var _container:CalendarForm;
		// day range being viewed on the calendar.
		private var _dayRange:DayRange;
		
		[Bindable] private var _contractors:DataModelCollection;			
		[Bindable] private var _clients:DataModelCollection;		
		[Bindable] private var _rigs:DataModelCollection;		
		[Bindable] private var _projects:DataModelCollection;
		[Bindable] private var _jobs:DataModelCollection;
		
		// list of job views.
		private var _jobViews:ArrayCollection;

		public var selectedClient:Client;
		public var selectedProject:Project;
				
		public function CalendarController(container:CalendarForm = null) {
			this.container = container;			
			jobViews = new ArrayCollection();
		}
		
		private function createViewEventListeners():void {
			container.addEventListener(JobCreationEvent.ADD_NEW_JOB, createJob);
			container.clientsList.addEventListener(IndexChangeEvent.CHANGE, selectedClientChanged);
			container.projectsList.addEventListener(IndexChangeEvent.CHANGE, selectedProjectChanged);
		}
		
		/**
		 * Updates active project list based on client selected.
		 */ 		
		public function updateProjectList():void {
			if(selectedClient) {
				container.projectsList.dataProvider = getProjectsByClient(selectedClient.ClientID);
				container.projectsList.selectedIndex = 0;
				
				// If the project list is greater than zero and since the first
				// item on the list is selected, set the selectedProject variable to
				// the newly selected project.
				if(container.projectsList.dataProvider.length > 0) {
					selectedProject = container.projectsList.selectedItem;
				}
				
			}
		}
		
		private function selectedClientChanged(event:Event = null):void {			
			selectedClient = container.clientsList.selectedItem;
			// update projects list since clients have changed.
			updateProjectList();
			
			// simulate selected project changed event.
			// when a client list has changed, the entire project list
			// displayed changes and the first element is selected,
			// so a new project is ALWAYS selected.
			selectedProjectChanged();
		}
		
		private function selectedProjectChanged(event:Event = null):void {
			// if there are any projects.
			if(container.projectsList.dataProvider.length > 0) {
				selectedProject = container.projectsList.selectedItem;
				
				// load new jobs for project from the database!
				loadProjectJobs();				
			} else {
				selectedProject = null;
			}
		}
		
		/**
		 * Loads Jobs based on selectedProject and selected dayRange
		 */
		public function loadProjectJobs():void {			
			new Dispatcher().dispatchEvent(new NotifyEvent(NotifyEvent.SHOW, "Loading assignments."));	
			
			// only load jobs if there is a selected project.
			if(selectedProject) {				
				var jobAssignmentEvent:JobAssignmentEvent = new JobAssignmentEvent( JobAssignmentEvent.FIND_BY_PROJECT );			
				jobAssignmentEvent.startDate = this.dayRange.startDay.date;
				jobAssignmentEvent.endDate = this.dayRange.endDay.date;
				jobAssignmentEvent.project = selectedProject;
				
				container.mateDispatcher.dispatchEvent(jobAssignmentEvent);
			}
		}		
				
		public function jobsLoaded():void {
			new Dispatcher().dispatchEvent(new NotifyEvent(NotifyEvent.HIDE));
			refresh();
		}
				
		public static function setCalendarDimensions(width:int, height:int):void {
			CALENDAR_WIDTH = width;
			DAY_WIDTH = CALENDAR_WIDTH/7; //7 columns, one per day of week.
			
			CALENDAR_HEIGHT = height;
			DAY_HEIGHT = CALENDAR_HEIGHT/6; //6 weeks in datagrid.
		}

		/**
		 * Draws an existing Job and positions it on the stage.
		 */
		public function drawJobView(model:Job = null):void {			
			var view:JobView = addJobView(model);
			// find the difference in days between the start day and end day.
			var dayLength:int = ( (model.endDay.date.getTime() - model.startDay.date.getTime()) / Day.MILISECONDS) + 1;			
			// if job starts outside of the viewable range
			if(view.leftInRange == false) {
				// cut off the difference from the start day and the viewable range start day				
				dayLength += (model.startDay.date.getTime() - dayRange.startDay.date.getTime()) / Day.MILISECONDS;
			}
			
			// if job finishes outside of viewable range
			if(view.rightInRange == false) {
				// cut off the difference from the end day and the viewable range end day
				dayLength += (dayRange.endDay.date.getTime() - model.endDay.date.getTime() ) / Day.MILISECONDS;
			}
			
			view.paint(dayLength);
		}
		
		/** 
		 * Creates a new job, traditionally done on drag and drop to the calendar. 
		 */
		public function createJob(event:JobCreationEvent):void {
			// if dragging into a valid week
			if(event.weekDay && event.weekDay.dayNumber != -1) {
				var model:Job = new Job();
				model.contractor = event.contractorJob;
				model.startDay = event.weekDay;
				
				PopUpManager.addPopUp(jobAssignmentPopup, _container, true);
				jobAssignmentPopup.jobModel = model;
				jobAssignmentPopup.init();
				jobAssignmentPopup.addEventListener(CloseEvent.CLOSE, onCloseJobAssignment);
				PopUpManager.centerPopUp(jobAssignmentPopup);
				
			}			
		}
		
		private function onCloseJobAssignment(event:CloseEvent):void{
			var assignment:JobAssignmentPopup = event.currentTarget as JobAssignmentPopup;
			PopUpManager.removePopUp(assignment);
			if ( assignment.isValid ){
				assignment.jobModel.project = this._container.projectsList.selectedItem as Project;
				assignment.jobModel.rig	= assignment.selectedRig;
				assignment.jobModel.client	= this._container.clientsList.selectedItem as Client;
				jobs.addItem(assignment.jobModel);
				addJobView(assignment.jobModel);				
			}
		}
		
		/** 
		 * Creates a new job view, positions it and adds it to the stage.
		 */
		public function addJobView(model:Job):JobView {
			var view:JobView = new JobView(model, DAY_WIDTH, JOB_HEIGHT);
			
			// get row and column positions of the start and end day of this job.
			var startPos:Point = dayRange.getDateRowAndColumn(model.startDay.date);
			var endPos:Point = dayRange.getDateRowAndColumn(model.endDay.date);
			
			// if the start day of this job is outside the viewable date range.
			if(startPos == null) {				
				// disable dragging from left side since the
				// true corner of the job extends past the
				// viewable range.
				view.leftDraggable = false;
				view.leftInRange = false;
				
				// since the left hand side is out of range
				// set the starting row,column position to be 0.
				startPos = new Point();
			}
			
			if(endPos == null) {
				// disable dragging from right side since the
				// true corner of the job extends past the
				// viewable range.				
				view.rightDraggable = false;
				view.rightInRange = false;
			}
			
			// set positioning.
			view.x = xOffset;
			view.y = yOffset;
			view.pos = startPos;
			positionJobView(startPos, view);
			
			// add to containers
			_container.calendarContainer.addElement(view);
			jobViews.addItem(view);
			
			// add event listeners
			view.addEventListener(JobEvent.JOB_RESIZED, jobResized, false, 0, true);
			view.addEventListener(JobEvent.ADD_JOB_SPRITE, addJobRow, false, 0, true);
			view.addEventListener(JobEvent.HIGHLIGHT, jobHighlighted, false, 0, true);
			view.addEventListener(JobEvent.UNHIGHLIGHT, jobUnhighlighted, false, 0, true);
						
			return view;			
		}

		private function jobUnhighlighted(event:JobEvent):void {
			for each(var view:JobView in jobViews) {
				if(view != event.view) {
					view.unfade();
				}
			}
		}
		
		private function jobHighlighted(event:JobEvent):void {
			for each(var view:JobView in jobViews) {
				if(view != event.view) {
					view.fade();
				}
			}
		}
		
		/** 
		 * Converts a row/column point into X and Y coordinates
		 * on the calendar. 
		 */
		private function positionJobView(pos:Point, job:JobView):void {
			// if the position is null, use 0,0 instead.
			if(pos == null) {
				pos = new Point();
			}
			
			var x:int = ( pos.x * DAY_WIDTH );
			var y:int = ( pos.y * DAY_HEIGHT) + ( (JOB_HEIGHT + JOB_VERTICAL_PADDING) * getYPosition(job.model.startDay) + 1) + 15;
			job.position(x, y);
		}
		
		/**
		 * Simply clears view and repaints it.
		 */ 
		public function refresh():void {
			// clear all old job views since week range was changed.
			clearJobViews();
			
			// re draw jobs based on new day range
			draw();			
		}
		
		
		/**
		 * Removes all JobViews from their stage and destroyes
		 * their respective listeners.
		 */
		public function clearJobViews():void {			
			for each(var jobView:JobView in jobViews) {									
				//jobModels.push(jobView.model);
				
				// clear out view elements from stage
				jobView.destroy();
				jobView.removeEventListener(JobEvent.JOB_RESIZED, jobResized);
				jobView.removeEventListener(JobEvent.ADD_JOB_SPRITE, addJobRow);
				
				_container.calendarContainer.removeElement(jobView);				
			}
			
			// clear out job views array
			jobViews = new ArrayCollection();
		}
		
		/** 
		 * Draws all jobs based on the current dayRange 
		 */
		public function draw():void {
			
			var jobs:ArrayCollection = getJobsInRange( selectedProjectJobs );
			for each(var job:Job in jobs) {
				drawJobView(job);
			}
		}
		
		/** 
		 * Gets all job models that enter the active dayRange. 
		 */
		public function getJobsInRange(jobs:ArrayCollection = null):ArrayCollection {
			// if jobs list is null, use global jobs list
			if(!jobs) {
				jobs = this.jobs;
			}
			
			var jobsInRange:ArrayCollection = new ArrayCollection();
			for each(var job:Job in jobs) {
				var jobStart:Number = job.startDay.date.getTime();
				var jobEnd:Number = job.endDay.date.getTime();
				
				var rangeStart:Number = dayRange.startDay.date.getTime();
				var rangeEnd:Number = dayRange.endDay.date.getTime();
				// if the job fits inside the current date range, add it to the active jobs array.
				if(jobStart <= rangeEnd && jobEnd >= rangeStart) {
					jobsInRange.addItem(job);
				}
			}
			return jobsInRange;
		}
		
		/** 
		 * Recalculates start and end day variables of a Job based on the new size 
		 */
		private function jobResized(event:JobEvent):void {
			// since drag has finished, must re-compute start and end day range
			// based on new width positions.			
			var sprite:JobSprite = event.view.firstRow;
			var startDay:Day = getDayByColumnAndRow(getColumnIndex(sprite.x), getRowIndex(sprite.y));
			sprite = event.view.lastRow;
			// -2 to shave off a few pixels of borders and padding
			var endDay:Day = getDayByColumnAndRow(getColumnIndex(sprite.x+sprite.width-2), getRowIndex(sprite.y));
			
			// set the right startDay and endDay to the view.
			if(event.view.leftDraggable) {
				event.model.startDay = startDay;
			}
			
			if(event.view.rightDraggable) {
				event.model.endDay = endDay;
			}
		}
		
		
		// NOTE: Encapsulation problem. The function below shouldn't actually
		// create the sprite on the view, that should be handled internally
		// by the view component itself. All this function should do
		// is POSITION the new row since the positioning of the row
		// is dependant on the positioning of other elements on the calendar.
		
		/** 
		 * Adds a new sprite row to the corresponding job container
		 * and positions the row with proper stacking. 
		 */
		public function addJobRow(jobEvent:JobEvent):void {
			var view:JobView = jobEvent.view;
			var JOB_HEIGHT:Number = 15;
			
			var weekIndex:int = view.rowIndex + jobEvent.view.numRows;
			// week that row will be added to.
			var nextWeek:Week = dayRange.weeks[weekIndex] as Week;
			// instantiate an empty sprite row
			var row:UIComponent = view.createEmptySprite();			
			
			
			// if the row being added is not past the 6 week calendar limit.
			if ( nextWeek != null ) {				
				var nextDay:Day  = nextWeek.getDayByIndex(0);					
				row.y = ( weekIndex * DAY_HEIGHT  )  + ( (JOB_HEIGHT+JOB_VERTICAL_PADDING) * getYPosition(nextDay, jobEvent.model) + 1 ) + 15;				
			}
			
		}
		
		/** 
		 * Determines how many JobViews have been added in a particular day 
		 * When a job is passed in, it is excluded from any position calculations.
		 */		
		private function getYPosition( day:Day, job:Job=null):int {
			var dayPosition:Point = dayRange.getDateRowAndColumn(day.date);
			// if position is outside viewable range
			// use 0, 0
			if(dayPosition == null) {
				dayPosition = new Point();
			}
			
			var dayTime:Number = day.date.getTime();			
			var jobCounter:int = 0;
			
			for each(var view:JobView in jobViews) {
				if(view.model != job) {
					// get the time range of the job we're checking.
					var startTime:Number = view.model.startDay.date.getTime();
					var endTime:Number = view.model.endDay.date.getTime();
					
					// if our date falls within the job of the job being checked
					if(startTime <= dayTime && endTime >= dayTime) {
					// add one to the number of jobs present inside this date.
						jobCounter++;
						
					// if the date is part of the same week as this job, then
					// we also add one to the stacking.					
					} else if(dayPosition.y == view.rowIndex || dayPosition.y == view.endRow) {
						jobCounter++;
					}
				}
			}
			
			return jobCounter;
		}
		
		public function showEditCustomer():void{
			PopUpManager.addPopUp(editCustomerPopup, _container, true);			
			editCustomerPopup.addEventListener(CloseEvent.CLOSE, onCloseEditCustomer);
			PopUpManager.centerPopUp(editCustomerPopup);
		}
		
		private function onCloseEditCustomer(event:CloseEvent):void{
			var editCustomer:EditCustomerPopup = event.currentTarget as EditCustomerPopup;
			PopUpManager.removePopUp(editCustomer);
		}
		
		public function showEditContractor():void{
			PopUpManager.addPopUp(editContractorPopup, _container, true);			
			editContractorPopup.addEventListener(CloseEvent.CLOSE, onCloseEditContractor);
			PopUpManager.centerPopUp(editContractorPopup);
		}
		
		private function onCloseEditContractor(event:CloseEvent):void{
			var editEditContractorPopup:EditContractorPopup = event.currentTarget as EditContractorPopup;
			PopUpManager.removePopUp(editEditContractorPopup);
		}
		
		public function showEditProject():void{
			PopUpManager.addPopUp(editProjectPopup, _container, true);
			editProjectPopup.init(this.selectedClient);
			editProjectPopup.addEventListener(CloseEvent.CLOSE, onCloseEditProject);
			PopUpManager.centerPopUp(editProjectPopup);
		}
		
		private function onCloseEditProject(event:CloseEvent):void{
			var editProjectPopup:EditProjectPopup = event.currentTarget as EditProjectPopup;
			PopUpManager.removePopUp(editProjectPopup);
		}
		
		private function getDayByColumnAndRow(column:int, row:int):Day {
			var week:Week = dayRange.weeks[row];
			return week.getDayByIndex(column);
		}
		
		private function getRowIndex(y:int):int {
			return Math.floor(y/CalendarController.DAY_HEIGHT);
		}
		
		private function getColumnIndex(x:int):int {
			return Math.floor(x/CalendarController.DAY_WIDTH);
		}		
		
		public function setOffset(x:int, y:int):void {
			xOffset = x;
			yOffset = y;
		}
		
		
		public function getProjectsByClient( clientId:String ):ArrayCollection{
			var projectsByClient:ArrayCollection = new ArrayCollection;
			for each(var project:Project in projects  ){
				if ( project.ClientID == clientId ){
					projectsByClient.addItem( project );					
				}
			}
			return projectsByClient;
		}		
		
		// -------------------
		// Getters and Setters
		// -------------------
		public function get selectedProjectJobs():ArrayCollection {			
			var jobs:ArrayCollection = new ArrayCollection();
			for each(var job:Job in this.jobs) {
				if(job.project.ProjectID == selectedProject.ProjectID) {
					jobs.addItem(job);
				}
			}
			
			return jobs;
		}
		
		[Bindable]
		public function set jobs(value:DataModelCollection):void {
			_jobs = value;	
		}
		
		public function get jobs():DataModelCollection {
			return _jobs;
		}
		
		[Bindable]
		public function set contractors(value:DataModelCollection):void {
			_contractors = value;
		}
		
		public function get contractors():DataModelCollection { 
			return _contractors;
		}
		
		[Bindable]
		public function get clients():DataModelCollection { 
			return _clients; 
		}
		
		public function set clients(value:DataModelCollection):void {				
			_clients = value;
			
			// set view data provider.
			container.clientsList.dataProvider = this._clients;
			container.clientsList.selectedIndex = 0;
			selectedClient = container.clientsList.selectedItem;
			
			// only update project list if projects exist.
			if(projects && projects.length > 0) {
				updateProjectList();
			}
		}
		
		
		[Bindable]
		public function get rigs():DataModelCollection {
			return _rigs;
		}
		
		public function set rigs(value:DataModelCollection):void {
			_rigs = value;
		}
		
		[Bindable]
		public function get projects():DataModelCollection {
			return _projects;
		}
		
		public function set projects(value:DataModelCollection):void {
			_projects = value;
			container.projectsList.selectedIndex = 0;
			
			// only update project list if clients exist
			if(clients && clients.length > 0) {
				updateProjectList();
			}
		}
		
		
		public function set container(container:CalendarForm):void {
			_container = container;
			
			// view event listeners
			if(container) {
				createViewEventListeners();				
			}			
		}
		
		public function get container():CalendarForm {
			return _container;
		}
		
		public function set dayRange(value:DayRange):void {
			_dayRange = value;
			// refresh view since range has changed.
			refresh();
		}
		
		public function get dayRange():DayRange {
			return _dayRange;
		}
		
		public function get jobViews():ArrayCollection {
			return _jobViews;
		}
		
		public function set jobViews(value:ArrayCollection):void {
			_jobViews = value;
		}
		
	}
}