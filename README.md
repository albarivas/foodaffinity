# foodaffinity
This is a sample application which leverages lightning connect capabilities in Salesforce for creating a site in which users are able to vote / ask for recommendations of nearby restaurants read from Google Places API

HOW TO SETUP THE APPLICATION

1- Follow these steps to download and install the Force.com Migration Tool:

- Log in to a Salesforce organization on your deployment machine.
- From Setup, enter Tools in the Quick Find box, then select Tools, and then click Force.com Migration Tool.
- Save the ZIP file locally and extract the contents to the directory of your choice.

2- Copy the content of the git repo src folder to the codepkg folder. You must end having something like:

- salesforce_ant_35.0/sample/codepkg/srcfoldercontent

3- Update build.properties with your org username / password. The security token may be needed following the password.

4- Open a cmd on salesforce_ant_35.0/sample and execute ant deployCode target

5- Copy your Google API developer key to GooglePlacesService class

6- Go to your org and give access to the admin profile to:

- foodaffinity application
- restaurants tab
- restaurant object FLS (all fields visible)
- vote object FLS (all fields visible)

At this point we have a visualforce page accesible for the admin user through Restaurants tab. If you only want to take a look at the code and the visualforce page, you can stop here. If you want to expose the application to the outside, in order users can self-register, continue to step 6 for creating a Community.

7- Let’s expose the application to the outside and let users self-register through a Community:

- Go to setup —> Communities and enable communities choosing a domain name.
- Create a new community, choose the napili template (or any template) and name it “FoodAffinity”.
- Set your community home page to restaurantlist visualforce page (Community Management —> Administration -> Pages)
- Enable “Authenticated Website Custom 2” profile for be used in the community (Community Management —> Administration -> Members)
- Let’s allow users to self-register:
	- First let’s configure an account to which self-registering users will be assigned. Account owner must have a role: choose an account you own, and assign yourself any role in the role hierarchy.
	- Go to Community Management —> Administration -> Login & Registration and enable “Allow external users to self-register”:
		- Choose “Authenticated Website Custom 2” as default profile.
		- Choose the account whose owner role you setup before as default account.

- Activate your community.(Community Management —> Administration -> Settings)

Bear in mind that self-registered users should use a different email address each!


