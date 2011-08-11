package com.etherpros.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class ClientEvent extends Event
	{
		public static const FIND_ALL:String = 'findAll';
		public static const FIND_ALL_DONE:String = 'findAllDone';
		
		public var clients:ArrayCollection;
		
		public function ClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}