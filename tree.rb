class Tree

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    #Should return the level 0 root node
    

    #Base Case
    if array.empty?
      nil    
    else
      #Get the middle element and make it root
      mid = array.size / 2

      root_node = Node.new(array[mid])

      #Recursively construct the left subtree and make it left child of root

      root_node.left_node = build_tree(array[0...mid])
      root_node.right_node = build_tree(array[(mid + 1)...-1])

      root_node      
    end
  end 

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_node, "#{prefix}#{is_left ? '|   ' : '   '}", false) if node.right_node
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_node, "#{prefix}#{is_left ? '   ' : '|   '}", true) if node.left_node
  end

  def insert(value, node = @root)


    #If the value is equal

    return nil if node.data == value
  
    if value < node.data
      node.left_node.nil? ? node.left_node = Node.new(value) : insert(value, node.left_node)
    else
      # Do something here
      node.right_node.nil? ? node.right_node = Node.new(value) : insert(value, node.right_node)
    end
  end 

  def delete(value)    
    return nil if find(value).nil?
    parent_node = find_parent(value)
    #Case 1: if we are trying to delete a leaf in the tree
    if find(value).left_node.nil? && find(value).right_node.nil?
      delete_leaf_node(parent_node,value)
    #Case 2: If we are deleting a node with one child
    elsif find(value).left_node.nil? || find(value).right_node.nil?
      delete_single_child_node(parent_node, value)
    #Case 3: If our node has two children, we find the next biggest
    else
      delete_double_child_node(parent_node, value)
    end
  end

  def find(value, node = @root)
    #Returns the node with the given value
    if node.nil?
      nil
    elsif node.data == value
      node
    elsif node.data > value
      find(value, node.left_node)
    elsif node.data < value
      find(value, node.right_node)
    end    
  end

  def find_parent(value, node = @root)
    #Returns the parent node of the specified node
    if node == value
      nil
    elsif node.left_node == value || node.right_node == value
      #Then we return the parent
      node
    elsif node.data > value
      find_parent(value, node.left_node)
    elsif node.data < value
      find_parent(value, node.right_node)
    end    
  end

  def delete_leaf_node(p_node, value)
    if p_node > value
      #do something
      p_node.left_node = nil
    elsif p_node < value
      #do something else here
      p_node.right_node = nil
    end
  end

  def delete_single_child_node(p_node, value)
    grandchild = find(value).right_node if find(value).left_node.nil?
    grandchild = find(value).left_node if find(value).right_node.nil?
    attach_right(p_node, grandchild) if p_node.right_node == find(value)
    attach_left(p_node, grandchild) if p_node.left_node == find(value)    
  end

  def delete_double_child_node(p_node, value)
    replace = find_inorder_successor(value)
    delete(replace.data)
    attach_right(replace, find(value).right_node)
    attach_left(replace, find(value).left_node)
    attach_right(p_node, replace) if p_node.right_node == find(value)
    attach_left(p_node, replace) if p_node.left_node == find(value)
  end

  def level_order
    return nil if @root.nil?
    #Create a queue
    queue = [@root]
    #Create empty array where we store them in breadth-first level order
    result = []
    until queue.empty?
      node = queue.shift
      block_given? ? yield(node) : result << node.data
      queue << node.left_node unless node.left_node.nil?
      queue << node.right_node unless node.right_node.nil?
    end
    result unless block_given?
  end

  def inorder(node = @root, output = [], &block)
    return if node.nil? # Base case, we have empty node

    inorder(node.left_node, output, &block)
    output.push(block_given? ? block.call(node) : node.data)
    inorder(node.right_node, output, &block)

    output
  end

  def preorder(node = @root, output = [], &block)
    return if node.nil?

    output.push(block_given? ? block.call(node) : node.data)
    preorder(node.left_node, output, &block)
    preorder(node.right_node, output, &block)

    output

  end

  def postorder(node = @root, output = [], &block)
    return if node.nil?

    postorder(node.left_node, output, &block)
    postorder(node.right_node, output, &block)
    output.push(block_given? ? block.call(node) : node.data)

    output
  end

  #Height is defined as the number of edges in longest path from a given node to a leaf node
  def height(node = @root)
    return -1 if node.nil?
    return ((height(node.left_node), height(node.right_node)).max) + 1
  end

  def depth(node)
    return nil if node.nil?

    curr_node = @root
    count = 0
    until curr_node.data == node.data
      count += 1
      curr_node = curr_node.left_node if node.data < curr_node.data
      curr_node = curr_node.right_node if node.data > curr_node.data
    end

    count
  end

  def balanced?
    left = height(@root.left_node, 0) # Pass count = 0, as we're starting at height 1
    right = height(@root.right_node, 0)
    (left - right).between?(-1, 1)    
  end

  def rebalance!
    values = inorder
    @root =  build_tree(values)

  end

  def node_list(current = @root, queue = [], result = [])
    return result if current.nil?

    node = [current.data]
    unless current.left_node.nil?
      node << "L: #{current.left_node.data}"
      queue << current.left_node
    end
    unless current.right_node.nil?
      node << "R: #{current.right_node.data}"
      queue << current.right_node
    end
    result << node
    queue.shift unless result.length == 1
    node_list(queue[0], queue, result)
  end

  def find_inorder_successor(value, successor = value)
    result = find(successor + 1)
    return result unless result.nil?

    find_inorder_successor(successor + 1)
  end

  def attach_right(p_node, node)
    p_node.right_node = node
  end

  def attach_left(p_node, node)
    p_node.left_node = node
  end

end