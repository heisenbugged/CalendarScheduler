package com.etherpros.business.loaders
{
	import com.asfusion.mate.events.Dispatcher;
	import com.etherpros.events.ContractorEvent;
	import com.etherpros.model.DataModelCollection;
	import com.etherpros.model.data.Contractor;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;

	public class ContractorDAO extends BaseDAO
	{
		public static var LAYOUT:String = "Contractors";
		public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT;	
		
		public static var CDN_URL:String =  "";
		private var contractors:DataModelCollection = new DataModelCollection();
		private var isLoaded:Boolean = false;		
		private var dispatcher:IEventDispatcher;
		
		public function ContractorDAO(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		public function findAll():void{
			var urlRequest:URLRequest = new URLRequest( URL +"&-findall" );
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,loadedContractors);
		}
		
		public function addNewContractor( contractor:Contractor ):void{
			var strURL:String = URL + "&FirstName=" + contractor.FirstName + "&LastName="+contractor.LastName+"&Title="+contractor.Title
				+ "&Tel="+ contractor.Tel + "&Email="+contractor.Email + "&Fax="+contractor.Fax + "&Cell="+contractor.Fax 
				+ "&Password=" + contractor.Password + "&-new";
			var urlRequest:URLRequest = new URLRequest( strURL );
			var urlLoader:URLLoader = new URLLoader( urlRequest );
			urlLoader.addEventListener( Event.COMPLETE,loadedContractors );
		}
		
		private function loadedContractors(event:Event):void {			
			var contractor:Contractor;
			var xml:XML = new XML(event.target.data);			
			if (xml.namespace("") != undefined) { default xml namespace = xml.namespace(""); }			

			for each(var result:XML in xml.resultset.record) {
				contractor = new Contractor();
				for each(var field:XML in result.field) {
					if(field.@name == "ContractorID") {
						contractor.ContractorID = field.data.toString();
					}
					if(field.@name == "FirstName") {
						contractor.FirstName = field.data.toString();
					}
					if(field.@name == "LastName") {
						contractor.LastName = field.data.toString();
					}
				}								
				contractors.addItem(contractor);				
			}
			isLoaded = true;
			checkIfFullyLoaded();
			default xml namespace = new Namespace("");		
		}
		
		private function checkIfFullyLoaded():void {
			if(isLoaded) {
				var contractorEvent:ContractorEvent = new ContractorEvent(ContractorEvent.FIND_ALL_DONE);
				contractorEvent.contractors = contractors;
				dispatcher.dispatchEvent(contractorEvent);
			}
		}
	}
}