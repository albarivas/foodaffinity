/*
 * Developed by @Alba_ARivas
 */
public with sharing class HttpConnection
{
	public static String doGet(String endpointURL)
	{
		String responseContent;

		HttpRequest request = new HttpRequest();
		Http connection = new Http();

		request.setHeader('Content-Type','application/json');
		request.setHeader('Connection','keep-alive');
		request.setHeader('Content-Length','0');
		request.setTimeout(20000); 
		request.setEndpoint(endpointURL);
		request.setMethod('GET');

		try
		{
			HTTPResponse response = connection.send(request);
			responseContent = response.getBody();
			return responseContent;
		}
		catch(Exception e)
		{
			System.assert(false, 'exception ' + e);
		}

		return '';
	}
}