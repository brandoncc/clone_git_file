require 'test_helper'

describe CloneGitFile do
  it "has a version number" do
    refute_nil ::CloneGitFile::VERSION
  end

  describe "#open_file" do
    before do
      ENV["TARGET_DIRECTORY"] = "/target"
      ENV["EDITOR"] = "myeditor"
      url = "https://github.com/author/repo/some/file.rb"
      @cloner = ::CloneGitFile::Cloner.new(url)
    end

    it "clones new repos" do
      expected_clone_command = "git clone https://github.com/author/repo /target/author/repo"
      expected_launch_command = "myeditor /target/author/repo/some/file.rb"

      Dir.stubs(:exists?).returns(false)
      @cloner.expects(:system).with(expected_clone_command)
      @cloner.expects(:system).with(expected_launch_command)

      @cloner.open_file
    end

    it "updates repos which exist in target directory" do
      expected_update_command = "cd /target/author/repo\ngit reset HEAD --hard\ngit pull"
      expected_launch_command = "myeditor /target/author/repo/some/file.rb"

      Dir.stubs(:exists?).returns(true)
      @cloner.expects(:system).with(expected_update_command)
      @cloner.expects(:system).with(expected_launch_command)

      @cloner.open_file
    end
  end
end
