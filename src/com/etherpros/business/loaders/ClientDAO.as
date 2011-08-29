package com.etherpros.business.loaders
{
	import com.etherpros.events.ClientEvent;
	import com.etherpros.model.DataModelCollection;
	import com.etherpros.model.data.Client;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;

	public class ClientDAO extends BaseDAO
	{
		public static var LAYOUT:String = "Clients";
		public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT;
	
		private var clients:DataModelCollection = new DataModelCollection();		
		private var isLoaded:Boolean = false;		
		private var dispatcher:IEventDispatcher;
		
		public function ClientDAO( dispatcher:IEventDispatcher )
		{
			this.dispatcher = dispatcher;
		}
		
		public function findAll():void{
			var urlRequest:URLRequest = new URLRequest( URL  + "&-findall" );
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,clientsLoaded);
		}
		
		public function addNewClient( client:Client ):void{
			var strURL:String = URL + "&ClientName=" + client.ClientName + "&-new";
			var urlRequest:URLRequest = new URLRequest( strURL );
			var urlLoader:URLLoader = new URLLoader( urlRequest );
			urlLoader.addEventListener( Event.COMPLETE,clientsLoaded );
		}
		
		private function clientsLoaded(event:Event):void{
						
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
				clients.addItem(client);
			}
			isLoaded = true;
			checkIfFullyLoaded();
			default xml namespace = new Namespace("");
		}
		
		private function checkIfFullyLoaded():void {
			if(isLoaded) {
				var clientEvent:ClientEvent = new ClientEvent(ClientEvent.FIND_ALL_DONE,true);
				clientEvent.clients = clients;
				dispatcher.dispatchEvent(clientEvent);
				
			}
		}	
	}
}