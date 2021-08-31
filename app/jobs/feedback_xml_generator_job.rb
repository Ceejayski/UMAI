class FeedbackXmlGeneratorJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Do something later
    feedback_xml = Feedback.all.as_json.to_xml
    filename = Rails.root.join("public/feedback.xml")

    File.open(filename, 'wb') do |file|
      file.write(feedback_xml)
    end
    pp filename
  end
end
