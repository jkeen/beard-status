require 'environment'

helpers do
  def dude_specified
    subdomain || params[:slug]
  end

  def new_user?
    slug.nil? || slug.empty?
  end

  def status_url(slug)
    # "/dude/#{s}"
    base_url.gsub("\/\/", "//#{slug}.")
  end

  def taken_message(dude)
    %Q{Aw shit&mdash;<a href="#{status_url(dude.slug)}">#{dude.display_name}</a> and his #{dude.has_beard? ? "bearded face " : "bald face "} have already claimed that address.}
  end

  def slug_available?(slug)
    return false if slug.empty?
    @dude = Dude.find_by_slug(dude_specified)
    @dude.nil?
  end

  def massage_status(status)
    return true if status.downcase == "yes"
    return false
  end

  def base_url
     @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
end

before do
   @dude = Dude.find_by_slug(dude_specified) if dude_specified
end

subdomain do
  get '/?' do
    if @dude
      erb :status
    else
      erb :edit
    end
  end

  get '/edit?' do
    erb :edit
  end

  post '/?' do
    @state = BeardState.new(:status => massage_status(params.fetch("status")))
    @dude = @state.dude = Dude.new({
      :slug => subdomain,
      :name => params.fetch("name") || subdomain
    })
    @state.save
    redirect '/', 303
  end

  put '/?' do
    @dude.update_attributes({
      :name => (params.fetch("name") || subdomain)
    })

    new_status = massage_status(params.fetch("status"))
    if (@dude.current_state.status != new_status && !params.fetch("status").nil?)
      @dude.beard_states.create({:status => new_status})
    end
    redirect '/', 303
  end
end

get '/new?' do
  erb :new
end

post '/new?' do
  slug = params.fetch("desired_slug")
  if slug_available?(slug)
    redirect status_url(slug)
  else
    erb :new
  end
end

get '/?' do
  @beards = Dude.with_beards
  @faces = Dude.without_beards
  erb :index
end