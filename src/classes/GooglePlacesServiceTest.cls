@isTest
public class GooglePlacesServiceTest
{
	@isTest
	static void getRestaurantsByExternalIds_shouldReturnDeserializedRestaurant()
	{
		// Given
		Restaurant myRestaurant = new Restaurant();
		myRestaurant.international_phone_number = '+34 555555555';
		myRestaurant.name = 'My Favourite Restaurant A';
		myRestaurant.place_id = 'A';
		myRestaurant.url = 'https://maps.google.com/?cid=10281119596374313554';
		myRestaurant.vicinity = 'My Favourite Street';
		myRestaurant.website = 'https://myfavouriterestaurant.com';

		GoogleResponse myResponse = new GoogleResponse();
		myResponse.result = myRestaurant;

		String endpointURL = GooglePlacesService.getRestaurantEndpoint(myRestaurant.place_id);
		String body = JSON.serialize(myResponse);

		HttpCalloutMockImpl calloutMockImpl = new HttpCalloutMockImpl();
		calloutMockImpl.addResponse(endpointURL, body);
		Test.setMock(HttpCalloutMock.class, calloutMockImpl);

		List<String> externalIds = new List<String>{myRestaurant.place_id};

		// When
		List<Restaurant> restaurants = GooglePlacesService.getRestaurantsByExternalIds(externalIds);

		// Then
		System.assertEquals(1, restaurants.size());
		System.assertEquals(myRestaurant.international_phone_number, restaurants[0].international_phone_number);
		System.assertEquals(myRestaurant.name, restaurants[0].name);
		System.assertEquals(myRestaurant.place_id, restaurants[0].place_id);
		System.assertEquals(myRestaurant.url, restaurants[0].url);
		System.assertEquals(myRestaurant.vicinity, restaurants[0].vicinity);
		System.assertEquals(myRestaurant.website, restaurants[0].website);
	}
}