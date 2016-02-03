/*
 * Developed by @Alba_ARivas
 */
public with sharing class VoteMapper
{
	public static List<Vote__c> getByRestaurantExternalIdsAndUserId(List<String> restaurantExternalIds, Id userId)
	{
		return [SELECT Id, Value__c, Restaurant__c FROM Vote__c WHERE User__c =: userId AND Restaurant__c IN : restaurantExternalIds];
	}

	public static List<Vote__c> getByUserIdOrderedByRestaurant(Id userId)
	{
		return [SELECT Restaurant__c, Value__c, User__c FROM Vote__c WHERE User__c = :userId ORDER BY Restaurant__c];
	}

	public static List<Vote__c> getByRestaurantExternalIdsAndDifferentFromUserId(List<String> restaurantExternalIds, Id userId)
	{
		return [SELECT Restaurant__c, Value__c, User__c FROM Vote__c WHERE Restaurant__c IN :restaurantExternalIds AND User__c != :userId AND User__r.IsActive = true ORDER BY Restaurant__c];
	}

	public static List<Vote__c> getByUserIdAndExternalIdsOrderedByValue(Id userId, Set<String> restaurantExternalIds)
	{
		return [SELECT Restaurant__c, Value__c FROM Vote__c WHERE User__c = :userId AND Restaurant__c IN :restaurantExternalIds ORDER BY Value__c DESC];
	}
}