/*
 * Developed by @Alba_ARivas
 */
public class GooglePlacesConnection extends DataSource.Connection
{
	public GooglePlacesConnection(DataSource.ConnectionParams connectionParams){}

	public override List<DataSource.Table> sync()
	{
		List<Datasource.Table> tables = new List<Datasource.Table>();
		List<Datasource.Column> columns = new List<Datasource.Column>();

		columns.add(DataSource.Column.text('ExternalId', 255));
		columns.add(DataSource.Column.url('DisplayUrl'));
		columns.add(DataSource.Column.text('Name', 255));
		columns.add(DataSource.Column.text('Location', 255));
		columns.add(DataSource.Column.text('Icon', 255));
		columns.add(DataSource.Column.text('Types', 255));
		columns.add(DataSource.Column.number('Latitude',10,8));
		columns.add(DataSource.Column.number('Longitude',10,8));
		columns.add(DataSource.Column.number('Rating',2,1));
		columns.add(DataSource.Column.url('Photo'));
		columns.add(DataSource.Column.text('MapsUrl', 255));
		columns.add(DataSource.Column.text('FormattedAddress', 255));
		columns.add(DataSource.Column.text('PhoneNumber', 255));
		columns.add(DataSource.Column.text('Website', 255));
		columns.add(DataSource.Column.boolean('OpenNow'));
		columns.add(DataSource.Column.text('WeekdayText', 255));

		tables.add(DataSource.Table.get('Restaurant','Restaurant','Restaurants',
								'Restaurants from google places','Name', columns));
		return tables;
	 }

	public override List<DataSource.TableResult> search(DataSource.SearchContext c)
	{
		return DataSource.SearchUtils.searchByName(c, this);
	}

	public override DataSource.TableResult query(DataSource.QueryContext c)
	{
		List<Map<String,Object>> rows = getRows(c);
		return DataSource.TableResult.get(c,rows);
	}

	private List<Map<String,Object>> getRows(DataSource.QueryContext c)
	{
		List<Map<String,Object>> rows = new List<Map<String,Object>>();

		if (c.tableSelection.filter != null)
		{
			// Restaurant detail retrieved by ExternalId
			if (c.tableSelection.filter.columnName == 'ExternalId')
			{
				String externalId = (String) c.tableSelection.filter.columnValue;

				List<Restaurant> restaurants = GooglePlacesService.getRestaurantsByExternalIds(new List<String>{externalId});

				rows.add(getRowFromRestaurant(restaurants[0]));
			}
			else
			{
				DataSource.FilterType type = c.tableSelection.filter.type;

				// Restaurants retrieved by latitude and longitude
				if (type == DataSource.FilterType.AND_)
				{
					List <DataSource.Filter> subfilters = c.tableSelection.filter.subfilters;

					Decimal latitude;
					Decimal longitude;

					for (DataSource.Filter subfilter : subfilters)
					{
						if (subfilter.columnName == 'Latitude')
							latitude = (Decimal) subfilter.columnValue;
						if (subfilter.columnName == 'Longitude')
							longitude = (Decimal) subfilter.columnValue;
					}

					if (latitude != null && longitude != null)
					{
						List<Restaurant> restaurants =  GooglePlacesService.getRestaurantsByLocation(latitude,longitude);
						for (Restaurant restaurant : restaurants)
							rows.add(getRowFromRestaurant(restaurant));
					}
				}
				// Restaurants retrieved by different ExternalIds
				else if (type == DataSource.FilterType.OR_)
				{
					List <DataSource.Filter> subfilters = c.tableSelection.filter.subfilters;
					List<String> externalIds = new List<String>();

					for (DataSource.Filter subfilter : subfilters)
					{
						if (subfilter.columnName == 'ExternalId')
							externalIds.add((String) subfilter.columnValue);
					}

					List<Restaurant> restaurants =  GooglePlacesService.getRestaurantsByExternalIds(externalIds);
					for (Restaurant restaurant : restaurants)
						rows.add(getRowFromRestaurant(restaurant));
				}
			}
		}

		return rows;
	}

	private Map<String,Object> getRowFromRestaurant(Restaurant restaurant)
	{
		Map<String,Object> row = new Map<String,Object>();
		row.put('Name', restaurant.name);
		row.put('Location', restaurant.vicinity);
		row.put('ExternalId', restaurant.place_id);
		row.put('DisplayUrl', GooglePlacesService.getRestaurantEndpoint(restaurant.place_id));
		row.put('Icon', restaurant.icon);
		row.put('Types', String.join(restaurant.types,' - '));
		row.put('Latitude', restaurant.geometry.lat);
		row.put('Longitude', restaurant.geometry.lng);
		row.put('Rating', restaurant.rating);
		row.put('Photo',  restaurant.photos != null && restaurant.photos.size() > 0 ? GooglePlacesService.getPhotoEndpoint(restaurant.photos[0].photo_reference) : '');
		row.put('MapsUrl', restaurant.url);
		row.put('FormattedAddress', restaurant.formatted_address);
		row.put('PhoneNumber', restaurant.international_phone_number);
		row.put('Website', restaurant.website);
		row.put('OpenNow', restaurant.opening_hours != null ? restaurant.opening_hours.open_now : false);
		row.put('WeekdayText', restaurant.opening_hours != null ? String.join(restaurant.opening_hours.weekday_text,' - ') : '');
		return row;
	}
}