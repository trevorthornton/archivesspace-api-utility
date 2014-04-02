require "spec_helper"

module ArchivesSpaceApiUtility
  describe Configuration do
    describe "host" do
      it "default value is localhost" do
        config = Configuration.new
        expect(config.host).to eq('localhost')
      end
    end

    describe "host=" do
      it "can set host" do
        config = Configuration.new
        config.host = 'some_other_host'
        expect(config.host).to eq('some_other_host')
      end
    end
  end
end