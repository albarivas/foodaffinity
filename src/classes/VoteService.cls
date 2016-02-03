/*
 * Developed by @Alba_ARivas
 */
public with sharing class VoteService
{
	public static Map<String, RestaurantVote> getVotesByRestaurantExternalIdForCurrentUser(List<Restaurant__x> restaurants)
	{
		Map<String, RestaurantVote> votesByRestaurantExternalId = new Map<String, RestaurantVote>();

		Id userId = UserInfo.getUserId();

		List<String> restaurantExternalIds = new List<String>();
		for (Restaurant__x restaurant : restaurants)
			restaurantExternalIds.add(restaurant.ExternalId);

		List<Vote__c> votes = VoteMapper.getByRestaurantExternalIdsAndUserId(restaurantExternalIds, userId);

		for (String restaurantExternalId : restaurantExternalIds)
		{
			Vote__c vote = new Vote__c();
			vote.User__c = userId;
			vote.Restaurant__c = restaurantExternalId;
			vote.Value__c = -1;
			votesByRestaurantExternalId.put(restaurantExternalId, new RestaurantVote(vote));
		}

		for (Vote__c vote : votes)
		{
			votesByRestaurantExternalId.put(vote.Restaurant__c, new RestaurantVote(vote));
		}

		return votesByRestaurantExternalId;
	}
}