require 'spec_helper'
require 'json'

module ArchivesSpaceApiUtility
  describe ArchivesSpaceSession do
    it "establishes a connection" do
      a = ArchivesSpaceSession.new
      expect(a.session_token).not_to be_nil
    end

    it "preforms a successful GET request" do
      a = ArchivesSpaceSession.new
      response = a.get('/repositories')
      expect(response.code).to eq(200)
    end

    it "preforms a GET request and returns data from ArchivesSpace" do
      a = ArchivesSpaceSession.new
      test_path = ARCHIVESSPACE_TEST_PATHS[:resource]
      response = a.get(ARCHIVESSPACE_TEST_PATHS[:resource], resolve: ['linked_agents','subjects'])
      response_data = JSON.parse(response.body)
      expect(response_data['uri']).to eq(test_path)
    end

    it "performs a post request" do
      a = ArchivesSpaceSession.new
      test_path = ARCHIVESSPACE_TEST_PATHS[:resource]
      response1 = a.get(ARCHIVESSPACE_TEST_PATHS[:resource])
      response2 = a.post(ARCHIVESSPACE_TEST_PATHS[:resource],response1.body)
      expect(response2.code).to eq(200)
    end

  end
end