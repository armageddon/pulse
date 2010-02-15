
module Scenarios
  module Loader
    def self.scenarios_path
      File.join( RAILS_ROOT, 'spec', 'scenarios' )
    end
    
    def self.load_file( file )
      # load the file
      require File.expand_path( File.join(scenarios_path, file) )
      # create an instance
      klass = file.camelize.constantize.new
    end
  end
  
  module ArrayMethods
    def save!()
      each{ |i| i.save! }
      if size == 1
        self[0]
      else
        self
      end
    end
    
    alias_method :save, :save!
  end
end


# add load_scenario method to spec examples
module Spec
  module Example
    module ExampleMethods
      extend ExampleGroupMethods
      extend ModuleReopeningFix
      
      def load_scenario( type, name )
        klass = Scenarios::Loader::load_file(type.to_s)
        
        # load particular scenario
        klass.send( name )
        
        # copy instance variables from the scenario class to self
        copy_instance_variables_from( klass )
      end
      
      def self.copy_instance_vars( obj_from )
        obj_from.instance_variables.each do |var|
          self.instance_var_set( obj_from.instance_variable_get(var) )
        end
      end
    end
  end
end


# handy method for saving each instance in an array

class Array
  include Scenarios::ArrayMethods
end