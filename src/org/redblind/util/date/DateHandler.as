package org.redblind.util.date
{
	public class DateHandler
	{
		/**
		 * Determines if four digit year is a leap year.
		 **/
		public function isLeapYear(year:Number):Boolean {
			return (year%4==0) ? (year%100==0) ? (year%400==0) ? true : false : true : false;
		}
		
		/**
		 * Converts a string (mm/dd/yyyy) to Date object.
		 **/
		public function toDate(dateStr:String):Date {  
			var dateArray:Array = dateArray = dateStr.split("/");  
			return new Date(dateArray[2],dateArray[0]-1,dateArray[1]);  
		}
		
		/**
		 * Takes birthdate and calculates age.
		 **/
		public function getAge(bDate:Date):int {  
			var cDate:Date = new Date();
			var cMonth:int = cDate.getMonth();  
			var cDay:int = cDate.getDate();  
			var cYear:int = cDate.getFullYear();  
		  
			var bMonth:int = bDate.getMonth();  
			var bDay:int = bDate.getDate();  
			var bYear:int = bDate.getFullYear();  
		   
			var ageYrs:int = cYear-bYear;
			
			if (cDay<bMonth || (cMonth==bMonth && cDay<bDay)){ 
				ageYrs--;  
			}  
			return ageYrs;  
		}  
	}
}