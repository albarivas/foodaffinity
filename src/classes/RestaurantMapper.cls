/*
 * Developed by @Alba_ARivas
 */
public with sharing class RestaurantMapper
{
	public static Restaurant__x getById(Id restaurantId)
	{
		return [SELECT Name__c, Location__c, Types__c, Photo__c, ExternalId, Rating__c, MapsUrl__c, FormattedAddress__c, PhoneNumber__c, Website__c, OpenNow__c, WeekdayText__c FROM Restaurant__x WHERE Id = :restaurantId];
	}

	public static List<Restaurant__x> getByExternalIds(List<String> restaurantExternalIds)
	{
		return [SELECT Id, Name__c, Location__c, Types__c, Photo__c, ExternalId, Rating__c, MapsUrl__c, FormattedAddress__c, PhoneNumber__c, Website__c, OpenNow__c, WeekdayText__c FROM Restaurant__x WHERE ExternalId IN :restaurantExternalIds];
	}

	public static List<Restaurant__x> getByLocation(Decimal latitude, Decimal longitude)
	{
		return [SELECT Id, Name__c, Location__c, Types__c, Photo__c, ExternalId, Rating__c, MapsUrl__c, FormattedAddress__c, PhoneNumber__c, Website__c, OpenNow__c, WeekdayText__c FROM Restaurant__x WHERE Latitude__c = :latitude AND Longitude__c = :longitude];
	}
}