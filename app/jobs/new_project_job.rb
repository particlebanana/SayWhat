# Manage Tasks for a new Project
class NewProjectJob
  @queue = :feed

  # Public: Manage Activity Feed keys for new project
  #
  # This job creates an object key and publishes a timeline
  # event to the group and project feed.
  #
  # project_id - The id of the new user
  #
  # Returns nothing. It's a worker task
  def self.perform(project_id)
    project = Project.find(project_id)
    obj = self.new(project)
    obj.create_object_key
    obj.publish_to_feed
  end

  def initialize(project)
    @project = project
    @group = project.group
  end

  # Create an object in the Activity Feed
  def create_object_key
    $feed.record("project:#{@project.id}", { id: @project.id, name: @project.display_name } )
  end

  # Publish event to group and project feed
  def publish_to_feed
    event = Chronologic::Event.new(
      key: "project:#{@project.id}:create",
      data: { type: "message", message: "#{@group.display_name} created a new project: #{@project.display_name}" },
      timelines: ["group:#{@group.id}", "project:#{@project.id}"],
      objects: { group: "group:#{@group.id}", project: "project:#{@project.id}" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)
  end
end