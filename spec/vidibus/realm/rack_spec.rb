require "spec_helper"

class Service
  def self.this
    OpenStruct.new.tap do |a|
      a.domain = "something.else.local"
    end
  end
end

describe "Vidibus::Realm::Rack" do
  include Rack::Test::Methods

  def downstream_app
    @downstream_app ||= OpenStruct.new.tap do |a|
      mock(a).call.with_any_args {[200,{"Content-Type" => "text/html"},[]]}
    end
  end

  def app
    @app ||= Vidibus::Realm::Rack.new(downstream_app)
  end

  it "should not set realm by default" do
    get "http://something.local"
    last_request.env[:realm].should be_nil
  end

  it "should set realm by subdomain" do
    get "http://hello.something.else.local"
    last_request.env[:realm].should eql("hello")
  end

  it "should not set realm by subdomain if hostname does not match the domain of this service" do
    get "http://hello.else.local"
    last_request.env[:realm].should be_nil
  end

  it "should not set realm by subdomain if no subdomain is available" do
    get "http://something.else.local"
    last_request.env[:realm].should be_nil
  end

  it "should set realm by constant if no valid subdomain is available" do
    VIDIBUS_REALM = "gotcha"
    get "http://something.else.local"
    last_request.env[:realm].should eql("gotcha")
  end

  it "should set realm by constant even if a valid subdomain is given" do
    VIDIBUS_REALM = "gotcha"
    get "http://hello.something.else.local"
    last_request.env[:realm].should eql("gotcha")
  end

  after do
    Object.send(:remove_const, :VIDIBUS_REALM) if defined?(VIDIBUS_REALM)
  end
end
