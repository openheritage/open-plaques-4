class TeamMember
  attr_accessor :id, :name, :title
  def initialize(hash)
    self.id = hash[:id]
    self.name = hash[:name]
    self.title = hash[:title]
  end
end
