class PetsController < ApplicationController
  protect_from_forgery with: :null_session

  def index

    # defined endpoint
    # GET /pets
    # use symbols even though json keys are strings

    # to_json vs. as_json
    # to returns a json object
    # as returns a hash (*** a bit more readable)

    pets = Pet.all
    render(
    json: pets.as_json(only: [:id, :name, :age, :human]), status: :ok
    )

    # old way of doing index before creating API
    # @pets = Pet.all
  end

  def show
    pet = Pet.find_by_id(params[:id])
    if pet
      render(
      json: pet.as_json(only: [:id, :name, :age, :human]), status: :ok
      )
    else
      render( json: {nothing: true}, status: :not_found
      )
    end
  end

  def create
    pet = Pet.new(pet_params)
    if pet.save
      render(
      json: {id: pet.id}, status: :ok
      )
    else
      render( json: { errors: pet.errors.messages },
      status: :bad_request
      )
    end
  end

  private
  def pet_params
    params.require(:pet).permit(:name, :age, :human)
  end

end
