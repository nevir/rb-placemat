# Helper methods for use within project template files.
module Placemat::CLI::TemplateContext
  # Requires that project_repo is set! See `Placemat::CLI#initialize_repo`.
  attr_accessor :project_repo

  def project_root
    @project_root ||= File.expand_path(Thor::Util.snake_case(@path))
  end

  def relative_project_root
    @relative_project_root ||= begin
      relative_to_original_destination_root(project_root)
    end
  end

  def project_basename
    @project_basename ||= File.basename(project_root)
  end

  def project_namespace
    @project_namespace ||= Thor::Util.camel_case(project_basename)
  end

  def author
    @author ||= begin
      value = project_repo ? project_repo.config('user.name').strip : ''
      value == '' ? (ask 'your name:') : value
    end
  end

  def email
    @email ||= begin
      value = project_repo ? project_repo.config('user.email').strip : ''
      value == '' ? (ask 'your email:') : value
    end
  end

  def project_summary
    ask 'project summary:'
  end

  def project_homepage
    ask 'project homepage:'
  end

  def q(string)
    string.gsub('\'', '\\\'')
  end
end
