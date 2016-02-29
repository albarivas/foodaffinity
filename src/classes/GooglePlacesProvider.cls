/*
 * Developed by @Alba_ARivas
 */
public with sharing class GooglePlacesProvider extends DataSource.Provider
{
    public override List<DataSource.AuthenticationCapability> getAuthenticationCapabilities()
    {
        List<DataSource.AuthenticationCapability> capabilities = new List<DataSource.AuthenticationCapability>();
        capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);
        return capabilities;
    }

    public override List<DataSource.Capability> getCapabilities()
    {
        List<DataSource.Capability> capabilities = new List<DataSource.Capability>();
        capabilities.add(DataSource.Capability.ROW_QUERY);
        capabilities.add(DataSource.Capability.SEARCH);
        capabilities.add(DataSource.Capability.ROW_CREATE);

        return capabilities;
    }

    public override DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams)
    {
        return new GooglePlacesConnection(connectionParams);
    }
}