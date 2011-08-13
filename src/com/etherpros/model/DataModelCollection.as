package com.etherpros.model {
	import com.etherpros.events.DataModelEvent;
	import com.etherpros.model.data.DataModel;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class DataModelCollection extends ArrayCollection {
		public var ids:Array = [];
		
		override public function addItem(item:Object):void {
			if(item is DataModel) {
				var model:DataModel = item as DataModel;
				
				if(ids[model.uniqueID] == undefined || !model.persisted) {
					super.addItem(item);
					ids[model.uniqueID] = model;
					
					// if the model hasn't been persisted, listen to its save event.
					// once the model is saved and an ID has been assigned to it,
					// we use the SAVED event to add the id to our ids array.
					if(!model.persisted) {
						model.addEventListener(DataModelEvent.SAVED, modelSaved);
					}
				} 			
			}
		}
		
		private function modelSaved(event:Event):void {
			var model:DataModel = event.target as DataModel;
			// add id of newly saved datamodel object to ids list!
			ids[model.uniqueID] = model
			
			// remove saved event since object has already been saved
			model.removeEventListener(DataModelEvent.SAVED, modelSaved);
		}
		
		public function getByID(id:String):DataModel {
			return ids[id];	
		}
		
	}
}