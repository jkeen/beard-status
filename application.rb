require 'environment'

helpers do
  def slug
    subdomain || params[:slug]
  end
  
  def new_user?
    slug.nil? || slug.empty?
  end
  
  def status_url(s)
    # "/dude/#{s}"
    "http://#{s}.beardstatus.com"
  end
  
  def edit_url(s = slug)
    # "/dude/#{s}/edit"
    "http://#{s}.beardstatus.com/edit"
  end
    
  def taken_message(dude)
    %Q{Aw shit&mdash;<a href="#{status_url(dude.slug)}">#{dude.display_name}</a> and his #{dude.has_beard? ? "bearded face " : "bald face "} have already claimed that address.}
  end
  
  def slug_available?(slug)
    return false if slug.empty?
    @dude = Dude.get(slug)
    @dude.nil?
  end
  
  def create
    @dude = Dude.create({
      :slug => slug,
      :name => params.fetch("name") || slug,
      :status => massage_status(params.fetch("status"))
    })
  end

  def update
    @dude = Dude.get(slug)
    @dude.update({
        :name => params.fetch("name") || slug,
        :status => massage_status(params.fetch("status"))
    })
  end

  def edit
    @dude = Dude.get(slug)
    erb :edit
  end

  def show
    @dude = Dude.get(slug)
    if @dude
      erb :status
    else
      edit
    end
  end
  
  def massage_status(status)
    return true if status.downcase == "yes"
    return false
  end  
end

subdomain do
  get '/?' do 
    show
  end
  
  get '/edit?' do
    edit
  end
  
  post '/?' do 
    create
    redirect '/', 303
  end
  
  put '/?' do
    update
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

get '/dude/:slug/?' do
  show
end

get '/dude/:slug/edit?' do
  edit  
end

post '/dude/:slug/?' do 
  create
  redirect status_url(slug), 303
end

put '/dude/:slug/?' do
  update
  redirect status_url(slug), 303
end

get '/?' do
  @beards = Dude.all(:status => true)
  @faces = Dude.all(:status => false)
  erb :index
end
