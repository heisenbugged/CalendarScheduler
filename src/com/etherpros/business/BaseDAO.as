package com.etherpros.business
{
	import flash.events.EventDispatcher;

	public class BaseDAO extends EventDispatcher
	{
		public static var SERVER:String = "http://174.3.224.247/";
		// default database is production.
		public static var DATABASE:String = "CSISched";		
		public function BaseDAO()
		{
		}
	}
}