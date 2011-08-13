package com.etherpros.model
{
	import com.etherpros.model.data.DataModel;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/** 
	 * Simple extension of the URLLoader class that carries
	 * a reference ot an IDataModel variable. 
	 */	
	public class URLDataModelLoader extends URLLoader
	{
		public var model:DataModel;
		public function URLDataModelLoader(request:URLRequest=null)
		{
			super(request);
		}
	}
}