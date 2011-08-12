package com.etherpros.events
{
	import com.etherpros.model.DataModelCollection;	
	import flash.events.Event;
	
	
	public class RigEvent extends Event
	{
		public static const FIND_ALL_DONE:String = 'findAllDoneRig';
		public static const FIND_ALL:String = 'findAllRig';
		
		public var rigs:DataModelCollection;
		
		public function RigEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}