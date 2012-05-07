# Recreate Project Object Key on Update
class UpdateProjectJob
  @queue = :feed

  # Public: Recreate Project Object Key on Update
  #
  # This job re-creates a project object key when a Project
  # model instance is updated so that the feed stays in
  # sync with the database.
  #
  # project_id - The id of the project
  #
  # Returns nothing. It's a worker task
  def self.perform(project_id)
    project = Project.find(project_id)
    obj = self.new(project)
    obj.recreate_object_key
  end

  def initialize(project)
    @project = project
  end

  # On model update, destroy the current object and recreate it
  def recreate_object_key
    $feed.unrecord("project:#{@project.id}")
    data = { id: @project.id, name: @project.display_name }
    data[:photo] = @project.profile_photo_url(:thumb) if @project.profile_photo
    $feed.record("project:#{@project.id}", data)
  end
end