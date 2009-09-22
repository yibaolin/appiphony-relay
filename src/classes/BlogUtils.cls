public with sharing class BlogUtils {

	/** Find the monthName by the month# passed in... */
	public static String monthNameByMonthNumber(Integer monthDate) {
		String monthName = 'January';

		if (monthDate == null || monthDate < 1 || monthDate > 12) {
			return monthName;
		}

		if (monthDate == 2) {
			monthName = 'February';
		} else if (monthDate == 3) {
			monthName = 'March';
		} else if (monthDate == 4) {
			monthName = 'April';
		} else if (monthDate == 5) {
			monthName = 'May';
		} else if (monthDate == 6) {
			monthName = 'June';
		} else if (monthDate == 7) {
			monthName = 'July';
		} else if (monthDate == 8) {
			monthName = 'August';
		} else if (monthDate == 9) {
			monthName = 'September';
		} else if (monthDate == 10) {
			monthName = 'October';
		} else if (monthDate == 11) {
			monthName = 'November';
		} else if (monthDate == 12) {
			monthName = 'December';
		}
		
		return monthName;
	} 
	
	
	static testmethod void testBlogUtils() {
		//Test the monthName Stuff.
		System.assert('January' == BlogUtils.monthNameByMonthNumber(1));
		System.assert('February' == BlogUtils.monthNameByMonthNumber(2));
		System.assert('March' == BlogUtils.monthNameByMonthNumber(3));
		System.assert('April' == BlogUtils.monthNameByMonthNumber(4));
		System.assert('May' == BlogUtils.monthNameByMonthNumber(5));
		System.assert('June' == BlogUtils.monthNameByMonthNumber(6));
		System.assert('July' == BlogUtils.monthNameByMonthNumber(7));
		System.assert('August' == BlogUtils.monthNameByMonthNumber(8));
		System.assert('September' == BlogUtils.monthNameByMonthNumber(9));
		System.assert('October' == BlogUtils.monthNameByMonthNumber(10));
		System.assert('November' == BlogUtils.monthNameByMonthNumber(11));
		System.assert('December' == BlogUtils.monthNameByMonthNumber(12));
		
	}
	

}