package com.etherpros.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class RigEvent extends Event
	{
		public static const FIND_ALL_DONE:String = 'findAllDoneRig';
		public static const FIND_ALL:String = 'findAllRig';
		
		public var rigs:ArrayCollection;
		
		public function RigEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}