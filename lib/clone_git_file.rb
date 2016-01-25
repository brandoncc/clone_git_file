require "clone_git_file/version"
require "clone_git_file/github_repo_parser"

module CloneGitFile
  class Cloner
    def initialize(file, options = {})
      @file = file
      @options = options
    end

    def open_file
      if Dir.exists?(File.expand_path(local_repo_path))
        update_repo
      else
        clone_repo
      end

      if @options[:open_in_editor] ||
          @options[:output_run_command_to_terminal]
        launch_editor
      else
        print_clone_location
      end
    end

    private

    def parsed_data
      @parsed_data ||= GithubRepoParser.new(@file).parse
    end

    def local_repo_path
      @local_repo_path ||= "#{ENV["TARGET_DIRECTORY"]}/#{parsed_data.github_username}/#{parsed_data.repo_name}"
    end

    def launch_editor
      commands = ""
      file_path = "#{local_repo_path}"
      file_path << "/#{parsed_data.file_relative_path}" if parsed_data.file_relative_path

      # change into the directory so that relative file loads will work
      commands << "cd #{File.dirname(file_path)}"
      commands << "\n#{ENV["EDITOR"]} #{file_path}"

      if @options[:output_run_command_to_terminal]
        puts(commands)
      else
        system(commands)
      end
    end

    def print_clone_location
      clone_path = "#{local_repo_path}"
      clone_path << "/#{parsed_data.file_relative_path}" unless parsed_data.file_relative_path == ""

      puts "Cloned to: #{clone_path}"
    end

    def clone_repo
      commands = ""
      commands << "git clone #{parsed_data.repo_url} #{local_repo_path}"

      branch_name = parsed_data.branch_name
      if branch_name && branch_name != ""
        commands << "\ncd #{local_repo_path}"
        commands << "\ngit checkout #{parsed_data.branch_name}"
      end

      commands = make_commands_silent(commands) if @options[:silent]

      system(commands)
    end

    def update_repo
      commands = ""

      commands << "cd #{local_repo_path}"
      commands << "\ngit reset HEAD --hard"
      commands << "\ngit pull"
      commands << "\ngit checkout #{parsed_data.branch_name}" if parsed_data.branch_name
      commands = make_commands_silent(commands) if @options[:silent]

      system(commands)
    end

    def make_commands_silent(commands)
      cmds = commands.split("\n")

      cmds.map { |c| "#{c} &> /dev/null" }.join("\n")
    end
  end
end
