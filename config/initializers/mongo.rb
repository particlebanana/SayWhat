Mongo_Config = YAML.load_file(File.join(File.dirname(__FILE__), '../mongodb_config.yml'))
$mongo = Mongo::Connection.new("localhost", 27017, logger: Rails.logger).db("saywhat_#{Rails.env.downcase}")