module BigQueryTestHelper
  def stub_big_query_table(table_name:)
    table = instance_double(Google::Cloud::Bigquery::Table)
    dataset = instance_double(Google::Cloud::Bigquery::Dataset)
    allow(dataset).to receive(:table).with(table_name, skip_lookup: true).and_return(table)
    project = instance_double(Google::Cloud::Bigquery::Project, dataset: dataset)

    allow(Google::Cloud::Bigquery).to receive(:new).and_return(project)

    table
  end
end
