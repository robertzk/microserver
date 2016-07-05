'use strict';

var chai     = require('chai')
  , chaiHttp = require('chai-http')
  , spawn    = require('child_process').spawn
  , PORT     = 33399
  , should   = chai.should();

chai.use(chaiHttp);

var base_url = 'http://localhost:' + PORT;

var microserver = spawn('Rscript', [process.cwd() + '/inst/simple_server.R']);
microserver.on('data', function (data) {
  console.log('stdout: ' + data);
});
microserver.stderr.on('data', function (data) {
  console.log('stderr: ' + data);
});
microserver.on('close', function (code, signal) {
  console.log('R process exited with code ' + code + ' by signal ' + signal);
});
microserver.on('error', function (err) {
  console.log('Failed to start child process.');
});

setTimeout(
  function() {
    describe('microserver', function() {
      after(function() {
        microserver.kill()
      });
      it('should pong on a /ping', function(done) {
        chai.request(base_url)
          .get('/ping')
          .end(function(err, res) {
            should.not.exist(err);
            res.should.have.status(200);
            res.body.should.equal('pong');
            done();
          });
      });
      it('should use a catch all route on other requests', function(done) {
        chai.request(base_url)
          .get('/foo')
          .end(function(err, res) {
            should.not.exist(err);
            res.should.have.status(200);
            res.type.should.equal('application/json');
            res.body.exception.should.equal('catch all route');
            done();
          });
      });
      it('can parse query parameters', function(done) {
        var query = { name: 'foo', limit: 1 }
        chai.request(base_url)
          .get('/parse_query')
          .query(query)
          .end(function(err, res) {
            should.not.exist(err);
            res.should.have.status(200);
            res.body.query.name.should.equal(query.name);
            console.log(res.body);
            res.body.query.limit.should.equal(query.limit.toString());
            done();
          });
      });
    });
    run();
  },
  2000 // allow R server to start
);
