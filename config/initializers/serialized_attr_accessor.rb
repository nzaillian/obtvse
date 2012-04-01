# A Rails initializer that adds accessor/mutator methods
# of the form "instance.property_key" for any serialized (hash) attribute
# of your models.  Stick contents in a file called serialized_attr_accessor.rb
# or similar and place it in your config/initializers directory.
#
# usage:
#
#   class MyModel < ActiveRecord::Base
#
#      # your model has a serialized hash attribute "settings"
#      serialize :settings
#
#      # add accessors/mutators for :email, :twitter_handle, and :github_url
#      # keys in the settings hash:
#
#      serialized_attr_accessor :settings, :email, :twitter_handle, :github_url
#
#      #...your model now has public attributes: settings_email, settings_twitter_handle, settings_github_url
#
#   end
class ActiveRecord::Base
  def self.serialized_attr_accessor(*args)
      accessor_block = ""

      # stringified name of the hash property whose keys
      # we're adding dedicated accessors for:
      serialized_attr = args[0].to_s

      # all remaining arguments are taken to be keys of the serialized attribute...
      keys = args.slice(1, args.length)

      # add the accessor/mutator methods to the code-block we'll
      # be patching onto our class...
      keys.each do |key|
        accessor_block += <<-EOS
          def #{serialized_attr}_#{key.to_s}
            self.#{serialized_attr}[:#{key.to_s}]
          end

          def #{serialized_attr}_#{key.to_s}=(value)
            self.#{serialized_attr}[:#{key.to_s}] = value
          end
        EOS
      end

      # eval the block to patch its contents onto our class
      eval accessor_block
  end
end