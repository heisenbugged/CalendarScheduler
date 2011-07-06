package classes.model
{
	public class WeekDay
	{
		private var _dayNumber:int = -1;
		private var _dayName:String = "";
		
		public function WeekDay()
		{
		}
		

		public function get dayName():String
		{
			return _dayName;
		}

		public function set dayName(value:String):void
		{
			_dayName = value;
		}

		public function get dayNumber():int
		{
			return _dayNumber;
		}

		public function set dayNumber(value:int):void
		{
			_dayNumber = value;
		}

	}
}