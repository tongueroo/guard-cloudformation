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
      let(:command) { mock "command" }
      before do
        guard.stub(:command).and_return(command)
        guard.stub(:all_paths).and_return(["/path/1", "/path/2"])
      end

      it "runs validate for templates" do
        guard.should_receive(:command).exactly(2).times
        subject
      end
    end

  end
end

