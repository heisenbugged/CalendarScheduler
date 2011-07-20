package com.etherpros.events
{
	import com.etherpros.components.RigView;
	import com.etherpros.model.Rig;
	
	import flash.events.Event;
	
	public class RigEvent extends Event
	{
		public var view:RigView;
		public var model:Rig;
		
		public static const RIG_RESIZED:String = 'rigResizedEvent';	
		
		public function RigEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}