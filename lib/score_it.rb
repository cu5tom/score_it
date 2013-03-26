require "score_it/version"

module ScoreIt

end

module ScoreIt

  def self.included base
    base.class_eval <<-END
      @scorable_attributes = []
      class << self; attr_accessor :scorable_attributes end
    END
    
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods

    def score_attributes *attributes
      @scorable_attributes = attributes
    end

    def scorable_attribute_names
      scorable_attributes.map { |item| item.is_a?(Array) ? item[0] : item }
    end

    def scorable_attribute_values    
      scorable_attributes.map { |item| item.is_a?(Array) && item.size == 2 ? item[1] : 0 }
    end
    
    private


  end
  
  module InstanceMethods

    def score
      score_attributes 
    end
    
    def total_score
      score
    end

    def scorable_attributes
      self.class.scorable_attributes
    end

    def score_for attribute
      @score = Hash[scorable_attributes][attribute]
      self.respond_to?(attribute) && !self.send(attribute).empty? && @score ? @score : 0
    end

    private

    def scorable_attribute_names
      self.class.scorable_attribute_names
    end

    def scorable_attribute_values    
      self.class.scorable_attribute_values
    end

    def score_attributes
      scorable_attribute_names.inject(0) {|sum,item| sum += score_for(item.to_sym) }
    end

  end
end
#ActiveRecord::Base.send :include, ScoreIt