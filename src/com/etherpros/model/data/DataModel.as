package com.etherpros.model.data {
	import com.etherpros.events.DataModelEvent;
	
	import flash.events.EventDispatcher;

	// Runtime enforced abstract class since
	// AS3 does not have native support for abstract classes.
	public class DataModel extends EventDispatcher {
		
		private var _persisted:Boolean;
		
		public function DataModel(self:DataModel) {
			if(self != this) {
				throw new Error("DataModel is an abstract class. Please instantiate a child of it");
			}
		}
		
		public function get uniqueID():String {
			throw new Error("You must override implement the uniqueID method");
		}
		public function set uniqueID(value:String):void {
			throw new Error("You must override implement the uniqueID method");
		}
		
		/**
		 * Determines whether model exists in database or not.
		 */
		public function get persisted():Boolean {
			return _persisted;
		}
		
		public function set persisted(value:Boolean):void {
			// if value is being set to persisted.
			if(_persisted != true && value == true) {
				// send saved event.
				dispatchEvent( new DataModelEvent(DataModelEvent.SAVED) );
			}
			
			_persisted = value;
		}
		
	}
}