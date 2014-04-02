require "spec_helper"

module ArchivesSpaceApiUtility
  describe ASpaceConnection do
    it "establishes a connection" do
      a = ASpaceConnection.new
      expect(a.session_token).not_to be_nil
    end


    it "preforms a GET request" do
      a = ASpaceConnection.new
      response = a.get('/repositories')
      expect(response.message).to eq('OK')
    end

    # TO DO - How to test a POST without actually posting to ArchivesSpace?
  end
end