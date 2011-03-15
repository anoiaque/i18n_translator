require 'test/unit'
require 'i18n_translator'
require 'mocha'

$KCODE = 'utf-8'

class TestI18nTranslator < Test::Unit::TestCase

  def setup
    stubs_easy_translate
    
    @dirname = File.join(File.dirname(__FILE__), 'config/locales/models/user')
    @source = File.join(@dirname, 'fr.yml')
    @targets = {:en => File.join(@dirname, 'en.yml'), :es => File.join(@dirname, 'es.yml')}
    I18nTranslator.create_locales(:dir_path => @dirname, :from => :fr, :to => [:en, :es])
  end
  
  def teardown
    File.delete(*@targets.values)
  end
  
  def test_should_create_english_locale_for_model_user
    yaml_locale = YAML.load_file(@targets[:en])
    
    assert_equal 'car', yaml_locale['en']['models']['user']['car']
    assert_equal 'error', yaml_locale['en']['models']['user']['error']
    assert_equal 'home', yaml_locale['en']['models']['user']['house']
  end
  
  def test_should_create_spanish_locale_for_model_user
    yaml_locale = YAML.load_file(@targets[:es])
    
    assert_equal 'coche', yaml_locale['es']['models']['user']['car']
    assert_equal 'error', yaml_locale['es']['models']['user']['error']
    assert_equal 'casa', yaml_locale['es']['models']['user']['house']
  end
  
  def test_should_keep_double_quoted_interpolations
    yaml_locale = YAML.load_file(@targets[:en])
    
    assert_equal 'Users : {{n}}', yaml_locale['en']['models']['user']['total_user']
  end
  
  private
  
  def stubs_easy_translate
    fr_to_en = [['maison', "home"], ['erreur', 'error'], ['voiture', 'car'], ['Utilisateurs : {{n}}', 'Users : {{n}}']]
    fr_to_es = [['maison', "casa"], ['erreur', 'error'], ['voiture', 'coche'], ['Utilisateurs : {{n}}', 'Usuario : {{n}}']]
    map = {:en => fr_to_en, :es => fr_to_es}
    map.each {|target, translations| translations.each { |fr, translated| EasyTranslate.stubs(:translate).with(fr, :to => target).returns(translated) } }
  end
  
end