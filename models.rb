class Dude < ActiveRecord::Base
  has_many :beard_states
  validates_uniqueness_of :slug

  named_scope :without_beards, {:conditions => ["dudes.id IN (select dude_id from beard_states group by dude_id having status = ?)", false]}
  named_scope :with_beards, {:conditions => ["dudes.id IN (select dude_id from beard_states group by dude_id having status = ?)", true]}

  def has_beard?
    current_state.status
  end

  def printed_status
    current_state.printed_status
  end

  def current_state
    beard_states.first
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

class BeardState < ActiveRecord::Base
  belongs_to :dude
  belongs_to :beard_type #Active Record, this is so backwards
  default_scope :order => "created_at desc"
  
  def printed_status
    status ? "YES" : "NO"
  end
end

class BeardType < ActiveRecord::Base
  has_many :beard_states
end