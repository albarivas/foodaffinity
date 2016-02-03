/*
 * Developed by @Alba_ARivas
 */
public with sharing class RestaurantVote
{
	public Vote__c Dto {get; set;}

	public RestaurantVote(Vote__c dto)
	{
		this.dto = dto;
	}

	public String getValue()
	{
		return (dto.Value__c == -1) ? '-' : String.valueOf(dto.Value__c);
	}

	public void setValue(String value)
	{
		dto.Value__c  = (value == '-')? -1 : Integer.valueOf(value);
	}
}