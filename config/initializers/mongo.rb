mongo = YAML.load_file(File.join(File.dirname(__FILE__), '../mongodb_config.yml'))

# Notifications Database
NOTIFICATIONS_DB = mongo['notifications']["#{Rails.env.downcase}"]["database"]
NOTIFICATIONS_COLL = mongo['notifications']["#{Rails.env.downcase}"]["collection"]

# Requests Collection
REQUESTS_DB = mongo['requests']["#{Rails.env.downcase}"]["database"]
REQUESTS_COLL = mongo['requests']["#{Rails.env.downcase}"]["collection"]