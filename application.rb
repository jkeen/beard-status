require 'bundler'
Bundler.setup
require 'active_record'
require 'sinatra'
require "sinatra/subdomain"
require "sinatra/activerecord"
require 'sinatra/static_assets'

# Database setup.
# 
if ENV['DATABASE_URL']
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
else
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))["production"])   
end

require './models'

# require "./environment"

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

  def error_message(dude)
    %Q{Something bad went down, and I'm starting to think you were responsible for it.  Whatever you wanted to do ain't happening, bud.}
  end

  def slug_available?(slug)
    return false if slug.empty?
    @dude = Dude.find_by_slug(slug)
    @dude.nil?
  end

  def massage_status(status)
    return true if status.downcase == "yes"
    return false
  end

  def base_url
     @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
  
  def number_with_delimiter(number, delimiter=",")
    number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
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
    @dude = Dude.new({
      :slug => subdomain,
      :name => params.fetch("name") || subdomain
    })
    @dude.beard_versions << BeardVersion.new(:status => massage_status(params.fetch("status")))
    @dude.save
    redirect '/', 303
  end

  put '/?' do
    @dude.update_attributes({
      :name => (params.fetch("name") || subdomain)
    })

    new_status = massage_status(params.fetch("status"))
    if (@dude.current_state.status != new_status && !params.fetch("status").nil?)
      @dude.beard_versions.create({:status => new_status})
    end
    redirect '/', 303
  end
  
  get '/rss.xml' do
    pass unless subdomain
    builder do |xml|
      xml.instruct! :xml, :version => '1.0'
      xml.rss :version => "2.0" do
        xml.channel do
          xml.title "Beard History For #{@dude.name}"
          xml.link "http://#{@dude.slug}.beardstatus.com/"

          @dude.beard_versions.each do |state|
            xml.item do
              xml.title state.printed_status
              xml.link "http://#{@dude.slug}.beardstatus.com/#status-#{state.id}"
              xml.description ""
              xml.pubDate Time.parse(state.created_at.to_s).rfc822()
              xml.guid "http://#{@dude.slug}.beardstatus.com/#status-#{state.id}"
            end
          end
        end
      end
    end
  end
end

get '/rss.xml' do
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "Beard Status"
        xml.link "http://beardstatus.com/"

        BeardVersion.find(:all, :include => :dude).each do |state|
          xml.item do
            xml.title "#{state.dude.name} changed his Beards Status to #{state.printed_status}"
            xml.link "http://#{state.dude.slug}.beardstatus.com/"
            xml.description ""
            xml.pubDate Time.parse(state.created_at.to_s).rfc822()
            xml.guid "http://#{state.dude.slug}.beardstatus.com/#status-#{state.id}"
          end
        end
      end
    end
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
  @beards = Dude.with_beards.to_a
  puts " -------------------"
  puts @beards.inspect
  puts " -------------------"
  @faces = Dude.without_beards.to_a
  erb :index
end