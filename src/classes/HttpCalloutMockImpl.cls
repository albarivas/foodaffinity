@isTest
global class HttpCalloutMockImpl implements HttpCalloutMock
{
	private Map<String, String> responsesByEndpointURL = new Map<String, String>();

	public void addResponse(String endpointUrl, String response)
	{
		responsesByEndpointURL.put(endpointUrl, response);
	}

	global HTTPResponse respond(HTTPRequest req)
	{
		String endpointUrl = req.getEndpoint();

		String body = responsesByEndpointURL.get(endpointUrl);

		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(body);
		res.setStatusCode(200);

		return res;
	}
}
