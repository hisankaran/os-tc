chai = require 'chai'
supertest = require 'supertest'
rand = require 'random-key'
app = require '../app/app'

should = chai.should()
api = supertest('http://localhost:3000')

testUser = {
  first_name: 'test'
  last_name: 'test'
  email: 'test@test.com'
  username: rand.generate()
  password: rand.generate()
}


describe 'POST /user [Create user]', ->

  it 'should return created and authentication token', (done)->
    api.post('/user')
    .send testUser
    .expect 201
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal true
      res.body.should.have.property 'data'
      res.body.data.should.have.property 'auth_token'
      done()

  it 'should return bad request on missing required parameters', (done)->
    api.post('/user')
    .send {username: testUser.name, password: testUser.password}
    .expect 400
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal false
      res.body.should.have.property 'error'
      res.body.error.should.have.property('code').and.equal 400
      done()

describe 'POST /user/login [User authentication]', ->

  it 'should return auth token on successful login', (done)->
    api.post('/user/login')
    .send {username: testUser.username, password: testUser.password}
    .expect 200
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal true
      res.body.should.have.property 'data'
      res.body.data.should.have.property 'auth_token'
      testUser.token = res.body.data.auth_token
      done()

  it 'should return bad request on invalid login', (done)->
    credentials = {username: 'test', password: 'test123'}
    api.post('/user/login').send(credentials)
    .expect 400
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal false
      res.body.should.have.property 'error'
      res.body.error.should.have.property('code').and.equal 400
      done()

describe 'POST /user/logout [User token invalidation]', ->

  it 'should invalidate the auth token', (done)->
    api.post('/user/logout').set('AuthToken', testUser.token)
    .expect 200
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal true
      done()

  it 'should return unauthorized on invalid token', (done)->
    api.post('/user/logout').set('AuthToken', testUser.token)
    .expect 401
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal false
      res.body.should.have.property 'error'
      res.body.error.should.have.property('code').and.equal 401
      # regenerate the token
      api.post('/user/login')
      .send {username: testUser.username, password: testUser.password}
      .end (err, res)->
        testUser.token = res.body.data.auth_token
        done()

describe 'GET /user [Fetch user info]', ->

  it 'should return user info on passing correct token', (done)->
    api.get('/user/info').set('AuthToken', testUser.token)
    .expect 200
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal true
      res.body.should.have.property 'data'
      res.body.data.should.have.property 'id'
      res.body.data.should.have.property('username').and.equal testUser.username
      done()

  it 'should return unauthorized on incorrect token', (done)->
    api.get('/user/info').set('AuthToken', testUser.token + 'make-it-incorrect')
    .expect 401
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal false
      res.body.should.have.property 'error'
      res.body.error.should.have.property('code').and.equal 401
      done()

describe 'DELETE /user [Delete user]', ->

  it 'should delete the authenticated user', (done)->
    api.del('/user').set('AuthToken', testUser.token)
    .expect 200
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal true
      done()

  it 'should return unauthorized on deleted token', (done)->
    api.del('/user').set('AuthToken', testUser.token)
    .expect 401
    .expect 'Content-Type', /json/
    .end (err, res)->
      res.body.should.have.property('status').and.equal false
      res.body.should.have.property 'error'
      res.body.error.should.have.property('code').and.equal 401
      done()