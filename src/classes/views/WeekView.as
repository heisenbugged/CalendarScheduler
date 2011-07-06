package classes.views
{
	import classes.utils.CommonUtils;
	
	import mx.containers.Canvas;
	
	import mxml_views.weekCell;

	/**
	 * THIS CLASS WILL ALLOW TO GENERATE A LIST OF HOUR CELLS
	 * WHICH WILL BE FROM 00hr. TO 24hr. AND THIS LIST WILL BE GENERATED FOR 7 DAYS IN CURRENT WEEK
	 * 
	 * THIS CLASS USES hourCell TO GENERATE THE LIST. IT READ CURRENT DATE TO GENERATE
	 * THE VIEW FOR THAT PARTICULAR WEEK.
	 * 
	 * ADDITIONALLY IT CONNECTS WITH DATA HOLDER AND CHECK FOR EVENT EXISTENSE FOR A PARTICULAR
	 * DATE AND GENERATE THE VIEW ACCORDINGLY.  
	 * 
	 * THIS CLASS IS EXTENDED TO CANVAS SO IT COULD BE USED A DISPLAY OBJECT IN MXML FILES AS WELL.
	*/

	public class WeekView extends Canvas
	{
		private var m_objLastGeneratedDate:Date;
		private var m_intTotalDays:int = 6;		
		private var m_currentDate:Date;
		
				
		public function WeekView()
		{
			super();
		}
		
		private function createIntialChildren():void
		{
			var intStartDate:int;
			var intEndDate:int;
			var dt:Date = m_currentDate;
			var dtStart:Date;
			
			if(m_objLastGeneratedDate != dt && currentDate != null)
			{
				m_objLastGeneratedDate = dt;
				
				// calculate start date of the current week
				dt.setDate(dt.getDate() - dt.getDay());
				intStartDate = dt.date;
				dtStart = new Date(dt.getFullYear(), dt.month, dt.date);
				
				
				
				// calculate end date of the current week
				dt.setDate(dt.getDate() + (m_intTotalDays - dt.getDay()));
				intEndDate = dt.date;
								
				
				// now generate view as per week dates
				this.removeAllChildren();
				
				var objHourContainer:Canvas = new Canvas();
				objHourContainer.horizontalScrollPolicy = "off";
				objHourContainer.verticalScrollPolicy = "off";
				this.addChild(objHourContainer);
				objHourContainer.y = 22;
				
				// create left stip which is blue colored strip
				CommonUtils.createLeftHourStrip(objHourContainer);
				
				var objWeekCellContainer:Canvas = new Canvas();				
				this.addChild(objWeekCellContainer);
				objWeekCellContainer.x = objHourContainer.getChildAt(0).width;
				objWeekCellContainer.width = 720;
				objWeekCellContainer.verticalScrollPolicy = "off";
				objWeekCellContainer.horizontalScrollPolicy = "off";
				
				// generate hour strip for seven daya i.e. number of days in a week
				for(var i:int=0; i<=m_intTotalDays; i++)
				{	
					var objWeekCell:weekCell = new weekCell();				
					objWeekCellContainer.addChild(objWeekCell);
					objWeekCell.x = objWeekCell.width * i;
					objWeekCell.lblDate.text = String(dtStart.date) + "    " + CommonUtils.getDayName(dtStart.day).substr(0, 3);
					
					// generate hour strip from common functions
					CommonUtils.createRightHourStrip(objWeekCell.canDayView, dtStart);
					dtStart.date = dtStart.date + 1;
				}
			}
			
		}
				
		override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		// set current date for week view and thereafter generate the view on the basis of this date
		public function set currentDate(_currentDate:Date):void
		{
			m_currentDate = new Date(_currentDate.getFullYear(), _currentDate.month, _currentDate.date);
			createIntialChildren();
		}
		
		public function get currentDate():Date
		{
			return m_currentDate;
		}
		
	}
}