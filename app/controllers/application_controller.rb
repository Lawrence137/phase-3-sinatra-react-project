class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # # Add your routes here
  # get "/" do
  #   { message: "Good luck Dexter C137 with your project!" }.to_json
  # end




    # @api: Enable CORS Headers
    configure do
      enable :cross_origin
    end
  
    before do
      response.headers['Access-Control-Allow-Origin'] = '*'
    end
  
    options "*" do
      response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
      response.headers["Access-Control-Allow-Origin"] = "*"
      200
    end
  
    # @api: Format the json response
    def json_response(code: 200, data: nil)
      status = [200, 201].include?(code) ? "SUCCESS" : "FAILED"
      headers['Content-Type'] = 'application/json'
      if data
        [ code, { data: data, message: status }.to_json ]
      end
    end
  
    # @api: Format all common JSON error responses
    def error_response(code, e)
      json_response(code: code, data: { error: e.message })
    end
  
    # @views: Format the erb responses
    def erb_response(file)
      headers['Content-Type'] = 'text/html'
      erb file
    end
  
    # @helper: not found error formatter
    def not_found_response
      json_response(code: 404, data: { error: "You seem lost. That route does not exist." })
    end
  
    # @api: 404 handler
    not_found do
      not_found_response
    end

     # @helper: read JSON body
     before do
      begin
        @user = user_data
      rescue
        @user = nil
      end
    end
  
    #@method: create a new user
    post '/register' do
      users = User.create(
        full_name: params[:full_name],
        email: params[:email],
        password_hash: params[:password_hash],
      )
      users.to_json
    end
  
    #@method: log in user using email and password
    post '/login' do
      begin
        user_data = User.find_by(email: params[:email])
        if user_data && BCrypt::Password.new(user_data.password_hash) == params[:password]
          json_response(code: 200, data: {
            id: user_data.id,
            email: user_data.email
          })
        else
          json_response(code: 422, data: { error: "Your email/password combination is not correct" })
        end
      rescue => e
        error_response(422, e)
      end
    end
    
  
    private
  
    # @helper: parse user JSON data
    def user_data
      JSON.parse(request.body.read)
    end


    # Create a new task
post '/tasks/create' do
  task = Task.new(
    title: params[:title],
    description: params[:description],
    due: params[:due],
    user_id: params[:user_id]
  )
  if task.save
    task.to_json
  else
    error_response(422, task.errors.full_messages)
  end
end


# Retrieve all tasks
get "/tasks" do
  Task.all.reverse.to_json
end


# Update a task
put '/tasks/update/:id' do
  task = Task.find(params[:id])
  if task.update(
    title: params[:title],
    description: params[:description],
    due: params[:due],
    user_id: params[:user_id]
  )
    task.to_json
  else
    error_response(422, task.errors.full_messages)
  end
rescue ActiveRecord::RecordNotFound
  error_response(404, "Task not found")
end


# Delete a task
delete '/tasks/delete/:id' do
  task = Task.find(params[:id])
  task.destroy
  task.to_json
rescue ActiveRecord::RecordNotFound
  error_response(404, "Task not found")
end


# Retrieve a specific task
get '/tasks/:id' do
  task = Task.find(params[:id])
  task.to_json
rescue ActiveRecord::RecordNotFound => e
  error_response(404, e)
end 




  
  
  

end
