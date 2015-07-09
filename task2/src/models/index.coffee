config = include("config")
Sequelize = require("sequelize")
sequelize = new Sequelize(config.database.name, config.database.username, config.database.password,
{
  host: config.database.server
  dialect: config.database.type
  logging: if config.database.logging is true then console.log else false
})

Models = {
  Sequelize: sequelize
  user: sequelize.import __dirname + "/user"
}

sequelize.sync()

module.exports = Models