require "spec_helper"

describe "Templates api" do
  
  context "Get Templates" do

    it "returns an array with numbers from 0 to 9" do
      get "/templates", {}, { "Accept" => "application/json", "Content-Type" => "application/json"}
      expect(response.status).to eq 200
      json = JSON.parse(response.body)
      expect(json.size).to eq 10
    end

  end

end