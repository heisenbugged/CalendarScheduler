package classes.views
{
	import classes.events.CustomEvents;
	import classes.model.DataHolder;
	import classes.utils.CommonUtils;
	
	import flash.events.MouseEvent;
	
	import mx.containers.ApplicationControlBar;
	import mx.containers.Canvas;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.TextArea;
	import mx.utils.ObjectUtil;
	
	import mxml_views.monthCell;
	
	
	/**
	 * THIS CLASS WILL ALLOW TO GENERATE A GRID OF CURRENT MONTH
	 * 
	 * THIS CLASS USES monthCell TO REPRESENT A SINGLE DAY.
	 * 
	 * ADDITIONALLY IT CONNECTS WITH DATA HOLDER AND CHECK FOR EVENT EXISTENSE FOR A PARTICULAR
	 * DATE AND GENERATE THE VIEW ACCORDINGLY.  
	 * 
	 * THIS CLASS IS EXTENDED TO CANVAS SO IT COULD BE USED A DISPLAY OBJECT IN MXML FILES AS WELL.
	*/
	
	public class MonthView extends Canvas
	{
		
		private var m_intCurrentMonth:int;
		private var m_intCurrentYear:int;
		
		private var m_monthViewGrid:Grid;
		private var m_appBar:ApplicationControlBar
		private var m_lblDaysNames:Label;
		
		public function MonthView()
		{
			super();			
			createIntialChildren();
		}
		
		// function responsible for generating the view
		private function createIntialChildren():void
		{
			// add a new grid
			m_monthViewGrid = new Grid();
			m_monthViewGrid.styleName = "grdMonthView";
			m_monthViewGrid.y = 25;
			
			// add application bar which will show days name on the top of the view
			m_appBar = new ApplicationControlBar();
			m_appBar.width = 800;
			m_appBar.height = 22;
			m_appBar.styleName = "appBarDayCell";
			
			m_lblDaysNames = new Label();
			m_lblDaysNames.width = 775;
			m_lblDaysNames.height = 16;
			m_lblDaysNames.styleName = "lblDaysNames";
			m_lblDaysNames.text = "        Sunday                        Monday                       Tuesday                   Wednesday                    Thursday                      Friday                        Saturday";
			
			this.addChild(m_appBar);
			m_appBar.addChild(m_lblDaysNames);
			this.addChild(m_monthViewGrid);
			
		}
				
		override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		// create grid of days in current month as per current date provided
		private function createDaysGrid():void
		{
			// always assume that first day of a month will have date as 1
			// currentMonth and currentYear are supplied by main.mxml file		
			var objDate:Date = new Date(currentYear, currentMonth, 1);
			
			// get total days count for currentMonth in currentYear
			var intTotalDaysInMonth:int = CommonUtils.getDaysCount(currentMonth, currentYear);
			var i:int;
			
			/**
			 * Add Total number of Grid items in a Array 
			 * 
			**/
			
			// add empty items in case first day is not Sunday
			// i.e. MonthView always shows 7 coloumns starting from Sunday and ending to Saturday
			// so if it suppose Wednesday is the date 1 of this month that means we need to
			// add 3 empty cells at start
			var arrDays:Array = new Array();
			for(i=0; i<objDate.getDay(); i++)
			{
				arrDays.push(-1);
			}
			
			// now loop through total number of days in this month and save values in array
			for(i=0; i<intTotalDaysInMonth; i++)
			{
				var objDate1:Date = new Date(currentYear, currentMonth, i);
				var strStartDayName:String = CommonUtils.getDayName(objDate1.getDay());
				arrDays.push({data:i+1, label:strStartDayName});
			}
			
			// if first day of the month is Friday and it is not a leap year then we need to show 7 rows
			// there could be max 42 items in a calendar grid for a month with 6 rows
			// so add blank values in case still some cells are pending as per count of 7 cols x 6 rows = 42
			if(objDate.getDay() >= 5 && arrDays.length <= 32)
			{
				for(i=arrDays.length; i<42; i++)
				{
					arrDays.push(-1);
				}
			}
			else
			{
				for(i=arrDays.length; i<35; i++)
				{
					arrDays.push(-1);
				}
			}
			
			m_monthViewGrid.removeAllChildren();
			
			var objGridRow:GridRow;
			
			
			// once array is created now loop through the array and generate the Grid
			for(i=0; i<arrDays.length; i++)
			{
				if(i % 7 == 0)
				{
					objGridRow = new GridRow();
					m_monthViewGrid.addChild(objGridRow);
				}
				
				var objGridItem:GridItem = new GridItem();
				var objDayCell:Label = new Label();
				objDayCell.width = 115;
				objDayCell.height = 112;
				objGridItem.addChild(objDayCell);
				objGridRow.addChild(objGridItem);
				
				
				//objDayCell.visible = false;
						
				if(arrDays[i] == -1)
				{
					objDayCell.visible = false;
				}
				else
				{
					objDayCell.text = arrDays[i].data;
					objDayCell.addEventListener(MouseEvent.CLICK, onDayCellClick);
					objDayCell.data = {date: new Date(currentYear, currentMonth, arrDays[i].data) };
					
					// check if current date has some event stored in DataHolder
					// if YES then display event description
					for(var j:int=0; j<DataHolder.getInstance().dataProvider.length; j++)
					{
						var obj:Object = DataHolder.getInstance().dataProvider[j];
						if(ObjectUtil.dateCompare(obj.date, objDayCell.data.date) == 0)
						{
							objDayCell.text = obj.desc;
							objDayCell.visible = true;
							break;
						}
					}
				} 
			}
			
			
			
		}
		
		public function redraw():void
		{
			createDaysGrid();
		}
		
		// click event for a day cell
		// will change the view to Day View and set current date as per cell clicked in the Grid
		private function onDayCellClick(_event:MouseEvent):void
		{
			/*var objDayCell:monthCell
			if(_event.target.toString().indexOf("txtDesc") == -1)
			{
				objDayCell = monthCell(_event.target);
			}
			else
			{
				objDayCell = monthCell(_event.target.parent.parent);
			}
			dispatchEvent(new CustomEvents(CustomEvents.MONTH_VIEW_CLICK, objDayCell.data));*/
			Alert.show("Click");
		}
		
		/**
		 * Custom Properties
		 * 
		**/
		public function set currentMonth(_intCurrentMonth:int):void
		{
			m_intCurrentMonth = _intCurrentMonth;
		}
		
		public function get currentMonth():int
		{
			return m_intCurrentMonth;
		}
		
		public function set currentYear(_intCurrentYear:int):void
		{
			m_intCurrentYear = _intCurrentYear;
			createDaysGrid();
		}
		
		public function get currentYear():int
		{
			return m_intCurrentYear;
		}
	}
}