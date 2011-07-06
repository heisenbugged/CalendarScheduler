package com.components
{
	import classes.model.WeekDay;
	
	import mx.controls.Label;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	public class WeekDayRender extends UIComponent implements IDropInListItemRenderer, 
		IListItemRenderer, IDataRenderer
	{
		private var weekDay:WeekDay;
		public function WeekDayRender()
		{
			super();
		}
		
		private var displayLabel:Label;
		
		private var _listData:BaseListData;
		
		public function get listData():BaseListData
		{
			return _listData;
		}
		
		public function set listData(value:BaseListData):void
		{
			_listData = value;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			displayLabel = new Label();
			this.addChild(displayLabel);
		}
		
		override protected function measure():void
		{
			super.measure();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
		}
				
		
		[Bindable("dataChange")]
		public function get data():Object
		{
			return weekDay;
		}
		
		public function set data(value:Object):void
		{
			if ( value != null ){
				weekDay = value as WeekDay;
				displayLabel.text = weekDay.dayNumber.toString();
			}
		}
		

	}
}