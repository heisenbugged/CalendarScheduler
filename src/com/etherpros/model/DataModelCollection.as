package com.etherpros.model {
	import mx.collections.ArrayCollection;
	
	public class DataModelCollection extends ArrayCollection {
		public var ids:Array = [];
		
		override public function addItem(item:Object):void {
			if(item is IDataModel) {
				var model:IDataModel = item as IDataModel;
				
				if(ids[model.uniqueID] == undefined || !model.persisted) {
					super.addItem(item);
					ids[model.uniqueID] = model;
				} 			
			}
		}
		
		public function getByID(id:String):IDataModel {
			return ids[id];	
		}
		
	}
}