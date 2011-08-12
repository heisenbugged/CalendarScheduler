package com.etherpros.model
{
	public interface IDataModel
	{
		function get uniqueID():String;
		
		/**
		 * Determines whether model exists in database or not.
		 */
		function get persisted():Boolean;
		function set persisted(value:Boolean):void;
	}
}