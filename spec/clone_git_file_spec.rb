require "spec_helper"

describe CloneGitFile do
  before do
    ENV["TARGET_DIRECTORY"] = "/target"
    ENV["EDITOR"] = "myeditor"
  end

  it { expect(::CloneGitFile::VERSION).not_to be_nil }

  describe "#open_file" do
    let(:url) { "https://github.com/author/repo/some/file.rb" }
    let(:cloner) { ::CloneGitFile::Cloner.new(url) }

    it "clones new repos" do
      expected_clone_command = "git clone https://github.com/author/repo /target/author/repo"
      expected_output = "Cloned to: /target/author/repo/some/file.rb"
      allow(Dir).to receive(:exists?).and_return(false)
      expect(cloner).to receive(:system).with(expected_clone_command)
      expect(cloner).to receive(:puts).with(expected_output)
      cloner.open_file
    end

    it "updates repos which exist in target directory" do
      expected_update_command = "cd /target/author/repo\ngit reset HEAD --hard\ngit pull"
      expected_output = "Cloned to: /target/author/repo/some/file.rb"
      allow(Dir).to receive(:exists?).and_return(true)
      expect(cloner).to receive(:system).with(expected_update_command)
      expect(cloner).to receive(:puts).with(expected_output)
      cloner.open_file
    end

    context "output editor run commands to terminal" do
      let(:url) { "https://github.com/author/repo/some/file.rb" }

      context "open_in_editor is supplied" do
        let(:cloner) do
          ::CloneGitFile::Cloner.new(url, open_in_editor: true, output_run_command_to_terminal: true)
        end

        it "outputs the commands to the terminal instead of executing them" do
          expected_update_command = "cd /target/author/repo\ngit reset HEAD --hard\ngit pull"
          expected_output = "cd /target/author/repo/some\nmyeditor /target/author/repo/some/file.rb"
          allow(Dir).to receive(:exists?).and_return(true)
          expect(cloner).to receive(:system).with(expected_update_command)
          expect(cloner).to receive(:puts).with(expected_output)
          cloner.open_file
        end
      end

      context "open_in_editor is not supplied" do
        let(:cloner) do
          ::CloneGitFile::Cloner.new(url, output_run_command_to_terminal: true)
        end

        it "outputs the commands to the terminal instead of executing them" do
          expected_update_command = "cd /target/author/repo\ngit reset HEAD --hard\ngit pull"
          expected_output = "cd /target/author/repo/some\nmyeditor /target/author/repo/some/file.rb"
          allow(Dir).to receive(:exists?).and_return(true)
          expect(cloner).to receive(:system).with(expected_update_command)
          expect(cloner).to receive(:puts).with(expected_output)
          cloner.open_file
        end
      end
    end

    context "silent output" do
      let(:url) { "https://github.com/author/repo/some/file.rb" }
      let(:cloner) { ::CloneGitFile::Cloner.new(url, silent: true) }

      it "redirects output" do
        expected_update_command = "cd /target/author/repo &> /dev/null\ngit reset HEAD --hard &> /dev/null\ngit pull &> /dev/null"
        expected_output = "Cloned to: /target/author/repo/some/file.rb"
        allow(Dir).to receive(:exists?).and_return(true)
        expect(cloner).to receive(:system).with(expected_update_command)
        expect(cloner).to receive(:puts).with(expected_output)
        cloner.open_file
      end
    end

    context "open the file" do
      let(:url) { "https://github.com/author/repo/some/file.rb" }
      let(:cloner) { ::CloneGitFile::Cloner.new(url, open_in_editor: true) }

      it "clones new repos" do
        expected_clone_command = "git clone https://github.com/author/repo /target/author/repo"
        expected_launch_command = "cd /target/author/repo/some\nmyeditor /target/author/repo/some/file.rb"
        allow(Dir).to receive(:exists?).and_return(false)
        expect(cloner).to receive(:system).with(expected_clone_command)
        expect(cloner).to receive(:system).with(expected_launch_command)
        cloner.open_file
      end
    end
  end
end
