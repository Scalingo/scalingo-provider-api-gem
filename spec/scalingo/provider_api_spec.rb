require "spec_helper"

RSpec.describe Scalingo::ProviderApi do
  it 'has a version number' do
    expect(Scalingo::ProviderApi::VERSION).not_to be nil
  end

  context 'with an initialized client' do
    let(:client) {Scalingo::ProviderApi::Client.new('user', 'password')}

    describe '#find_app' do
      it 'should send a request to the correct url' do
        stub_request(:get, "https://api.scalingo.com/v1/provider/apps/1234").
          with(headers: {'Authorization'=>'Basic dXNlcjpwYXNzd29yZA==', 'Content-Type'=>'application/json'}).
          to_return(body: '{"key": "value"}')

        resp = client.find_app("1234")
        expect(resp["key"]).to eq "value"
      end

      it 'should refuse a request with an invalid number of arguments' do
        expect {client.find_app("1234", "456")}.to raise_error("Invalid arg count: 2, expected: 1")
      end

      it 'should fail if the server return an error' do
        stub_request(:get, "https://api.scalingo.com/v1/provider/apps/1234").
          with(headers: {'Authorization'=>'Basic dXNlcjpwYXNzd29yZA==', 'Content-Type'=>'application/json'}).
          to_return(body: '{"key": "value"}', status: 500)

        expect {client.find_app("1234")}.to raise_error(Faraday::ClientError)
      end
    end

    describe '#send_config' do
      it 'should send a request to the correct url' do
        stub_request(:patch, "https://api.scalingo.com/v1/provider/addons/1234/config").
          with(headers: {'Authorization'=>'Basic dXNlcjpwYXNzd29yZA==', 'Content-Type'=>'application/json'}, body: {config: {A: "B"}}).
          to_return(body: '{"key": "value"}')

        resp = client.send_config("1234", {A:'B'})
        expect(resp["key"]).to eq "value"
      end

      it 'should refuse a request with an invalid number of arguments' do
        expect {client.send_config("1234")}.to raise_error("Invalid arg count: 1, expected: 2")
      end

      it 'should fail if the server return an error' do
        stub_request(:patch, "https://api.scalingo.com/v1/provider/addons/1234/config").
          with(headers: {'Authorization'=>'Basic dXNlcjpwYXNzd29yZA==', 'Content-Type'=>'application/json'}).
          to_return(body: '{"key": "value"}', status: 500)

        expect {client.send_config("1234", {A: 'B'})}.to raise_error(Faraday::ClientError)
      end
    end

    describe '#provision' do
      it 'should send a request to the correct url' do
        stub_request(:post, "https://api.scalingo.com/v1/provider/addons/1234/actions/provision").
          with(headers: {'Authorization'=>'Basic dXNlcjpwYXNzd29yZA==', 'Content-Type'=>'application/json'}).
          to_return(body: '{"key": "value"}')

        resp = client.provision("1234")
        expect(resp["key"]).to eq "value"
      end

      it 'should refuse a request with an invalid number of arguments' do
        expect {client.provision("1234", "1234")}.to raise_error("Invalid arg count: 2, expected: 1")
      end

      it 'should fail if the server return an error' do
        stub_request(:post, "https://api.scalingo.com/v1/provider/addons/1234/actions/provision").
          with(headers: {'Authorization'=>'Basic dXNlcjpwYXNzd29yZA==', 'Content-Type'=>'application/json'}).
          to_return(body: '{"key": "value"}', status: 500)

        expect {client.provision("1234")}.to raise_error(Faraday::ClientError)
      end
    end

  end
end
