
# Load Models
class Dude < ActiveRecord::Base
  has_many :beard_versions, :dependent => :destroy
  validates_presence_of :slug
  validates_uniqueness_of :slug

  default_scope { order("created_at desc") }
  
  # Here's some code I don't like.
  
  scope :with_beard_status_of, lambda { |status| 
    {:joins => "INNER JOIN (SELECT MAX(id) as latest_version, dude_id FROM beard_versions GROUP BY dude_id) as b on dudes.id = b.dude_id INNER JOIN beard_versions on b.latest_version = beard_versions.id", :conditions => ["beard_versions.status = ?", status], :order => "beard_versions.updated_at desc"}  
  }

  def self.with_beards
    self.with_beard_status_of(true)
  end
  
  def self.without_beards
    self.with_beard_status_of(false)
  end
  
  def has_beard?
    current_state.status
  end

  def printed_status
    current_state.printed_status
  end

  def current_state
    beard_versions.first
  end
  
  def display_name
    name.strip.length > 0 ? name.strip : slug
  end 

  def beard_type
    if has_beard?
      current_state.beard_type ? current_state.beard_type.name : "unknown"
    else
      "none"
    end
  end
end

class BeardVersion < ActiveRecord::Base
  belongs_to :dude
  belongs_to :beard_type #Active Record, this is so backwards
  default_scope { order("created_at desc") }

  
  def printed_status
    status ? "YES" : "NO"
  end
end

class BeardType < ActiveRecord::Base
  has_many :beard_versions
end
