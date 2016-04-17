/*
 * Developed by @Alba_ARivas
 */
public with sharing class RestaurantService
{
	public static final Boolean useCallouts = true;

	public static List<Restaurant__x> getByDistance(Decimal latitude, Decimal longitude)
	{
		List<Restaurant__x> restaurants;

		Datetime startTime = System.now();
		if (useCallouts)
			restaurants = RestaurantCalloutService.getByLocation(latitude, longitude);
		else
			restaurants = RestaurantMapperFactory.getInstance().getByLocation(latitude, longitude);
		Datetime endTime = System.now();

		Decimal duration = endTime.getTime() - startTime.getTime();

		System.debug(LoggingLevel.ERROR, 'Time (useCallouts = '+ useCallouts + '): ' +  duration);

		return restaurants;
	}

	public static List<Restaurant__x> orderByPopularity(List<Restaurant__x> restaurants)
	{
		Map<String, Restaurant__x> restaurantsByExternalId = new Map<String, Restaurant__x>();
		for (Restaurant__x restaurant : restaurants)
			restaurantsByExternalId.put(restaurant.ExternalId, restaurant);

		restaurants = new List<Restaurant__x>();
		for (String externalId : restaurantsByExternalId.keySet())
		{
			Restaurant__x compareRestaurant = restaurantsByExternalId.get(externalId);
			Decimal compareRating = compareRestaurant.Rating__c;

			Boolean added = false;
			for (Integer i=0; i<restaurants.size(); i++)
			{
				Restaurant__x highestRatingRestaurant = restaurantsByExternalId.get(restaurants[i].ExternalId);
				Decimal highestRating = highestRatingRestaurant.Rating__c;
				if (compareRating > highestRating)
				{
					added = true;
					restaurants.add(i, compareRestaurant);
					break;
				}
			}

			if (!added)
				restaurants.add(compareRestaurant);
		}

		return restaurants;
	}

	public static List<Restaurant__x> orderByAffinity(List<Restaurant__x> restaurants)
	{
		Id userId = UserInfo.getUserId();

		// Create map with user votes for nearby restaurants
		List<Vote__c> userVotes = VoteMapper.getByUserIdOrderedByRestaurant(userId);
		Map<String, Vote__c> userVotesByRestaurantExternalId = new Map<String, Vote__c>();
		for (Vote__c userVote : userVotes)
			userVotesByRestaurantExternalId.put(userVote.Restaurant__c, userVote);

		// Retrieve votes from other users to those restaurants
		List<Vote__c> othersVotes = VoteMapper.getByRestaurantExternalIdsAndDifferentFromUserId(new List<String>(userVotesByRestaurantExternalId.keySet()), userId);

		// Calculate affinity with other users in the system
		Map<Id,Integer> affinityByUserId = getAffinityByUserId(userVotesByRestaurantExternalId, othersVotes);

		// Get user Ids ordered by affinity
		List<Id> userIdsOrderedByAffinity = getUserIdsOrderedByAffinity(affinityByUserId);

		// Create map with nearby restaurants
		Map<String, Restaurant__x> restaurantsByExternalId = new Map<String, Restaurant__x>();
		for (Restaurant__x restaurant : restaurants)
			restaurantsByExternalId.put(restaurant.ExternalId, restaurant);

		// Order nearby restaurants by the rating the max affinity user has given to them
		List<Restaurant__x> sortedRestaurants = getSortedRestaurantsByMaxAffinityUserVotes(restaurantsByExternalId, userIdsOrderedByAffinity);

		return sortedRestaurants;
	}

	private static Map<Id,Integer> getAffinityByUserId(Map<String, Vote__c> userVotesByRestaurantExternalId, List<Vote__c> othersVotes)
	{
		Map<Id,Integer> affinityByUserId = new Map<Id,Integer>();
		for (Vote__c othersVote : othersVotes)
		{
			Vote__c userVote = userVotesByRestaurantExternalId.get(othersVote.Restaurant__c);

			Decimal userRating = userVote.Value__c;
			Decimal othersRating = othersVote.Value__c;
			Id otherUserId = othersVote.User__c;

			Integer affinityToAdd;

			if (othersRating == userRating)
				affinityToAdd = 3;
			else if (userRating - 1 > othersRating && othersRating < userRating + 1)
				affinityToAdd = 1;

			if (affinityToAdd != null)
			{
				if (!affinityByUserId.containsKey(otherUserId))
					affinityByUserId.put(otherUserId, 0);
				affinityByUserId.put(otherUserId, affinityByUserId.get(otherUserId) + affinityToAdd);
			}
		}

		return affinityByUserId;
	}

	private static List<Id> getUserIdsOrderedByAffinity(Map<Id,Integer> affinityByUserId)
	{
		List<Id> userIdsOrderedByAffinity = new List<Id>();
		for (Id affinityUserId : affinityByUserId.keySet())
		{
			Integer affinity = affinityByUserId.get(affinityUserId);
			Boolean added = false;
			for (Integer i=0; i<userIdsOrderedByAffinity.size(); i++)
			{
				Id compareUserId = userIdsOrderedByAffinity.get(i);

				Integer compareAffinity = affinityByUserId.get(compareUserId);
				if (affinity > compareAffinity)
				{
					userIdsOrderedByAffinity.add(i,affinityUserId);
					added = true;
					break;
				}
			}

			if (!added)
				userIdsOrderedByAffinity.add(affinityUserId);
		}

		return userIdsOrderedByAffinity;
	}

	private static List<Restaurant__x> getSortedRestaurantsByMaxAffinityUserVotes(Map<String, Restaurant__x> restaurantsByExternalId, List<Id> userIdsOrderedByAffinity)
	{
		// Retrieve votes to nearby restaurants from max affinity user. If empty, try next user.
		List<Vote__c> maxAffinityVotes = new List<Vote__c>();
		Integer i = 0;
		while (maxAffinityVotes.isEmpty() && i < userIdsOrderedByAffinity.size())
		{
			Id maxAffinityUserId = userIdsOrderedByAffinity.get(i);
			maxAffinityVotes = VoteMapper.getByUserIdAndExternalIdsOrderedByValue(maxAffinityUserId, restaurantsByExternalId.keySet());
			i++;
		}

		// Order nearby restaurants by max affinity user preferences
		List<Restaurant__x> sortedRestaurants = new List<Restaurant__x>();
		for (Vote__c maxAffinityVote : maxAffinityVotes)
		{
			if (restaurantsByExternalId.containsKey(maxAffinityVote.Restaurant__c))
				sortedRestaurants.add(restaurantsByExternalId.get(maxAffinityVote.Restaurant__c));
		}

		return sortedRestaurants;
	}
}