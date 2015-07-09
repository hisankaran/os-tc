crypto = require('crypto')

module.exports = (sequelize, DataTypes) ->

  sequelize.define "user", {
    first_name: {
      type: DataTypes.STRING(32)
      allowNull: true
    }
    last_name: {
      type: DataTypes.STRING(32)
      allowNull: true
    }
    email: {
      type: DataTypes.STRING(256)
      allowNull: false
    }
    username: {
      type: DataTypes.STRING(16)
      unique: true
      allowNull: false
    }
    password: {
      type: DataTypes.STRING(32)
      allowNull: false
      set: (value)->
        @setDataValue('password', crypto.createHash('md5').update(value).digest("hex"))
    }
    auth_token: {
      type: DataTypes.STRING(36)
      allowNull: true
    }
  }, {
    underscored: true
  }