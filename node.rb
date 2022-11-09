class Node
  include Comparable
  attr_accessor :data, :left_node, :right_node

  def initialize(data = nil, left_node = nil, right_node = nil)
    @data = data
    @left_node = left_node
    @right_node = right_node
  end

  def to_s
    @data.to_s
  end

  def <=>(other)
    @data <=> other.data
  end
  
end