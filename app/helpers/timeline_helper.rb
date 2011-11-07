module TimelineHelper

  def build_event(event, section_key)
    return unless event.data.type
    type, obj = event.data.type, EventTimeline.new(event, section_key)
    case type
    when "message"
      event = obj.build_message
    when "comment"
      objects = event.objects
      if objects.project
        form_url = group_project_comment_comments_path(objects.group.id, objects.project.id, event['key'])
        event_section = 'project'
      elsif objects.group
        form_url = group_comment_comments_path(objects.group.id, event['key'])
        event_section = 'group'
      end

      render 'timeline/comment', {
        key: event['key'],
        form: form_url,
        user: event.objects.user,
        objects: event.objects,
        title: obj.build_title(event_section),
        comment: event.data.comment,
        timestamp: Time.at(event.token.split(':')[1].to_i),
        subevents: event.subevents
      }
    end
  end

  class EventTimeline

    def initialize(event, section_key)
      @data = event.data
      @objects = event.objects
      @section_key = section_key
    end

    # Build a message event type in the timeline.
    # EX: <p><a href="#">Object Name</a> some message text.</p>
    def build_message
      msg = @data.message
      html = ""
      @objects.to_a.each do |obj|
        klass = obj[0]
        case klass
        when 'user'
          url = "/#{klass.pluralize}/#{obj[1].id}"
        when 'group'
          url = "/#{klass.pluralize}/#{obj[1].id}"
        when 'project'
          url = "/groups/#{@objects.group.id}/#{klass.pluralize}/#{obj[1].id}"
        end
        msg.gsub!(obj[1].name, "<a href='#{url}'>#{obj[1].name}</a>")
      end
      html << "<p>" + msg + "</p>"
    end

    # Build an event title for use in timeline
    # EX: <h6>
    def build_title(section)
      html = ""
      case @data.type
      when 'comment'
        title = "<a href='/users/#{@objects.user.id}'>#{@objects.user.name}</a> "
        if (@objects.include? 'project') && (section != @section_key)
          title << "<span class='arrow'></span> "
          title << "<a href='/groups/#{@objects.group.id}/projects/#{@objects.project.id}'>#{@objects.project.name}</a>"
        elsif (@objects.include? 'group') && (section != @section_key)
          title << "<span class='arrow'></span> "
          title << "<a href='/groups/#{@objects.group.id}'>#{@objects.group.name}</a>"
        end
      end
      html << "<h6 class='cf'>#{title}</h6>"
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