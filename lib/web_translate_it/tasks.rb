require File.join(File.dirname(__FILE__), '..', 'web_translate_it')

namespace :trans do  
  desc "Fetch translation files from Web Translate It"
  task :fetch, :locale do |t, args|
    welcome_message
    colour_puts "<b>Fetching file for locale #{args.locale}…</b>"
    configuration = WebTranslateIt::Configuration.new
    configuration.files.each do |file|
      response_code = file.fetch(args.locale)
      handle_response(file.file_path_for_locale(args.locale), response_code)
    end
  end
  
  namespace :fetch do
    desc "Fetch all the translation files from Web Translate It"
    task :all do
      welcome_message
      configuration = WebTranslateIt::Configuration.new
      locales = configuration.locales
      configuration.ignore_locales.each do |ignore|
        locales.delete(ignore)
      end
      colour_puts "<b>Fetching all files for all locales…</b>"
      locales.each do |locale|
        configuration.files.each do |file|
          response_code = file.fetch(locale) 
          handle_response(file.file_path_for_locale(locale), response_code)
        end
      end
    end
  end
  
  desc "Upload a translation file to Web Translate It"
  task :upload, :locale do |t, args|
    welcome_message
    colour_puts "<b>Uploading file for locale #{args.locale}…</b>"
    configuration = WebTranslateIt::Configuration.new
    configuration.files.each do |file|
      response_code = file.upload(args.locale)
      handle_response(file.file_path_for_locale(args.locale), response_code)
    end
  end
  
  desc "Install Web Translate It for your application"
  task :config do
    welcome_message
    WebTranslateIt::Configuration.create_config_file
  end
  
  def handle_response(file_path, response_code)
    if response_code < 400
      colour_puts "<green>#{file_path}: #{response_code}, OK</green>"
    else
      colour_puts "<red>#{file_path}: #{response_code}, Problem!</red>"
    end
  end
  
  def welcome_message
    colour_puts WELCOME_SCREEN
  end
  
  def colour_puts(text)
    puts WebTranslateIt::Util.subs_colour(text)
  end
  
private
  
WELCOME_SCREEN = <<-EO_WELCOME
<banner>Web Translate It v#{WebTranslateIt::Util.version}</banner>

EO_WELCOME
end