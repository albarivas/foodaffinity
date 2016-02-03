/*
 * Developed by @Alba_ARivas
 */
public with sharing class GooglePlacesService
{
	private static final String GOOGLE_API_KEY = 'ENTER_YOUR_API_KEY';

	public static String getRestaurantEndpoint(String externalId)
	{
		String endpointURL = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=' + externalId + '&key=' + GOOGLE_API_KEY;
		return endpointURL;
	}

	public static String getPhotoEndpoint(String photoReference)
	{
		String endpointURL = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=' + photoReference + '&key=' + GOOGLE_API_KEY;
		return endpointURL;
	}

	public static List<Restaurant> getRestaurantsByLocation(Decimal latitude, Decimal longitude)
	{
		String endpointURL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' + latitude + ',' + longitude + '&radius=1000&types=restaurant&rankBy=distance&key=' + GOOGLE_API_KEY;

		String response = HttpConnection.doGet(endpointURL);

		GoogleResponse deserializedResponse = (GoogleResponse) JSON.deserialize(response, GoogleResponse.class);
		List<Restaurant> restaurants = deserializedResponse.results;

		calculateOverallRatings(restaurants);

		return restaurants;
	}

	public static List<Restaurant> getRestaurantsByExternalIds(List<String> externalIds)
	{
		List<Restaurant> restaurants = new List<Restaurant>();

		for (String externalId : externalIds)
		{
			String endpointURL = getRestaurantEndpoint(externalId);

			String response = HttpConnection.doGet(endpointURL);

			GoogleResponse deserializedResponse = (GoogleResponse) JSON.deserialize(response, GoogleResponse.class);

			Restaurant restaurant = deserializedResponse.result;
			restaurants.add(restaurant);
		}

		calculateOverallRatings(restaurants);

		return restaurants;
	}

	private static void calculateOverallRatings(List<Restaurant> restaurants)
	{
		List<String> externalIds = new List<String>();
		for (Restaurant restaurant : restaurants)
			externalIds.add(restaurant.place_id);

		Map<String,Decimal> overallRatingByRestaurantExternalId = new Map<String,Decimal>();
		AggregateResult[] groupedResults = [SELECT Restaurant__c, AVG(Value__c)aver FROM Vote__c WHERE Restaurant__c IN :externalIds GROUP BY Restaurant__c];

		for (AggregateResult ar : groupedResults)
			overallRatingByRestaurantExternalId.put((String)ar.get('Restaurant__c'), (Decimal)ar.get('aver'));

		for (Restaurant restaurant : restaurants)
			restaurant.rating = overallRatingByRestaurantExternalId.get(restaurant.place_id);
	}
}