package com.etherpros.events
{
	import com.etherpros.model.DataModelCollection;
	import com.etherpros.model.data.Client;
	
	import flash.events.Event;
	
	
	public class ClientEvent extends Event
	{
		public static const FIND_ALL:String = 'findAll';
		public static const FIND_ALL_DONE:String = 'findAllDone';
		public static const ADD_NEW:String = 'addNew';
		
		public var client:Client;
		
		public var clients:DataModelCollection;
		
		public function ClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}