module TimelineHelper

  def build_event(event)
    return unless event.data.type
    type, obj = event.data.type, EventTimeline.new(event)
    case type
    when "message"
      event = obj.build_message
    when "comment"
      objects = event.objects
      if objects.project
        form_url = group_project_comment_comments_path(objects.group.id, objects.project.id, event['key'])
      elsif objects.group
        form_url = group_comment_comments_path(objects.group.id, event['key'])
      end

      render 'timeline/comment', {
        key: event['key'],
        form: form_url,
        user: event.objects.user,
        objects: event.objects,
        comment: event.data.comment,
        timestamp: Time.at(event.token.split(':')[1].to_i),
        subevents: event.subevents
      }
    end
  end

  class EventTimeline

    def initialize(event)
      @data = event.data
      @objects = event.objects
    end

    # Build a message event type in the timeline.
    # EX: <p><a href="#">Object Name</a> some message text.</p>
    def build_message
      msg = @data.message
      html = ""
      @objects.to_a.each do |obj|
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