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
      stub(a).call.with_any_args {[200,{"Content-Type" => "text/html"},[]]}
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

  context 'if Service has not been set up' do
    it 'should raise an error' do
      stub(Service).this { raise(Vidibus::Service::ConfigurationError) }
      expect { get 'http://hello.else.local' }.
        to raise_error(Vidibus::Realm::ServiceError)
    end

    it 'should not raise an error for connector requests' do
      stub(Service).this { raise(Vidibus::Service::ConfigurationError) }
      expect { get 'http://hello.else.local/connector' }.
        not_to raise_error
    end

    it 'should not raise an error for connector requests with args' do
      stub(Service).this { raise(Vidibus::Service::ConfigurationError) }
      expect { get 'http://hello.else.local/connector?uuid=124' }.
        not_to raise_error
    end
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
