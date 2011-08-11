package com.etherpros.business.loaders
{
	import flash.events.EventDispatcher;
	
	import mx.formatters.DateFormatter;

	public class BaseDAO extends EventDispatcher
	{
		public static var SERVER:String = "http://174.3.224.247/";
		// default database is production.
		public static var DATABASE:String = "CSISched";		
		public function BaseDAO()
		{
		}
		
		public static function format(date:Date, str_dateFormat:String = "MM/DD/YYYY"):String
		{
			var f:DateFormatter = new DateFormatter();
			f.formatString = str_dateFormat;
			return f.format(date);
		}
	}
}