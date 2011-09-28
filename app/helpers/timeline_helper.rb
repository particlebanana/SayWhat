module TimelineHelper

  def build_event(event)
    return unless event.data.type
    type, obj = event.data.type, EventTimeline.new(event)
    case type
    when "message"
      event = obj.create_message
    end
    event
  end

  class EventTimeline

    def initialize(event)
      @data = event.data
      @objects = event.objects
    end

    # Build a message event type in the timeline.
    # EX: <p><a href="#">Object Name</a> some message text.</p>
    def create_message
      msg = @data.message
      html = ""
      @objects.each do |obj| 
        klass = obj[0]
        msg.gsub!(obj[1].name, "<a href='/#{klass.pluralize}/#{obj[1].id}'>#{obj[1].name}</a>")
      end
      html << "<p>" + msg + "</p>"
    end

    private

    # Find the resouce linked to by an object in the timeline.
    # Takes in the klass string and turns it into a constant to
    # use in an ActiveRecord query.
    def find_resource(klass, id)
      obj = klass.classify.constantize.find(id)
      obj ? obj : false
    end
  end
end