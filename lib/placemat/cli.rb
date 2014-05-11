require 'git'
require 'erb'
require 'fileutils'
require 'thor/actions'
require 'thor/error'
require 'thor/group'
require 'thor/util'

class Placemat::CLI < Thor::Group
  extend Placemat::AutoloadConvention
  include Thor::Actions
  include Placemat::CLI::TemplateContext

  desc "Scaffolds a new gem, or updates a current one to use Placemat.\n\n"
  # Wow, cheating; but easiest way to show argument help for the group.
  namespace '[path or ProjectName]'
  argument :path, required: false
  class_option :new_project, type: :boolean, default: :auto
  class_option :dev_placemat, type: :boolean, default: false

  source_root Placemat::DATA_PATH.join('project_template')

  def detect_project_type
    if options[:new_project] == :auto
      @new_project = !File.directory?(project_root)
    else
      @new_project = options[:new_project]
    end
  end

  def initialize_repo
    status_line = "#{relative_project_root} (git repo)"
    self.project_repo = Git.open(project_root)
    say_status 'exists', status_line, :blue
  rescue ArgumentError
    self.project_repo = Git.init(project_root)
    say_status 'create', status_line, :green
  end

  def check_dirty_status
    if project_repo_dirty?
      raise(
        Thor::Error,
        'Refusing to modify a dirty repo. Please commit or stash your changes.'
      )
    end
  end

  def generate_new_project
    return unless new_project?
    all_project_files.each { |f| template f }
  end

  def generate_current_project
    return if new_project?
    template '.rspec'
    template 'Guardfile'
    template 'Rakefile'
  end

  def inject_dev_placemat
    return unless options[:dev_placemat]
    append_to_file 'Gemfile' do
      "gem 'placemat', path: '#{Placemat::GEM_PATH}'"
    end
  end

  def commit_changes
    project_repo.commit("Placemat Configuration (v#{Placemat::Version})")
    say_status 'commit', "#{relative_project_root} (git changes)"
  rescue Git::GitExecuteError
    # Nothing to commit.
  end

  private

  def initialize(args=[], local_options=[], config={}, &block)
    super(args, local_options, config, &block)

    if !@path
      self.class.help(shell)
      fail Thor::Error, 'A path or ProjectName is required. ' +
        'Perhaps you want to run `placemat .`?'
    end
  end

  def template(source)
    final_path = super(source, File.join(project_root, source), force: true)
    project_repo.add(final_path)

    final_path
  end

  def prepend_to_file(path, *args, &block)
    super(File.join(project_root, path), *args, &block)
    project_repo.add(path)
  end

  def append_to_file(path, *args, &block)
    super(File.join(project_root, path), *args, &block)
    project_repo.add(path)
  end

  def new_project?
    @new_project
  end

  def project_repo_dirty?
    project_repo.status.any?(&:type)
  rescue Git::GitExecuteError
    false # No commits whatsoever.
  end

  def all_project_files
    @all_project_files ||= begin
      files = []
      source_paths.each do |source_path|
        some_files = Dir.glob(File.join(source_path, '**', '*'), File::FNM_DOTMATCH)
        some_files.reject! { |f| File.directory? f }
        some_files.map! do |file|
          file[(source_path.to_s.size + 1)..-1].sub(/\.tt$/, '')
        end
        files += some_files
      end

      files
    end
  end

end
