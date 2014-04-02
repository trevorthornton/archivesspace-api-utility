require "spec_helper"

module ArchivesSpaceApiUtility
  describe ArchivesSpaceSession do
    it "establishes a connection" do
      a = ArchivesSpaceSession.new
      expect(a.session_token).not_to be_nil
    end


    it "preforms a GET request" do
      a = ArchivesSpaceSession.new
      response = a.get('/repositories')
      expect(response.message).to eq('OK')
    end

    # TO DO - How to test a POST without actually posting to ArchivesSpace?
  end
end