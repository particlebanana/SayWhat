#-------------------------
# ADMIN ACTIONS
#-------------------------

# PUT - /admin/grants/:id
def do_update_grant(options={})
  attributes = { id: "123" }
  attributes.merge!(options)
  put :update, :id => attributes[:id]
end

# POST - /admin/grants/:id
def do_deny_grant(options={})
  attributes = { id: "123" }
  attributes.merge!(options)
  post :deny_grant, attributes
end

# PUT - /admin/groups/:id
def do_update_group(options={})
  attributes = {
    :id => @group.id,
    :group => {:display_name => "Rebel Alliance"}
  }
  attributes.merge!(options)
  put :update, attributes
end

# PUT - /admin/groups/:id/resend
def do_resend(options={})
  attributes = {
    :id => @group.id.to_s
  }
  attributes.merge!(options)
  put :resend, attributes
end

# PUT - /admin/groups/:id/sponsors
def do_update_sponsor(options={})
  attributes = {
    :user => @user.id.to_s,
    :id => @group.id.to_s
  }
  attributes.merge!(options)
  put :update, attributes
end

# DELETE - /admin/users/:id/remove_avatar
def do_remove_avatar(options={})
  attributes = { :id => @user.id }
  attributes.merge!(options)
  delete :remove_avatar, attributes
end

# DELTE - /admin/users/:id
def do_destroy_user(options={})
  attributes = {}
  attributes.merge!(options)
  delete :destroy_user, attributes
end