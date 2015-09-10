require 'spec_helper'

describe TimekitApi do
  it 'has a version number' do
    expect(TimekitApi::VERSION).not_to be nil
  end

  describe "#config" do
    
    before(:each) do
      TimekitApi.config.reset
    end

    context "#reset" do
      it "clears all configuration values" do
        TimekitApi.config.update({api_key: '1234567891011'})
        expect(TimekitApi.config.has_key?(:api_key)).to eq(true)
        TimekitApi.config.reset
        expect(TimekitApi.config.has_key?(:api_key)).to eq(false)
      end
    end

    context "#update" do
      
      it "updates the TimekitApi config from a hash" do
        api_key = '1234567891011'
        TimekitApi.config.update({api_key: api_key})
        expect(TimekitApi.config[:api_key]).to eq(api_key)
      end

      it "raises a TimkeitApi::Config::Error on invalid keys" do
        expect{ TimekitApi.config.update({butt: 'butt'}) }
      end

    end

    context "#[]" do
      it "returns the value of a single key of the configuration" do
        TimekitApi.config.update({output_timestamp_format: 'Y-m-d h:ia', input_timestamp_format: 'm-d-Y h:ia'})
        expect(TimekitApi.config[:output_timestamp_format]).to eq('Y-m-d h:ia')
        expect(TimekitApi.config[:input_timestamp_format]).to eq('m-d-Y h:ia')
      end


    end

    context "#[]=" do

      it "raises a TimkeitApi::Config::Error on invalid keys" do
        expect{ TimekitApi.config.update({butt: 'butt'}) }
      end

      it "sets the value of a single key of the configuration" do
        TimekitApi.config[:input_timestamp_format] = 'Y-m-d h:ia'
        expect(TimekitApi.config[:input_timestamp_format]).to eq('Y-m-d h:ia')
      end
    end

    context "#has_key?" do
      it "returns true if the specified key is set" do
        TimekitApi.config.update({api_key: '1234567891011'})

        expect(TimekitApi.config.has_key?(:api_key)).to eq(true)
      end

      it "returns false if the specified key is not set" do
        expect(TimekitApi.config.has_key?(:api_key)).to eq(false)
      end
    end
  end

end
