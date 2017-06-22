## App For Managing Math Plus Branches and Locations

### Dev Environment Setup

Setup puma-dev for easier management of subdomains in the development environment. https://github.com/puma/puma-dev

Once you've installed puma-dev run `cd ~/.puma-dev; ln -s /path/to/my/app mathplusacademy`. There is additional setup required for puma-dev, [please reference the docs for setup](https://github.com/puma/puma-dev). This will allow you to access the application at mathplusacademy.dev. Be sure to replace `/path/to/my/app` with the correct local path to the cloned repository.

If you run into issues launching the app or resetting the database you can run the command `pkill USER1 puma-dev`. This will sever all connections with the database and restart puma-dev.

Make sure you have postgres installed. An easy solution is https://postgresapp.com/documentation/gui-tools.html Download the app and and run!

Clone repository and run `bundle install`

To set up development environment run `rake development:setup`

After completing the above you will have access to columbus.mathplusacademy.dev and india.mathplusacademy.dev.

### Accessing Information via Rails Console

After running `rails c` you will can access company specific information via `Company.switch(company_id)`. Be sure to replace `company_id` with an actual company id (1-Columbus 2-India). This is will switch to a company schema matching the id you've provided.
