#-------------------------
# ADMIN ACTIONS
#-------------------------

# PUT - /admin/grants/:id
def do_approve_grant(options={})
  attributes = { id: "123" }
  attributes.merge!(options)
  put :approve_grant, :id => attributes[:id]
end