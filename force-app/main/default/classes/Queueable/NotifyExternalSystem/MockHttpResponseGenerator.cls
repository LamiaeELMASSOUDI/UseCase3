@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
  Integer code = 404;
  public MockHttpResponseGenerator(Integer code) {
    this.code = code;
  }
  public HttpResponse respond(HttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setStatusCode(this.code);
    return response;
  }
}