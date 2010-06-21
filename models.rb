class Dude
  include DataMapper::Resource
  property :name, String
  property :slug, String, :key => true
  property :status, Boolean
  
  def has_beard?
    status
  end
  
  def printed_status
    status ? "YES" : "NO"
  end
  
  def display_name
    name.strip.length > 0 ? name.strip : slug
  end
end

DataMapper.finalize