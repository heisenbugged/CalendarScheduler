package com.etherpros.events
{
	import com.etherpros.model.DataModelCollection;	
	import flash.events.Event;
	
	public class ContractorEvent extends Event
	{
		public static const FIND_ALL_DONE:String = 'findAllDoneContractor';
		public static const FIND_ALL:String = 'findAllContractor';
		
		
		public var contractors:DataModelCollection;
		
		public function ContractorEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}