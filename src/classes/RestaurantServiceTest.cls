/*
 * Developed by @Alba_ARivas
 */
@isTest
public with sharing class RestaurantServiceTest
{
	@isTest
	static void getByDistance_shouldReturnRestaurantListRetrievedFromMapper()
	{
		// Given
		Decimal latitude = 1.23442354;
		Decimal longitude = -0.23236786;

		// When
		List<Restaurant__x> restaurants = RestaurantService.getByDistance(latitude, longitude);

		// Then
		System.assert(!restaurants.isEmpty());
	}
}