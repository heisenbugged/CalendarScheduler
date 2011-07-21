package com.etherpros.utils
{
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.utils.ObjectUtil;
	

	
	/**
	 * COMMON UTILS CLASS CONATINS ALL COMMON FUNCTIONS/VARIABLES
	 * WHICH COULD BE USED BY DIFFERENT CLASSES OR VIEWS
	*/
	
	public class CommonUtils
	{	
		// used to send values to Event Form 
		[Bindable]
		public static var hour:int
		
		// used to send values to Event Form 
		[Bindable]
		public static var meridiem:int;
		
		// used to send values to Event Form 
		[Bindable]
		public static var mins:int;
		
		// used to send values to Event Form 
		[Bindable]
		public static var description:String;
		
		// used to send values to Event Form 
		[Bindable]
		public static var currentDate:Date;
		
		// Constructor 
		public function CommonUtils()
		{
		}
		
		/**
		 * returns day name for a particular day number in a week
		 */
		public static function getDayName(_intDayNumber:int):String
		{
			_intDayNumber++;
			switch (_intDayNumber)
			{
				case 1:
					return "Sunday";
					break;
				case 2:
					return "Monday";
					break;
				case 3:
					return "Tuesday";
					break;
				case 4:
					return "Wednesday";
					break;
				case 5:
					return "Thursday";
					break;
				case 6:
					return "Friday";
					break;
				case 7:
					return "Saturday";
					break;
				default:
					return "no day";
			}
		}
		  
		/**
		 * returns day count for a month 
		*/ 
		public static function getDaysCount(_intMonth:int, _intYear:int):int
		{
			_intMonth ++;
			switch (_intMonth)
			{
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					return 31;
					break;
				case 4:
				case 6:
				case 9:
				case 11:
					return 30;
					break;
				case 2:
					if((_intYear % 4 == 0 && _intYear % 100 != 0) || _intYear % 400 ==0)
					{
						return 29;
					}
					else
					{
						return 28;
					}
					break;
				default:
					return -1;
			}
		}
		
		public static function getArrayDays(objDate:Date,currentYear:int,currentMonth:int, intTotalDaysInMonth:int  ):Array{
			//Setting previous month days
			var objDatePrevious:Date;			
			//O for Enero month number- Validates if the previous month is december of last year
			if ( currentMonth == 0 ){
				//11 for december
				objDatePrevious= new Date(currentYear -  1 , 11, 1);
			}else{
				objDatePrevious= new Date(currentYear , currentMonth - 1 , 1);
			}
			var todalDayPreviousMonth:int = CommonUtils.getDaysCount(objDatePrevious.month, objDatePrevious.fullYear);
			
			
			var arrDays:Array = new Array();
			var i:int;
			var previousDate:Date;
			for(i=0; i<objDate.getDay(); i++)
			{				
				previousDate =  new Date(objDatePrevious.fullYear , objDatePrevious.month , todalDayPreviousMonth);
				var strDayName:String = CommonUtils.getDayName(todalDayPreviousMonth);
				arrDays.push({dayNumber:todalDayPreviousMonth, dayName:strDayName, isPrevious:true,date:previousDate});
				todalDayPreviousMonth--;
			}
			arrDays.reverse();
			
			// now loop through total number of days in this month and save values in array
			for(i=0; i<intTotalDaysInMonth; i++)
			{
				var objDate1:Date = new Date(currentYear, currentMonth, i+1);
				var strStartDayName:String = CommonUtils.getDayName(objDate1.getDay());
				arrDays.push({dayNumber:i+1, dayName:strStartDayName, isPrevious:false,date:objDate1});
			}
			
			// if first day of the month is Friday and it is not a leap year then we need to show 7 rows
			// there could be max 42 items in a calendar grid for a month with 6 rows
			// so add blank values in case still some cells are pending as per count of 7 cols x 6 rows = 42
			if(objDate.getDay() >= 5 && arrDays.length <= 32)
			{
				for(i=arrDays.length; i<42; i++)
				{
					arrDays.push({dayNumber:-1, dayName:"None"});
				}
			}
			else
			{
				for(i=arrDays.length; i<35; i++)
				{
					arrDays.push({dayNumber:-1, dayName:"None"});
				}
			}
			return arrDays;
		}
		
		public static function getMonthName( monthNumber:int ):String{
			var monthNameList:Array = new Array();
			monthNameList = new Array();
			monthNameList[0] = "January";
			monthNameList[1] = "February";
			monthNameList[2] = "March";
			monthNameList[3] = "April";
			monthNameList[4] = "May";
			monthNameList[5] = "June";
			monthNameList[6] = "July";
			monthNameList[7] = "August";
			monthNameList[8] = "September";
			monthNameList[9] = "October";
			monthNameList[10] = "November";
			monthNameList[11] = "December";
			return monthNameList[monthNumber] as String;
		}
	}
}