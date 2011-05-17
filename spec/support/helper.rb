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