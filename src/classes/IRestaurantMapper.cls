/*
 * Developed by @Alba_ARivas
 */
public interface IRestaurantMapper
{
	Restaurant__x getById(Id restaurantId);
	List<Restaurant__x> getByExternalIds(List<String> restaurantExternalIds);
	List<Restaurant__x> getByLocation(Decimal latitude, Decimal longitude);
}