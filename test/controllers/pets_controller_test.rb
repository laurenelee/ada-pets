require 'test_helper'

class PetsControllerTest < ActionDispatch::IntegrationTest
  describe "index" do
    # These tests are a little verbose - yours do not need to be
    # this explicit.
    it "is a real working route" do
      get pets_path
      must_respond_with :success
    end

    it "returns json" do
      get pets_path
      response.header['Content-Type'].must_include 'json'
    end

    it "returns an Array" do
      get pets_path

      body = JSON.parse(response.body)
      # binding.pry

      body.must_be_kind_of Array
    end

    it "returns all of the pets" do
      get pets_path

      body = JSON.parse(response.body)
      body.length.must_equal Pet.count
    end

    it "returns pets with exactly the required fields" do
      keys = %w(age human id name)
      get pets_path
      body = JSON.parse(response.body)
      body.each do |pet|
        # double checking keys (age human id name)
        pet.keys.sort.must_equal keys
      end
    end

    it "returns an empty array if there are no pets" do
      # always good to add this scenario
      Pet.destroy_all
      get pets_path
      must_respond_with :success
      body = JSON.parse(response.body)
      body.must_be_kind_of Array
      body.must_be :empty?
    end
  end

  describe "show" do

    it "can get a pet" do
      get pet_path(pets(:two).id)
      must_respond_with :success
    end

    # what other things to test for here?
    it "returns a hash with all of the fields about a particular pet" do
      get pet_path(pets(:two).id)
      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body["human"].must_equal pets("two").human
    end

    # negative tests- how to handle the errors! What if the pet doesn't exist??
    it "returns not found when pet doesn't exist" do
      invalid_pet_id = Pet.all.last.id + 1
      get pet_path(invalid_pet_id)
      must_respond_with :not_found
      body = JSON.parse(response.body)
      body.must_equal "nothing" => true
    end

  end

  describe "create" do
    let(:pet_data) {
      {
        name: "Jack",
        age: 7,
        human: "Captain Barbossa"
      }
    }

    it "Creates a new pet" do
      proc {
        post pets_path, params: {pet: pet_data}
      }.must_change 'Pet.count', 1
      must_respond_with :success

      # another way
      # assert_difference "Pet.count", 1 do
      #   post pets_path, params: { pet: pet_data }
      #   assert_response :success
    end

    #   body = JSON.parse(response.body)
    #   body.must_be_kind_of Hash
    #   body.must_include "id"
    #
    #   # Check that the ID matches
    #   Pet.find(body["id"]).name.must_equal pet_data[:name]
    # end
    #
    # it "Returns an error for an invalid pet" do
    #   bad_data = pet_data.clone()
    #   bad_data.delete(:name)
    #   assert_no_difference "Pet.count" do
    #     post pets_url, params: { pet: bad_data }
    #     assert_response :bad_request
    #   end
    #
    #   body = JSON.parse(response.body)
    #   body.must_be_kind_of Hash
    #   body.must_include "errors"
    #   body["errors"].must_include "name"
  end
# end
end
