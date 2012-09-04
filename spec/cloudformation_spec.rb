require "spec_helper"
require "guard/cloudformation"

module Guard
  describe Cloudformation do
    before { Notifier.stub(:notify) }

    it { should be_a_kind_of ::Guard::Guard }

    describe "#run_all" do
      subject { guard.run_all }
      let(:guard) { described_class.new [], :templates_path => "templates", :notification => notification }
      let(:notification) { false }
      # let(:command) { mock "command" }

      it "runs return true when all templates are valid" do
        guard.stub(:command).and_return(["good output", true])
        guard.stub(:all_paths).and_return(["/path/1", "/path/2"])
        guard.should_receive(:command).exactly(2).times
        subject
      end

      it "runs return false when all templates are invalid" do
        guard.stub(:command).and_return(["bad output", false])
        guard.stub(:all_paths).and_return(["/path/1", "/path/2"])
        expect { subject }.to throw_symbol(:task_has_failed)
      end
    end

  end
end

