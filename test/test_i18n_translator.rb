require 'test/unit'
require 'i18n_translator'
require 'mocha'

$KCODE = 'utf-8'

class TestI18nTranslator < Test::Unit::TestCase

  def setup
    @dirname = File.join(File.dirname(__FILE__), 'config/locales/models/user')
    @source = File.join(@dirname, 'fr.yml')
    @targets = [File.join(@dirname, 'en.yml'), File.join(@dirname, 'es.yml')]
    stubs_easy_translate
  end
  
  def teardown
    delete_targets
  end

  def test_should_create_locales_files_for_each_language_passed_as_argument
    I18nTranslator.create_locale(:dir_path => @dirname, :from => :fr, :to => [:en, :es])
  
    @targets.each {|target| assert File.exists?(target)}
  end
  
  def test_created_locale_should_have_keys_from_source_and_translated_values
    I18nTranslator.create_locale(:dir_path => @dirname, :from => :fr, :to => [:en, :es])
    yaml_locale = YAML.load_file(@targets.first)
    
    assert_equal 'car', yaml_locale['en']['models']['user']['car']
    assert_equal 'error', yaml_locale['en']['models']['user']['error']
    assert_equal 'home', yaml_locale['en']['models']['user']['house']
    
    yaml_locale = YAML.load_file(@targets[1])
    
    assert_equal 'coche', yaml_locale['es']['models']['user']['car']
    assert_equal 'error', yaml_locale['es']['models']['user']['error']
    assert_equal 'casa', yaml_locale['es']['models']['user']['house']
    
  end
  
  private
  
  def stubs_easy_translate
    fr_to_en = [['maison', 'home'], ['erreur', 'error'], ['voiture', 'car']]
    fr_to_es = [['maison', 'casa'], ['erreur', 'error'], ['voiture', 'coche']]
    map = {:en => fr_to_en, :es => fr_to_es}
    map.each {|target, translations| translations.each { |fr, translated| EasyTranslate.stubs(:translate).with(fr, :to => target).returns(translated) } }
  end
  
  def delete_targets
    begin
      File.delete(*@targets)
    rescue
    end
  end
  
end