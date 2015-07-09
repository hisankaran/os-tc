Getting started:
---
1. Make sure Node.js and NPM installed.
2. Run `npm install` to install project dependencies.
3. Copy `config/template.json` to `config/development.json` and fill in your configuration.
4. Fill in the databse details and the schema will be auto synced.
5. Run `NODE_ENV=development grunt dev`, the API should be up and running on configured port.
6. And edit the `test/webServiceTest.coffee` to configure the api url then run `grunt test` to run the tests.

WebService Routes:
---
1. POST /user/ = User registration
    * @params   first_name [optional|empty]
    * @params   last_name [optional|empty]
    * @params   email [required]
    * @params   username [required]
    * @params   password [required]

2. POST /user/login
    * @params   username [required]
    * @params   password [required]

3. POST /user/logout [Authenticated endpoint]
    
4. GET /user/ = User information [Authenticated endpoint]

5. DELETE /user/ = User deletion [Authenticated endpoint]

Note: 
`AuthToken` will be returned on successful login. 
This token will be persisted in the Database and flushed when you call logout.
For Authenticated API Calls, you must present the `AuthToken` as a request header.

UI Routes:
---
1. /
2. /list1
3. /list2
4. /login
5. /logout