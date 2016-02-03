/*
 * Developed by @Alba_ARivas
 */
public with sharing class Restaurant
{
	public Location geometry;
	public String icon;
	public String id;
	public String name;
	public OpeningHours opening_hours;
	public List<Photo> photos;
	public String place_id;
	public String reference;
	public String scope;
	public List<String> types;
	public String vicinity;
	public Decimal rating;
	public String url;
	public String formatted_address;
	public String international_phone_number;
	public String website;

	public class Location
	{
		public Double lat;
		public Double lng;
	}

	public class Photo
	{
		public Integer height;
		public List<String> html_attributions;
		public String photo_reference;
		public Integer width;
	}

	public class OpeningHours
	{
		public Boolean open_now;
		public List<String> weekday_text;
	}
}