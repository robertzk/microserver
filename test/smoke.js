'use strict';

var chai     = require('chai')
  , chaiHttp = require('chai-http')
  , spawn    = require('child_process').spawn
  , PORT     = 33399
  , should   = chai.should();

chai.use(chaiHttp);

var base_url = 'http://localhost:' + PORT;

var microserver = spawn('Rscript', [process.cwd() + '/inst/simple_server.R']);
microserver.on('data', (data) => {
  console.log(`stdout: ${data}`);
});
microserver.stderr.on('data', (data) => {
  console.log(`stderr: ${data}`);
});
microserver.on('close', (code, signal) => {
  console.log(`R process exited with code ${code} by signal ${signal}`);
});
microserver.on('error', (err) => {
  console.log('Failed to start child process.');
});

describe('microserver', function() {
  beforeEach(function(done) {
    this.timeout(1500); // A very long environment setup.
    setTimeout(done, 1000);
  });
  it('should pong on a /ping', function(done) {
    chai.request(base_url)
      .get('/ping')
      .end(function(err, res) {
        res.should.have.status(200);
        res.text.should.equal('"pong"');
        done();
      });
  });
  it('should use a catch all route on other requests', function(done) {
    chai.request(base_url)
      .get('/foo')
      .end(function(err, res) {
        res.should.have.status(200);
        res.type.should.equal('text/json');
        JSON.parse(res.text).exception.should.equal('catch all route');
        done();
      });
  });
});
