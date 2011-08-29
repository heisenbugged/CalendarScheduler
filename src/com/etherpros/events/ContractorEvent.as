package com.etherpros.events
{
	import com.etherpros.model.DataModelCollection;
	import com.etherpros.model.data.Contractor;
	
	import flash.events.Event;
	
	public class ContractorEvent extends Event
	{
		public static const FIND_ALL_DONE:String = 'findAllDoneContractor';
		public static const FIND_ALL:String = 'findAllContractor';
		public static const ADD_NEW:String = 'addNewContractor';
		
		public var contractors:DataModelCollection;
		public var contractor:Contractor;
		
		public function ContractorEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}