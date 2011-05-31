#-------------------------
# ADMIN ACTIONS
#-------------------------

# PUT - /admin/grants/:id
def do_approve_grant(options={})
  attributes = { id: "123" }
  attributes.merge!(options)
  put :approve_grant, :id => attributes[:id]
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
    :id => @group.id.to_s,
    :group => {:display_name => "Rebel Alliance"}
  }
  attributes.merge!(options)
  put :update_group, attributes
end

# PUT - /admin/groups/:id/setup_email
def do_group_approval_email(options={})
  attributes = {
    :id => @group.id.to_s
  }
  attributes.merge!(options)
  put :group_approval_email, attributes
end

# PUT - /admin/groups/reassign_sponsor
def do_reassign_sponsor(options={})
  attributes = {
    :user => @user.id.to_s,
    :id => @group.id.to_s
  }
  attributes.merge!(options)
  put :reassign_sponsor, attributes
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