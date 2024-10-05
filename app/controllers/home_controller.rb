class HomeController < ApiController
  def index
    render json: {message: "Hello world!"}
  end
end
