/*
 * Developed by @Alba_ARivas
 */
public with sharing class RestaurantMapperMockImpl implements IRestaurantMapper
{
	public Restaurant__x getById(Id restaurantId)
	{
		Restaurant__x restaurant = new Restaurant__x();
		restaurant.Name__c = 'My favourite restaurant';
		return restaurant;
	}

	public List<Restaurant__x> getByExternalIds(List<String> restaurantExternalIds)
	{
		List<Restaurant__x> restaurants = new List<Restaurant__x>();
		for (String restaurantExternalId : restaurantExternalIds)
		{
			Restaurant__x restaurant = new Restaurant__x();
			restaurant.ExternalId = restaurantExternalId;
			restaurant.Name__c = 'My favourite restaurant ' + restaurantExternalId;
			restaurants.add(restaurant);
		}

		return restaurants;
	}

	public List<Restaurant__x> getByLocation(Decimal latitude, Decimal longitude)
	{
		List<Restaurant__x> restaurants = new List<Restaurant__x>();
		for (Integer i=0; i<10; i++)
		{
			Restaurant__x restaurant = new Restaurant__x();
			restaurant.Name__c = 'My favourite restaurant ' + i;
			restaurants.add(restaurant);
		}

		return restaurants;
	}
}