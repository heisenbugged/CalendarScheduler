package com.etherpros.business.loaders
{
	import com.etherpros.events.ProjectEvent;
	import com.etherpros.model.DataModelCollection;
	import com.etherpros.model.data.Project;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;

	public class ProjectDAO extends BaseDAO
	{
		public static var LAYOUT:String = "Projects";
		public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT;
		private var projects:DataModelCollection = new DataModelCollection()
		private var isLoaded:Boolean = false;
		[Bindable]
		private var dispatcher:IEventDispatcher;
		
		public function ProjectDAO(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		public function findAll():void{
			var urlRequest:URLRequest = new URLRequest( URL + "&-findall" );
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,projectsLoaded);
		}
		
		public function addNewProject( project:Project ):void{
			var strURL:String = URL + "&ProjName=" + project.ProjName + "&ClientID=" + project.ClientID 
				+ "&ClientName="+project.ClientName	+ "&-new";
			var urlRequest:URLRequest = new URLRequest( strURL );
			var urlLoader:URLLoader = new URLLoader( urlRequest );
			urlLoader.addEventListener( Event.COMPLETE, projectsLoaded );
		}
		
		private function projectsLoaded(event:Event):void{						
			var xml:XML = new XML(event.target.data);			
			if (xml.namespace("") != undefined) { default xml namespace = xml.namespace(""); }
			
			for each(var result:XML in xml.resultset.record) {
				var project:Project = new Project();
				for each(var field:XML in result.field) {
					if(field.@name == "ProjectID") {
						project.ProjectID = field.data.toString();
					}
					if(field.@name == "ProjName") {
						project.ProjName = field.data.toString();
					}
					if(field.@name == "ClientID") {
						project.ClientID = field.data.toString();
					}
					if(field.@name == "ProjStatus") {
						project.ProjStatus = field.data.toString();
					}
					if(field.@name == "ClientName") {
						project.ClientName = field.data.toString();
					}
				}
				projects.addItem(project);				
			}
			isLoaded = true;
			checkIfFullyLoaded();
			default xml namespace = new Namespace("");
		}
		
		private function XML2Object(result:XML):Project{
			var project:Project = new Project();
			for each(var field:XML in result.field) {
				if(field.@name == "ProjectID") {
					project.ProjectID = field.data.toString();
				}
				if(field.@name == "ProjName") {
					project.ProjName = field.data.toString();
				}
				if(field.@name == "ClientID") {
					project.ClientID = field.data.toString();
				}
				if(field.@name == "ProjStatus") {
					project.ProjStatus = field.data.toString();
				}
				if(field.@name == "ClientName") {
					project.ClientName = field.data.toString();
				}
			}
			return project;
		}
		
		private function checkIfFullyLoaded():void {
			if(isLoaded) {
				var projectEvent:ProjectEvent = new ProjectEvent( ProjectEvent.FIND_ALL_DONE, true );
				projectEvent.projects = projects;
				dispatcher.dispatchEvent(projectEvent);
			}
		}		
	}
}