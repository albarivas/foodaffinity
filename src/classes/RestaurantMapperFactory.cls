/*
 * Developed by @Alba_ARivas
 */
public with sharing class RestaurantMapperFactory
{
	public static IRestaurantMapper instance;

	public static IRestaurantMapper getInstance()
	{
		if (instance == null)
		{
			if (Test.isRunningTest())
				instance = (IRestaurantMapper) new RestaurantMapperMockImpl();
			else
				instance = (IRestaurantMapper) new RestaurantMapper();
		}
		
		return instance;
	}
}