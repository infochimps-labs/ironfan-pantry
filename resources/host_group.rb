actions :create, :destroy

def initialize *args
  super
  @action = :create
end
