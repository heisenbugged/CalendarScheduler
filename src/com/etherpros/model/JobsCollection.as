package com.etherpros.model
{
	import mx.collections.ArrayCollection;
	
	public class JobsCollection extends ArrayCollection {
		public var ids:Array = [];
		
		override public function addItem(item:Object):void {			
			if(item is Job) {
				var job:Job = item as Job;
				
				// if the job with this ID doesn't exist yet
				// in our collection
				if(ids[job.AssignmentID] != true) {
					super.addItem(item);
					ids[job.AssignmentID] = true;
				}			
			}			
		}		
	}
}