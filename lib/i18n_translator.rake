namespace :i18n do
  
  def indicator 
    Proc.new do |dirname, lang|
      print "\033[37m -->  #{dirname} : #{lang} .. \033[32m done  \n"
    end
  end
  
  desc "Translate and create locales from source locale"
  
  task :translate, [:from, :to, :path_to_file] => :environment do |t , args|
    locales = args[:path_to_file] || Dir.glob("#{RAILS_ROOT}/config/locales/**/*.yml")


    locales.each do |locale_path|
      dirname = File.dirname(locale_path)
      I18nTranslator.create_locales(:dir_path => dirname, :from => args[:from], :to => args[:to].split(';'), :indicator => indicator)
    end
    
  end
end