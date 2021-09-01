class FeedbackXmlGeneratorJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Do something later
    feedback_xml = FeedbackSerializer.new(Feedback.all).serializable_hash.to_xml
    filename = Rails.root.join("public/feedback.xml")

    File.open(filename, 'wb') do |file|
      file.write(feedback_xml)
    end
  end
end
