package com.etherpros.events
{
	import flash.events.Event;
	
	public class ClientEvent extends Event
	{
		public static const FIND_ALL:String = 'findAll';
		public static const FIND_ALL_DONE:String = 'findAllDone';
		public function ClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}