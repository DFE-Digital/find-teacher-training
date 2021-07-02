class SendEventToBigQueryJob < ApplicationJob
  def perform(request_event_json)
    bq = Google::Cloud::Bigquery.new(project: Settings.google.big_query.project_id)
    dataset = bq.dataset(Settings.google.big_query.dataset, skip_lookup: true)
    bq_table = dataset.table(Settings.google.big_query.table_name, skip_lookup: true)
    bq_table.insert([request_event_json])
  end
end
