require 'test_helper'

describe CloneGitFile do
  before do
    ENV["TARGET_DIRECTORY"] = "/target"
    ENV["EDITOR"] = "myeditor"
  end

  it "has a version number" do
    refute_nil ::CloneGitFile::VERSION
  end

  describe "#open_file" do
    before do
      url = "https://github.com/author/repo/some/file.rb"
      @cloner = ::CloneGitFile::Cloner.new(url)
    end

    it "clones new repos" do
      expected_clone_command = "git clone https://github.com/author/repo /target/author/repo"
      expected_output = "Cloned to: /target/author/repo/some/file.rb"

      Dir.stubs(:exists?).returns(false)
      @cloner.expects(:system).with(expected_clone_command)
      @cloner.expects(:puts).with(expected_output)

      @cloner.open_file
    end

    it "updates repos which exist in target directory" do
      expected_update_command = "cd /target/author/repo\ngit reset HEAD --hard\ngit pull"
      expected_output = "Cloned to: /target/author/repo/some/file.rb"

      Dir.stubs(:exists?).returns(true)
      @cloner.expects(:system).with(expected_update_command)
      @cloner.expects(:puts).with(expected_output)

      @cloner.open_file
    end
  end

  context "output editor run commands to terminal" do
    before do
      @url = "https://github.com/author/repo/some/file.rb"
    end

    context "open_in_editor is supplied" do
      before do
        @cloner = ::CloneGitFile::Cloner.new(@url, {open_in_editor: true, output_run_command_to_terminal: true})
      end

      it "outputs the commands to the terminal instead of executing them" do
        expected_update_command = "cd /target/author/repo\ngit reset HEAD --hard\ngit pull"
        expected_output = "cd /target/author/repo/some\nmyeditor /target/author/repo/some/file.rb"

        Dir.stubs(:exists?).returns(true)
        @cloner.expects(:system).with(expected_update_command)
        @cloner.expects(:puts).with(expected_output)

        @cloner.open_file
      end
    end

    context "open_in_editor is not supplied" do
      before do
        @cloner = ::CloneGitFile::Cloner.new(@url, {output_run_command_to_terminal: true})
      end

      it "outputs the commands to the terminal instead of executing them" do
        expected_update_command = "cd /target/author/repo\ngit reset HEAD --hard\ngit pull"
        expected_output = "cd /target/author/repo/some\nmyeditor /target/author/repo/some/file.rb"

        Dir.stubs(:exists?).returns(true)
        @cloner.expects(:system).with(expected_update_command)
        @cloner.expects(:puts).with(expected_output)

        @cloner.open_file
      end
    end
  end

  context "silent output" do
    before do
      url = "https://github.com/author/repo/some/file.rb"
      @cloner = ::CloneGitFile::Cloner.new(url, {silent: true})
    end

    it "redirects output" do
      expected_update_command = "cd /target/author/repo &> /dev/null\ngit reset HEAD --hard &> /dev/null\ngit pull &> /dev/null"
      expected_output = "Cloned to: /target/author/repo/some/file.rb"

      Dir.stubs(:exists?).returns(true)
      @cloner.expects(:system).with(expected_update_command)
      @cloner.expects(:puts).with(expected_output)

      @cloner.open_file
    end
  end

  context "open the file" do
    before do
      url = "https://github.com/author/repo/some/file.rb"
      @cloner = ::CloneGitFile::Cloner.new(url, {open_in_editor: true})
    end

    it "clones new repos" do
      expected_clone_command = "git clone https://github.com/author/repo /target/author/repo"
      expected_launch_command = "cd /target/author/repo/some\nmyeditor /target/author/repo/some/file.rb"

      Dir.stubs(:exists?).returns(false)
      @cloner.expects(:system).with(expected_clone_command)
      @cloner.expects(:system).with(expected_launch_command)

      @cloner.open_file
    end
  end
end
