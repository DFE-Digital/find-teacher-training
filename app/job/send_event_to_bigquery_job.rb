class SendEventToBigqueryJob < ApplicationJob
  TABLE_NAME = 'events'.freeze

  def perform(request_event_json)
    bq = Google::Cloud::Bigquery.new(project: Settings.google.big_query_project_id)
    dataset = bq.dataset(Settings.google.big_query_dataset, skip_lookup: true)
    bq_table = dataset.table(TABLE_NAME, skip_lookup: true)
    bq_table.insert([request_event_json])
  end
end
