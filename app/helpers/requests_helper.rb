module RequestsHelper

  def build_request(klass, data)
    type, obj = klass, RequestView.new(klass, data)
    if type == "membership"
      membership = obj.find_object(data.id)
      user = User.find(membership.user_id)
      data_obj = {
        record: membership,
        user: user,
        thumb: image_tag(user.profile_photo_url(:thumb)),
        group: current_user.group
      }

      data_obj[:confirm_link] = link_to "Confirm", group_membership_path(data_obj[:group].permalink, data_obj[:record].id), :method => "put", :class => "btn success"
      data_obj[:deny_link] = link_to "Deny", group_membership_path(data_obj[:group].permalink, data_obj[:record].id), :method => "delete", :class => "btn danger"
      
      return obj.build_view(data_obj).html_safe
    end
  end

  class RequestView

    def initialize(klass, data)
      @klass = klass
      @data = data
    end

    def find_object(id)
      klass = @klass.classify.constantize
      klass.find(id)
    end

    def build_view(data)
      if @klass == 'membership'
        build_membership_view(data)
      end
    end

    private

    def build_membership_view(data)
      user = data[:user]
      html = "<div class='profile_image'>#{data[:thumb]}</div>"
      html += "<span class='userName'><a href='/users/#{user.id}'>#{user.name}</a></span>"
      html += "<div class='actionList'>"
      html += data[:confirm_link]
      html += data[:deny_link]
      html += "</div>"
      return html
    end

  end

end