public with sharing class RestaurantCalloutService {

	public static List<Restaurant__x> getByLocation(Decimal latitude, Decimal longitude)
	{
		List<Restaurant> restaurants =  GooglePlacesService.getRestaurantsByLocation(latitude,longitude);
		List<Restaurant__x> restaurantDtos = new List<Restaurant__x>();
		for (Restaurant restaurant : restaurants)
		{
			Restaurant__x restaurantDto = new Restaurant__x();
			restaurantDto.Name__c = restaurant.name;
			restaurantDto.Location__c = restaurant.vicinity;
			restaurantDto.ExternalId = restaurant.place_id;
			restaurantDto.DisplayUrl = GooglePlacesService.getRestaurantEndpoint(restaurant.place_id);
			restaurantDto.Icon__c = restaurant.icon;
			restaurantDto.Types__c = String.join(restaurant.types,' - ');
			restaurantDto.Latitude__c = restaurant.geometry.lat;
			restaurantDto.Longitude__c = restaurant.geometry.lng;
			restaurantDto.Rating__c = restaurant.rating;
			restaurantDto.Photo__c =  restaurant.photos != null && restaurant.photos.size() > 0 ? GooglePlacesService.getPhotoEndpoint(restaurant.photos[0].photo_reference) : '';
			restaurantDto.MapsUrl__c = restaurant.url;
			restaurantDto.FormattedAddress__c = restaurant.formatted_address;
			restaurantDto.PhoneNumber__c = restaurant.international_phone_number;
			restaurantDto.Website__c = restaurant.website;
			restaurantDto.OpenNow__c = restaurant.opening_hours != null ? restaurant.opening_hours.open_now : false;
			restaurantDto.WeekdayText__c = restaurant.opening_hours != null ? String.join(restaurant.opening_hours.weekday_text,' - ') : '';
			restaurantDtos.add(restaurantDto);
		}
		return restaurantDtos;
	}
}