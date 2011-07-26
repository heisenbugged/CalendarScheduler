package com.etherpros.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class ContractorEvent extends Event
	{
		public static const FIND_ALL_DONE:String = 'findAllDone';
		public static const FIND_ALL:String = 'findAll';
		public var contractorList:ArrayCollection;
		public function ContractorEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}