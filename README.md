## App For Managing Math Plus Branches and Locations

Setup puma-dev for easier management of subdomains in the development environment. https://github.com/puma/puma-dev

Once you've installed puma-dev run `cd ~/.puma-dev; ln -s /path/to/my/app mathplusacademy`. This will allow you to access the application at mathplusacademy.dev. Be sure to replace `/path/to/my/app` with the correct local path to the cloned repository.

If you run into issues lanching the app or resetting the database you can run the command `pkill USER1 puma-dev`. This will sever all connections with the database and restart puma-dev.

Make sure you have postgres installed. An easy solution is https://postgresapp.com/documentation/gui-tools.html Download the app and and run!

Clone repository and run `bundle install`

To set up development environment run `rake development:setup`

Then to see second instance of a company run `rake new:company`

After completing the above commands you will have access to columbus.mathplusacademy.dev and india.mathplusacademy.dev.s
