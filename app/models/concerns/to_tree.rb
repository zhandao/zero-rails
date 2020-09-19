# frozen_string_literal: true

module ToTree
  def self.included(base)
    base.class_eval do
      extend ClassMethods

      def self.as_tree by_key:, name: ''
        @tree_relation_key = by_key
      end
    end
  end

  module ClassMethods
    # @return nested Hash Array
    def to_tree
      nodes = self.clone.where(@tree_relation_key => nil).to_a
      nodes.map!(&_generating_tree)
    end

    def _generating_tree
      proc do |node|
        sub_nodes = self.clone.where(@tree_relation_key => node.id).to_a
        sub_nodes.map!(&_generating_tree)
        node.to_h.merge!(sub_nodes: sub_nodes)
      end
    end
  end
end
