'use strict';

var chai     = require('chai')
  , chaiHttp = require('chai-http')
  , should   = chai.should();

chai.use(chaiHttp);

describe('Blobs', function() {
  it('should list ALL blobs on /blobs GET', done => {
    var a = 10;
    a.should.be.a('string');
    done();
  });
  it('should list a SINGLE blob on /blob/<id> GET');
  it('should add a SINGLE blob on /blobs POST');
  it('should update a SINGLE blob on /blob/<id> PUT');
  it('should delete a SINGLE blob on /blob/<id> DELETE');
});
