package com.etherpros.events
{
	import flash.events.Event;
	
	public class DataModelEvent extends Event {
		public static const SAVED:String = "dataModelSavedEvent";
		
		public function DataModelEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
	}
}