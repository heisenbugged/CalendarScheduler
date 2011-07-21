package com.etherpros.events
{
	import com.etherpros.components.RigView;
	import com.etherpros.model.Rig;
	
	import flash.events.Event;
	
	public class RigEvent extends Event
	{
		public var view:RigView;
		public var model:Rig;
		//Used when re-drawing a rig
		public var rigTotalWidth:Number;
		public var isRedraw:Boolean = false;
		
		public static const RIG_RESIZED:String = 'rigResizedEvent';
		
		public static const ADD_RIG_SPRITE:String = 'addRigSprite';	
		
		public function RigEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}