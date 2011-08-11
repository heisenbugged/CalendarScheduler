package com.etherpros.events
{
	import flash.events.Event;
	
	public class NotifyEvent extends Event
	{
		public static const SHOW:String = "showNotifyEvent";
		public static const HIDE:String = "hideNotifyEvent";
		
		public var notification:String;
		public function NotifyEvent(type:String, text:String="") {
			super(type, true, false);
			notification = text;
		}
	}
}