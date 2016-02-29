/*
 * Developed by @Alba_ARivas
 */
public with sharing class RestaurantController 
{
	private ApexPages.StandardController standardController;
	private ApexPages.StandardSetController standardSetController;
	public List<Restaurant__x> Restaurants {get; set;}
	public Map<String, RestaurantVote> VotesByRestaurantExternalId {get; set;}
	public String RestaurantVoteToUpsert {get; set;}
	public Decimal Latitude {get; set;}
	public Decimal Longitude {get; set;}

	public RestaurantController(Apexpages.StandardSetController standardSetController)
	{
		this.standardSetController = standardSetController;

		Restaurants = (List<Restaurant__x>) standardSetController.getRecords();
	}

	public RestaurantController(ApexPages.StandardController standardController)
	{
		this.standardController = standardController;

		// No high volume datasource
		//Restaurant__x restaurant = (Restaurant__x) standardController.getRecord();
		//Restaurants = new List<Restaurant__x>{RestaurantMapperFactory.getInstance().getById(restaurant.Id)};

		// High volume datasource
		String externalId = ApexPages.currentPage().getParameters().get('ExternalId');
		Restaurants = RestaurantMapperFactory.getInstance().getByExternalIds(new List<String>{externalId});

		VotesByRestaurantExternalId = VoteService.getVotesByRestaurantExternalIdForCurrentUser(Restaurants);
	}

	public PageReference getByDistance()
	{
		try
		{
			Restaurants = RestaurantService.getByDistance(Latitude, Longitude);
			VotesByRestaurantExternalId = VoteService.getVotesByRestaurantExternalIdForCurrentUser(Restaurants);
		}
		catch (Exception e)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
		}

		return null;
	}

	public PageReference orderByPopularity()
	{
		try
		{
			Restaurants = RestaurantService.orderByPopularity(Restaurants);
			VotesByRestaurantExternalId = VoteService.getVotesByRestaurantExternalIdForCurrentUser(Restaurants);
		}
		catch (Exception e)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
		}
		return null;
	}

	public PageReference orderByAffinity()
	{
		try
		{
			Restaurants = RestaurantService.orderByAffinity(Restaurants);
			VotesByRestaurantExternalId = VoteService.getVotesByRestaurantExternalIdForCurrentUser(Restaurants);
		}
		catch (Exception e)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
		}
		return null;
	}

	public PageReference vote()
	{
		try
		{
			RestaurantVote vote = VotesByRestaurantExternalId.get(RestaurantVoteToUpsert);
			if (vote.getValue() == '-')
				throw new FoodAffinityException('Invalid vote.');
			upsert vote.dto;
		}
		catch (Exception e)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
		}
		return null;
	}
}