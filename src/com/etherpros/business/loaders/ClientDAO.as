package com.etherpros.business.loaders
{
	import com.etherpros.events.ClientEvent;
	import com.etherpros.model.Client;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;

	public class ClientDAO extends BaseDAO
	{
		public static var LAYOUT:String = "Clients";
		public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT+"&-findall";
		[Bindable]
		public  var clients:ArrayCollection;
		private var _clientList:ArrayCollection;
		
		private var isLoaded:Boolean = false;		
		private var dispatcher:IEventDispatcher;
		
		public function ClientDAO( dispatcher:IEventDispatcher )
		{
			this.dispatcher = dispatcher;
		}
		
		public function findAll():void{
			var urlRequest:URLRequest = new URLRequest(URL);
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,clientsLoaded);
		}
		
		private function clientsLoaded(event:Event):void{
			this._clientList  = new ArrayCollection();			
			var xml:XML = new XML(event.target.data);			
			if (xml.namespace("") != undefined) { default xml namespace = xml.namespace(""); }
			
			for each(var result:XML in xml.resultset.record) {
				var client:Client = new Client();
				for each(var field:XML in result.field) {
					if(field.@name == "ClientID") {
						client.ClientID = field.data.toString();
					}
					if(field.@name == "ClientName") {
						client.ClientName = field.data.toString();
					}
				}
				this._clientList.addItem(client);
			}
			isLoaded = true;
			checkIfFullyLoaded();
			default xml namespace = new Namespace("");
		}
		
		private function checkIfFullyLoaded():void {
			if(isLoaded) {

				var clientEvent:ClientEvent = new ClientEvent(ClientEvent.FIND_ALL_DONE,true);
				clientEvent.clients = _clientList;				
				dispatcher.dispatchEvent(clientEvent);
				
			}
		}	
	}
}