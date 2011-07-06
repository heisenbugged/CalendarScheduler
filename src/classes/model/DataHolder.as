package classes.model
{
	import classes.events.CustomEvents;
	
	import flash.events.EventDispatcher;
	
	/**
	 * DataHolder class represent all data which needs to be stored 
	 * or needs to be used by any of the classes.
	 * It also dispatches events on adding a new event from any of the views.
	 * It is a singletone class so only single instance will be created through out the application cycle.
	*/
	public class DataHolder extends EventDispatcher 
	{
		import flash.events.EventDispatcher;
		
		public static var objDataHolder:DataHolder;
		
		private var m_arrEvents:Array; 
		
		public function DataHolder()
		{
			m_arrEvents = new Array();
		}
		
		// return class instance and if it is not created then create it first and the return.
		public static function getInstance():DataHolder
		{
			if(objDataHolder == null)
			{
				objDataHolder = new DataHolder;
			}
			
			return objDataHolder;
		}
		
		// will add any event. used by day view and week view to do so.
		public function addEvent(_obj:Object):void
		{
			m_arrEvents.push(_obj);
			updateViews();
		}
		
		// dispatch event to main.mxml to update views as per new event added
		private function updateViews():void
		{
			dispatchEvent(new CustomEvents(CustomEvents.ADD_NEW_EVENT));
		}
		
		// currently not being used but could be used when we need to add a functionality of removing an event
		public function removeEventAt(index:int):void
		{
			m_arrEvents.splice(index, 1);
		}
		
		// set and get dataprovider, which store all event related data
		public function set dataProvider(_arrEvents:Array):void
		{
			m_arrEvents = _arrEvents;
		}
		
		public function get dataProvider():Array
		{
			return m_arrEvents;
		}
	}
}