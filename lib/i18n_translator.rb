require 'rake'
require 'yaml/encoding'
require 'yaml'
require 'easy_translate'

class Insider
  
  def self.redefine klass, method, &block
    klass.send(:alias_method, original_method(method), method)
    klass.send(:define_method, method) do |*params|
      instance_exec(*params, &block)
    end
  end

  def self.undefine klass, method
    klass.send(:undef_method, method)
    klass.send(:alias_method, method, original_method(method))
  end

  def self.original_method method
    ('original_' + method.to_s).to_sym
  end
  
end

module I18nTranslator
    
  def self.create_locale(args)
    redefine_hash_to_yaml
    source = File.join(args[:dir_path], "#{args[:from].to_s}.yml")
    source_yaml = YAML.load_file(source)

    args[:to].each do |language|

      @@target_language =  language
      target_yaml = source_yaml.dup.replace(language.to_s => source_yaml[args[:from].to_s])
      target = File.join(args[:dir_path], "#{language.to_s}.yml")
    
      File.open(target, 'w+') do |file|
        file << YAML.unescape(YAML.dump(target_yaml))
      end
    end
    
    Insider.undefine(Hash, :to_yaml)
  end
  
  def self.redefine_hash_to_yaml
    Insider.redefine(Hash, :to_yaml) do |opts|
      YAML::quick_emit( object_id, opts ) do |out|
        out.map( taguri, to_yaml_style ) do |map|
          sort.each do |k, v|
            v = EasyTranslate.translate(v, :to => @@target_language) unless v.is_a?(Hash) 
            map.add( k, v )
          end
        end
      end
    end
  end

  import File.join(File.dirname(__FILE__), 'i18n_translator.rake')
end

