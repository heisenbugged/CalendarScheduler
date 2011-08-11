package com.etherpros.business.loaders
{
	import com.etherpros.events.RigEvent;
	import com.etherpros.model.Rig;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;

	public class RigDAO extends BaseDAO
	{
		public static var LAYOUT:String = "Rigs";
		public static var URL:String = SERVER + "fmi/xml/fmresultset.xml?-db="+DATABASE+"&-lay="+LAYOUT+"&-findall";

		public var rigs:ArrayCollection;
		private var isLoaded:Boolean = false;
		[Bindable]
		private var dispatcher:IEventDispatcher;
		
		public function RigDAO(dispatcher:IEventDispatcher)
		{
			super();
			this.dispatcher = dispatcher;
		}
		
		public function findAll():void{
			var urlRequest:URLRequest = new URLRequest(URL);
			var urlLoader:URLLoader = new URLLoader(urlRequest);
			urlLoader.addEventListener(Event.COMPLETE,rigsLoaded);
		}
		
		private function rigsLoaded(event:Event):void{
			rigs  = new ArrayCollection();			
			var xml:XML = new XML(event.target.data);			
			if (xml.namespace("") != undefined) { default xml namespace = xml.namespace(""); }
			
			for each(var result:XML in xml.resultset.record) {
				var rig:Rig = new Rig();
				for each(var field:XML in result.field) {
					if(field.@name == "RigID") {
						rig.RigID = field.data.toString();
					}
					if(field.@name == "RigName") {
						rig.RigName = field.data.toString();
					}
				}
				rigs.addItem(rig);
			}
			isLoaded = true;
			checkIfFullyLoaded();
			default xml namespace = new Namespace("");	
		}
		private function checkIfFullyLoaded():void {
			if(isLoaded) {
				var doneEvent:RigEvent = new RigEvent(RigEvent.FIND_ALL_DONE,true);
				doneEvent.rigs = rigs;
				dispatcher.dispatchEvent(doneEvent);
			}
		}	
	}
}